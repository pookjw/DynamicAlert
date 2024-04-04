
namespace da_SBSystemApertureContainerView {

namespace da_SAUIElementViewController {
namespace setCustomContentAlpha {
static void (*original)(id, SEL, CGFloat);
static void custom(id self, SEL _cmd, CGFloat alpha) {
    id /* (SBSystemApertureSceneElement */ elementViewProvider = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("elementViewProvider"));
    BOOL flag = ((NSNumber *)objc_getAssociatedObject(elementViewProvider, da::getIsDAElementKey())).boolValue;
    
    if (flag) {
        NSUInteger layoutMode = ((long (*)(id, SEL))objc_msgSend)(self, sel_registerName("layoutMode"));
        
        if (layoutMode == 3) {
            original(self, _cmd, 1.f);
        } else {
            original(self, _cmd, alpha);
        }
    } else {
        original(self, _cmd, alpha);
    }
}
}

namespace setCustomContentBlurProgress {
static void (*original)(id, SEL, CGFloat);
static void custom(id self, SEL _cmd, CGFloat progress) {
    id /* (SBSystemApertureSceneElement */ elementViewProvider = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("elementViewProvider"));
    BOOL flag = ((NSNumber *)objc_getAssociatedObject(elementViewProvider, da::getIsDAElementKey())).boolValue;
    
    if (flag) {
        NSUInteger layoutMode = ((long (*)(id, SEL))objc_msgSend)(self, sel_registerName("layoutMode"));
        
        if (layoutMode == 3) {
            original(self, _cmd, 0.f);
        } else {
            original(self, _cmd, progress);
        }
    } else {
        original(self, _cmd, progress);
    }
}
}
}

namespace da_SAUILayoutSpecifyingElementViewController {
namespace setSensorObscuringShadowProgress {
static void (*original)(id, SEL, CGFloat);
static void custom(id self, SEL _cmd, CGFloat progress) {
    id /* (SBSystemApertureSceneElement */ elementViewProvider = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("elementViewProvider"));
    BOOL flag = ((NSNumber *)objc_getAssociatedObject(elementViewProvider, da::getIsDAElementKey())).boolValue;
    
    if (flag) {
        NSUInteger layoutMode = ((long (*)(id, SEL))objc_msgSend)(self, sel_registerName("layoutMode"));
        
        if (layoutMode == 3) {
            original(self, _cmd, 0.f);
        } else {
            original(self, _cmd, progress);
        }
    } else {
        original(self, _cmd, progress);
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
    BOOL flag = ((NSNumber *)objc_getAssociatedObject(elementViewProvider, da::getIsDAElementKey())).boolValue;
    
    if (flag) {
        original(self, _cmd, NO);
    } else {
        original(self, _cmd, isContentClippingEnabled);
    }
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
        
        if (layoutMode != 3) {
            original(self, _cmd);
            return;
        }
        
        __kindof UIView *leadingView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("leadingView"));
        ((void (*)(id, SEL, CGSize))objc_msgSend)(leadingView, sel_registerName("setPreferredSize:"), CGSizeMake(40.f, 40.f));
//        __kindof UIView *leadingPortalView = ((id (*)(id, SEL))objc_msgSend)(leadingView, sel_registerName("portalView"));
//        leadingPortalView.hidden = YES;
        
        __kindof UIView *trailingView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("trailingView"));
        ((void (*)(id, SEL, CGSize))objc_msgSend)(trailingView, sel_registerName("setPreferredSize:"), CGSizeMake(40.f, 40.f));
//        __kindof UIView *trailingPortalView = ((id (*)(id, SEL))objc_msgSend)(trailingView, sel_registerName("portalView"));
//        trailingPortalView.hidden = YES;
        
        __kindof UIView *minimalView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("minimalView"));
        ((void (*)(id, SEL, CGSize))objc_msgSend)(minimalView, sel_registerName("setPreferredSize:"), CGSizeMake(40.f, 40.f));
//        __kindof UIView *minimalPortalView = ((id (*)(id, SEL))objc_msgSend)(minimalView, sel_registerName("portalView"));
//        minimalPortalView.hidden = YES;
        
        __kindof UIView *detachedMinimalView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("detachedMinimalView"));
        ((void (*)(id, SEL, CGSize))objc_msgSend)(detachedMinimalView, sel_registerName("setPreferredSize:"), CGSizeMake(40.f, 40.f));
