#import "TweakSettings.h"

@implementation SCITweakSettings

// MARK: - Sections

///
/// This returns an array of sections, with each section consisting of a dictionary
///
/// `"title"`: The section title (leave blank for no title)
///
/// `"rows"`: An array of **SCISetting** classes, potentially containing a "navigationCellWithTitle" initializer to allow for nested setting pages.
///
/// `"footer`: The section footer (leave blank for no footer)

+ (NSArray *)sections {
    return @[
        @{
            @"header": @"",
            @"rows": @[
                [SCISetting linkCellWithTitle:@"開発者を支援する" subtitle:@"この tweak の開発を支えたい方はこちらから" icon:[SCISymbol symbolWithName:@"heart.circle.fill" color:[UIColor systemPinkColor] size:20.0] url:@"https://ko-fi.com/SoCuul"]
            ]
        },
        @{
            @"header": @"",
            @"rows": @[
                [SCISetting navigationCellWithTitle:@"全般"
                                           subtitle:@""
                                               icon:[SCISymbol symbolWithName:@"gear"]
                                        navSections:@[@{
                                            @"header": @"",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"広告を隠す" subtitle:@"アプリ内の広告をすべて取り除きます" defaultsKey:@"hide_ads"],
                                                [SCISetting switchCellWithTitle:@"Meta AI を隠す" subtitle:@"アプリ内の Meta AI のボタンと機能を隠します" defaultsKey:@"hide_meta_ai"],
                                                [SCISetting switchCellWithTitle:@"説明文をコピー" subtitle:@"説明文を長押しするとコピーできます" defaultsKey:@"copy_description"],
                                                [SCISetting switchCellWithTitle:@"検索履歴を残さない" subtitle:@"検索欄が最近の検索を保存しなくなります" defaultsKey:@"no_recent_searches"],
                                                [SCISetting switchCellWithTitle:@"詳細なカラーピッカー" subtitle:@"ストーリーのスポイトを長押しすると、文字色をより細かく選べます" defaultsKey:@"detailed_color_picker"],
                                                [SCISetting switchCellWithTitle:@"リキッドグラスのボタン" subtitle:@"アプリ内のボタンを実験的なリキッドグラス表示にします" defaultsKey:@"liquid_glass_buttons" requiresRestart:YES],
                                                [SCISetting switchCellWithTitle:@"リキッドグラスの面" subtitle:@"メニューなど、他の要素もリキッドグラス表示にします" defaultsKey:@"liquid_glass_surfaces" requiresRestart:YES],
                                                [SCISetting switchCellWithTitle:@"ティーン向けアイコンを使う" subtitle:@"有効にすると、Instagram のロゴを長押ししてアプリのアイコンを変えられます" defaultsKey:@"teen_app_icons" requiresRestart:YES]
                                            ]
                                        },
                                        @{
                                            @"header": @"ノート",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"ノート欄を隠す" subtitle:@"DM 一覧の上にあるノート欄を隠します" defaultsKey:@"hide_notes_tray"],
                                                [SCISetting switchCellWithTitle:@"友達マップを隠す" subtitle:@"ノート欄にある友達マップのアイコンを隠します" defaultsKey:@"hide_friends_map"],
                                                [SCISetting switchCellWithTitle:@"ノートのテーマを使う" subtitle:@"ノートのテーマ選択を使えるようにします" defaultsKey:@"enable_notes_customization"],
                                                [SCISetting switchCellWithTitle:@"ノートのテーマを自作" subtitle:@"絵文字と背景色・文字色を自分で決められます" defaultsKey:@"custom_note_themes"],
                                            ]
                                        },
                                        @{
                                            @"header": @"集中(気の散るもの)",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"おすすめユーザーを消す" subtitle:@"フィードの外にある「おすすめのユーザー」をすべて隠します" defaultsKey:@"no_suggested_users"],
                                                [SCISetting switchCellWithTitle:@"おすすめチャットを消す" subtitle:@"DM のおすすめチャンネルを隠します" defaultsKey:@"no_suggested_chats"],
                                                [SCISetting switchCellWithTitle:@"発見タブの投稿一覧を隠す" subtitle:@"発見(検索)タブに並ぶおすすめ投稿の格子を隠します" defaultsKey:@"hide_explore_grid"],
                                                [SCISetting switchCellWithTitle:@"話題の検索を隠す" subtitle:@"検索欄の下に出る「話題の検索」を隠します" defaultsKey:@"hide_trending_searches"],
                                            ]
                                        }]
                ],
                [SCISetting navigationCellWithTitle:@"フィード"
                                           subtitle:@""
                                               icon:[SCISymbol symbolWithName:@"rectangle.stack"]
                                        navSections:@[@{
                                            @"header": @"",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"ストーリー欄を隠す" subtitle:@"上部とフィード内のストーリー欄を隠します" defaultsKey:@"hide_stories_tray"],
                                                [SCISetting switchCellWithTitle:@"フィードを丸ごと隠す" subtitle:@"ホームのフィードから投稿を含むすべての内容を消します" defaultsKey:@"hide_entire_feed"],
                                                [SCISetting switchCellWithTitle:@"おすすめ投稿を消す" subtitle:@"フィードからおすすめ投稿を取り除きます" defaultsKey:@"no_suggested_post"],
                                                [SCISetting switchCellWithTitle:@"「あなたへのおすすめ」を消す" subtitle:@"フォローのおすすめアカウントを隠します" defaultsKey:@"no_suggested_account"],
                                                [SCISetting switchCellWithTitle:@"おすすめリールを消す" subtitle:@"おすすめのリールを隠します" defaultsKey:@"no_suggested_reels"],
                                                [SCISetting switchCellWithTitle:@"Threads の投稿を消す" subtitle:@"おすすめされる Threads の投稿を隠します" defaultsKey:@"no_suggested_threads"],
                                                [SCISetting switchCellWithTitle:@"動画の自動再生を止める" subtitle:@"フィードの動画が勝手に再生されなくなります" defaultsKey:@"disable_feed_autoplay"]
                                            ]
                                        }]
                ],
                [SCISetting navigationCellWithTitle:@"リール"
                                           subtitle:@""
                                               icon:[SCISymbol symbolWithName:@"film.stack"]
                                        navSections:@[@{
                                            @"header": @"",
                                            @"rows": @[
                                                [SCISetting menuCellWithTitle:@"タップ操作" subtitle:@"リールをタップしたときの動作を変えます" menu:[self menus][@"reels_tap_control"]],
                                                [SCISetting switchCellWithTitle:@"シークバーを常に出す" subtitle:@"すべてのリールで進行バーを表示します" defaultsKey:@"reels_show_scrubber"],
                                                [SCISetting switchCellWithTitle:@"自動でミュート解除しない" subtitle:@"音量ボタンや消音スイッチでミュートが解除されなくなります" defaultsKey:@"disable_auto_unmuting_reels" requiresRestart:YES],
                                                [SCISetting switchCellWithTitle:@"リール更新の確認" subtitle:@"リールを更新しようとしたとき確認を出します" defaultsKey:@"refresh_reel_confirm"],
                                            ]
                                        },
                                        @{
                                            @"header": @"非表示",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"リールの上部バーを隠す" subtitle:@"リール視聴中の上部バーを隠します" defaultsKey:@"hide_reels_header"],
                                                [SCISetting switchCellWithTitle:@"ブレンドのボタンを隠す" subtitle:@"DM にあるリールのブレンドを開くボタンを隠します" defaultsKey:@"hide_reels_blend"]
                                            ]
                                        },
                                        @{
                                            @"header": @"制限",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"リールのスクロールを止める" subtitle:@"次の動画へスクロールできなくします" defaultsKey:@"disable_scrolling_reels" requiresRestart:YES],
                                                [SCISetting switchCellWithTitle:@"延々と見続けるのを防ぐ" subtitle:@"一度にスクロールできるリールの数を制限し、更新もできなくします" defaultsKey:@"prevent_doom_scrolling"],
                                                [SCISetting stepperCellWithTitle:@"スクロールできる本数" subtitle:@"%@ %@ だけ読み込む" defaultsKey:@"doom_scrolling_reel_count" min:1 max:100 step:1 label:@"reels" singularLabel:@"reel"]
                                            ]
                                        }]
                ],
                [SCISetting navigationCellWithTitle:@"保存"
                                           subtitle:@""
                                               icon:[SCISymbol symbolWithName:@"tray.and.arrow.down"]
                                        navSections:@[@{
                                            @"header": @"",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"フィードの投稿を保存" subtitle:@"ホームで投稿を指で長押しすると保存します" defaultsKey:@"dw_feed_posts"],
                                                [SCISetting switchCellWithTitle:@"リールを保存" subtitle:@"リールを指で長押しすると保存します" defaultsKey:@"dw_reels"],
                                                [SCISetting switchCellWithTitle:@"ストーリーを保存" subtitle:@"ストーリーを見ている間に指で長押しすると保存します" defaultsKey:@"dw_story"],
                                                [SCISetting switchCellWithTitle:@"プロフィール写真を保存" subtitle:@"プロフィール写真をタップして拡大し、そのまま長押しすると保存します" defaultsKey:@"save_profile"]
                                            ]
                                        },
                                        @{
                                            @"header": @"長押しの設定",
                                            @"rows": @[
                                                [SCISetting stepperCellWithTitle:@"長押しする指の本数" subtitle:@"%@ %@ で保存" defaultsKey:@"dw_finger_count" min:1 max:5 step:1 label:@"fingers" singularLabel:@"finger"],
                                                [SCISetting stepperCellWithTitle:@"長押しの秒数" subtitle:@"%@ %@ 長押し" defaultsKey:@"dw_finger_duration" min:0 max:10 step:0.25 label:@"sec" singularLabel:@"sec"]
                                            ]
                                        }]
                ],
                [SCISetting navigationCellWithTitle:@"ストーリーとメッセージ"
                                           subtitle:@""
                                               icon:[SCISymbol symbolWithName:@"rectangle.portrait.on.rectangle.portrait.angled"]
                                        navSections:@[@{
                                            @"header": @"メッセージ",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"削除されたメッセージを残す" subtitle:@"会話の中で削除されたメッセージを残します" defaultsKey:@"keep_deleted_message"],
                                                [SCISetting switchCellWithTitle:@"既読を手動でつける" subtitle:@"DM に、既読をつけるボタンを足します" defaultsKey:@"remove_lastseen"],
                                                [SCISetting switchCellWithTitle:@"入力中を知らせない" subtitle:@"DM の入力中に、相手へ「入力中」が出なくなります" defaultsKey:@"disable_typing_status"],
                                            ]
                                        },
                                        @{
                                            @"header": @"消える写真・動画とストーリー",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"消える写真・動画を何度でも見る" subtitle:@"一度きりの写真・動画を何度でも再生できます(画像のチェックアイコンで切り替え)" defaultsKey:@"unlimited_replay"],
                                                [SCISetting switchCellWithTitle:@"一度きりの制限を外す" subtitle:@"一度きりのメッセージを普通の写真・動画と同じように扱います(繰り返し・一時停止可)" defaultsKey:@"disable_view_once_limitations"],
                                                [SCISetting switchCellWithTitle:@"スクショの検知を止める" subtitle:@"DM の写真・動画のスクショ防止機能を無効にします" defaultsKey:@"remove_screenshot_alert"],
                                                [SCISetting switchCellWithTitle:@"ストーリーの足跡を残さない" subtitle:@"相手のストーリーを見ても通知されなくなります" defaultsKey:@"no_seen_receipt"],
                                                [SCISetting switchCellWithTitle:@"インスタントの作成を隠す" subtitle:@"インスタントを作る・送る機能を隠します" defaultsKey:@"disable_instants_creation" requiresRestart:YES]
                                            ]
                                        }]
                ],
                [SCISetting navigationCellWithTitle:@"ナビゲーション"
                                           subtitle:@""
                                               icon:[SCISymbol symbolWithName:@"hand.draw.fill"]
                                        navSections:@[@{
                                            @"header": @"",
                                            @"rows": @[
                                                [SCISetting menuCellWithTitle:@"アイコンの並び" subtitle:@"下のバーに並ぶアイコンの順番" menu:[self menus][@"nav_icon_ordering"]],
                                                [SCISetting menuCellWithTitle:@"スワイプでタブを移動" subtitle:@"横スワイプで下のバーのタブを切り替えられます" menu:[self menus][@"swipe_nav_tabs"]],
                                            ]
                                        },
                                        @{
                                            @"header": @"タブを隠す",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"ホームタブを隠す" subtitle:@"下のバーからホームタブを隠します" defaultsKey:@"hide_feed_tab" requiresRestart:YES],
                                                [SCISetting switchCellWithTitle:@"検索タブを隠す" subtitle:@"下のバーから検索タブを隠します" defaultsKey:@"hide_explore_tab" requiresRestart:YES],
                                                [SCISetting switchCellWithTitle:@"リールタブを隠す" subtitle:@"下のバーからリールタブを隠します" defaultsKey:@"hide_reels_tab" requiresRestart:YES],
                                                [SCISetting switchCellWithTitle:@"作成タブを隠す" subtitle:@"下のバーから作成タブを隠します" defaultsKey:@"hide_create_tab" requiresRestart:YES]
                                            ]
                                        }]
                ],
                [SCISetting navigationCellWithTitle:@"操作の確認"
                                           subtitle:@""
                                               icon:[SCISymbol symbolWithName:@"checkmark"]
                                        navSections:@[@{
                                            @"header": @"",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"いいねの確認(投稿・ストーリー)" subtitle:@"投稿やストーリーでいいねを押したとき確認を出します" defaultsKey:@"like_confirm"],
                                                [SCISetting switchCellWithTitle:@"いいねの確認(リール)" subtitle:@"リールでいいねを押したとき確認を出します" defaultsKey:@"like_confirm_reels"]
                                            ]
                                        },
                                        @{
                                            @"header": @"",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"フォローの確認" subtitle:@"フォローを押したとき確認を出します" defaultsKey:@"follow_confirm"],
                                                [SCISetting switchCellWithTitle:@"リポストの確認" subtitle:@"リポストを押したとき確認を出します" defaultsKey:@"repost_confirm"],
                                                [SCISetting switchCellWithTitle:@"通話の確認" subtitle:@"通話ボタンを押したとき確認を出します" defaultsKey:@"call_confirm"],
                                                [SCISetting switchCellWithTitle:@"音声メッセージの確認" subtitle:@"音声メッセージを送る前に確認を出します" defaultsKey:@"voice_message_confirm"],
                                                [SCISetting switchCellWithTitle:@"フォロー申請の確認" subtitle:@"フォロー申請を承認・拒否するとき確認を出します" defaultsKey:@"follow_request_confirm"],
                                                [SCISetting switchCellWithTitle:@"消えるメッセージの確認" subtitle:@"消えるメッセージを切り替える前に確認を出します" defaultsKey:@"shh_mode_confirm"],
                                                [SCISetting switchCellWithTitle:@"コメント投稿の確認" subtitle:@"コメントを投稿するとき確認を出します" defaultsKey:@"post_comment_confirm"],
                                                [SCISetting switchCellWithTitle:@"テーマ変更の確認" subtitle:@"チャットのテーマを変えるとき確認を出します" defaultsKey:@"change_direct_theme_confirm"],
                                                [SCISetting switchCellWithTitle:@"スタンプ操作の確認" subtitle:@"ストーリーのスタンプを押したとき確認を出します" defaultsKey:@"sticker_interact_confirm"]
                                            ]
                                        }]
                ]
            ]
        },
        @{
            @"header": @"",
            @"rows": @[
                // [SCISetting navigationCellWithTitle:@"実験中"
                //                            subtitle:@""
                //                                icon:[SCISymbol symbolWithName:@"testtube.2"]
                //                         navSections:@[@{
                //                             @"header": @"注意",
                //                             @"footer": @"ここの機能は不安定で、Instagram が突然落ちることがあります。\n\n自己責任で使ってください。"
                //                         },
                //                         @{
                //                             @"header": @"",
                //                             @"rows": @[

                //                             ]
                //                         }
                //                         ]
                // ],
                [SCISetting navigationCellWithTitle:@"開発者向け"
                                           subtitle:@""
                                               icon:[SCISymbol symbolWithName:@"ladybug"]
                                        navSections:@[@{
                                            @"header": @"FLEX",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"FLEX のジェスチャーを使う" subtitle:@"画面を 5 本指で長押しすると FLEX が開きます" defaultsKey:@"flex_instagram"],
                                                [SCISetting switchCellWithTitle:@"起動時に FLEX を開く" subtitle:@"アプリを起動したとき自動で FLEX を開きます" defaultsKey:@"flex_app_launch"],
                                                [SCISetting switchCellWithTitle:@"前面に戻ったとき FLEX を開く" subtitle:@"アプリが前面に戻ったとき自動で FLEX を開きます" defaultsKey:@"flex_app_start"]
                                            ]
                                        },
                                        @{
                                            @"header": @"SCInsta",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"出てきた画面の名前を表示" subtitle:@"ポップアップが出るたびに、その内部名を数秒だけ画面に出します。消したい画面を特定するため" defaultsKey:@"debug_show_presented"],
                                                [SCISetting switchCellWithTitle:@"設定のショートカット" subtitle:@"ホームタブを長押しすると SCInsta の設定が開きます" defaultsKey:@"settings_shortcut" requiresRestart:YES],
                                                [SCISetting switchCellWithTitle:@"起動時に設定を開く" subtitle:@"アプリを起動したとき自動で SCInsta の設定を開きます" defaultsKey:@"tweak_settings_app_launch"],
                                                [SCISetting buttonCellWithTitle:@"初回案内の状態を戻す"
                                                                           subtitle:@""
                                                                               icon:nil
                                                                             action:^(void) { [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SCInstaFirstRun"]; [SCIUtils showRestartConfirmation];}
                                                ],
                                            ]
                                        },
                                        @{
                                            @"header": @"Instagram",
                                            @"rows": @[
                                                [SCISetting switchCellWithTitle:@"セーフモードを無効にする" subtitle:@"続けて落ちたときに Instagram が設定を初期化しないようにします(自己責任)" defaultsKey:@"disable_safe_mode"]
                                            ]
                                        },
                                        @{
                                            @"header": @"_ Example",
                                            @"rows": @[
                                                [SCISetting staticCellWithTitle:@"Static Cell" subtitle:@"" icon:[SCISymbol symbolWithName:@"tablecells"]],
                                                [SCISetting switchCellWithTitle:@"Switch Cell" subtitle:@"Tap the switch" defaultsKey:@"test_switch_cell"],
                                                [SCISetting switchCellWithTitle:@"Switch Cell (Restart)" subtitle:@"Tap the switch" defaultsKey:@"test_switch_cell_restart" requiresRestart:YES],
                                                [SCISetting stepperCellWithTitle:@"Stepper cell" subtitle:@"%@%@" defaultsKey:@"test_stepper_cell" min:-10 max:1000 step:5.5 label:@"$" singularLabel:@"$"],
                                                [SCISetting linkCellWithTitle:@"Link Cell" subtitle:@"Using icon" icon:[SCISymbol symbolWithName:@"link" color:[UIColor systemTealColor] size:20.0] url:@"https://google.com"],
                                                [SCISetting linkCellWithTitle:@"Link Cell" subtitle:@"Using image" imageUrl:@"https://i.imgur.com/c9CbytZ.png" url:@"https://google.com"],
                                                [SCISetting buttonCellWithTitle:@"Button Cell"
                                                                           subtitle:@""
                                                                               icon:[SCISymbol symbolWithName:@"oval.inset.filled"]
                                                                             action:^(void) { [SCIUtils showConfirmation:^(void){}]; }
                                                ],
                                                [SCISetting menuCellWithTitle:@"Menu Cell" subtitle:@"Change the value on the right" menu:[self menus][@"test"]],
                                                [SCISetting navigationCellWithTitle:@"Navigation Cell"
                                                                           subtitle:@""
                                                                               icon:[SCISymbol symbolWithName:@"rectangle.stack"]
                                                                        navSections:@[@{
                                                                            @"header": @"",
                                                                            @"rows": @[]
                                                                        }]
                                                ]
                                            ],
                                            @"footer": @"_ Example"
                                        }
                                        ]
                ]
            ]
        },
        @{
            @"header": @"クレジット",
            @"rows": @[
                [SCISetting linkCellWithTitle:@"開発者" subtitle:@"SoCuul" imageUrl:@"https://i.imgur.com/c9CbytZ.png" url:@"https://socuul.dev"],
                [SCISetting linkCellWithTitle:@"リポジトリを見る" subtitle:@"GitHub でソースコードを見る" imageUrl:@"https://i.imgur.com/BBUNzeP.png" url:@"https://github.com/SoCuul/SCInsta"]
            ],
            @"footer": [NSString stringWithFormat:@"SCInsta %@\n\nInstagram v%@", SCIVersionString, [SCIUtils IGVersionString]]
        }
    ];
}


