//
//  SKColor+Colors.h
//  RunningGame
//
//  Created by Michael MacCallum on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

@class SKColor;

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
@interface UIColor (Colors)

#else

#import <Cocoa/Cocoa.h>
@interface NSColor (Colors)

#endif

+ (SKColor *)_switchBackgroundColor;
+ (SKColor *)_stepTileColor;
+ (SKColor *)_nonStepTileColor;
+ (SKColor *)_stepConfirmationColor;
+ (SKColor *)_stepDestructiveColor;
+ (SKColor *)_redColor;



@end
