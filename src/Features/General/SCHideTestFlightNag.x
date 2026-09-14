#import "../../InstagramHeaders.h"
#import "../../Utils.h"

// Instagram's TestFlight builds nag you to update on every launch, with a full-screen
// sheet you have to dismiss by hand. The class behind it is
// IGCoreRootTestFlightNagPlugin.TestFlightUpdateNudgeViewController -- a Swift type, so
// the runtime name carries the module prefix. Matched on the distinctive part only, so a
// module rename does not quietly turn this off.
%hook UIViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion {
    if (viewControllerToPresent && [SCIUtils getBoolPref:@"hide_testflight_nag"]) {
        NSString *name = NSStringFromClass([viewControllerToPresent class]);
        if ([name containsString:@"TestFlightUpdateNudge"] || [name containsString:@"TestFlightNag"]) {
            NSLog(@"[SCInsta] blocked TestFlight update nag: %@", name);
            // Nothing was presented, but the caller may be waiting on this
            if (completion) completion();
            return;
        }
    }

    %orig;
}

%end
