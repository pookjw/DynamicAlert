//
//  UIAlertController+Category.hpp
//  SampleApp
//
//  Created by Jinwoo Kim on 4/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface UIAlertController (Category)
@property (class, assign, readonly, nonatomic) void *apertureUIKey;
@end

NS_ASSUME_NONNULL_END
