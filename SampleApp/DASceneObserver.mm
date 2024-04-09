//
//  DASceneObserver.mm
//  SampleApp
//
//  Created by Jinwoo Kim on 4/10/24.
//

#import "DASceneObserver.hpp"
#import <objc/runtime.h>
#import <objc/message.h>

NSNotificationName const DASceneObserverDidTriggerActionNotification = @"DASceneObserverDidTriggerActionNotification";
NSString *DASceneObserverActionIdentifierKey = @"actionIdentifier";

@implementation DASceneObserver

- (void)scene:(id)scene didUpdateSettings:(id)settingsUpdate {
    id diff = ((id (*)(id, SEL))objc_msgSend)(settingsUpdate, sel_registerName("settingsDiff"));
    
    ((void (*)(id, SEL, id))objc_msgSend)(diff, sel_registerName("inspectOtherChangesWithBlock:"), ^(NSUInteger key, NSUInteger state) {
        if (key == 0x234567 && state == 2) {
            id settings = ((id (*)(id, SEL))objc_msgSend)(settingsUpdate, sel_registerName("settings"));
            id otherSettings = ((id (*)(id, SEL))objc_msgSend)(settings, sel_registerName("otherSettings"));
            
            NSArray *actionIdentifier = ((id (*)(id, SEL, NSUInteger))objc_msgSend)(otherSettings, sel_registerName("objectForSetting:"), 0x234567);
            
            [NSNotificationCenter.defaultCenter postNotificationName:DASceneObserverDidTriggerActionNotification 
                                                              object:self
                                                            userInfo:@{DASceneObserverActionIdentifierKey: actionIdentifier}];
        }
    });
}

@end
