#import "../../InstagramHeaders.h"
#import "../../Tweak.h"
#import "../../Utils.h"
#import <objc/runtime.h>
#import <objc/message.h>

// Seen buttons (in DMs)
// - Enables no seen for messages
// - Enables unlimited views of DM visual messages
%hook IGTallNavigationBarView
- (void)setRightBarButtonItems:(NSArray <UIBarButtonItem *> *)items {
    NSMutableArray *new_items = [[items filteredArrayUsingPredicate:
        [NSPredicate predicateWithBlock:^BOOL(UIView *value, NSDictionary *_) {
            if ([SCIUtils getBoolPref:@"hide_reels_blend"]) {
                return ![value.accessibilityIdentifier isEqualToString:@"blend-button"];
            }

            return true;
        }]
    ] mutableCopy];

    // Messages seen
    if ([SCIUtils getBoolPref:@"remove_lastseen"]) {
        UIBarButtonItem *seenButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"checkmark.message"] style:UIBarButtonItemStylePlain target:self action:@selector(seenButtonHandler:)];
        [new_items addObject:seenButton];
    }

    // DM visual messages viewed
    if ([SCIUtils getBoolPref:@"unlimited_replay"]) {
        UIBarButtonItem *dmVisualMsgsViewedButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"photo.badge.checkmark"] style:UIBarButtonItemStylePlain target:self action:@selector(dmVisualMsgsViewedButtonHandler:)];
        [new_items addObject:dmVisualMsgsViewedButton];

        if (dmVisualMsgsViewedButtonEnabled) {
            [dmVisualMsgsViewedButton setTintColor:SCIUtils.SCIColor_Primary];
        } else {
            [dmVisualMsgsViewedButton setTintColor:UIColor.labelColor];
        }
    }

    %orig([new_items copy]);
}

// Messages seen button
//
// -markLastMessageAsSeen still exists, but it moved off IGDirectThreadViewController onto the
// message list, which is a child view controller (実機 2026-09-20 で確認):
//
//   [child 1 IGDirectMessageListViewController]  markLastMessageAsSeen
//   [_featureManager IGDirectThreadViewFeatureManager]  markLastMessageAsSeen
//
// Calling it on the controller itself threw, and guarding that call left the button doing
// nothing. Look for the owner instead of assuming one: the controller, then its children, then
// _featureManager. Whichever answers to the selector gets it.
//
// The list also carries -bypassSeenStateUpdate, which is how "don't send read receipts" is
// implemented. It has to come off for the duration of the call, or the request is suppressed
// on the way out and the button appears to work while changing nothing.
static id SCIFindSeenTarget(UIViewController *controller) {
    SEL sel = @selector(markLastMessageAsSeen);
    if ([controller respondsToSelector:sel]) return controller;

    for (UIViewController *child in controller.childViewControllers) {
        if ([child respondsToSelector:sel]) return child;
    }

    // _featureManager holds the same method and is reached through an ivar, not a property.
    Ivar ivar = class_getInstanceVariable([controller class], "_featureManager");
    if (ivar) {
        @try {
            id manager = object_getIvar(controller, ivar);
            if ([manager respondsToSelector:sel]) return manager;
        } @catch (__unused NSException *e) {}
    }
    return nil;
}

/// The names that looked plausible, for when the owner cannot be found.
///
/// The log is not reachable from inside LiveContainer, so this is put on screen instead.
static void SCICollectFrom(id obj, NSString *label, NSMutableArray *out, NSArray *needles) {
    if (!obj) return;
    for (Class cls = [obj class]; cls && cls != [NSObject class]; cls = class_getSuperclass(cls)) {
        unsigned int count = 0;
        Method *methods = class_copyMethodList(cls, &count);
        for (unsigned int i = 0; i < count; i++) {
            NSString *name = NSStringFromSelector(method_getName(methods[i]));
            NSString *lower = name.lowercaseString;
            for (NSString *needle in needles) {
                if ([lower containsString:needle]) {
                    [out addObject:[NSString stringWithFormat:@"%@  %@", label, name]];
                    break;
                }
            }
        }
        free(methods);
    }
}

