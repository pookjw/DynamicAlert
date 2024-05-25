//
//  DAAlertControllerView.mm
//  SampleApp
//
//  Created by Jinwoo Kim on 4/10/24.
//

#import "DAAlertControllerView.hpp"
#import <objc/runtime.h>
#import <objc/message.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

__attribute__((objc_direct_members))
@interface DAAlertControllerView ()
@property (class, assign, readonly, nonatomic) void *actionIdentifierKey;
@property (retain, readonly, nonatomic, nullable) id fbsScene;
@property (copy, readonly, nonatomic) NSUUID *alertIdentifier;
@end

@implementation DAAlertControllerView

+ (void)load {
    [DAAlertControllerView dynamicIsa];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[DAAlertControllerView dynamicIsa] allocWithZone:zone];
}

+ (Class)dynamicIsa __attribute__((objc_direct)) {
    static Class isa;
    
    if (isa == NULL) {
        Class _isa = objc_allocateClassPair(objc_lookUpClass("_UIAlertControllerView"), "_DAAlertControllerView", 0);
        
        IMP initWithFrame = class_getMethodImplementation(self, @selector(initWithFrame:));
        assert(class_addMethod(_isa, @selector(initWithFrame:), initWithFrame, NULL));
        
        IMP didMoveToWindow = class_getMethodImplementation(self, @selector(didMoveToWindow));
        assert(class_addMethod(_isa, @selector(didMoveToWindow), didMoveToWindow, NULL));
        
        IMP configureForPresentAlongsideTransitionCoordinator = class_getMethodImplementation(self, @selector(configureForPresentAlongsideTransitionCoordinator:));
        assert(class_addMethod(_isa, @selector(configureForPresentAlongsideTransitionCoordinator:), configureForPresentAlongsideTransitionCoordinator, NULL));
        
        IMP scene_didUpdateSettings = class_getMethodImplementation(self, @selector(scene:didUpdateSettings:));
        assert(class_addMethod(_isa, @selector(scene:didUpdateSettings:), scene_didUpdateSettings, NULL));
        
        class_addIvar(_isa, "_alertIdentifier", sizeof(id), sizeof(id), NULL);
        
        isa = _isa;
    }
    
    return isa;
}

+ (void *)actionIdentifierKey {
    static void *key = &key;
    return key;
}

- (instancetype)initWithFrame:(CGRect)frame {
    objc_super superInfo = { self, [self class] };
    self = ((id (*)(objc_super *, SEL, CGRect))objc_msgSendSuper2)(&superInfo, _cmd, frame);
    
    if (self) {
        NSUUID *alertIdentifier = [NSUUID UUID];
        object_setInstanceVariable(self, "_alertIdentifier", [alertIdentifier copy]);
    }
    
    return self;
}

- (void)didMoveToWindow {
    objc_super superInfo = { self, [self class] };
    ((void (*)(objc_super *, SEL))objc_msgSendSuper2)(&superInfo, _cmd);
    
    ((void (*)(id, SEL, id))objc_msgSend)(self.fbsScene, sel_registerName("addObserver:"), self);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<_DAAlertControllerView: %p>", self];
}

- (void)configureForPresentAlongsideTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)transitionCoordinator {
    UIAlertController *alertController = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("alertController"));
    
    NSUUID *alertIdentifier = self.alertIdentifier;
    NSString *title = alertController.title;
    NSString *message = alertController.message;
    
    NSMutableArray<NSDictionary *> *actions = [NSMutableArray new];
    for (UIAlertAction *action in alertController.actions) {
        NSString *identifier = [NSUUID UUID].UUIDString;
        objc_setAssociatedObject(action, DAAlertControllerView.actionIdentifierKey, identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        [actions addObject:@{
            @"identifier": identifier,
            @"title": action.title
        }];
    }
    
    ((void (*)(id, SEL, id))objc_msgSend)(self.fbsScene, sel_registerName("updateUIClientSettingsWithBlock:"), ^(id /* (UIMutableApplicationSceneClientSettings *) */ mutableSettings, Class resultClass) {
        id mutableOtherSettings = ((id (*)(id, SEL))objc_msgSend)(mutableSettings, sel_registerName("otherSettings"));
        
        NSMutableArray *alertInfo = [((id (*)(id, SEL, NSUInteger))objc_msgSend)(mutableOtherSettings, sel_registerName("objectForSetting:"), 0x123456) mutableCopy];
        
        if (alertInfo == nil) {
            alertInfo = [NSMutableArray new];
        }
        
        [alertInfo addObject:@{
            @"identifier": alertIdentifier.UUIDString,
            @"title": title,
            @"message": message,
            @"actions": actions
        }];
        
        ((void (*)(id, SEL, id, NSUInteger))objc_msgSend)(mutableOtherSettings, sel_registerName("setObject:forSetting:"), alertInfo, 0x123456);
        
        [alertInfo release];
    });
    
    [actions release];
    
    objc_super superInfo = { self, [self class] };
    ((void (*)(objc_super *, SEL, id))objc_msgSendSuper2)(&superInfo, _cmd, transitionCoordinator);
}

