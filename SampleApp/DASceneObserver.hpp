//
//  DASceneObserver.hpp
//  SampleApp
//
//  Created by Jinwoo Kim on 4/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSNotificationName const DASceneObserverDidTriggerActionNotification;
extern NSString *DASceneObserverActionIdentifierKey;

__attribute__((objc_direct_members))
@interface DASceneObserver : NSObject

@end

NS_ASSUME_NONNULL_END
