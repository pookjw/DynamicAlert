//
//  ViewController.mm
//  SampleApp
//
//  Created by Jinwoo Kim on 4/9/24.
//

#import "ViewController.hpp"
#import "UIAlertController+Category.hpp"
#import <objc/runtime.h>

@interface ViewController ()
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation ViewController

- (void)dealloc {
    [_statusLabel release];
    [super dealloc];
}

- (IBAction)originalAlertButtonDidTrigger:(UIButton *)sender {
    [self presentAlertWithApertureUI:NO];
}

- (IBAction)apertureAlertButtonDidTrigger:(UIButton *)sender {
    [self presentAlertWithApertureUI:YES];
}

- (void)presentAlertWithApertureUI:(BOOL)apertureUI __attribute__((objc_direct)) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hello World!" message:@"🥲😖🙂" preferredStyle:UIAlertControllerStyleAlert];
    
    objc_setAssociatedObject(alertController, UIAlertController.apertureUIKey, @(apertureUI), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UILabel *statusLabel = self.statusLabel;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        statusLabel.text = @"Cancel";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        statusLabel.text = @"OK";
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
