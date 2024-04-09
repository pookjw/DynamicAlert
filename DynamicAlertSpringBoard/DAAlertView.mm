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
@property (retain, readonly, nonatomic) UIStackView *stackView;
@property (retain, readonly, nonatomic) UILabel *titleLabel;
@property (retain, readonly, nonatomic) UILabel *messageLabel;
@property (weak, nonatomic) id systemApertureSceneElement;
@end

@implementation DAAlertView

@synthesize stackView = _stackView;
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;

- (instancetype)initWithFrame:(CGRect)frame systemApertureSceneElement:(id)systemApertureSceneElement {
    if (self = [super initWithFrame:frame]) {
        UIStackView *labelStackView = self.stackView;
        
        NSArray<UIAction *> *actions = objc_getAssociatedObject(systemApertureSceneElement, da::getAlertActionsKey());
        
        for (UIAction *action in actions) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem primaryAction:action];
            [labelStackView addArrangedSubview:button];
        }
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:labelStackView];
        [NSLayoutConstraint activateConstraints:@[
            [labelStackView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [labelStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [labelStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [labelStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
        
        self.titleLabel.text = objc_getAssociatedObject(systemApertureSceneElement, da::getAlertTitleKey());
        self.messageLabel.text = objc_getAssociatedObject(systemApertureSceneElement, da::getAlertMessageKey());
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_titleLabel release];
    [_messageLabel release];
    [super dealloc];
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleLabel, self.messageLabel]];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentLeading;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    stackView.spacing = 8.f;
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (UILabel *)titleLabel {
    if (auto titleLabel = _titleLabel) return titleLabel;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = UIColor.whiteColor;
    
    _titleLabel = [titleLabel retain];
    return [titleLabel autorelease];
}

- (UILabel *)messageLabel {
    if (auto messageLabel = _messageLabel) return messageLabel;
    
    UILabel *messageLabel = [UILabel new];
    messageLabel.textColor = UIColor.whiteColor;
    
    _messageLabel = [messageLabel retain];
    return [messageLabel autorelease];
}

@end
