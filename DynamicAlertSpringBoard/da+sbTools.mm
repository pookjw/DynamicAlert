//
//  da+sbTools.mm
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 3/31/24.
//

#import "da+sbTools.hpp"
#import <objc/runtime.h>
#import <objc/message.h>

id da::systemApertureControllerForMainDisplay() {
    // Home Button 같은 버튼들의 Action을 가지고 있음
    return ((id (*)(id, SEL))objc_msgSend)(UIApplication.sharedApplication, sel_registerName("systemApertureControllerForMainDisplay"));
}

__kindof UIViewController * da::systemApertureViewController() {
    id systemApertureController = da::systemApertureControllerForMainDisplay();
    
    __kindof UIViewController *systemApertureViewController = nil;
    object_getInstanceVariable(systemApertureController, "_systemApertureViewController", (void **)&systemApertureViewController);
    
    return systemApertureViewController;
}

id da::systemApertureManager() {
    __kindof UIViewController *systemApertureViewController = da::systemApertureViewController();
    
    id systemApertureManager = nil;
    object_getInstanceVariable(systemApertureViewController, "_systemApertureManager", (void **)&systemApertureManager);
    
    return systemApertureManager;
}

id da::defaultActivitySystemApertureElementObserver() {
    id /* (SBActivityManager *) */ activityManager = ((id (*)(Class, SEL))objc_msgSend)(objc_lookUpClass("SBActivityManager"), sel_registerName("sharedInstance"));
    
    NSHashTable *_observers;
    object_getInstanceVariable(activityManager, "_observers", (void **)&_observers);
    
    for (id observer in _observers) {
        if ([observer isKindOfClass:objc_lookUpClass("SBActivitySystemApertureElementObserver")]) {
            return observer;
        }
    }
    
    return nil;
}

id da::makeTestActivityDescriptor() {
    NSString *identifier = [NSUUID UUID].UUIDString;
    
    NSString *target = NSBundle.mainBundle.bundleIdentifier;
    
    id /* (ACActivityPresentationDestination *) */ destination_0 = ((id (*)(id, SEL, NSUInteger))objc_msgSend)([objc_lookUpClass("ACActivityPresentationDestination") alloc], sel_registerName("initWithDestination:"), 0);
    id /* (ACActivityPresentationDestination *) */ destination_1 = ((id (*)(id, SEL, NSUInteger))objc_msgSend)([objc_lookUpClass("ACActivityPresentationDestination") alloc], sel_registerName("initWithDestination:"), 1);
    id /* (ACActivityPresentationDestination *) */ destination_2 = ((id (*)(id, SEL, NSUInteger))objc_msgSend)([objc_lookUpClass("ACActivityPresentationDestination") alloc], sel_registerName("initWithDestination:"), 2);
    id /* (ACActivityPresentationDestination *) */ destination_3 = ((id (*)(id, SEL, NSUInteger))objc_msgSend)([objc_lookUpClass("ACActivityPresentationDestination") alloc], sel_registerName("initWithDestination:"), 3);
    
    id /* (ACActivityPresentationOptions *) */ presentaionOptions = ((id (*)(id, SEL, id))objc_msgSend)([objc_lookUpClass("ACActivityPresentationOptions") alloc], sel_registerName("initWithDestinations:"), @[destination_0, destination_1, destination_2, destination_3]);
    [destination_0 release];
    [destination_1 release];
    [destination_2 release];
    [destination_3 release];
    ((void (*)(id, SEL, BOOL))objc_msgSend)(presentaionOptions, sel_registerName("setUserDismissalAllowedOnLockScreen:"), YES);
    ((void (*)(id, SEL, BOOL))objc_msgSend)(presentaionOptions, sel_registerName("setShouldSuppressAlertContentOnLockScreen:"), YES);
    ((void (*)(id, SEL, BOOL))objc_msgSend)(presentaionOptions, sel_registerName("setShowsAuthorizationOptions:"), NO);
    ((void (*)(id, SEL, NSUInteger))objc_msgSend)(presentaionOptions, sel_registerName("setShowsAuthorizationOptions:"), 0);
    
    BOOL isEphemeral = NO;
    
    NSDate *date = [NSDate now];
    
    NSDictionary *attributes = @{};
    NSError * _Nullable error = nil;
    NSData *attributesData = [NSJSONSerialization dataWithJSONObject:attributes options:NSJSONReadingJSON5Allowed error:&error];
    assert(!error);
    NSDictionary *descriptor = @{
        @"attributesData": attributesData,
        @"attributesType": @{
            @"attributesType": @"DynamicAlertSpringBoardAttributes"
        },
        @"createdDate": date,
        @"id": identifier,
        @"isEphemeral": @NO,
        @"platterTarget": @{
            @"widget": @{
                @"containingProcess": @{
                    @"bundleIdentifier": NSBundle.mainBundle.bundleIdentifier,
                    @"canBypassActivityCountLimits": @NO,
                    @"canContributeToAllActivities": @NO,
                    @"canEndAllActivities": @NO,
                    @"isAppIntentsExtension": @NO
                }
            }
        },
        @"contentSources": @[
            @{
            @"process": @{
                 @"target": @{
                 @"bundleIdentifier": NSBundle.mainBundle.bundleIdentifier,
             @"canBypassActivityCountLimits": @NO,
             @"canContributeToAllActivities": @NO,
             @"canEndAllActivities": @NO,
             @"isAppIntentsExtension": @NO
             }
             }
             },
             @{
             @"sync": @{
                 
                 }
                 }
        ],
        @"presentationOptions": @{
            @"destinations": @[
                               @{
                               @"lockscreen": @{}
                               },
                                @{
                                @"systemAperture": @{}
                                },
                                @{
                                @"banner": @{}
                                },
                                @{
                                @"ambient": @{}
                                }
                               ],
            @"isUserDismissalAllowedOnLockScreen": @YES,
            @"shouldSuppressAlertContentOnLockScreen": @YES,
            @"showsAuthorizationOptions": @NO
        }
    };
    NSData *descriptorData = ((id (*)(id, SEL))objc_msgSend)(descriptor, sel_registerName("plistData"));
    
    NSUInteger contentType = 0;
    
    // -[ACActivityDescriptor initWithIdentifier:target:presentationOptions:isEphemeral:createdDate:descriptorData:contentType:]
    
    id result = ((id (*)(id, SEL, id, id, id, BOOL, id, id, NSUInteger))objc_msgSend)([objc_lookUpClass("ACActivityDescriptor") alloc], sel_registerName("initWithIdentifier:target:presentationOptions:isEphemeral:createdDate:descriptorData:contentType:"), identifier, target, presentaionOptions, isEphemeral, date, descriptorData, contentType);
    return [result autorelease];
    
    /*
     NSString * (Random UUID), NSString * (com.pookjw.Practice-DynamicIsland), ACActivityPresentationOptions *, NO, NSDate *, NSData * (NSDictionary PLIST), 0
     
     {
         attributesData = {length = 16, bytes = 0x7b226e616d65223a22576f726c64227d};
         attributesType =     {
             attributesType = "PDI_WidgetAttributes";
         };
         contentSources =     (
                     {
                 process =             {
                     target =                 {
                         bundleIdentifier = "com.pookjw.Practice-DynamicIsland";
                         canBypassActivityCountLimits = 0;
                         canContributeToAllActivities = 0;
                         canEndAllActivities = 0;
                         isAppIntentsExtension = 0;
                     };
                 };
             },
                     {
                 sync =             {
                 };
             }
         );
         createdDate = "2024-03-31 09:25:06 +0000";
         id = "9211260C-CF70-443F-BC13-B6DC7EE443B2";
         isEphemeral = 0;
         platterTarget =     {
             widget =         {
                 containingProcess =             {
                     bundleIdentifier = "com.pookjw.Practice-DynamicIsland";
                     canBypassActivityCountLimits = 0;
                     canContributeToAllActivities = 0;
                     canEndAllActivities = 0;
                     isAppIntentsExtension = 0;
                 };
             };
         };
         presentationOptions =     {
             authorizationOptionsType =         {
                 firstPermission =             {
                 };
             };
             destinations =         (
                             {
                     lockscreen =                 {
                     };
                 },
                             {
                     systemAperture =                 {
                     };
                 },
                             {
                     banner =                 {
                     };
                 },
                             {
                     ambient =                 {
                     };
                 }
             );
             isUserDismissalAllowedOnLockScreen = 1;
             shouldSuppressAlertContentOnLockScreen = 1;
             showsAuthorizationOptions = 0;
         };
     }
     */
}

