//
//  DASceneHandleObserver.mm
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 4/9/24.
//

#import "DASceneHandleObserver.hpp"
#import <objc/runtime.h>
#import <objc/message.h>
#import "da+sbTools.hpp"

@implementation DASceneHandleObserver

+ (void)load {
    class_addProtocol(self, NSProtocolFromString(@"SBSceneHandleObserver"));
}

+ (DASceneHandleObserver *)sharedInstance {
    static dispatch_once_t onceToken;
    static DASceneHandleObserver *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [DASceneHandleObserver new];
    });
    
    return instance;
}

- (void)sceneHandle:(id)sceneHandle didCreateScene:(id)scene {
    
}

- (void)sceneHandle:(id)sceneHandle didDestroyScene:(id)scene {
    
}

- (void)sceneHandle:(id)sceneHandle didUpdateClientSettingsWithDiff:(id)diff transitionContext:(id)transitionContext {
    ((void (*)(id, SEL, id))objc_msgSend)(diff, sel_registerName("inspectOtherChangesWithBlock:"), ^(NSUInteger key, NSUInteger state) {
        if (key == 0x123456 && state == 2) {
            id fbscene = ((id (*)(id, SEL))objc_msgSend)(sceneHandle, sel_registerName("sceneIfExists"));
            
            NSString *identifier = ((id (*)(id, SEL))objc_msgSend)(fbscene, sel_registerName("identifier"));
            id clientSettings = ((id (*)(id, SEL))objc_msgSend)(fbscene, sel_registerName("clientSettings"));
            id otherSettings = ((id (*)(id, SEL))objc_msgSend)(clientSettings, sel_registerName("otherSettings"));
            
            NSArray *alertInfo = ((id (*)(id, SEL, NSUInteger))objc_msgSend)(otherSettings, sel_registerName("objectForSetting:"), 0x123456);
            if (alertInfo.count == 0) return;

            NSDictionary *first = alertInfo[0];
            
            NSString *title = first[@"title"];
            NSString *message = first[@"message"];
            NSArray<NSDictionary *> *actionsInfo = first[@"actions"];
            
            __block id systemApertureSceneElement;
            NSMutableArray<UIAction *> *actions = [NSMutableArray new];
            for (NSDictionary *actionInfo in actionsInfo) {
                NSString *title = actionInfo[@"title"];
                NSString *identifier = actionInfo[@"identifier"];
                
                UIAction *action = [UIAction actionWithTitle:title image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    ((void (*)(id, SEL, id))objc_msgSend)(fbscene, sel_registerName("updateSettingsWithBlock:"), ^(id mutableSettings, Class) {
                        id mutableOtherSettings = ((id (*)(id, SEL))objc_msgSend)(mutableSettings, sel_registerName("otherSettings"));
                        ((void (*)(id, SEL, id, NSUInteger))objc_msgSend)(mutableOtherSettings, sel_registerName("setObject:forSetting:"), identifier, 0x234567);
                    });
                    
                    id associatedApplication = ((id (*)(id, SEL))objc_msgSend)(systemApertureSceneElement, sel_registerName("associatedApplication"));
                    NSString *bundleIdentifier = ((id (*)(id, SEL))objc_msgSend)(associatedApplication, sel_registerName("bundleIdentifier"));
                    id activityItem = da::activatedActivityItemFromBundleIdentifier(bundleIdentifier);
                    
                    id activitySystemApertureElementObserver = da::defaultActivitySystemApertureElementObserver();
                    ((void (*)(id, SEL, id))objc_msgSend)(activitySystemApertureElementObserver, sel_registerName("activityDidEnd:"), activityItem);
                }];
                
                [actions addObject:action];
            }
            
            da::makeAlertElement(title, message, actions, ^(id  _Nonnull element) {
                ((void (*)(id, SEL, BOOL))objc_msgSend)(element, sel_registerName("setUrgent:"), YES);
                systemApertureSceneElement = element;
            });
            
            [actions release];
        }
    });
}

- (void)sceneHandle:(id)sceneHandle didUpdateContentState:(NSUInteger)contentState {
    
}

- (void)sceneHandle:(id)sceneHandle didUpdatePairingStatusForExternalSceneIdentifiers:(id)externalSceneIdentifiers {
    
}

- (void)sceneHandle:(id)sceneHandle didUpdateSettingsWithDiff:(id)diff previousSettings:(id)previousSettings {
    
}

@end
