//
//  ViewController.mm
//  SampleApp
//
//  Created by Jinwoo Kim on 4/9/24.
//

#import "ViewController.hpp"
#import <objc/message.h>
#import <objc/runtime.h>
#import "DASceneObserver.hpp"

#define KEY 0x123456

@interface ViewController ()
@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(alertButtonDidTrigger:)
                                                   name:DASceneObserverDidTriggerActionNotification 
                                                 object:nil];
    }
    
    return self;
}

- (IBAction)buttonDidTrigger:(UIButton *)sender {
    UIWindowScene *windowScene = self.view.window.windowScene;
    id fbsScene = ((id (*)(id, SEL))objc_msgSend)(windowScene, sel_registerName("_scene"));
    
    ((void (*)(id, SEL, id))objc_msgSend)(fbsScene, sel_registerName("updateUIClientSettingsWithBlock:"), ^(id /* (UIMutableApplicationSceneClientSettings *) */ mutableSettings, Class resultClass) {
        id mutableOtherSettings = ((id (*)(id, SEL))objc_msgSend)(mutableSettings, sel_registerName("otherSettings"));
        
        NSMutableArray *alertInfo = [((id (*)(id, SEL, NSUInteger))objc_msgSend)(mutableOtherSettings, sel_registerName("objectForSetting:"), 0x123456) mutableCopy];
        
        if (alertInfo == nil) {
            alertInfo = [NSMutableArray new];
        }
        
        [alertInfo addObject:@{
            @"title": @"Hello World!",
            @"message": @"Can you hear me?",
            @"actions": @[
                @{
                    @"identifier": @"CANCEL",
                    @"title": @"Cancel"
                },
                @{
                    @"identifier": @"OK",
                    @"title": @"OK"
                }
            ]
        }];
        
        ((void (*)(id, SEL, id, NSUInteger))objc_msgSend)(mutableOtherSettings, sel_registerName("setObject:forSetting:"), alertInfo, 0x123456);
        
        [alertInfo release];
    });
}

- (void)alertButtonDidTrigger:(NSNotification *)notification {
    NSLog(@"%@", notification.userInfo);
}

@end
