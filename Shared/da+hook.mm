//
//  da+hook.mm
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 3/30/24.
//

#import "da+hook.hpp"
#import <objc/runtime.h>

void da::hookMessage(Class cls, SEL name, IMP hook, IMP _Nonnull * _Nullable old) {
    Method method = class_getInstanceMethod(cls, name);
    
    if (old) {
        *old = method_getImplementation(method);
    }
    
    method_setImplementation(method, hook);
}
