#import <UIKit/UIKit.h>


@class MAGPanelButtonCell;
@class MAGPanelTitleCell;
@class MAGPanelToggleCell;
@class MAGPanelInputCell;
@class MAGPanelPickerManager;
@protocol MAGSettingsReactor;
@protocol MAGPanelCell;

NS_ASSUME_NONNULL_BEGIN

@interface MAGSettingsPanelVC : UIViewController

@property (nonatomic, readonly) id<MAGSettingsReactor> settingsReactor;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
						 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithSettings:(id<MAGSettingsReactor>)settingsReactor;

- (MAGPanelTitleCell *)addTitle:(NSString *)title;

- (MAGPanelButtonCell *)addButtonWithTitle:(NSString *)title action:(void(^)(void))action;

- (MAGPanelToggleCell *)addToggleWithTitle:(NSString *)title key:(NSString *)key;

- (MAGPanelInputCell *)addInputWithTitle:(NSString *)title key:(NSString *)key;

- (MAGPanelPickerManager *)addPickerWithTitle:(NSString *)title key:(NSString *)key
									  options:(NSArray *)options optionRenderer:(NSString * _Nullable (^)(_Nullable id value))renderer;

- (void)addCustomCell:(__kindof UIView<MAGPanelCell> *)cell addSeparator:(BOOL)addSeparator;

- (void)removeCell:(__kindof UIView<MAGPanelCell> *)cell;

NS_ASSUME_NONNULL_END

@end
