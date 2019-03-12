#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Constraints)

- (void)addSubviewWithConstrainsAround:(UIView *)view;
- (void)addSubviewWithConstrainsAround:(UIView *)view insets:(UIEdgeInsets)insets;

@end

NS_ASSUME_NONNULL_END
