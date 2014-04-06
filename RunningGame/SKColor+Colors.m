//
//  SKColor+Colors.m
//  RunningGame
//
//  Created by Michael MacCallum on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "SKColor+Colors.h"
@import SpriteKit;

@implementation SKColor (Colors)

+ (SKColor *)_switchBackgroundColor
{
    static SKColor *color = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [SKColor __two55ColorSpaceRed:189.0 green:195.0 blue:199.0];
    });

    return color;
}

+ (SKColor *)_stepConfirmationColor
{
    NSArray *array = [SKColor confirmationColors];

    SKColor *color = array[arc4random_uniform((uint32_t)array.count)];

    return color;
}

+ (SKColor *)_stepDestructiveColor
{
    NSArray *array = [SKColor destructiveColors];

    SKColor *color = array[arc4random_uniform((uint32_t)array.count)];

    return color;
}

+ (SKColor *)_redColor
{
    return [self __two55ColorSpaceRed:231.0 green:76.0 blue:60.0];
}

+ (SKColor *)_stepTileColor
{
    NSArray *array = [SKColor allColorsArray];

    static uint32_t previous = 0;
    uint32_t new = 0;
    
    while (previous == new) {
        new = arc4random_uniform((u_int32_t)array.count);
    }
    previous = new;
    
    SKColor *color = array[new];
    
    return color;
}

+ (NSArray *)colorArrayFromStringArray:(NSArray *)stringArray
{
    NSMutableArray *output = [NSMutableArray new];

    for (NSString *string in stringArray) {
        NSArray *components = [string componentsSeparatedByString:@","];

        UIColor *color = [self __two55ColorSpaceRed:[components[0] doubleValue]
                                              green:[components[1] doubleValue]
                                               blue:[components[2] doubleValue]];
        [output addObject:color];
    }
    return [output copy];
}

+ (NSArray *)confirmationColors
{
    static NSArray *array = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [self colorArrayFromStringArray:[[self colorsDictionary][@"confirmColors"] copy]];
    });

    return array;
}

+ (NSArray *)destructiveColors
{
    static NSArray *array = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [self colorArrayFromStringArray:[[self colorsDictionary][@"destructiveColors"] copy]];
    });

    return array;
}

+ (NSArray *)allColorsArray
{
    static NSArray *array = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSMutableArray *mutable = [NSMutableArray new];
        [mutable addObjectsFromArray:[self confirmationColors]];
        [mutable addObjectsFromArray:[self destructiveColors]];
        [mutable addObjectsFromArray:[self colorArrayFromStringArray:[[self colorsDictionary][@"otherColors"] copy]]];

        array = [mutable copy];
    });

    return array;
}

+ (SKColor *)_nonStepTileColor
{
    static SKColor *color = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [self __two55ColorSpaceRed:236.0 green:240.0 blue:241.0];
    });

    return color;
}


+ (SKColor *)__two55ColorSpaceRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [SKColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

+ (NSDictionary *)colorsDictionary
{
    static NSDictionary *dictionary = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Colors" ofType:@"plist"]];
    });

    return dictionary;
}


@end