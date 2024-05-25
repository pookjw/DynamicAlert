//
//  da+hook.hpp
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 3/30/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

namespace da {
void hookMessage(Class cls, SEL name, BOOL isInstanceMethod, IMP hook, IMP _Nonnull * _Nullable old);
}

NS_ASSUME_NONNULL_END
