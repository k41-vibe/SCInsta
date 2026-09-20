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
// -markLastMessageAsSeen is gone from current Instagram builds. Guarding the call stopped the
// crash but left the button doing nothing, which is not a fix. Upstream has this open as #252
// and #268 and has not shipped since 2026-03.
//
// Rather than pin a new name that will move again, look for one at the moment of the tap: walk
// the class and its superclasses for a no-argument method whose name says it marks something
// seen or read. The list is logged so the exact name is recoverable when this breaks next.
static SEL SCIFindSeenSelector(id target) {
    static NSArray<NSString *> *wanted = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Most specific first: the old name, then names current builds are likely to use.
        wanted = @[@"markLastMessageAsSeen", @"markThreadAsSeen", @"markAsSeen", @"markThreadAsRead",
                   @"markAsRead", @"markVisibleMessagesAsSeen", @"sendSeenState", @"sendReadReceipt"];
    });
    for (NSString *name in wanted) {
        SEL sel = NSSelectorFromString(name);
        if ([target respondsToSelector:sel]) return sel;
    }

    // Nothing known matched. Collect the candidates so the name can be picked up from the log.
    NSMutableArray *found = [NSMutableArray array];
    for (Class cls = [target class]; cls && cls != [UIViewController class]; cls = class_getSuperclass(cls)) {
        unsigned int count = 0;
        Method *methods = class_copyMethodList(cls, &count);
        for (unsigned int i = 0; i < count; i++) {
            NSString *name = NSStringFromSelector(method_getName(methods[i]));
            if ([name containsString:@":"]) continue;   // takes arguments, not a plain action
            if ([name rangeOfString:@"seen" options:NSCaseInsensitiveSearch].location == NSNotFound &&
                [name rangeOfString:@"read" options:NSCaseInsensitiveSearch].location == NSNotFound) continue;
            [found addObject:name];
        }
        free(methods);
    }
    NSLog(@"[SCInsta] seen: no known selector on %@. candidates: %@",
          NSStringFromClass([target class]), found);
    return NULL;
}

%new - (void)seenButtonHandler:(UIBarButtonItem *)sender {
    UIViewController *nearestVC = [SCIUtils nearestViewControllerForView:self];
    if (![nearestVC isKindOfClass:%c(IGDirectThreadViewController)]) return;

    SEL sel = SCIFindSeenSelector(nearestVC);
    if (!sel) {
        [SCIUtils showToastForDuration:3.5 title:@"既読を送る処理が見つかりません"];
        return;
    }

    ((void (*)(id, SEL))objc_msgSend)(nearestVC, sel);
    [SCIUtils showToastForDuration:2.5 title:[NSString stringWithFormat:@"既読を送りました (%@)",
                                              NSStringFromSelector(sel)]];
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