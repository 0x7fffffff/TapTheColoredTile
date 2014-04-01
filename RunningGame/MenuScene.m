//
//  MenuScene.m
//  RunningGame
//
//  Created by Mick on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "MenuScene.h"
#import "MenuButtonNode.h"
#import "GameScene.h"
#import "SKColor+Colors.h"
#import "NodeAdditions.h"

@implementation MenuScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self setBackgroundColor:[SKColor _nonStepTileColor]];
        
        SKLabelNode *titleLabelNode = [[SKLabelNode alloc] initWithFontNamed:@"ComicNeueSansID"];
        [titleLabelNode setText:@"Tap the Colored Tile"];
        [titleLabelNode setPosition:CGPointMake(size.width / 2.0, size.height - 60.0)];
        [titleLabelNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [titleLabelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [titleLabelNode setFontColor:[SKColor _stepTileColor]];
        [titleLabelNode setFontSize:28.0];
        [self addChild:titleLabelNode];

        
        MenuButtonNode *sprintButton = [[MenuButtonNode alloc] initWithColor:[SKColor _stepTileColor] size:CGSizeMake(self.frame.size.width, 50.0)];
        [sprintButton setAnchorPoint:CGPointMake(0.0, 0.0)];
        [sprintButton setPosition:CGPointMake(0.0, size.height / 2.0 + 10.0)];
        [sprintButton setName:@"sprintButton"];
        [sprintButton setText:@"Sprint"];
        [self addChild:sprintButton];

        MenuButtonNode *marathonButton = [[MenuButtonNode alloc] initWithColor:[SKColor _stepTileColor] size:CGSizeMake(self.frame.size.width, 50.0)];
        [marathonButton setAnchorPoint:CGPointMake(0.0, 0.0)];
        [marathonButton setPosition:CGPointMake(0.0, size.height / 2.0 - 50.0)];
        [marathonButton setName:@"marathonButton"];
        [marathonButton setText:@"Marathon"];
        [self addChild:marathonButton];
        
        MenuButtonNode *enduranceButton = [[MenuButtonNode alloc] initWithColor:[SKColor _stepTileColor] size:CGSizeMake(self.frame.size.width, 50.0)];
        [enduranceButton setAnchorPoint:CGPointMake(0.0, 0.0)];
        [enduranceButton setPosition:CGPointMake(0.0, size.height / 2.0 - 110.0)];
        [enduranceButton setName:@"enduranceButton"];
        [enduranceButton setText:@"Endurance"];
        [self addChild:enduranceButton];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    
    if ([self nodesAtPoint:location].count > 0) {
        
        if ([self shouldPlaySounds]) {
            [self removeAllActions];
            [self runAction:[self _tapSoundAction]];
        }
        
        for (SKNode *touchedNode in [self nodesAtPoint:location]) {
            
            if (touchedNode == [self childNodeWithName:@"sprintButton"]) {
                GameScene *scene = [[GameScene alloc] initWithSize:self.size andGameType:GameTypeSprint];
                [scene setScaleMode:SKSceneScaleModeFill];
                
                [self.view presentScene:scene transition:[SKTransition doorwayWithDuration:0.35]];
            }else if (touchedNode == [self childNodeWithName:@"marathonButton"]) {
                GameScene *scene = [[GameScene alloc] initWithSize:self.size andGameType:GameTypeMarathon];
                [scene setScaleMode:SKSceneScaleModeFill];
                
                [self.view presentScene:scene transition:[SKTransition doorwayWithDuration:0.35]];
                
            }else if (touchedNode == [self childNodeWithName:@"enduranceButton"]) {
                GameScene *scene = [[GameScene alloc] initWithSize:self.size andGameType:GameTypeEndurance];
                [scene setScaleMode:SKSceneScaleModeFill];
                
                [self.view presentScene:scene transition:[SKTransition doorwayWithDuration:0.35]];

            }
        }
    }
}

@end
