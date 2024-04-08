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
        id activitySystemApertureElementObserver = da::defaultActivitySystemApertureElementObserver();
        id activityDescriptor = da::makeTestActivityDescriptor();
        id activityIdentifier = ((id (*)(id, SEL))objc_msgSend)(activityDescriptor, sel_registerName("activityIdentifier"));
        id activityContent = da::makeTestActivityContent();
        id activityContentUpdate = da::makeTestActivityContentUpdate(activityDescriptor, activityContent);
        id activityItem = da::makeTestActivityItem(activityContentUpdate);
        
        ((void (*)(id, SEL, id, id))objc_msgSend)(activitySystemApertureElementObserver, sel_registerName("_createAndActivateElementForActivityItem:completion:"), activityItem, ^void(BOOL success) {
            assert(success);
            
            id element = da::systemApertureSceneElementFromActivityIdentifier(activityIdentifier);
            
            objc_setAssociatedObject(element, da::getIsDAElementKey(), @YES, OBJC_ASSOCIATION_COPY_NONATOMIC);
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

namespace da_SBSystemApertureSceneElement {
namespace _updatePortalViews {
static void (*original)(id, SEL);
static void custom(id self, SEL _cmd) {
    BOOL flag = ((NSNumber *)objc_getAssociatedObject(self, da::getIsDAElementKey())).boolValue;
    
    if (flag) {
        NSUInteger layoutMode = ((NSUInteger (*)(id, SEL))objc_msgSend)(self, sel_registerName("layoutMode"));
        
//        if (layoutMode != 3) {
//            original(self, _cmd);
//            return;
//        }
        
        __kindof UIView *leadingView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("leadingView"));
        ((void (*)(id, SEL, CGSize))objc_msgSend)(leadingView, sel_registerName("setPreferredSize:"), CGSizeMake(40.f, 40.f));
        __kindof UIView *leadingPortalView = ((id (*)(id, SEL))objc_msgSend)(leadingView, sel_registerName("portalView"));
        leadingPortalView.hidden = YES;
        
        __kindof UIView *trailingView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("trailingView"));
        ((void (*)(id, SEL, CGSize))objc_msgSend)(trailingView, sel_registerName("setPreferredSize:"), CGSizeMake(40.f, 40.f));
        __kindof UIView *trailingPortalView = ((id (*)(id, SEL))objc_msgSend)(trailingView, sel_registerName("portalView"));
        trailingPortalView.hidden = YES;
        
        __kindof UIView *minimalView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("minimalView"));
        ((void (*)(id, SEL, CGSize))objc_msgSend)(minimalView, sel_registerName("setPreferredSize:"), CGSizeMake(40.f, 40.f));
        __kindof UIView *minimalPortalView = ((id (*)(id, SEL))objc_msgSend)(minimalView, sel_registerName("portalView"));
        minimalPortalView.hidden = YES;
        
        __kindof UIView *detachedMinimalView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("detachedMinimalView"));
        ((void (*)(id, SEL, CGSize))objc_msgSend)(detachedMinimalView, sel_registerName("setPreferredSize:"), CGSizeMake(40.f, 40.f));
        __kindof UIView *detachedMinimalPortalView = ((id (*)(id, SEL))objc_msgSend)(detachedMinimalView, sel_registerName("portalView"));
        detachedMinimalPortalView.hidden = YES;
    } else {
        original(self, _cmd);
    }
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
            contentView.backgroundColor = UIColor.systemBrownColor;
            
            DemoView *demoView = [[DemoView alloc] initWithFrame:contentView.bounds systemApertureSceneElement:elementViewProvider];
            
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

namespace _configureTransformView_ifNecessaryWithProvidedView_assertIfConfigurationRequired {
static BOOL (*original)(__kindof UIView *, SEL, __kindof UIView **, __kindof UIView *, id);
static BOOL custom(__kindof UIView *self, SEL _cmd, __kindof UIView **transformView, __kindof UIView *providedView, id assertIfConfigurationRequired) {
    BOOL result = original(self, _cmd, transformView, providedView, assertIfConfigurationRequired);
    
    __kindof UIView *portalView = ((id (*)(id, SEL))objc_msgSend)(providedView, sel_registerName("portalView"));
    providedView.backgroundColor = UIColor.systemRedColor;
    
//    [portalView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperview];
//    }];
    
    [(*transformView).subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperview];
        obj.backgroundColor = UIColor.systemRedColor;
    }];
    (*transformView).backgroundColor = UIColor.systemRedColor;
//    portalView.hidden = YES;
    
    
    
    
//    __kindof UIView *minimalTransformView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("minimalTransformView"));
//    CGRect minimalTransformViewFrame = minimalTransformView.frame;
//    minimalTransformViewFrame.size = CGSizeMake(40.f, 40.f);
//    minimalTransformView.frame = minimalTransformViewFrame;
    
    return result;
}
}

namespace layoutSubviews {
static void (*original)(__kindof UIView *, SEL);
static void custom(__kindof UIView *self, SEL _cmd) {
    original(self, _cmd);
    
    __kindof UIView *leadingTransformView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("leadingTransformView"));
    CGRect leadingTransformViewFrame = leadingTransformView.frame;
    leadingTransformViewFrame.size = CGSizeMake(40.f, 40.f);
    leadingTransformView.frame = leadingTransformViewFrame;
    leadingTransformView.alpha = 1.f;
    leadingTransformView.clipsToBounds = NO;
    
