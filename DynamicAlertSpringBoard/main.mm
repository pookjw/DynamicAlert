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
#import <AVFoundation/AVFoundation.h>

void *isDAElementKey = &isDAElementKey;

@interface PlayerView : UIView
@end
@implementation PlayerView
+ (Class)layerClass {
    return AVPlayerLayer.class;
}
@end

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
            
            NSArray *registeredElements = ((id (*)(id, SEL))objc_msgSend)(systemApertureManager, sel_registerName("registeredElements"));
            
            for (id element in registeredElements) {
                NSString *elementIdentifier = ((id (*)(id, SEL))objc_msgSend)(element, sel_registerName("elementIdentifier"));
                if (![elementIdentifier containsString:activityIdentifier]) {
                    continue;
                }
                
                objc_setAssociatedObject(element, isDAElementKey, @YES, OBJC_ASSOCIATION_COPY_NONATOMIC);
                
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
                            AVQueuePlayer *player = [[AVQueuePlayer alloc] initWithURL:[NSURL fileURLWithPath:@"/Users/pookjw/Desktop/video.mp4"]];
                            AVPlayerLooper *looper = [[AVPlayerLooper alloc] initWithPlayer:player templateItem:player.currentItem timeRange:kCMTimeRangeInvalid];
                            PlayerView *playerView = [PlayerView new];
                            playerView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5f];
                            objc_setAssociatedObject(playerView, (void *)playerView, looper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                            [looper release];
                            ((AVPlayerLayer *)playerView.layer).player = player;
                            [player release];
                            yellowView = playerView;
                            [player play];
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
            }
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
namespace _updatePortalViews {
static void (*original)(id, SEL);
static void custom(id self, SEL _cmd) {
    BOOL flag = ((NSNumber *)objc_getAssociatedObject(self, isDAElementKey)).boolValue;
    
    if (flag) {
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

namespace _sizeForSceneView {
static CGSize (*original)(id, SEL);
static CGSize custom(id self, SEL _cmd) {
    BOOL flag = ((NSNumber *)objc_getAssociatedObject(self, isDAElementKey)).boolValue;
    
    if (flag) {
        return CGSizeMake(400.f, 300.f);
    } else {
        return original(self, _cmd);
    }
}
}
}

namespace da_SBSystemApertureContainerView {
namespace setContentClippingEnabled {
static void (*original)(id, SEL, BOOL);
static void custom(id self, SEL _cmd, BOOL isContentClippingEnabled) {
    __kindof UIViewController * /* (SAUIElementViewController *) */ elementViewController = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("elementViewController"));
    id /* (SBSystemApertureSceneElement */ elementViewProvider = ((id (*)(id, SEL))objc_msgSend)(elementViewController, sel_registerName("elementViewProvider"));
    BOOL flag = ((NSNumber *)objc_getAssociatedObject(elementViewProvider, isDAElementKey)).boolValue;
    
    if (flag) {
        original(self, _cmd, NO);
    } else {
        original(self, _cmd, isContentClippingEnabled);
    }
}
}
}

namespace da_SAUIElementViewController {
namespace setCustomContentAlpha {
static void (*original)(id, SEL, CGFloat);
static void custom(id self, SEL _cmd, CGFloat alpha) {
    id /* (SBSystemApertureSceneElement */ elementViewProvider = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("elementViewProvider"));
    BOOL flag = ((NSNumber *)objc_getAssociatedObject(elementViewProvider, isDAElementKey)).boolValue;
    
//    if (flag) {
//        original(self, _cmd, 1.f);
//    } else {
//        original(self, _cmd, alpha);
//    }
    original(self, _cmd, alpha);
}
}

namespace setCustomContentBlurProgress {
static void (*original)(id, SEL, CGFloat);
static void custom(id self, SEL _cmd, CGFloat alpha) {
    id /* (SBSystemApertureSceneElement */ elementViewProvider = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("elementViewProvider"));
    BOOL flag = ((NSNumber *)objc_getAssociatedObject(elementViewProvider, isDAElementKey)).boolValue;
    
//    if (flag) {
//        original(self, _cmd, 0.f);
//    } else {
//        original(self, _cmd, alpha);
//    }
    original(self, _cmd, alpha);
}
}
}

__attribute__((constructor)) static void init() {
    da::hookMessage(UIScene.class, sel_registerName("_sceneForFBSScene:create:withSession:connectionOptions:"), NO, (IMP)(&da_UIScene::_sceneForFBSScene_create_withSession_connectionOptions::custom), (IMP *)(&da_UIScene::_sceneForFBSScene_create_withSession_connectionOptions::original));
    
    da::hookMessage(objc_lookUpClass("SBSystemApertureSceneElement"), sel_registerName("_updatePortalViews"), YES, (IMP)(&da_SBSystemApertureSceneElement::_updatePortalViews::custom), (IMP *)(&da_SBSystemApertureSceneElement::_updatePortalViews::original));
    
    da::hookMessage(objc_lookUpClass("SBSystemApertureSceneElement"), sel_registerName("_sizeForSceneView"), YES, (IMP)(&da_SBSystemApertureSceneElement::_sizeForSceneView::custom), (IMP *)(&da_SBSystemApertureSceneElement::_sizeForSceneView::original));
    
    da::hookMessage(objc_lookUpClass("SBSystemApertureContainerView"), sel_registerName("setContentClippingEnabled:"), YES, (IMP)(&da_SBSystemApertureContainerView::setContentClippingEnabled::custom), (IMP *)(&da_SBSystemApertureContainerView::setContentClippingEnabled::original));
    
    da::hookMessage(objc_lookUpClass("SAUIElementViewController"), sel_registerName("setCustomContentAlpha:"), YES, (IMP)(&da_SAUIElementViewController::setCustomContentAlpha::custom), (IMP *)(&da_SAUIElementViewController::setCustomContentAlpha::original));
    
    da::hookMessage(objc_lookUpClass("SAUIElementViewController"), sel_registerName("setCustomContentBlurProgress:"), YES, (IMP)(&da_SAUIElementViewController::setCustomContentBlurProgress::custom), (IMP *)(&da_SAUIElementViewController::setCustomContentBlurProgress::original));
}