//        __kindof UIView *detachedMinimalPortalView = ((id (*)(id, SEL))objc_msgSend)(detachedMinimalView, sel_registerName("portalView"));
//        detachedMinimalPortalView.hidden = YES;
    } else {
        original(self, _cmd);
    }
}
}

namespace da_SBSAElementDescription {
namespace customContentAlpha {
static CGFloat (*original)(id, SEL);
static CGFloat custom(id self, SEL _cmd) {
    if (!da::isDAElementFromElementDescription(self)) {
        return original(self, _cmd);
    }
    
    NSUInteger layoutMode = da::layoutModeFromElementDescription(self);
    
    if (layoutMode == 3) {
        return 1.f;
    } else {
        return original(self, _cmd);
    }
}
}

namespace customContentBlurProgress {
static CGFloat (*original)(id, SEL);
static CGFloat custom(id self, SEL _cmd) {
    if (!da::isDAElementFromElementDescription(self)) {
        return original(self, _cmd);
    }
    
    NSUInteger layoutMode = da::layoutModeFromElementDescription(self);
    
    if (layoutMode == 3) {
        return 0.f;
    } else {
        return original(self, _cmd);
    }
}
}

namespace sensorObscuringShadowProgress  {
static CGFloat (*original)(id, SEL);
static CGFloat custom(id self, SEL _cmd) {
    if (!da::isDAElementFromElementDescription(self)) {
        return original(self, _cmd);
    }
    
    NSUInteger layoutMode = da::layoutModeFromElementDescription(self);
    
    if (layoutMode == 1 || layoutMode == 2 || layoutMode == 3) {
        return 0.f;
    } else {
        return original(self, _cmd);
    }
}
}
}
    
//    da::hookMessage(objc_lookUpClass("SAUIElementViewController"), sel_registerName("setCustomContentAlpha:"), YES, (IMP)(&da_SAUIElementViewController::setCustomContentAlpha::custom), (IMP *)(&da_SAUIElementViewController::setCustomContentAlpha::original));
//    
//    da::hookMessage(objc_lookUpClass("SAUIElementViewController"), sel_registerName("setCustomContentBlurProgress:"), YES, (IMP)(&da_SAUIElementViewController::setCustomContentBlurProgress::custom), (IMP *)(&da_SAUIElementViewController::setCustomContentBlurProgress::original));
//    
//    da::hookMessage(objc_lookUpClass("SAUILayoutSpecifyingElementViewController"), sel_registerName("setSensorObscuringShadowProgress:"), YES, (IMP)(&da_SAUILayoutSpecifyingElementViewController::setSensorObscuringShadowProgress::custom), (IMP *)(&da_SAUILayoutSpecifyingElementViewController::setSensorObscuringShadowProgress::original));
    
//    da::hookMessage(objc_lookUpClass("SBSystemApertureSceneElement"), sel_registerName("_updatePortalViews"), YES, (IMP)(&da_SBSystemApertureSceneElement::_updatePortalViews::custom), (IMP *)(&da_SBSystemApertureSceneElement::_updatePortalViews::original));

//    da::hookMessage(objc_lookUpClass("SBSystemApertureContainerView"), sel_registerName("setContentClippingEnabled:"), YES, (IMP)(&da_SBSystemApertureContainerView::setContentClippingEnabled::custom), (IMP *)(&da_SBSystemApertureContainerView::setContentClippingEnabled::original));
    
//    da::hookMessage(objc_lookUpClass("SBSAElementDescription"), sel_registerName("customContentAlpha"), YES, (IMP)(&da_SBSAElementDescription::customContentAlpha::custom), (IMP *)(&da_SBSAElementDescription::customContentAlpha::original));
//    
//    da::hookMessage(objc_lookUpClass("SBSAElementDescription"), sel_registerName("customContentBlurProgress"), YES, (IMP)(&da_SBSAElementDescription::customContentBlurProgress::custom), (IMP *)(&da_SBSAElementDescription::customContentBlurProgress::original));
//    
//    da::hookMessage(objc_lookUpClass("SBSAElementDescription"), sel_registerName("sensorObscuringShadowProgress"), YES, (IMP)(&da_SBSAElementDescription::sensorObscuringShadowProgress::custom), (IMP *)(&da_SBSAElementDescription::sensorObscuringShadowProgress::original));
