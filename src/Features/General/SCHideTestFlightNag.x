#import "../../InstagramHeaders.h"
#import "../../Utils.h"

// Instagram's TestFlight builds nag you to update on every launch, with a full-screen
// sheet you have to dismiss by hand. The class behind it is
// IGCoreRootTestFlightNagPlugin.TestFlightUpdateNudgeViewController -- a Swift type, so
// the runtime name carries the module prefix and cannot be written in %hook directly.
// Matched on the distinctive part only, so a module rename does not quietly turn this off.

static BOOL SCIIsTestFlightNag(NSString *name) {
    if (!name) return NO;
    return [name containsString:@"TestFlightUpdateNudge"] || [name containsString:@"TestFlightNag"];
}

// Unset counts as on. This fork exists to get rid of the thing; a switch that has to be
// found and flipped first is a step with no upside.
static BOOL SCIHidesTestFlightNag(void) {
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:@"hide_testflight_nag"];
    return value ? [value boolValue] : YES;
}

%hook UIViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion {
    if (viewControllerToPresent && SCIHidesTestFlightNag()
        && SCIIsTestFlightNag(NSStringFromClass([viewControllerToPresent class]))) {
        NSLog(@"[SCInsta] blocked TestFlight update nag at presentation");
        // Nothing was presented, but the caller may be waiting on this
        if (completion) completion();
        return;
    }

    %orig;
}

// Second line: if it reaches the screen by some other route (pushed, made a window's
// root, swapped in as a child), close it as soon as it appears.
- (void)viewWillAppear:(BOOL)animated {
    %orig;

    if (!SCIHidesTestFlightNag()) return;
    if (!SCIIsTestFlightNag(NSStringFromClass([self class]))) return;

    NSLog(@"[SCInsta] dismissing TestFlight update nag that got on screen anyway");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:NO completion:nil];
        } else if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:NO];
        } else {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
    });
}

%end

%ctor {
    // The comment that stood here said %init was what had been missing, and that without
    // it the hooks above were never installed. That is not how Logos works and it was not
    // what fixed this. If %init appears nowhere in a file, Logos writes the constructor
    // that registers the file's hooks itself (logos.pl:875), and if a hook group is left
    // uninitialized it fails the build rather than going quiet (logos.pl:885) -- there is
    // no silent version of that failure to have been hit.
    //
    // The commit that made the nag go away changed three things at once: it added %init,
    // it stopped depending on the preference being written before it was read, and it
    // added the viewWillAppear route below. The third is the one that can account for the
    // symptom, since the sheet evidently did not arrive through presentViewController.
    // Which it was has not been established, so it is left written down rather than
    // guessed at again. %init is kept because it is harmless and explicit.
    %init;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"hide_testflight_nag"] == nil) {
        [defaults setBool:YES forKey:@"hide_testflight_nag"];
    }
}
