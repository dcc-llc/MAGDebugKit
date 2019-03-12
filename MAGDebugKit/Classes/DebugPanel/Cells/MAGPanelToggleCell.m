#import "MAGPanelToggleCell.h"
#import "MAGPanelGeometry.h"


@interface MAGPanelToggleCell ()

@property (nonatomic) UILabel *label;
@property (nonatomic) UISwitch *toggle;

@end


@implementation MAGPanelToggleCell
@synthesize separator;

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self setupMAGPanelToggleCell];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self setupMAGPanelToggleCell];
	}
	
	return self;
}

- (void)setupMAGPanelToggleCell {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.heightAnchor constraintEqualToConstant:magPanelCellHeight] setActive:YES];

    self.backgroundColor = [UIColor magPanelCellBackground];

    self.label = [[UILabel alloc] init];

    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.label.textColor = [UIColor magPanelCellText];
    self.label.text = self.title;
    [self addSubview:self.label];

    self.toggle = [[UISwitch alloc] init];
    self.toggle.on = self.value.boolValue;
    [self.toggle addTarget:self action:@selector(switchToggle:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.toggle];

    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:magPanelCellEdgeInsets.left] setActive:YES];
    [[self.label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];

    self.toggle.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.toggle.leadingAnchor constraintEqualToAnchor:self.label.trailingAnchor] setActive:YES];
    [[self.toggle.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-magPanelCellEdgeInsets.right] setActive:YES];
    [[self.toggle.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];

    [self.toggle setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.label setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title {
	_title = title;
	self.label.text = title;
}

- (void)setValue:(NSNumber *)value {
	_value = value;
	self.toggle.on = value.boolValue;
}

#pragma mark - UI actions

- (void)switchToggle:(UISwitch *)sender {
	_value = @(self.toggle.on);

	if (self.action) {
		self.action(self.value);
	}
}

@end
