//
//  DAAlertView.mm
//  DynamicAlertSpringBoard
//
//  Created by Jinwoo Kim on 4/9/24.
//

#import "DAAlertView.hpp"
#import <objc/message.h>
#import <objc/runtime.h>
#import "da+sbTools.hpp"

__attribute__((objc_direct_members))
@interface DAAlertView ()
@property (retain, readonly, nonatomic) UIStackView *rootStackView;
@property (retain, readonly, nonatomic) UIStackView *actionsStackView;
@property (retain, readonly, nonatomic) UILabel *titleLabel;
@property (retain, readonly, nonatomic) UILabel *messageLabel;
@property (weak, nonatomic) id systemApertureSceneElement;
@end

@implementation DAAlertView

@synthesize rootStackView = _rootStackView;
@synthesize actionsStackView = _actionsStackView;
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;

- (instancetype)initWithFrame:(CGRect)frame systemApertureSceneElement:(id)systemApertureSceneElement {
    if (self = [super initWithFrame:frame]) {
        UIStackView *labelStackView = self.rootStackView;
        UIStackView *actionsStackView = self.actionsStackView;
        
        NSArray<UIAction *> *actions = objc_getAssociatedObject(systemApertureSceneElement, da::getAlertActionsKey());
        UIButtonConfiguration *buttonConfiguration = [UIButtonConfiguration tintedButtonConfiguration];
        
        for (UIAction *action in actions) {
            UIButton *button = [UIButton buttonWithConfiguration:buttonConfiguration primaryAction:action];
            [actionsStackView addArrangedSubview:button];
        }
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:labelStackView];
        [NSLayoutConstraint activateConstraints:@[
            [labelStackView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor],
            [labelStackView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
            [labelStackView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
            [labelStackView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],
            [actionsStackView.widthAnchor constraintEqualToAnchor:self.layoutMarginsGuide.widthAnchor]
        ]];
        
        self.titleLabel.text = objc_getAssociatedObject(systemApertureSceneElement, da::getAlertTitleKey());
        self.messageLabel.text = objc_getAssociatedObject(systemApertureSceneElement, da::getAlertMessageKey());
    }
    
    return self;
}

- (void)dealloc {
    [_rootStackView release];
    [_actionsStackView release];
    [_titleLabel release];
    [_messageLabel release];
    [super dealloc];
}

- (UIStackView *)rootStackView {
    if (auto rootStackView = _rootStackView) return rootStackView;
    
    UIStackView *rootStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleLabel, self.messageLabel, self.actionsStackView]];
    rootStackView.axis = UILayoutConstraintAxisVertical;
    rootStackView.alignment = UIStackViewAlignmentLeading;
    rootStackView.distribution = UIStackViewDistributionFillProportionally;
    rootStackView.spacing = 8.f;
    
    _rootStackView = [rootStackView retain];
    return [rootStackView autorelease];
}

- (UIStackView *)actionsStackView {
    if (auto actionsStackView = _actionsStackView) return actionsStackView;
    
    UIStackView *actionsStackView = [UIStackView new];
    actionsStackView.axis = UILayoutConstraintAxisHorizontal;
    actionsStackView.alignment = UIStackViewAlignmentCenter;
    actionsStackView.distribution = UIStackViewDistributionFill;
    actionsStackView.spacing = 8.f;
    
    _actionsStackView = [actionsStackView retain];
    return [actionsStackView autorelease];
}

- (UILabel *)titleLabel {
    if (auto titleLabel = _titleLabel) return titleLabel;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.numberOfLines = 0;
    
    _titleLabel = [titleLabel retain];
    return [titleLabel autorelease];
}

- (UILabel *)messageLabel {
    if (auto messageLabel = _messageLabel) return messageLabel;
    
    UILabel *messageLabel = [UILabel new];
    messageLabel.textColor = UIColor.whiteColor;
    messageLabel.numberOfLines = 0;
    
    _messageLabel = [messageLabel retain];
    return [messageLabel autorelease];
}

@end
