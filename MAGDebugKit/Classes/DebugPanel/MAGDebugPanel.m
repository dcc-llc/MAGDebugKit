#import "MAGDebugPanel.h"
#import "MAGLoggingSettingsVC.h"
#import "MAGSandboxBrowserVC.h"
#import "MAGUDSettingsStorage.h"

#import "MAGDebugPanelSettingsKeys.h"
#import "MAGLogging.h"
#import "MAGLoggingSettingsVC.h"
#import <libextobjc/extobjc.h>


@interface MAGDebugPanel ()

@property (nonatomic) MAGDebugPanelAppearanceStyle appearanceStyle;
@property (nonatomic) UIWindow *window;

@property (nonatomic) BOOL hasCustomActions;

@end


@implementation MAGDebugPanel

#pragma mark - Lifecycle

- (instancetype)initWithAppearanceStyle:(MAGDebugPanelAppearanceStyle)appearanceStyle {
	NSAssert(appearanceStyle != MAGDebugPanelAppearanceStyleUnknown, @"Appearance style must be defined.");

	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	id<MAGSettingsReactor> settings = [[MAGUDSettingsStorage alloc] initWithUserDefaults:ud];
	[MAGDebugPanel configureReactionsFor:settings];

	self = [super initWithSettings:settings];
	if (!self) {
		return nil;
	}
	
	_appearanceStyle = appearanceStyle;
	
	return self;
}

+ (instancetype)rightPanel {
	return [[self alloc] initWithAppearanceStyle:MAGDebugPanelAppearanceStyleRight];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Settings";
	
	[self setupMenuActions];
}

#pragma mark - Public methods

- (void)integrateAboveWindow:(UIWindow *)appWindow {
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self];
	nc.navigationBar.translucent = NO;

	CGRect screenRect = [UIScreen mainScreen].bounds;
	screenRect.origin.x = screenRect.size.width;
	self.window = [[UIWindow alloc] initWithFrame:screenRect];
	self.window.rootViewController = nc;
	self.window.windowLevel = appWindow.windowLevel + 1;
	
	[self setupAppearanceFromWindow:appWindow];
	
	[self setupCloseButton];
}

- (void)desintegrate {
	[self.navigationController.view removeFromSuperview];
	[self.navigationController removeFromParentViewController];
	self.window.rootViewController = nil;
	self.window = nil;
}

- (void)addAction:(void(^)(void))action withTitle:(NSString *)title {
	[self loadViewIfNeeded];

	if (!self.hasCustomActions) {
		[self addTitle:@"Custom actions"];
		self.hasCustomActions = YES;
	}
	[self addButtonWithTitle:title action:action];
}

#pragma mark - UI actions

- (void)rightEdgeAppearanceGRAction:(UIScreenEdgePanGestureRecognizer *)gr {
	UIView *appWindow = gr.view;
	CGFloat translation = [gr translationInView:gr.view].x;

	if (gr.state == UIGestureRecognizerStateBegan ||
		gr.state == UIGestureRecognizerStateChanged) {
		
		CGRect panelRect = appWindow.bounds;
		panelRect.origin.x = appWindow.frame.size.width + translation;
		self.window.frame = panelRect;
		self.window.hidden = NO;
	} else {
		[self stickToNearestEdge];
	}
}

- (void)closeButtonTap:(id)sender {
	[self hideAnimated:YES];
}

#pragma mark - Private methods

- (void)setupAppearanceFromWindow:(UIWindow *)appWindow {
	UIGestureRecognizer *gr = nil;
	switch (self.appearanceStyle) {
		case MAGDebugPanelAppearanceStyleRight: {
			gr = ({
				UIScreenEdgePanGestureRecognizer *edgeGR = [[UIScreenEdgePanGestureRecognizer alloc]
					initWithTarget:self action:@selector(rightEdgeAppearanceGRAction:)];
				edgeGR.edges = UIRectEdgeRight;
				edgeGR.minimumNumberOfTouches = 1;
				edgeGR.maximumNumberOfTouches = 1;
				edgeGR;
			});
			break;
		}
		default: {
			NSAssert(NO, @"Appearance style must be defined.");
			break;
		}
	}
	
	[appWindow addGestureRecognizer:gr];
}

