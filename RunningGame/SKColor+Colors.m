//
//  SKColor+Colors.m
//  RunningGame
//
//  Created by Michael MacCallum on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "SKColor+Colors.h"
#import "NSString+MD5.h"

@import SpriteKit;

@implementation SKColor (Colors)

+ (SKColor *)_nonStepTileColor
{
    static SKColor *color = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [SKColor colorWithRed:236.0 / 255.0 green:240.0 / 255.0 blue:241.0 / 255.0 alpha:1.0];
    });

    return color;
}


+ (SKColor *)colorWith255RangeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [SKColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

+ (SKColor *)_switchBackgroundColor
{
    static SKColor *color = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [SKColor colorWithRed:189.0 / 255.0 green:195.0 / 255.0 blue:199.0 / 255.0 alpha:1.0];
    });
    
    return color;
}

+ (SKColor *)_stepTileColor
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSInteger theme = [defaults integerForKey:@"theme"];

    NSArray *schemes = [self colorSchemes];
    if (schemes) {
        if (theme < schemes.count) {
            NSArray *colors = schemes[theme];
            
            static uint32_t previous = 0;
            uint32_t new = 0;
            
            while (previous == new) {
                new = arc4random_uniform((u_int32_t)colors.count);
            }
            previous = new;
            
            SKColor *color = colors[new];
            return color;
        }
    }
    return nil;
}

+ (NSArray *)colorSchemes
{
    static NSArray *array = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *plistArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ColorSchemes" ofType:@"plist"]];
//        NSLog(@"%@",[[plistArray componentsJoinedByString:@","] MD5]);
        NSMutableArray *output = [NSMutableArray new];

        for (NSDictionary *dictionary in plistArray) {

            NSMutableArray *colorsForCurrentTheme = [NSMutableArray new];

            for (NSString *numbersListString in dictionary[@"colors"]) {
                
                NSArray *numberListArray = [numbersListString componentsSeparatedByString:@","];

                SKColor *color = [SKColor colorWith255RangeRed:[numberListArray[0] doubleValue]
                                                         green:[numberListArray[1] doubleValue]
                                                          blue:[numberListArray[2] doubleValue]];
                [colorsForCurrentTheme addObject:color];
            }
            [output addObject:colorsForCurrentTheme];
        }
        array = [output copy];
    });

    return array;
}


+ (SKColor *) _alizarinColor
{
    static SKColor *color = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [SKColor colorWithRed:231.0 / 255.0 green:76.0 / 255.0 blue:60.0 / 255.0 alpha:1.0];
    });
    
    return color;
}

@end






