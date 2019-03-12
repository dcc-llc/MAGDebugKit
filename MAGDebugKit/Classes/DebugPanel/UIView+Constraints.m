#import "UIView+Constraints.h"
#import <UIKit/UIKit.h>

@implementation UIView (Constraints)


- (void)addSubviewWithConstrainsAround:(UIView *)view {
    [self addSubviewWithConstrainsAround:view insets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)addSubviewWithConstrainsAround:(UIView *)view insets:(UIEdgeInsets)insets {
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;

    [[view.topAnchor constraintEqualToAnchor:self.topAnchor constant:insets.top] setActive:YES];
    [[view.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-insets.bottom] setActive:YES];
    [[view.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:insets.left] setActive:YES];
    [[view.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-insets.right] setActive:YES];
}

@end
