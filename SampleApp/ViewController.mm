//
//  ViewController.mm
//  SampleApp
//
//  Created by Jinwoo Kim on 4/9/24.
//

#import "ViewController.hpp"
#import <objc/message.h>
#import <objc/runtime.h>

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonDidTrigger:(UIButton *)sender {
    UIWindowScene *windowScene = self.view.window.windowScene;
    id fbsScene = ((id (*)(id, SEL))objc_msgSend)(windowScene, sel_registerName("_scene"));
    NSLog(@"%@", fbsScene);
}

@end