    __kindof UIView *trailingTransformView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("trailingTransformView"));
    CGRect trailingTransformViewFrame = trailingTransformView.frame;
    trailingTransformViewFrame.size = CGSizeMake(40.f, 40.f);
    trailingTransformView.frame = trailingTransformViewFrame;
    trailingTransformView.alpha = 1.f;
    trailingTransformView.clipsToBounds = NO;
}
}

namespace suggestedOutsetsForLayoutMode_maximumOutsets {
static NSDirectionalEdgeInsets (*original)(__kindof UIView *, SEL, NSUInteger, NSDirectionalEdgeInsets);
static NSDirectionalEdgeInsets custom(__kindof UIView *self, SEL _cmd, NSUInteger layoutMode, NSDirectionalEdgeInsets maximumOutsets) {
    NSDirectionalEdgeInsets result = original(self, _cmd, layoutMode, maximumOutsets);
    NSLog(@"Foo %@", NSStringFromDirectionalEdgeInsets(result));
    return NSDirectionalEdgeInsetsMake(0.f, -15.333f, 0.f, -41.f);
//    return result;
}
}

}

namespace da_SAUIProvidedViewContainerView {
namespace layoutSubviews {
static void (*original)(__kindof UIView *, SEL);
static void custom(__kindof UIView *self, SEL _cmd) {
    original(self, _cmd);
    
//    [UIView performWithoutAnimation:^{
//        CGRect frame = self.frame;
//        frame.size = CGSizeMake(40.f, 40.f);
//        self.frame = frame;
//        
//    }];
//    
//    objc_super superInfo = { self, [self class] };
//    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
}
}
}

namespace da_SAUIElementViewController {

namespace maximumSizeOfLeadingViewForElementView {
static CGSize (*original)(__kindof UIViewController *, SEL, __kindof UIView *);
static CGSize custom(__kindof UIViewController *self, SEL _cmd, __kindof UIView *elementView) {
    return CGSizeMake(40.f, 40.f);
}
}

namespace maximumSizeOfMinimalViewForElementView {
static CGSize (*original)(__kindof UIViewController *, SEL, __kindof UIView *);
static CGSize custom(__kindof UIViewController *self, SEL _cmd, __kindof UIView *elementView) {
    return CGSizeMake(40.f, 40.f);
}
}

namespace maximumSizeOfTrailingViewForElementView {
static CGSize (*original)(__kindof UIViewController *, SEL, __kindof UIView *);
static CGSize custom(__kindof UIViewController *self, SEL _cmd, __kindof UIView *elementView) {
    return CGSizeMake(40.f, 40.f);
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
    
    da::hookMessage(objc_lookUpClass("SBSystemApertureSceneElement"), sel_registerName("_updatePortalViews"), YES, (IMP)(&da_SBSystemApertureSceneElement::_updatePortalViews::custom), (IMP *)(&da_SBSystemApertureSceneElement::_updatePortalViews::original));
    
    da::hookMessage(objc_lookUpClass("SAUIElementView"), sel_registerName("initWithElementViewProvider:"), YES, (IMP)(&da_SAUIElementView::initWithElementViewProvider::custom), (IMP *)(&da_SAUIElementView::initWithElementViewProvider::original));
    
    da::hookMessage(objc_lookUpClass("SAUIElementView"), sel_registerName("_configureTransformView:ifNecessaryWithProvidedView:assertIfConfigurationRequired:"), YES, (IMP)(&da_SAUIElementView::_configureTransformView_ifNecessaryWithProvidedView_assertIfConfigurationRequired::custom), (IMP *)(&da_SAUIElementView::_configureTransformView_ifNecessaryWithProvidedView_assertIfConfigurationRequired::original));
    
//    da::hookMessage(objc_lookUpClass("SAUIElementView"), @selector(layoutSubviews), YES, (IMP)(&da_SAUIElementView::layoutSubviews::custom), (IMP *)(&da_SAUIElementView::layoutSubviews::original));
    
    da::hookMessage(objc_lookUpClass("SAUIElementView"), sel_registerName("suggestedOutsetsForLayoutMode:maximumOutsets:"), YES, (IMP)(&da_SAUIElementView::suggestedOutsetsForLayoutMode_maximumOutsets::custom), (IMP *)(&da_SAUIElementView::suggestedOutsetsForLayoutMode_maximumOutsets::original));
    
//    da::hookMessage(objc_lookUpClass("_SAUIProvidedViewContainerView"), @selector(layoutSubviews), YES, (IMP)(&da_SAUIProvidedViewContainerView::layoutSubviews::custom), (IMP *)(&da_SAUIProvidedViewContainerView::layoutSubviews::original));
//    
//    da::hookMessage(objc_lookUpClass("SAUIElementViewController"), sel_registerName("maximumSizeOfLeadingViewForElementView:"), YES, (IMP)(&da_SAUIElementViewController::maximumSizeOfLeadingViewForElementView::custom), (IMP *)(&da_SAUIElementViewController::maximumSizeOfLeadingViewForElementView::original));
//    
//    da::hookMessage(objc_lookUpClass("SAUIElementViewController"), sel_registerName("maximumSizeOfMinimalViewForElementView:"), YES, (IMP)(&da_SAUIElementViewController::maximumSizeOfMinimalViewForElementView::custom), (IMP *)(&da_SAUIElementViewController::maximumSizeOfMinimalViewForElementView::original));
//    
//    da::hookMessage(objc_lookUpClass("SAUIElementViewController"), sel_registerName("maximumSizeOfTrailingViewForElementView:"), YES, (IMP)(&da_SAUIElementViewController::maximumSizeOfTrailingViewForElementView::custom), (IMP *)(&da_SAUIElementViewController::maximumSizeOfTrailingViewForElementView::original));
}
