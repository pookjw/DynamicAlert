//
//  main.mm
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 3/30/24.
//

#import <UIKit/UIKit.h>
#import "da+hook.hpp"
#import "da+sbTools.hpp"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ButtonViewController : UIViewController
@end

@implementation ButtonViewController

- (void)loadView {
    UIView *view = [objc_lookUpClass("SBFTouchPassThroughView") new];
    self.view = view;
    [view release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButtonConfiguration *buttonConfiguration = [UIButtonConfiguration tintedButtonConfiguration];
    buttonConfiguration.title = @"Foo";
    
    UIAction *primaryAction = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        NSLog(@"Foo: %@", da::systemApertureManager());
        NSLog(@"Foo: %@", da::makeTestActivityDescriptor());
        
        /*
         -[ACActivityDescriptor initWithIdentifier:target:presentationOptions:isEphemeral:createdDate:descriptorData:contentType:]
         
         NSString * (Random UUID), ACActivityDescriptor *, int (2), ACActivityContent *
         -[ACActivityContentUpdate initWithIdentifier:descriptor:state:content:]
         
         
         -[SBActivityItem initWithContentUpdate:]
         -[SBActivitySystemApertureElementObserver _createSystemApertureSceneHandleWithItem:]
         -[SBSystemApertureSceneElement initWithScene:statusBarBackgroundActivitiesSuppresser:readyForPresentationHandler:]
         -[SAUISystemApertureManager registerElement:]
         */
    }];
    
    UIButton *button = [UIButton buttonWithConfiguration:buttonConfiguration primaryAction:primaryAction];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [button.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];
}

@end

namespace da_UIScene {
namespace _sceneForFBSScene_create_withSession_connectionOptions {
static void *key = &key;
static id (*original)(Class, SEL, id, BOOL, id, id);
static id custom(Class cls, SEL _cmd, id fbScene, BOOL create, id session, id connectionOptions) {
    UIWindowScene *windowScene = original(cls, _cmd, fbScene, create, session, connectionOptions);
    
    if ([windowScene isKindOfClass:objc_lookUpClass("SBWindowScene")]) {
        UIWindow *window = ((id (*)(id, SEL, id))objc_msgSend)([objc_lookUpClass("SBFSecureTouchPassThroughWindow") alloc], @selector(initWithWindowScene:), windowScene);
        ButtonViewController *rootViewController = [ButtonViewController new];
        window.rootViewController = rootViewController;
        [rootViewController release];
        [window makeKeyAndVisible];
        objc_setAssociatedObject(windowScene, key, window, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [window release];
    }
    
    return windowScene;
}
}
}

namespace da_ACActivityDescriptor {
namespace initWithIdentifier_target_presentationOptions_isEphemeral_createdDate_descriptorData_contentType {
static id (*original)(id self, SEL _cmd, id identifier, id target, id presentationOptions, BOOL isEphemeral, NSDate *createdDate, NSData *descriptorData, NSUInteger contentType);
static id custom(id self, SEL _cmd, id identifier, id target, id presentationOptions, BOOL isEphemeral, NSDate *createdDate, NSData *descriptorData, NSUInteger contentType) {
    NSDictionary *dic = ((id (*)(Class, SEL, id))objc_msgSend)(NSDictionary.class, sel_registerName("dictionaryWithPlistData:"), descriptorData);
    NSData *attributesData = dic[@"attributesData"];
//    NSDictionary *attributes = ((id (*)(Class, SEL, id))objc_msgSend)(NSDictionary.class, sel_registerName("dictionaryWithPlistData:"), attributesData);
    NSError * _Nullable error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:attributesData options:NSJSONReadingJSON5Allowed error:&error];
    
    return original(self, _cmd, identifier, target, presentationOptions, isEphemeral, createdDate, descriptorData, contentType);
}
}
}

__attribute__((constructor)) static void init() {
    da::hookMessage(UIScene.class, sel_registerName("_sceneForFBSScene:create:withSession:connectionOptions:"), NO, (IMP)(&da_UIScene::_sceneForFBSScene_create_withSession_connectionOptions::custom), (IMP *)(&da_UIScene::_sceneForFBSScene_create_withSession_connectionOptions::original));
    
    da::hookMessage(objc_lookUpClass("ACActivityDescriptor"), sel_registerName("initWithIdentifier:target:presentationOptions:isEphemeral:createdDate:descriptorData:contentType:"), YES, (IMP)(&da_ACActivityDescriptor::initWithIdentifier_target_presentationOptions_isEphemeral_createdDate_descriptorData_contentType::custom), (IMP *)(&da_ACActivityDescriptor::initWithIdentifier_target_presentationOptions_isEphemeral_createdDate_descriptorData_contentType::original));
}