// MARK: - Title

///
/// This is the title displayed on the initial settings page view controller
///

+ (NSString *)title {
    return @"SCInsta Settings";
}


// MARK: - Menus

///
/// This returns a dictionary where each key corresponds to a certain menu that can be displayed.
/// Each "propertyList"  item is an NSDictionary containing the following items:
///
/// `"defaultsKey"`: The key to save the selected value under in NSUserDefaults
///
/// `"value"`: A unique string corresponding to the menu item which is selected
///
/// `"requiresRestart"`: (optional) Causes a popup to appear detailing you have to restart to use these features
///

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

+ (NSDictionary *)menus {
    return @{
        @"reels_tap_control": [UIMenu menuWithChildren:@[
            [UICommand commandWithTitle:@"既定"
                                    image:nil
                                    action:@selector(menuChanged:)
                            propertyList:@{
                                @"defaultsKey": @"reels_tap_control",
                                @"value": @"default",
                                @"requiresRestart": @YES
                            }
            ],
            [UIMenu menuWithTitle:@""
                            image:nil
                        identifier:nil
                            options:UIMenuOptionsDisplayInline
                            children:@[
                                [UICommand commandWithTitle:@"一時停止と再生"
                                                        image:nil
                                                        action:@selector(menuChanged:)
                                                propertyList:@{
                                                    @"defaultsKey": @"reels_tap_control",
                                                    @"value": @"pause",
                                                    @"requiresRestart": @YES
                                                }
                                ],
                                [UICommand commandWithTitle:@"ミュート切り替え"
                                                        image:nil
                                                        action:@selector(menuChanged:)
                                                propertyList:@{
                                                    @"defaultsKey": @"reels_tap_control",
                                                    @"value": @"mute",
                                                    @"requiresRestart": @YES
                                                }
                                ]
                            ]
            ]
        ]],

        @"nav_icon_ordering": [UIMenu menuWithChildren:@[
            [UICommand commandWithTitle:@"既定"
                                    image:nil
                                    action:@selector(menuChanged:)
                            propertyList:@{
                                @"defaultsKey": @"nav_icon_ordering",
                                @"value": @"default",
                                @"requiresRestart": @YES
                            }
            ],
            [UIMenu menuWithTitle:@""
                            image:nil
                        identifier:nil
                            options:UIMenuOptionsDisplayInline
                            children:@[
                                [UICommand commandWithTitle:@"従来"
                                                        image:nil
                                                        action:@selector(menuChanged:)
                                                propertyList:@{
                                                    @"defaultsKey": @"nav_icon_ordering",
                                                    @"value": @"classic",
                                                    @"requiresRestart": @YES
                                                }
                                ],
                                [UICommand commandWithTitle:@"標準"
                                                        image:nil
                                                        action:@selector(menuChanged:)
                                                propertyList:@{
                                                    @"defaultsKey": @"nav_icon_ordering",
                                                    @"value": @"standard",
                                                    @"requiresRestart": @YES
                                                }
                                ],
                                [UICommand commandWithTitle:@"別の形"
                                                        image:nil
                                                        action:@selector(menuChanged:)
                                                propertyList:@{
                                                    @"defaultsKey": @"nav_icon_ordering",
                                                    @"value": @"alternate",
                                                    @"requiresRestart": @YES
                                                }
                                ]
                            ]
            ]
        ]],
        @"swipe_nav_tabs": [UIMenu menuWithChildren:@[
            [UICommand commandWithTitle:@"既定"
                                    image:nil
                                    action:@selector(menuChanged:)
                            propertyList:@{
                                @"defaultsKey": @"swipe_nav_tabs",
                                @"value": @"default",
                                @"requiresRestart": @YES
                            }
            ],
            [UIMenu menuWithTitle:@""
                            image:nil
                        identifier:nil
                            options:UIMenuOptionsDisplayInline
                            children:@[
                                [UICommand commandWithTitle:@"有効"
                                                        image:nil
                                                        action:@selector(menuChanged:)
                                                propertyList:@{
                                                    @"defaultsKey": @"swipe_nav_tabs",
                                                    @"value": @"enabled",
                                                    @"requiresRestart": @YES
                                                }
                                ],
                                [UICommand commandWithTitle:@"無効"
                                                        image:nil
                                                        action:@selector(menuChanged:)
                                                propertyList:@{
                                                    @"defaultsKey": @"swipe_nav_tabs",
                                                    @"value": @"disabled",
                                                    @"requiresRestart": @YES
                                                }
                                ]
                            ]
            ]
        ]],

        @"test": [UIMenu menuWithChildren:@[
            [UIMenu menuWithTitle:@""
                            image:nil
                        identifier:nil
                            options:UIMenuOptionsDisplayInline
                            children:@[
                                [UICommand commandWithTitle:@"ABC"
                                                        image:nil
                                                        action:@selector(menuChanged:)
                                                propertyList:@{
                                                    @"defaultsKey": @"test_menu_cell",
                                                    @"value": @"abc"
                                                }
                                ],
                                [UICommand commandWithTitle:@"123"
                                                        image:nil
                                                        action:@selector(menuChanged:)
                                                propertyList:@{
                                                    @"defaultsKey": @"test_menu_cell",
                                                    @"value": @"123"
                                                }
                                ]
                            ]
            ],
            [UICommand commandWithTitle:@"再起動が必要"
                                  image:nil
                                 action:@selector(menuChanged:)
                           propertyList:@{
                               @"defaultsKey": @"test_menu_cell",
                               @"value": @"requires_restart",
                               @"requiresRestart": @YES
                           }
            ],
        ]]
    };
}

#pragma clang diagnostic pop

@end