id da::makeTestActivityContent() {
    NSDictionary *content = @{
        
    };
    
    NSError * _Nullable error = nil;
    NSData *contentData = [NSJSONSerialization dataWithJSONObject:content options:0 error:&error];
    
    id result = ((id (*)(id, SEL, id, id, double))objc_msgSend)([objc_lookUpClass("ACActivityContent") alloc], sel_registerName("initWithContentData:staleDate:relevanceScore:"), contentData, nil, 0.);
    
    return [result autorelease];
}

id da::makeTestActivityContentUpdate(id  _Nonnull descriptor, id  _Nonnull content) {
    NSString *identifier = NSBundle.mainBundle.bundleIdentifier;
    
    // 아마 SpringBoard가 재시작 됐을 때를 말하는 것 같음
    NSUInteger state = 2;
    
    id result = ((id (*)(id, SEL, id, id, NSUInteger, id))objc_msgSend)([objc_lookUpClass("ACActivityContentUpdate") alloc], sel_registerName("initWithIdentifier:descriptor:state:content:"), identifier, descriptor, state, content);
    
    return [result autorelease];
}

id da::makeTestActivityItem(id contentUpdate) {
    id result = ((id (*)(id, SEL, id))objc_msgSend)([objc_lookUpClass("SBActivityItem") alloc], sel_registerName("initWithContentUpdate:"), contentUpdate);
    return [result autorelease];
}

id da::makeSystemApertureSceneHandleWithItem(id  _Nonnull activityItem) {
    id activitySystemApertureElementObserver = da::defaultActivitySystemApertureElementObserver();
    
    return ((id (*)(id, SEL, id))objc_msgSend)(activitySystemApertureElementObserver, sel_registerName("_createSystemApertureSceneHandleWithItem:"), activityItem);
}

id da::makeSystemApertureSceneElement(id scene, id systemApertureController, void
(^readyForPresentationHandler)(id element, BOOL success)) {
    id result = ((id (*)(id, SEL, id, id, id))objc_msgSend)([objc_lookUpClass("SBSystemApertureSceneElement") alloc], sel_registerName("initWithScene:statusBarBackgroundActivitiesSuppresser:readyForPresentationHandler:"), scene, systemApertureController, readyForPresentationHandler);
    
    return [result autorelease];
}
