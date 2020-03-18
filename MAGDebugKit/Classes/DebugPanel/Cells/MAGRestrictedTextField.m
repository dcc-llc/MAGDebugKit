#import "MAGRestrictedTextField.h"

@implementation MAGRestrictedTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	return false;
}

@end
