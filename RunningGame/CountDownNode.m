//
//  CountDownNode.m
//  RunningGame
//
//  Created by Mick on 3/29/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "CountDownNode.h"
#import "SKColor+Colors.h"
#import "NodeAdditions.h"

@interface CountDownNode ()
@property (strong, nonatomic) SKLabelNode *labelNode;
@end

@implementation CountDownNode

- (instancetype)initWithColor:(SKColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size];
    
    if (self) {
        [self setAnchorPoint:CGPointMake(0.0, 0.0)];
        [self setPosition:CGPointZero];
        [self setZPosition:1100.0];
        
        self.labelNode = [[SKLabelNode alloc] initWithFontNamed:@"ComicNeueSansID"];
        [self.labelNode setText:@"3"];
        [self.labelNode setFontSize:248.0];
        [self.labelNode setFontColor:[SKColor _stepDestructiveColor]];
        [self.labelNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [self.labelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [self.labelNode setPosition:CGPointMake(size.width / 2.0, size.height / 2.0)];
        [self addChild:self.labelNode];
        
        if ([self shouldPlaySounds]) {
            [self.labelNode runAction:[self _beepSoundAction]];
        }
    }
    
    return self;
}

- (void)startCountDownWithCompletion:(CountDownCompleteionBlock)completionBlock
{
    static int i = 3;
 
    SKAction *increment = [SKAction runBlock:^{
        i -- ;
        if (i == 0) {
            if ([self shouldPlaySounds]) {
                [self.labelNode runAction:[self _tapSoundAction]];
            }
            i = 3;
        }else{
            [self.labelNode setText:[NSString stringWithFormat:@"%d",i]];
            if (i == 2) {
                if ([self shouldPlaySounds]) {
                    [self.labelNode runAction:[self _beepSoundAction]];
                }
                [self.labelNode setFontColor:[SKColor _stepDestructiveColor]];
            }else if (i == 1) {
                if ([self shouldPlaySounds]) {
                    [self.labelNode runAction:[self _beepSoundAction]];
                }
                [self.labelNode setFontColor:[SKColor _stepConfirmationColor]];
            }else{
                [self.labelNode setFontColor:[SKColor _stepDestructiveColor]];
            }
        }
    }];
    
    SKAction *wait = [SKAction waitForDuration:1.0];
    SKAction *waitAndIncrement = [SKAction sequence:@[wait,increment]];
    SKAction *completionAction = [SKAction runBlock:completionBlock];
    
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:waitAndIncrement count:3],completionAction]]];
}

@end
