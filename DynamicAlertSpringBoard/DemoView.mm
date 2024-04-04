//
//  DemoView.mm
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 4/5/24.
//

#import "DemoView.hpp"
#import <AVFoundation/AVFoundation.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "da+sbTools.hpp"

__attribute__((objc_direct_members))
@interface DemoView ()
@property (retain, readonly, nonatomic) AVQueuePlayer *queuePlayer;
@property (retain, readonly, nonatomic) AVPlayerLooper *playerLooper;
@property (weak, nonatomic) id systemApertureSceneElement;
@property (retain, readonly, nonatomic) UIButton *menuButton;
@end

@implementation DemoView

@synthesize queuePlayer = _queuePlayer;
@synthesize playerLooper = _playerLooper;
@synthesize menuButton = _menuButton;

+ (Class)layerClass {
    return AVPlayerLayer.class;
}

- (instancetype)initWithFrame:(CGRect)frame systemApertureSceneElement:(id)systemApertureSceneElement {
    if (self = [super initWithFrame:frame]) {
        AVQueuePlayer *queuePlayer = self.queuePlayer;
        ((AVPlayerLayer *)self.layer).player = queuePlayer;
        [self playerLooper];
        [queuePlayer play];
        
        self.systemApertureSceneElement = systemApertureSceneElement;
        
        UIButton *menuButton = self.menuButton;
        menuButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:menuButton];
        [NSLayoutConstraint activateConstraints:@[
            [menuButton.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
            [menuButton.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor]
        ]];
    }
    
    return self;
}

- (void)dealloc {
    [_queuePlayer release];
    [_playerLooper release];
    [_systemApertureSceneElement release];
    [_menuButton release];
    [super dealloc];
}

- (AVQueuePlayer *)queuePlayer {
    if (auto queuePlayer = _queuePlayer) return queuePlayer;
    
    AVQueuePlayer *queuePlayer = [[AVQueuePlayer alloc] initWithURL:[NSURL fileURLWithPath:@"/Users/pookjw/Desktop/video.mp4"]];
    
    _queuePlayer = [queuePlayer retain];
    return [queuePlayer autorelease];
}

- (AVPlayerLooper *)playerLooper {
    if (auto playerLooper = _playerLooper) return playerLooper;
    
    AVQueuePlayer *queuePlayer = self.queuePlayer;
    AVPlayerLooper *playerLooper = [[AVPlayerLooper alloc] initWithPlayer:queuePlayer templateItem:queuePlayer.currentItem timeRange:kCMTimeRangeInvalid];
    
    _playerLooper = [playerLooper retain];
    return [playerLooper autorelease];
}

- (UIButton *)menuButton {
    if (auto menuButton = _menuButton) return menuButton;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.image = [UIImage systemImageNamed:@"fan.fill"];
    configuration.buttonSize = UIButtonConfigurationSizeLarge;
    configuration.cornerStyle = UIButtonConfigurationCornerStyleCapsule;
    
    UIButton *menuButton = [UIButton buttonWithConfiguration:configuration primaryAction:nil];
    
    __weak auto weakSelf = self;
    
    UIAction *popAction = [UIAction actionWithTitle:@"Pop" image:[UIImage systemImageNamed:@"ev.plug.dc.nacs.fill"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
//        ((void (*)(id, SEL))objc_msgSend)(weakSelf.systemApertureSceneElement, sel_registerName("invalidate"));
        id systemApertureManager = da::systemApertureManager();
        __kindof UIViewController *elementViewController = ((id (*)(id, SEL, id))objc_msgSend)(systemApertureManager, sel_registerName("elementViewControllerForElement:"), weakSelf.systemApertureSceneElement);
        ((void (*)(id, SEL, NSUInteger, NSUInteger))objc_msgSend)(elementViewController, sel_registerName("setLayoutMode:reason:"), 2, 1);
        ((void (*)(id, SEL, NSUInteger, NSUInteger))objc_msgSend)(weakSelf.systemApertureSceneElement, sel_registerName("setLayoutMode:reason:"), 2, 1);
        
        // SAUIElementViewController setLayoutMode:(long)arg1 reason:(l
    }];
    
    UIAction *removeAction = [UIAction actionWithTitle:@"Remove" image:[UIImage systemImageNamed:@"trash"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        id systemApertureManager = da::systemApertureManager();
        ((void (*)(id, SEL, id))objc_msgSend)(systemApertureManager, sel_registerName("_removeAssertionForElement:"), weakSelf.systemApertureSceneElement);
        __kindof UIViewController *elementViewController = ((id (*)(id, SEL, id))objc_msgSend)(systemApertureManager, sel_registerName("elementViewControllerForElement:"), weakSelf.systemApertureSceneElement);
        ((void (*)(id, SEL, NSUInteger, NSUInteger))objc_msgSend)(elementViewController, sel_registerName("setLayoutMode:reason:"), 2, 1);
        
//        ((void (*)(id, SEL, id))objc_msgSend)(systemApertureManager, sel_registerName("_removeElementViewController:"), elementViewController);
//        NSLog(@"%@", ((id (*)(id, SEL, id))objc_msgSend)(systemApertureManager, sel_registerName("elementViewControllerForElement:"), weakSelf.systemApertureSceneElement));
//        NSLog(@"F");
    }];
    
    removeAction.attributes = UIMenuElementAttributesDestructive;
    
    UIMenu *menu = [UIMenu menuWithChildren:@[
        popAction,
        removeAction
    ]];
    
    menuButton.menu = menu;
    menuButton.showsMenuAsPrimaryAction = YES;
    
    _menuButton = [menuButton retain];
    return menuButton;
}

@end
