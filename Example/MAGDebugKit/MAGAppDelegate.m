//
//  MAGAppDelegate.m
//  MAGDebugKit
//
//  Created by Evgeniy Stepanov on 10/05/2016.
//  Copyright (c) 2016 Evgeniy Stepanov. All rights reserved.
//

#import "MAGAppDelegate.h"
#import <MAGDebugKit/MAGDebugKit.h>
#import <libextobjc/extobjc.h>


@implementation MAGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		MAGDebugPanel *panel = [MAGDebugPanel rightPanel];
		
		@weakify(panel);
		[panel addAction:^{
				@strongify(panel);
				[panel desintegrate];
			} withTitle:@"Desintegrate panel"];
		
		[panel integrateAboveWindow:self.window];
    });

    return YES;
}

@end
