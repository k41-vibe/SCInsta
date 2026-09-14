#import "../../InstagramHeaders.h"

// A way to find out what a popup actually is.
//
// Instagram builds most of its dialogs generically, so you cannot guess the class of the
// one you want gone. With this on, every modal that appears names itself on screen for a
// couple of seconds, which is enough to write a hook against it afterwards.
//
// Settings -> 開発者向け -> SCInsta -> 出てきた画面の名前を表示
%hook UIViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion {
    %orig;

    if (![SCIUtils getBoolPref:@"debug_show_presented"]) return;
    if (!viewControllerToPresent) return;

    // Do not report our own settings screen, or the report itself becomes the noise
    NSString *name = NSStringFromClass([viewControllerToPresent class]);
    if ([name hasPrefix:@"SCI"] || [name isEqualToString:@"UIAlertController"]) return;

    NSString *inner = name;
    if ([viewControllerToPresent isKindOfClass:[UINavigationController class]]) {
        UIViewController *top = [(UINavigationController *)viewControllerToPresent topViewController];
        if (top) inner = [NSString stringWithFormat:@"%@ > %@", name, NSStringFromClass([top class])];
    }

    NSLog(@"[SCInsta] presented: %@", inner);

    dispatch_async(dispatch_get_main_queue(), ^{
        [SCIUtils showErrorHUDWithDescription:inner dismissAfterDelay:4.0];
    });
}

%end
