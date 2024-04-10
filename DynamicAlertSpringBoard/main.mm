//
//  main.mm
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 3/30/24.
//

#import <UIKit/UIKit.h>
#import "da+hook.hpp"
#import "da+sbTools.hpp"
//#import "DemoView.hpp"
#import "DAAlertView.hpp"
#import <objc/runtime.h>
#import <objc/message.h>
#import "DASceneHandleObserver.hpp"

extern "C" CGPoint UIRectGetCenter(CGRect);
OBJC_EXPORT id objc_msgSendSuper2(void);

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
namespace _shouldHandleLaunchAction {
static BOOL (*original)(id, SEL);
static BOOL custom(id self, SEL _cmd) {
    if (da::isDAElementFromSystemApertureSceneElement(self)) {
        return NO;
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
    
    CGSize contentSize = da::preferredContentSize(self, 400.f);
    return CGRectMake(0.f, 0.f, contentSize.width, contentSize.height);
}
}

namespace contentCenter {
static CGPoint (*original)(id, SEL);
static CGPoint custom(id self, SEL _cmd) {
    if (!da::isDAElementFromContainerViewDescription(self)) {
        return original(self, _cmd);
    }
    
    CGSize contentSize = da::preferredContentSize(self, 400.f);
    return CGPointMake(contentSize.width * 0.5f, contentSize.height * 0.5f);
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
    
    CGSize contentSize = da::preferredContentSize(self, 400.f);
    return CGRectMake(0.f, 0.f, contentSize.width, contentSize.height);
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
    CGSize contentSize = da::preferredContentSize(self, 400.f);
    
    return CGPointMake(center.x, center.y - CGRectGetHeight(inertContainerFrame) * 0.5f + contentSize.height * 0.5f);
}
}
}

namespace da_SAUIElementView {
namespace initWithElementViewProvider {
static id (*original)(UIView *, SEL, id);
static id custom(UIView *self, SEL _cmd, id elementViewProvider) {
    // SAUIElementViewController -> SAUIElementView
    
    self = original(self, _cmd, elementViewProvider);
    
    if (self) {
        if (da::isDAElementFromSystemApertureSceneElement(elementViewProvider)) {
            UIView *contentView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("contentView"));
            
            DAAlertView *demoView = [[DAAlertView alloc] initWithFrame:contentView.bounds systemApertureSceneElement:elementViewProvider];
            objc_setAssociatedObject(self, da::getDAAlertViewKey(), demoView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            demoView.translatesAutoresizingMaskIntoConstraints = NO;
            [contentView addSubview:demoView];
            [NSLayoutConstraint activateConstraints:@[
                [demoView.topAnchor constraintEqualToAnchor:contentView.topAnchor],
                [demoView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
                [demoView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
                [demoView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor],
            ]];
            [demoView release];
            
            //
            
            __kindof UIView *minimalTransformView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("minimalTransformView"));
            UIView *minimalProvidedView = ((id (*)(id, SEL))objc_msgSend)(minimalTransformView, sel_registerName("providedView"));
            minimalProvidedView.backgroundColor = UIColor.systemRedColor;
            
            __kindof UIView *leadingTransformView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("leadingTransformView"));
            UIView *leadingProvidedView = ((id (*)(id, SEL))objc_msgSend)(leadingTransformView, sel_registerName("providedView"));
            leadingProvidedView.backgroundColor = UIColor.systemRedColor;
            
            __kindof UIView *trailingTransformView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("trailingTransformView"));
            UIView *trailingProvidedView = ((id (*)(id, SEL))objc_msgSend)(trailingTransformView, sel_registerName("providedView"));
            trailingProvidedView.backgroundColor = UIColor.systemPinkColor;
        }
    }
    
    return self;
}
}
}

namespace da_SBSceneHandle {
namespace _commonInit {
static void (*original)(id, SEL);
static void custom(id self, SEL _cmd) {
    original(self, _cmd);
    
    ((void (*)(id, SEL, id))objc_msgSend)(self, sel_registerName("addObserver:"), DASceneHandleObserver.sharedInstance);
}
}
}

