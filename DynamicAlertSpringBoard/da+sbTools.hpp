//
//  da+sbTools.hpp
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 3/31/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

namespace da {

void *getIsDAElementKey();
void *getAlertTitleKey();
void *getAlertMessageKey();
void *getAlertActionsKey();
void *getDAAlertViewKey();

id /* (SBSAContext *) */ context();

id /* (SBSystemApertureController *) */ systemApertureControllerForMainDisplay();

__kindof UIViewController * /* (SBSystemApertureViewController *) */ systemApertureViewController();

__kindof UIViewController * /* (SAUIElementViewController *) */ elementViewControllerFromElement(id /* (SBSystemApertureSceneElement *) */ element);

id /* (SAUISystemApertureManager *) */ systemApertureManager();

id /* (SBActivitySystemApertureElementObserver *) */ defaultActivitySystemApertureElementObserver();

id /* (SBActivityItem *) */ activatedActivityItemFromBundleIdentifier(NSString *bundleIdentifier);

id /* (ACActivityDescriptor *) */ makeTestActivityDescriptor();

id /* (ACActivityContent *) */ makeTestActivityContent();

id /* (ACActivityContentUpdate *) */ makeTestActivityContentUpdate(id /* (ACActivityDescriptor *) */ descriptor, id /* (ACActivityContent *) */ content);

id /* (SBActivityItem *) */ makeTestActivityItem(id /* (ACActivityContentUpdate *) */ contentUpdate);

id /* (ACUISSystemApertureSceneHandle *) */ makeSystemApertureSceneHandleWithItem(id /* (SBActivityItem *) */ activityItem);

id /* (SBSystemApertureSceneElement *) */ makeSystemApertureSceneElement(id /* (FBScene *) */ scene, id /* (SBSystemApertureController *) */ systemApertureController, void (^readyForPresentationHandler)(id /* (SBSystemApertureSceneElement *) */ element, BOOL success));

BOOL isDAElementFromSystemApertureSceneElement(id /* (SBSystemApertureSceneElement *) */ systemApertureSceneElement);

id _Nullable /* (SBSystemApertureSceneElement *) */ systemApertureSceneElementFromActivityIdentifier(NSString *activityIdentifier);

id _Nullable /* (SBSystemApertureSceneElement *) */ systemApertureSceneElementFromElementDescription(id /* (SBSAElementDescription *) */ elementDescription);

void makeSystemApertureSceneElement(void (^completionHandler)(id /* (SBSystemApertureSceneElement *) */element));

void makeAlertElement(NSString *title, NSString * _Nullable message, NSArray<UIAction *> *actions, void (^completionHandler)(id /* (SBSystemApertureSceneElement *) */element));

BOOL isDAElementFromElementDescription(id /* (SBSAElementDescription *) */ elementDescription);

id _Nullable /* (SBSystemApertureSceneElement *) */ systemApertureSceneElementFromContainerViewDescription(id /* (SBSAContainerViewDescription *) */ containerViewDescription);

BOOL isDAElementFromContainerViewDescription(id /* (SBSAContainerViewDescription *) */ containerViewDescription);

NSUInteger layoutModeFromElementDescription(id /* (SBSAElementDescription *) */ elementDescription);

CGSize preferredContentSize(id /* (SBSAContainerViewDescription *) */ containerViewDescription, CGFloat width);

}

NS_ASSUME_NONNULL_END

/*
 SAUILayoutModePreference
 SAUILayoutSpecifyingOverrider
 */
