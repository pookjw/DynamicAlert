#import "da_UIAlertController.hpp"
#import "DAAlertControllerView.hpp"

id (*da_UIAlertController::platformStyleViewForAlertController_inIdiom::original)(UIAlertController *, SEL, UIAlertController *, UIUserInterfaceIdiom);

id da_UIAlertController::platformStyleViewForAlertController_inIdiom::custom(UIAlertController *self, SEL _cmd, UIAlertController *alertController, UIUserInterfaceIdiom idiom) {
    return [[DAAlertControllerView new] autorelease];
}