- (void)stickToNearestEdge {
	CGFloat finalPosition = NAN;
	if (self.window.frame.origin.x < self.window.frame.size.width/2) {
		finalPosition = 0;
		self.window.hidden = NO;
	} else {
		finalPosition = self.window.frame.size.width;
		self.window.hidden = YES;
	}
	
	CGRect finalRect = self.window.frame;
	finalRect.origin.x = finalPosition;

	[UIView animateWithDuration:0.25 animations:^{
			self.window.frame = finalRect;
		}];
}

- (void)hideAnimated:(BOOL)animated {
	CGRect finalRect = self.window.frame;
	finalRect.origin.x = self.window.frame.size.width;

	if (animated) {
		//[UIView animateWithDuration:0.25 animations:^{
		[UIView
			animateWithDuration:0.25
			animations:^{
				self.window.frame = finalRect;
			}
			completion:^(BOOL finished) {
				self.window.hidden = YES;
			}];
	} else {
		self.window.frame = finalRect;
		self.window.hidden = YES;
	}
}

- (void)setupCloseButton {
	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
		initWithBarButtonSystemItem:UIBarButtonSystemItemDone
		target:self action:@selector(closeButtonTap:)];
	self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)setupMenuActions {
	@weakify(self);
	
	[self addTitle:@"Logging"];
	
	[self addButtonWithTitle:@"Logging" action:^{
			@strongify(self);
			[self loggingAction];
		}];
	
	[self addTitle:@"Sandbox"];

	[self addButtonWithTitle:@"Disk browser" action:^{
			@strongify(self);
			[self sandboxBrowserAction];
		}];
}

#pragma mark - UI actions

- (void)loggingAction {
	MAGLoggingSettingsVC *vc = [[MAGLoggingSettingsVC alloc] initWithSettings:self.settingsReactor];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)sandboxBrowserAction {
	MAGSandboxBrowserVC *vc = [[MAGSandboxBrowserVC alloc] initWithURL:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private methods

+ (void)configureReactionsFor:(id<MAGSettingsReactor>) settings {
	// Logging.
	[settings setReaction:^(NSNumber *value) {
			MAGLoggingLevel level = [value unsignedIntegerValue];
			[[MAGLogging sharedInstance] setLogLevel:ddLogLevelForLoggingLevel(level)];
		} forKey:MAGDebugPanelSettingKeyLoggingVerbosity defaultValue:@(MAGLoggingLevelAll)];
	
	[settings setReaction:^(NSNumber *value) {
			[[MAGLogging sharedInstance] setFileLoggingEnabled:value.boolValue];
		} forKey:MAGDebugPanelSettingKeyFileLoggingEnabled defaultValue:@NO];
	
	[settings setReaction:^(NSNumber *value) {
			[[MAGLogging sharedInstance] setTtyLoggingEnabled:value.boolValue];
		} forKey:MAGDebugPanelSettingKeyTTYLoggingEnabled defaultValue:@NO];

	[settings setReaction:^(NSNumber *value) {
			[[MAGLogging sharedInstance] setAslLoggingEnabled:value.boolValue];
		} forKey:MAGDebugPanelSettingKeyASLLoggingEnabled defaultValue:@NO];

	[settings setReaction:^(NSString *value) {
			[MAGLogging sharedInstance].remoteLoggingHost = value;
		} forKey:MAGDebugPanelSettingKeyAntennaLoggingHost defaultValue:nil];

	[settings setReaction:^(NSString *value) {
			[MAGLogging sharedInstance].remoteLoggingPort = @(value.integerValue);
		} forKey:MAGDebugPanelSettingKeyAntennaLoggingPort defaultValue:nil];

	[settings setReaction:^(NSNumber *value) {
			[MAGLogging sharedInstance].remoteLoggingEnabled = value.boolValue;
		} forKey:MAGDebugPanelSettingKeyAntennaLoggingEnabled defaultValue:@NO];
}

@end
