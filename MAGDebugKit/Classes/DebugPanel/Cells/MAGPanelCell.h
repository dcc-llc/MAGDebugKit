#import <Foundation/Foundation.h>


@class MAGPanelSeparator;


@protocol MAGPanelCell <NSObject>

@property (nonatomic, weak, nullable) MAGPanelSeparator *separator;

@end
