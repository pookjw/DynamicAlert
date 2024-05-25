#import "da+hook.hpp"
#import "da_UIAlertController.hpp"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#include <stdlib.h>

__attribute__((constructor)) static void init() {
    if (strcmp(getprogname(), "SpringBoard") == 0) return;

    da::hookMessage(UIAlertController.class, sel_registerName("platformStyleViewForAlertController:inIdiom:"), NO, (IMP)&da_UIAlertController::platformStyleViewForAlertController_inIdiom::custom, (IMP *)&da_UIAlertController::platformStyleViewForAlertController_inIdiom::original);
}
