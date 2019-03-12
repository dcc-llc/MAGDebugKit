#import "MAGPanelSeparator.h"
#import "MAGPanelGeometry.h"


@implementation MAGPanelSeparator

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self setupMAGPanelSeparator];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self setupMAGPanelSeparator];
	}
	
	return self;
}

- (void)setupMAGPanelSeparator {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.heightAnchor constraintEqualToConstant:magPanelSeparatorHeight] setActive:YES];

	self.backgroundColor = [UIColor magPanelSeparator];
}

@end
