#import <UIKit/UIKit.h>
#import "MAGSettingsPanelVC.h"


typedef NS_ENUM(NSUInteger, MAGDebugPanelAppearanceStyle) {
    MAGDebugPanelAppearanceStyleUnknown = 0,
    MAGDebugPanelAppearanceStyleRight,
};


typedef NS_ENUM(NSUInteger, MAGDebugPanelDefaultAction) {
	MAGDebugPanelDefaultActionSandbox = 0,
};


@interface MAGDebugPanel : MAGSettingsPanelVC

@property (nonatomic, readonly) MAGDebugPanelAppearanceStyle appearanceStyle;

// Must be initialized with predefined appearance style.
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAppearanceStyle:(MAGDebugPanelAppearanceStyle)appearanceStyle;

// Initialize an instance with MAGDebugPanelAppearanceStyleRight.
+ (instancetype)rightPanel;

// Add panel to window, and setup gesture recognizer according to appearance style.
- (void)integrateAboveWindow:(UIWindow *)appWindow;
- (void)desintegrate;

- (void)addDefaultAction:(MAGDebugPanelDefaultAction)action;
- (void)addAction:(void(^)(void))action withTitle:(NSString *)title;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end
