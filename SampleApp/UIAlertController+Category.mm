//
//  UIAlertController+Category.mm
//  SampleApp
//
//  Created by Jinwoo Kim on 4/10/24.
//

#import "UIAlertController+Category.hpp"
#import "da+hook.hpp"
#import <objc/runtime.h>
#import <objc/message.h>
#import "DAAlertControllerView.hpp"

namespace da_UIAlertController {
    namespace platformStyleViewForAlertController_inIdiom {
        static id (*original)(UIAlertController *, SEL, UIAlertController *, UIUserInterfaceIdiom);
        static id custom(UIAlertController *self, SEL _cmd, UIAlertController *alertController, UIUserInterfaceIdiom idiom) {
            BOOL apertureUI = ((NSNumber *)objc_getAssociatedObject(alertController, UIAlertController.apertureUIKey)).boolValue;
            
            if (apertureUI) {
                return [[DAAlertControllerView new] autorelease];
            } else {
                return original(self, _cmd, alertController, idiom);
            }
        }
    }
}

@implementation UIAlertController (Category)

+ (void *)apertureUIKey {
    static void *key = &key;
    return key;
}

+ (void)load {
    da::hookMessage(self, sel_registerName("platformStyleViewForAlertController:inIdiom:"), YES, (IMP)&da_UIAlertController::platformStyleViewForAlertController_inIdiom::custom, (IMP *)&da_UIAlertController::platformStyleViewForAlertController_inIdiom::original);
}

@end