namespace da_SAUILayoutSpecifyingElementViewController {
namespace viewDidLoad {
static void (*original)(id, SEL);
static void custom(id self, SEL _cmd) {
    original(self, _cmd);
    
    id elementViewProvider = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("elementViewProvider"));
    
    id layoutSpecifyingOverrider = ((id (*)(id, SEL))objc_msgSend)(elementViewProvider, sel_registerName("systemApertureLayoutSpecifyingOverrider"));
    ((void (*)(id, SEL, NSUInteger, NSUInteger))objc_msgSend)(layoutSpecifyingOverrider, sel_registerName("setLayoutMode:reason:"), 3, 3);
}
}
}

namespace da_SBSystemApertureViewController {
namespace  _collapseExpandedElementIfPossible {
static BOOL (*original)(id, SEL);
static BOOL custom(id self, SEL _cmd) {
    id _currentFirstElement = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("_currentFirstElement"));
    
    if (da::isDAElementFromSystemApertureSceneElement(_currentFirstElement)) {
        return NO;
    } else {
        return original(self, _cmd);
    }
}
}
}

__attribute__((constructor)) static void init() {
    da::hookMessage(UIScene.class, sel_registerName("_sceneForFBSScene:create:withSession:connectionOptions:"), NO, (IMP)(&da_UIScene::_sceneForFBSScene_create_withSession_connectionOptions::custom), (IMP *)(&da_UIScene::_sceneForFBSScene_create_withSession_connectionOptions::original));
    
    da::hookMessage(objc_lookUpClass("SBSystemApertureSceneElement"), sel_registerName("_shouldHandleLaunchAction"), YES, (IMP)(&da_SBSystemApertureSceneElement::_shouldHandleLaunchAction::custom), (IMP *)(&da_SBSystemApertureSceneElement::_shouldHandleLaunchAction::original));
    
    da::hookMessage(objc_lookUpClass("SBSAContainerViewDescription"), sel_registerName("contentBounds"), YES, (IMP)(&da_SBSAContainerViewDescription::contentBounds::custom), (IMP *)(&da_SBSAContainerViewDescription::contentBounds::original));
    
    da::hookMessage(objc_lookUpClass("SBSAContainerViewDescription"), sel_registerName("contentCenter"), YES, (IMP)(&da_SBSAContainerViewDescription::contentCenter::custom), (IMP *)(&da_SBSAContainerViewDescription::contentCenter::original));
    
    da::hookMessage(objc_lookUpClass("SBSAViewDescription"), sel_registerName("bounds"), YES, (IMP)(&da_SBSAViewDescription::bounds::custom), (IMP *)(&da_SBSAViewDescription::bounds::original));
    
    da::hookMessage(objc_lookUpClass("SBSAViewDescription"), sel_registerName("center"), YES, (IMP)(&da_SBSAViewDescription::center::custom), (IMP *)(&da_SBSAViewDescription::center::original));
    
    da::hookMessage(objc_lookUpClass("SAUIElementView"), sel_registerName("initWithElementViewProvider:"), YES, (IMP)(&da_SAUIElementView::initWithElementViewProvider::custom), (IMP *)(&da_SAUIElementView::initWithElementViewProvider::original));
    
    da::hookMessage(objc_lookUpClass("SBSceneHandle"), sel_registerName("_commonInit"), YES, (IMP)(&da_SBSceneHandle::_commonInit::custom), (IMP *)(&da_SBSceneHandle::_commonInit::original));
    
    da::hookMessage(objc_lookUpClass("SAUILayoutSpecifyingElementViewController"), @selector(viewDidLoad), YES, (IMP)(&da_SAUILayoutSpecifyingElementViewController::viewDidLoad::custom), (IMP *)(&da_SAUILayoutSpecifyingElementViewController::viewDidLoad::original));
    
    da::hookMessage(objc_lookUpClass("SBSystemApertureViewController"), sel_registerName("_collapseExpandedElementIfPossible"), YES, (IMP)(&da_SBSystemApertureViewController::_collapseExpandedElementIfPossible::custom), (IMP *)(&da_SBSystemApertureViewController::_collapseExpandedElementIfPossible::original));
}