static NSArray<NSString *> *SCICollectSeenCandidates(id target) {
    NSArray *needles = @[@"seen", @"read", @"receipt", @"viewed", @"markthread", @"markmessage"];
    NSMutableArray *out = [NSMutableArray array];

    SCICollectFrom(target, @"[self]", out, needles);

    if ([target isKindOfClass:UIViewController.class]) {
        NSInteger i = 0;
        for (UIViewController *child in [(UIViewController *)target childViewControllers]) {
            SCICollectFrom(child, [NSString stringWithFormat:@"[child %ld %@]", (long)i++,
                                   NSStringFromClass([child class])], out, needles);
        }
    }

    for (Class cls = [target class]; cls && cls != [UIViewController class]; cls = class_getSuperclass(cls)) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList(cls, &count);
        for (unsigned int i = 0; i < count; i++) {
            const char *type = ivar_getTypeEncoding(ivars[i]);
            if (!type || type[0] != '@') continue;
            @try {
                id value = object_getIvar(target, ivars[i]);
                if (!value) continue;
                SCICollectFrom(value, [NSString stringWithFormat:@"[%@ %@]", @(ivar_getName(ivars[i])),
                                       NSStringFromClass([value class])], out, needles);
            } @catch (__unused NSException *e) {}
        }
        free(ivars);
    }

    return [out sortedArrayUsingSelector:@selector(compare:)];
}

%new - (void)seenButtonHandler:(UIBarButtonItem *)sender {
    UIViewController *nearestVC = [SCIUtils nearestViewControllerForView:self];
    if (![nearestVC isKindOfClass:%c(IGDirectThreadViewController)]) return;

    id target = SCIFindSeenTarget(nearestVC);
    if (!target) {
        NSArray *found = SCICollectSeenCandidates(nearestVC);
        NSString *cls = NSStringFromClass([nearestVC class]);
        NSString *body = found.count ? [found componentsJoinedByString:@"\n"] : @"該当なし";
        UIPasteboard.generalPasteboard.string = [NSString stringWithFormat:@"%@\n%@", cls, body];

        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:@"既読を送る処理が見つかりません"
                             message:[NSString stringWithFormat:@"%@\n\n%@\n\n(コピー済み)", cls, body]
                      preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [nearestVC presentViewController:alert animated:YES completion:nil];
        return;
    }

    // Take the suppression off while the call goes out, then put it back the way it was.
    SEL getter = @selector(bypassSeenStateUpdate);
    SEL setter = @selector(setBypassSeenStateUpdate:);
    BOOL bypassed = NO;
    BOOL canToggle = [target respondsToSelector:getter] && [target respondsToSelector:setter];
    if (canToggle) {
        bypassed = ((BOOL (*)(id, SEL))objc_msgSend)(target, getter);
        if (bypassed) ((void (*)(id, SEL, BOOL))objc_msgSend)(target, setter, NO);
    }

    ((void (*)(id, SEL))objc_msgSend)(target, @selector(markLastMessageAsSeen));

    if (canToggle && bypassed) {
        ((void (*)(id, SEL, BOOL))objc_msgSend)(target, setter, YES);
    }

    [SCIUtils showToastForDuration:2.5 title:@"既読を送りました"];
}


// DM visual messages viewed button
%new - (void)dmVisualMsgsViewedButtonHandler:(UIBarButtonItem *)sender {
    if (dmVisualMsgsViewedButtonEnabled) {
        dmVisualMsgsViewedButtonEnabled = false;
        [sender setTintColor:UIColor.labelColor];

        [SCIUtils showToastForDuration:4.5 title:@"Visual messages can be replayed without expiring"];
    }
    else {
        dmVisualMsgsViewedButtonEnabled = true;
        [sender setTintColor:SCIUtils.SCIColor_Primary];

        [SCIUtils showToastForDuration:4.5 title:@"Visual messages will now expire after viewing"];
    }
}
%end

// Messages seen logic
%hook IGDirectThreadViewListAdapterDataSource
- (BOOL)shouldUpdateLastSeenMessage {
    if ([SCIUtils getBoolPref:@"remove_lastseen"]) {
        return false;
    }
    
    return %orig;
}
%end

// DM stories viewed logic
%hook IGDirectVisualMessageViewerEventHandler
- (void)visualMessageViewerController:(id)arg1 didBeginPlaybackForVisualMessage:(id)arg2 atIndex:(NSInteger)arg3 {
    if ([SCIUtils getBoolPref:@"unlimited_replay"]) {
        // Check if dm stories should be marked as viewed
        if (dmVisualMsgsViewedButtonEnabled) {
            %orig;
        }
    }
}
- (void)visualMessageViewerController:(id)arg1 didEndPlaybackForVisualMessage:(id)arg2 atIndex:(NSInteger)arg3 mediaCurrentTime:(CGFloat)arg4 forNavType:(NSInteger)arg5 {
    if ([SCIUtils getBoolPref:@"unlimited_replay"]) {
        // Check if dm stories should be marked as viewed
        if (dmVisualMsgsViewedButtonEnabled) {
            %orig;
        }
    }
}
%end