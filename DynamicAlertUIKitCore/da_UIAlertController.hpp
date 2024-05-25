#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

namespace da_UIAlertController {
    namespace platformStyleViewForAlertController_inIdiom {
        extern id (*original)(UIAlertController *, SEL, UIAlertController *, UIUserInterfaceIdiom);
        extern id custom(UIAlertController *self, SEL _cmd, UIAlertController *alertController, UIUserInterfaceIdiom idiom);
    }
}

NS_ASSUME_NONNULL_END
