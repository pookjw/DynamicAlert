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

id /* (ACActivityDescriptor *) */ makeTestActivityDescriptor();

}

NS_ASSUME_NONNULL_END
