//
//  MenuScene.m
//  RunningGame
//
//  Created by Mick on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "SKColor+Colors.h"
#import "NodeAdditions.h"
#import "SKButton.h"
#import "GameOverScene.h"

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
        [titleLabelNode setFontSize:30.0];
        [self addChild:titleLabelNode];
        
        CGSize buttonSize = CGSizeMake(size.width, 50.0);
        CGFloat xStart = size.width / 2.0;
        CGFloat yStart = titleLabelNode.position.y / 2.0;
        
        
        
        SKButton *sprintButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [sprintButton setPosition:CGPointMake(xStart, yStart + 120.0)];
        [sprintButton setText:@"Sprint"];
        [sprintButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            [self presentGameSceneWithGameType:GameTypeSprint];
        }];
        [self addChild:sprintButton];
        
        
        
        SKButton *marathonButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [marathonButton setPosition:CGPointMake(xStart, yStart + 60.0)];
        [marathonButton setText:@"Marathon"];
        [marathonButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            [self presentGameSceneWithGameType:GameTypeMarathon];
        }];
        [self addChild:marathonButton];
        
        
        
        SKButton *enduranceButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [enduranceButton setPosition:CGPointMake(xStart, yStart)];
        [enduranceButton setText:@"Endurance"];
        [enduranceButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            [self presentGameSceneWithGameType:GameTypeEndurance];
        }];
        [self addChild:enduranceButton];
        
        
        
        SKButton *gameMode4Button = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [gameMode4Button setPosition:CGPointMake(xStart, yStart - 60.0)];
        [gameMode4Button setText:@"Practice"];
        [gameMode4Button addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            [self presentGameSceneWithGameType:GameTypeFreePlay];
        }];
        [self addChild:gameMode4Button];
        
        
        
        SKButton *settingsButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [settingsButton setPosition:CGPointMake(xStart, yStart - 120.0)];
        [settingsButton setText:@"Settings"];
        [settingsButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{

            GameOverScene *scene = [[GameOverScene alloc] initWithSize:self.size andReturningGameType:GameTypeSprint andDidWin:NO withTapCount:12023231];
            [scene setScaleMode:SKSceneScaleModeFill];
            
            [self.view presentScene:scene transition:[SKTransition doorwayWithDuration:0.35]];
        }];
        [self addChild:settingsButton];
    }
    
    return self;
}

- (void)presentGameSceneWithGameType:(GameType)gameType
{
    GameScene *scene = [[GameScene alloc] initWithSize:self.size andGameType:gameType];
    [scene setScaleMode:SKSceneScaleModeFill];
    
    [self.view presentScene:scene transition:[SKTransition doorwayWithDuration:0.35]];
}


@end