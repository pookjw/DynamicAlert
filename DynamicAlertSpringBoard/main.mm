//
//  main.mm
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 3/30/24.
//

#import <UIKit/UIKit.h>
#import "da+hook.hpp"

namespace da {
namespace _UIViewController {
namespace viewDidLoad {
static void (*original)(id, SEL);
static void custom(id self, SEL _cmd) {
    original(self, _cmd);
}
}
}
}

__attribute__((constructor)) static void init() {
    da::hookMessage(UIViewController.class, @selector(viewDidLoad), (IMP)(&da::_UIViewController::viewDidLoad::custom), (IMP *)(&da::_UIViewController::viewDidLoad::original));
}
