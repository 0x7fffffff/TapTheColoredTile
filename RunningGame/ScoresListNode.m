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

- (instancetype)initWithColor:(SKColor *)color
                         size:(CGSize)size
                      andData:(NSArray *)data
                  andGameType:(GameType)gameType
          andHighlightedIndex:(NSInteger)index
{
    self = [super initWithColor:color size:size];

    if (self) {
        [self setAnchorPoint:CGPointMake(0.5, 0.0)];


        SKColor *listTextColor = [SKColor _stepConfirmationColor];

        [data enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *score = (NSNumber *)obj;

            CGPoint position = CGPointMake(0.0, size.height - (34.0 * idx) - 17.0);

            if (position.y >= 0.0) {
                SKButton *button = [[SKButton alloc] initWithColor:[SKColor clearColor]
                                                              size:CGSizeMake(size.width, 34.0)];
                __weak SKButton *weakButton = button;

                [button setPosition:position];
                [button setText:[self listStringFromScore:score forGameType:gameType]];

                if (idx == index) {
                    [button setTextColor:[SKColor _redColor]];
                }else{
                    [button setTextColor:listTextColor];
                }

                [button addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{

                    NSString *sharingString = [self sharingStringForGameType:gameType fromScoreString:weakButton.text];

                    if (sharingString) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIActivityViewController *sharingController = [[UIActivityViewController alloc] initWithActivityItems:@[sharingString] applicationActivities:nil];
                            [self.scene.view.window.rootViewController presentViewController:sharingController animated:YES completion:nil];
                        });
                    }
                }];
                
                [self addChild:button];
            }
        }];
    }
    
    return self;
}

- (NSString *)sharingStringForGameType:(GameType)gameType fromScoreString:(NSString *)input
{
    if (input) {
        NSString *qualifier = nil;

        if (gameType == GameTypeFallingTiles) {
            qualifier = @"Falling Tiles";
        }else if (gameType == GameTypeMarathon) {
            qualifier = @"Marathon";
        }else if (gameType == GameTypeSprint) {
            qualifier = @"Sprint";
        }else{
            return nil;
        }

        NSString *output = [NSString stringWithFormat:@"I just scored %@ in %@ mode on Tap the Colored Tile!",input,qualifier];
        return output;
    }

    return nil;
}


- (NSString *)listStringFromScore:(NSNumber *)score
                      forGameType:(GameType)gameType
{
    NSString *outputString = nil;

    if (gameType == GameTypeFallingTiles) {

        long convertedScore = (long)score.integerValue;

        if (convertedScore == 1) {
            outputString = [NSString stringWithFormat:@"%ld Tile",convertedScore];
        }else{
            outputString = [NSString stringWithFormat:@"%ld Tiles",convertedScore];
        }
    }else{
        double convertedScore = score.doubleValue;

        if (convertedScore == 1.0) {
            outputString = [NSString stringWithFormat:@"%.3f Second",convertedScore];
        }else{
            outputString = [NSString stringWithFormat:@"%.3f Seconds",convertedScore];
        }
    }

    return outputString;
}

- (NSArray *)reversedArrayFromArray:(NSArray *)inputArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[inputArray count]];
    NSEnumerator *enumerator = [inputArray reverseObjectEnumerator];

    for (id element in enumerator) {
        [array addObject:element];
    }

    return array;
}

@end