//
//  main.mm
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 3/30/24.
//

#import <UIKit/UIKit.h>
#import "da+hook.hpp"
#import "da+sbTools.hpp"
#import "DemoView.hpp"
#import <objc/runtime.h>
#import <objc/message.h>

extern "C" CGPoint UIRectGetCenter(CGRect);

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
        id activityIdentifier = ((id (*)(id, SEL))objc_msgSend)(activityDescriptor, sel_registerName("activityIdentifier"));
        id activityContent = da::makeTestActivityContent();
        id activityContentUpdate = da::makeTestActivityContentUpdate(activityDescriptor, activityContent);
        id activityItem = da::makeTestActivityItem(activityContentUpdate);
        
        ((void (*)(id, SEL, id, id))objc_msgSend)(activitySystemApertureElementObserver, sel_registerName("_createAndActivateElementForActivityItem:completion:"), activityItem, ^void(BOOL success) {
            assert(success);
            
            id element = da::systemApertureSceneElementFromActivityIdentifier(activityIdentifier);
            
            objc_setAssociatedObject(element, da::getIsDAElementKey(), @YES, OBJC_ASSOCIATION_COPY_NONATOMIC);
            
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
                        yellowView = [[DemoView alloc] initWithFrame:sceneView.bounds systemApertureSceneElement:element];
                    }
                        break;
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
        });
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

namespace da_SBSystemApertureSceneElement {

namespace _sizeForSceneView {
static CGSize (*original)(id, SEL);
static CGSize custom(id self, SEL _cmd) {
    BOOL flag = ((NSNumber *)objc_getAssociatedObject(self, da::getIsDAElementKey())).boolValue;
    
    if (flag) {
        return CGSizeMake(400.f, 300.f);
    } else {
        return original(self, _cmd);
    }
}
}
}



namespace da_SBSAContainerViewDescription {
namespace contentBounds {
static CGRect (*original)(id, SEL);
static CGRect custom(id self, SEL _cmd) {
    if (!da::isDAElementFromContainerViewDescription(self)) {
        return original(self, _cmd);
    }
    
    return CGRectMake(0.f, 0.f, 400.f, 300.f);
}
}

namespace contentCenter {
static CGPoint (*original)(id, SEL);
static CGPoint custom(id self, SEL _cmd) {
    if (!da::isDAElementFromContainerViewDescription(self)) {
        return original(self, _cmd);
    }
    
    return CGPointMake(200.f, 150.f);
}
}
}

namespace da_SBSAViewDescription {
namespace bounds {
static CGRect (*original)(id, SEL);
static CGRect custom(id self, SEL _cmd) {
    if (![self isKindOfClass:objc_lookUpClass("SBSAContainerViewDescription")]) {
        return original(self, _cmd);
    }
    
    id element = da::systemApertureSceneElementFromContainerViewDescription(self);
    NSUInteger layoutMode = da::layoutModeFromElementDescription(self);
    
    if (layoutMode != 3) {
        return original(self, _cmd);
    }
    
    if (!da::isDAElementFromSystemApertureSceneElement(element)) {
        return original(self, _cmd);
    }
    
    return CGRectMake(0.f, 0.f, 400.f, 300.f);
}
}

namespace center {
static CGPoint (*original)(id, SEL);
static CGPoint custom(id self, SEL _cmd) {
    if (![self isKindOfClass:objc_lookUpClass("SBSAContainerViewDescription")]) {
        return original(self, _cmd);
    }
    
    id element = da::systemApertureSceneElementFromContainerViewDescription(self);
    NSUInteger layoutMode = da::layoutModeFromElementDescription(self);
    
    if (layoutMode != 3) {
        return original(self, _cmd);
    }
    
    if (!da::isDAElementFromSystemApertureSceneElement(element)) {
        return original(self, _cmd);
    }
    
    id context = da::context();
    CGRect inertContainerFrame = ((CGRect (*)(id, SEL))objc_msgSend)(context, sel_registerName("inertContainerFrame"));
    CGPoint center = UIRectGetCenter(inertContainerFrame);
    
    return CGPointMake(center.x, center.y - CGRectGetHeight(inertContainerFrame) * 0.5f + 150.f);
}
}
}

__attribute__((constructor)) static void init() {
    da::hookMessage(UIScene.class, sel_registerName("_sceneForFBSScene:create:withSession:connectionOptions:"), NO, (IMP)(&da_UIScene::_sceneForFBSScene_create_withSession_connectionOptions::custom), (IMP *)(&da_UIScene::_sceneForFBSScene_create_withSession_connectionOptions::original));
    
    da::hookMessage(objc_lookUpClass("SBSystemApertureSceneElement"), sel_registerName("_sizeForSceneView"), YES, (IMP)(&da_SBSystemApertureSceneElement::_sizeForSceneView::custom), (IMP *)(&da_SBSystemApertureSceneElement::_sizeForSceneView::original));
    
    da::hookMessage(objc_lookUpClass("SBSAContainerViewDescription"), sel_registerName("contentBounds"), YES, (IMP)(&da_SBSAContainerViewDescription::contentBounds::custom), (IMP *)(&da_SBSAContainerViewDescription::contentBounds::original));
    
    da::hookMessage(objc_lookUpClass("SBSAContainerViewDescription"), sel_registerName("contentCenter"), YES, (IMP)(&da_SBSAContainerViewDescription::contentCenter::custom), (IMP *)(&da_SBSAContainerViewDescription::contentCenter::original));
    
    da::hookMessage(objc_lookUpClass("SBSAViewDescription"), sel_registerName("bounds"), YES, (IMP)(&da_SBSAViewDescription::bounds::custom), (IMP *)(&da_SBSAViewDescription::bounds::original));
    
    da::hookMessage(objc_lookUpClass("SBSAViewDescription"), sel_registerName("center"), YES, (IMP)(&da_SBSAViewDescription::center::custom), (IMP *)(&da_SBSAViewDescription::center::original));
}