- (void)scene:(id)scene didUpdateSettings:(id)settingsUpdate {
    if (![scene isEqual:self.fbsScene]) return;
    
    NSUUID *alertIdentifier = self.alertIdentifier;
    UIAlertController *alertController = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("alertController"));
    NSArray<UIAlertAction *> *actions = alertController.actions;
    
    id diff = ((id (*)(id, SEL))objc_msgSend)(settingsUpdate, sel_registerName("settingsDiff"));
    
    ((void (*)(id, SEL, id))objc_msgSend)(diff, sel_registerName("inspectOtherChangesWithBlock:"), ^(NSUInteger key, NSUInteger state) {
        if (key == 0x234567) {
            id settings = ((id (*)(id, SEL))objc_msgSend)(settingsUpdate, sel_registerName("settings"));
            id otherSettings = ((id (*)(id, SEL))objc_msgSend)(settings, sel_registerName("otherSettings"));
            
            NSString *actionIdentifier = ((id (*)(id, SEL, NSUInteger))objc_msgSend)(otherSettings, sel_registerName("objectForSetting:"), 0x234567);
            
            for (UIAlertAction *action in actions) {
                NSString *identifier = objc_getAssociatedObject(action, DAAlertControllerView.actionIdentifierKey);
                
                if ([actionIdentifier isEqualToString:identifier]) {
                    ((void (*)(id, SEL, BOOL, id))objc_msgSend)(alertController, sel_registerName("_dismissAnimated:triggeringAction:"), YES, action);
                    
                    ((void (*)(id, SEL, id))objc_msgSend)(self.fbsScene, sel_registerName("updateUIClientSettingsWithBlock:"), ^(id /* (UIMutableApplicationSceneClientSettings *) */ mutableSettings, Class resultClass) {
                        id mutableOtherSettings = ((id (*)(id, SEL))objc_msgSend)(mutableSettings, sel_registerName("otherSettings"));
                        
                        NSMutableArray<NSDictionary *> *alertInfo = [((id (*)(id, SEL, NSUInteger))objc_msgSend)(mutableOtherSettings, sel_registerName("objectForSetting:"), 0x123456) mutableCopy];
                        
                        if (alertInfo == nil) {
                            return;
                        }
                        
                        [alertInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj[@"identifier"] isEqual:alertIdentifier.UUIDString]) {
                                [alertInfo removeObjectAtIndex:idx];
                                *stop = YES;
                            }
                        }];
                        
                        ((void (*)(id, SEL, id, NSUInteger))objc_msgSend)(mutableOtherSettings, sel_registerName("setObject:forSetting:"), alertInfo, 0x123456);
                        
                        [alertInfo release];
                    });
                    
                    break;
                }
            }
        }
    });
}

- (id)fbsScene {
    UIWindow *window = ((id (*)(id, SEL))objc_msgSend)(self, @selector(window));
    if (window == nil) return nil;
    
    UIWindowScene *windowScene = window.windowScene;
    id fbsScene = ((id (*)(id, SEL))objc_msgSend)(windowScene, sel_registerName("_scene"));
    
    return fbsScene;
}

- (NSUUID *)alertIdentifier {
    NSUUID *alertIdentifier;
    object_getInstanceVariable(self, "_alertIdentifier", (void **)&alertIdentifier);
    return alertIdentifier;
}

@end
