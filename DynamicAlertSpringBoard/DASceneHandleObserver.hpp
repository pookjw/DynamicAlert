//
//  DASceneHandleObserver.hpp
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 4/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface DASceneHandleObserver : NSObject
@property (class, retain, readonly, nonatomic) DASceneHandleObserver *sharedInstance;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
