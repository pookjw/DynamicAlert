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
        id activitySystemApertureElementObserver = da::defaultActivitySystemApertureElementObserver();
        id systemApertureManager = da::systemApertureManager();
        id activityDescriptor = da::makeTestActivityDescriptor();
        id activityContent = da::makeTestActivityContent();
        id activityContentUpdate = da::makeTestActivityContentUpdate(activityDescriptor, activityContent);
        id activityItem = da::makeTestActivityItem(activityContentUpdate);
        
        ((void (*)(id, SEL, id, id))objc_msgSend)(activitySystemApertureElementObserver, sel_registerName("_createAndActivateElementForActivityItem:completion:"), activityItem, ^void(BOOL success) {
            assert(success);
            
            NSArray *registeredElements = ((id (*)(id, SEL))objc_msgSend)(systemApertureManager, sel_registerName("registeredElements"));
            
            for (id element in registeredElements) {
//                ((void (*)(id, SEL, NSDirectionalEdgeInsets))objc_msgSend)(element, )
                
                NSMutableArray<UIView *> *views = [NSMutableArray array];
                
                __kindof UIView *sceneView = [objc_lookUpClass("SBSystemApertureSceneElementScenePresenterView") new];
                [views addObject:sceneView];
                ((void (*)(id, SEL, id))objc_msgSend)(element, sel_registerName("setSceneView:"), sceneView);
                [sceneView release];
                
                __kindof UIView *leadingView = [objc_lookUpClass("SBSystemApertureSceneElementAccessoryView") new];
                [views addObject:leadingView];
                ((void (*)(id, SEL, id))objc_msgSend)(element, sel_registerName("setLeadingView:"), leadingView);
                [leadingView release];
                
                __kindof UIView *trailingView = [objc_lookUpClass("SBSystemApertureSceneElementAccessoryView") new];
                [views addObject:trailingView];
                ((void (*)(id, SEL, id))objc_msgSend)(element, sel_registerName("setTrailingView:"), trailingView);
                [trailingView release];
                
                __kindof UIView *minimalView = [objc_lookUpClass("SBSystemApertureSceneElementAccessoryView") new];
                [views addObject:minimalView];
                ((void (*)(id, SEL, id))objc_msgSend)(element, sel_registerName("setMinimalView:"), minimalView);
                [minimalView release];
                
                __kindof UIView *detachedMinimalView = [objc_lookUpClass("SBSystemApertureSceneElementAccessoryView") new];
                [views addObject:detachedMinimalView];
                ((void (*)(id, SEL, id))objc_msgSend)(element, sel_registerName("setDetachedMinimalView:"), detachedMinimalView);
                [detachedMinimalView release];
                
                [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIView *yellowView = [UIView new];
                    switch (idx) {
                        case 0:
//                            yellowView.backgroundColor = UIColor.cyanColor;
                        {
                            [yellowView release];
                            yellowView = [UIActivityIndicatorView new];
                            [(UIActivityIndicatorView *)yellowView startAnimating];
                        }
                        case 1:
                            yellowView.backgroundColor = UIColor.blueColor;
                            break;
                        case 2:
                            yellowView.backgroundColor = UIColor.greenColor;
                            break;
                        case 3:
                            yellowView.backgroundColor = UIColor.purpleColor;
                            break;
                        case 4:
                            yellowView.backgroundColor = UIColor.systemPinkColor;
                            break;
                        default:
                            break;
                    }
                    
                    yellowView.translatesAutoresizingMaskIntoConstraints = NO;
                    [obj addSubview:yellowView];
                    [NSLayoutConstraint activateConstraints:@[
                        [yellowView.topAnchor constraintEqualToAnchor:obj.topAnchor],
                        [yellowView.leadingAnchor constraintEqualToAnchor:obj.leadingAnchor],
                        [yellowView.trailingAnchor constraintEqualToAnchor:obj.trailingAnchor],
                        [yellowView.bottomAnchor constraintEqualToAnchor:obj.bottomAnchor],
                    ]];
                    [yellowView release];
                }];
            }
        });
        
        /*
         -[ACActivityDescriptor initWithIdentifier:target:presentationOptions:isEphemeral:createdDate:descriptorData:contentType:]
         
         NSString * (Random UUID), ACActivityDescriptor *, int (2), ACActivityContent *
         -[ACActivityContentUpdate initWithIdentifier:descriptor:state:content:]
         
         -[SBActivityItem initWithContentUpdate:]
         -[SBActivitySystemApertureElementObserver _createAndActivateElementForActivityItem:completion:]
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

namespace da_ACActivityContent {
namespace initWithContentData_staleDate_relevanceScore {
static id (*original)(id self, SEL _cmd, id contentData, NSDate *staleDate, double relevanceScore);
static id custom(id self, SEL _cmd, id contentData, NSDate *staleDate, double relevanceScore) {
    NSError * _Nullable error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingJSON5Allowed error:&error];
    
    return original(self, _cmd, contentData, staleDate, relevanceScore);
}
}
}

namespace da_SBSystemApertureSceneElementAccessoryView {
namespace _configurePortalView {
static void (*original)(id self, SEL _cmd);
static void custom(id self, SEL _cmd) {
    
}
}
}

namespace da_SBSAContainerViewDescription {
namespace contentBounds {
static CGRect (*original)(id self, SEL _cmd);
static CGRect custom(id self, SEL _cmd) {
    return CGRectMake(0.f, 0.f, 200.f, 200.f);
}
}
}

namespace da_SBSAContainerViewDescription {
namespace _setContentBounds {
static void (*original)(id self, SEL _cmd, CGRect);
static void custom(id self, SEL _cmd, CGRect) {
    original(self, _cmd, CGRectMake(0.f, 0.f, 200.f, 200.f));
}
}
}

namespace da_SBSAViewDescription {
namespace bounds {
static CGRect (*original)(id self, SEL _cmd);
static CGRect custom(id self, SEL _cmd) {
    return CGRectMake(0.f, 0.f, 407.33333333333331, 200.f);
}
}
}
namespace da_SBSAViewDescription {
namespace center {
static CGPoint (*original)(id self, SEL _cmd);
static CGPoint custom(id self, SEL _cmd) {
    return CGPointMake(200.f, 100.f);
}
}
}

namespace da_SBSAViewDescription {
namespace _setCenter {
static void (*original)(id self, SEL _cmd, CGPoint);
static void custom(id self, SEL _cmd, CGPoint center) {
    NSLog(@"Foo: %@", NSStringFromCGPoint(center));
    original(self, _cmd, CGPointMake(215, 33.333333333333336));
}
}
}

namespace da_SBSAViewDescription {
namespace _setBounds {
static void (*original)(id self, SEL _cmd, CGRect);
static void custom(id self, SEL _cmd, CGRect bounds) {
    NSLog(@"Foo: %@", NSStringFromCGRect(bounds));
    original(self, _cmd, CGRectMake(0.f, 0.f, 200.f, 100.f));
}
}
}

__attribute__((constructor)) static void init() {
    da::hookMessage(UIScene.class, sel_registerName("_sceneForFBSScene:create:withSession:connectionOptions:"), NO, (IMP)(&da_UIScene::_sceneForFBSScene_create_withSession_connectionOptions::custom), (IMP *)(&da_UIScene::_sceneForFBSScene_create_withSession_connectionOptions::original));
    
    da::hookMessage(objc_lookUpClass("ACActivityDescriptor"), sel_registerName("initWithIdentifier:target:presentationOptions:isEphemeral:createdDate:descriptorData:contentType:"), YES, (IMP)(&da_ACActivityDescriptor::initWithIdentifier_target_presentationOptions_isEphemeral_createdDate_descriptorData_contentType::custom), (IMP *)(&da_ACActivityDescriptor::initWithIdentifier_target_presentationOptions_isEphemeral_createdDate_descriptorData_contentType::original));
    
    da::hookMessage(objc_lookUpClass("ACActivityContent"), sel_registerName("initWithContentData:staleDate:relevanceScore:"), YES, (IMP)(&da_ACActivityContent::initWithContentData_staleDate_relevanceScore::custom), (IMP *)(&da_ACActivityContent::initWithContentData_staleDate_relevanceScore::original));
    
//    da::hookMessage(objc_lookUpClass("SBSystemApertureSceneElementAccessoryView"), sel_registerName("_configurePortalView"), YES, (IMP)(&da_SBSystemApertureSceneElementAccessoryView::_configurePortalView::custom), (IMP *)(&da_SBSystemApertureSceneElementAccessoryView::_configurePortalView::original));
    
//    da::hookMessage(objc_lookUpClass("SBSAContainerViewDescription"), sel_registerName("contentBounds"), YES, (IMP)(&da_SBSAContainerViewDescription::contentBounds::custom), (IMP *)(&da_SBSAContainerViewDescription::contentBounds::original));
//    
//    da::hookMessage(objc_lookUpClass("SBSAContainerViewDescription"), sel_registerName("_setContentBounds:"), YES, (IMP)(&da_SBSAContainerViewDescription::_setContentBounds::custom), (IMP *)(&da_SBSAContainerViewDescription::_setContentBounds::original));
    
//    da::hookMessage(objc_lookUpClass("SBSAViewDescription"), sel_registerName("center"), YES, (IMP)(&da_SBSAViewDescription::center::custom), (IMP *)(&da_SBSAViewDescription::center::original));
//    da::hookMessage(objc_lookUpClass("SBSAViewDescription"), sel_registerName("bounds"), YES, (IMP)(&da_SBSAViewDescription::bounds::custom), (IMP *)(&da_SBSAViewDescription::bounds::original));
    
//    da::hookMessage(objc_lookUpClass("SBSAViewDescription"), sel_registerName("_setCenter:"), YES, (IMP)(&da_SBSAViewDescription::_setCenter::custom), (IMP *)(&da_SBSAViewDescription::_setCenter::original));
    
    da::hookMessage(objc_lookUpClass("SBSAViewDescription"), sel_registerName("_setBounds:"), YES, (IMP)(&da_SBSAViewDescription::_setBounds::custom), (IMP *)(&da_SBSAViewDescription::_setBounds::original));
}
