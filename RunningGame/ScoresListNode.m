//
//  ScoresListNode.m
//  TapTheColoredTile
//
//  Created by Michael MacCallum on 4/12/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "ScoresListNode.h"
#import "SKButton.h"
#import "SKColor+Colors.h"

@implementation ScoresListNode

- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size andData:(NSArray *)data
{
    self = [super initWithColor:[UIColor orangeColor] size:size];

    if (self) {
        [self setAnchorPoint:CGPointMake(0.5, 0.0)];


        SKColor *listTextColor = [SKColor _stepTileColor];

        [data enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *score = (NSNumber *)obj;

            CGPoint position = CGPointMake(0.0, size.height - (34.0 * idx) - 17.0);

            if (position.y >= 0.0) {
                SKButton *button = [[SKButton alloc] initWithColor:[SKColor clearColor] size:CGSizeMake(size.width, 34.0)];
                __weak SKButton *weakButton = button;
                [button setPosition:position];
                [button setText:[NSString stringWithFormat:@"%ld Taps",(long)score.integerValue]];
                [button setTextColor:listTextColor];
                [button setTag:(NSInteger)idx];
                [button addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
                    NSLog(@"%@",data[weakButton.tag]);
                }];
                [self addChild:button];

            }
            NSLog(@"Pos: %@",NSStringFromCGPoint(position));
        }];
        NSLog(@"%@",data);
    }

    return self;
}

- (NSArray *)reversedArrayFromArray:(NSArray *)inputArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[inputArray count]];
    NSEnumerator *enumerator = [inputArray reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end
