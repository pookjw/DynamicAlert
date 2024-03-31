//
//  da+sbTools.hpp
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 3/31/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

namespace da {

id /* (SBSystemApertureController *) */ systemApertureControllerForMainDisplay();

__kindof UIViewController * /* (SBSystemApertureViewController *) */ systemApertureViewController();

id /* (SAUISystemApertureManager *) */ systemApertureManager();

id /* (SBActivitySystemApertureElementObserver *) */ defaultActivitySystemApertureElementObserver();

id /* (ACActivityDescriptor *) */ makeTestActivityDescriptor();

id /* (ACActivityContent *) */ makeTestActivityContent();

id /* (ACActivityContentUpdate *) */ makeTestActivityContentUpdate(id /* (ACActivityDescriptor *) */ descriptor, id /* (ACActivityContent *) */ content);

id /* (SBActivityItem *) */ makeTestActivityItem(id /* (ACActivityContentUpdate *) */ contentUpdate);

id /* (ACUISSystemApertureSceneHandle *) */ makeSystemApertureSceneHandleWithItem(id /* (SBActivityItem *) */ activityItem);

id /* (SBSystemApertureSceneElement *) */ makeSystemApertureSceneElement(id /* (FBScene *) */ scene, id /* (SBSystemApertureController *) */ systemApertureController, void (^readyForPresentationHandler)(id /* (SBSystemApertureSceneElement *) */ element, BOOL success));

}

NS_ASSUME_NONNULL_END
