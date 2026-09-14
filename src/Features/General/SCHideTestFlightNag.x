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
    // %init is not optional here. Writing %ctor by hand replaces the constructor Logos
    // would have generated for this file, and that generated one is what registers the
    // file's hooks -- leave it out and the hooks above are simply never installed. That
    // is exactly what happened on the first attempt: the setting existed, the switch was
    // on, and the nag still appeared every launch.
    %init;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"hide_testflight_nag"] == nil) {
        [defaults setBool:YES forKey:@"hide_testflight_nag"];
    }
}
