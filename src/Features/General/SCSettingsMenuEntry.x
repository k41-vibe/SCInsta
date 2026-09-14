#import "../../InstagramHeaders.h"
#import "../../Settings/SCISettingsViewController.h"
#import <objc/runtime.h>

static char kSCIWindowGestureKey;

// Show SCInsta tweak settings by holding on the settings/more icon under profile for ~1 second
%hook IGBadgedNavigationButton
- (void)didMoveToWindow {
    %orig;

    if ([self.accessibilityIdentifier isEqualToString:@"profile-more-button"]) {
        [self addLongPressGestureRecognizer];
    }

    return;
}

%new - (void)addLongPressGestureRecognizer {
    if ([self.gestureRecognizers count] == 0) {
        NSLog(@"[SCInsta] Adding tweak settings long press gesture recognizer");

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self addGestureRecognizer:longPress];
    }
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) return;

    NSLog(@"[SCInsta] Tweak settings gesture activated");

    [SCIUtils showSettingsVC:[self window]];
}
%end

// Quick access to tweak settings by holding on home tab button
%hook IGTabBarButton
- (void)didMoveToSuperview {
    %orig;

    // Only work on home/feed tab
    if (![self.accessibilityIdentifier isEqualToString:@"mainfeed-tab"]) return;

    // Always on. This used to be gated behind the "settings_shortcut" preference, but
    // that preference can only be changed from the settings screen itself -- and since
    // Instagram reworked its navigation bar around v432 the profile-button entry point
    // above no longer attaches (issue #281), leaving no way in at all. An entry point
    // must never depend on already being able to open the thing it opens.
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.3;

    // Take precidence over existing gesture recognizers
    for (UIGestureRecognizer *existing in self.gestureRecognizers) {
        [existing requireGestureRecognizerToFail:longPress];
    }

    [self addGestureRecognizer:longPress];
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) return;

    [SCIUtils showSettingsVC:[self window]];
}
%end

// Last-resort entry point that does not depend on any Instagram class: hold two fingers
// anywhere for ~0.8s. Both hooks above attach to views Instagram owns and keeps renaming,
// so when a redesign lands the settings become unreachable. The window is ours to grab
// regardless of what the app looks like.
%hook UIWindow
- (void)becomeKeyWindow {
    %orig;

    if (objc_getAssociatedObject(self, &kSCIWindowGestureKey)) return;

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sciHandleWindowLongPress:)];
    longPress.numberOfTouchesRequired = 2;
    longPress.minimumPressDuration = 0.8;
    // Let normal touches through, so this never eats a tap meant for the app
    longPress.cancelsTouchesInView = NO;
    longPress.delaysTouchesBegan = NO;
    longPress.delaysTouchesEnded = NO;

    [self addGestureRecognizer:longPress];
    objc_setAssociatedObject(self, &kSCIWindowGestureKey, longPress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    NSLog(@"[SCInsta] Added window-level settings gesture (two-finger long press)");
}

%new - (void)sciHandleWindowLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) return;

    NSLog(@"[SCInsta] Tweak settings gesture activated (window)");

    [SCIUtils showSettingsVC:self];
}
%end
