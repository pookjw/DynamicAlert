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

id da::makeTestActivityDescriptor() {
    NSString *identifier = [NSUUID UUID].UUIDString;
    
    NSString *target = NSBundle.mainBundle.bundleIdentifier;
    
    id /* (ACActivityPresentationOptions *) */ presentaionOptions = nil;
    
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
        @"isEphemeral": @NO
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
