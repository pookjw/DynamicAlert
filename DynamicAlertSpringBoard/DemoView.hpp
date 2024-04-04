//
//  DemoView.hpp
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 4/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface DemoView : UIView
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame systemApertureSceneElement:(id /* (SBSystemApertureSceneElement *) */)systemApertureSceneElement NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
