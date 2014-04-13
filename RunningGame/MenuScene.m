//
//  MenuScene.m
//  RunningGame
//
//  Created by Mick on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "MenuScene.h"
#import "OriginalGameModeScene.h"
#import "SKColor+Colors.h"
#import "NodeAdditions.h"
#import "SKButton.h"
#import "SettingsScene.h"
#import "ScoreSelectionMenu.h"
#import "FallingTileGameModeScene.h"

@implementation MenuScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {

        [self.titleLabel setText:@"Tap the Colored Tile"];

        CGSize buttonSize = CGSizeMake(size.width, 44.0);
        CGFloat xStart = size.width / 2.0;
        CGFloat yStart = self.titleLabel.position.y / 2.0 + 54.0;

        
        
        SKButton *sprintButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [sprintButton setPosition:CGPointMake(xStart, yStart + 81.0)];
        [sprintButton setText:@"Sprint"];
        [sprintButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            [self presentGameSceneWithGameType:GameTypeSprint];
        }];
        [self addChild:sprintButton];
        
        
        
        SKButton *marathonButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [marathonButton setPosition:CGPointMake(xStart, yStart + 27.0)];
        [marathonButton setText:@"Marathon"];
        [marathonButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            [self presentGameSceneWithGameType:GameTypeMarathon];
        }];
        [self addChild:marathonButton];
        
        
        
        SKButton *fallingTilesButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [fallingTilesButton setPosition:CGPointMake(xStart, yStart - 27.0)];
        [fallingTilesButton setText:@"Falling Tiles"];
        [fallingTilesButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            [self presentGameSceneWithGameType:GameTypeFallingTiles];
        }];
        [self addChild:fallingTilesButton];
        
        
        
        SKButton *gameMode4Button = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [gameMode4Button setPosition:CGPointMake(xStart, yStart - 81.0)];
        [gameMode4Button setText:@"Practice"];
        [gameMode4Button addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            [self presentGameSceneWithGameType:GameTypeFreePlay];
        }];
        [self addChild:gameMode4Button];



        
        SKButton *scoreButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:CGSizeMake(buttonSize.width / 2.0 - 5.0, buttonSize.height)];
        [scoreButton setPosition:CGPointMake(self.size.width / 4.0 - 2.5, yStart - 138.0)];
        [scoreButton setText:@"Scores"];
        [scoreButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{

            ScoreSelectionMenu *scene = [[ScoreSelectionMenu alloc] initWithSize:self.size];
            [scene setScaleMode:SKSceneScaleModeFill];
            [self.view presentScene:scene transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.35]];

        }];
        [self addChild:scoreButton];
        
        
        
        SKButton *settingsButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:CGSizeMake(buttonSize.width / 2.0 - 5.0, buttonSize.height)];
        [settingsButton setPosition:CGPointMake(3.0 * self.size.width / 4.0 + 2.5, yStart - 138.0)];
        [settingsButton setText:@"Settings"];
        [settingsButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{

            SettingsScene *scene = [[SettingsScene alloc] initWithSize:self.size];
            [scene setScaleMode:SKSceneScaleModeFill];
            [self.view presentScene:scene transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.35]];

        }];
        [self addChild:settingsButton];
    }
    
    return self;
}

- (void)presentGameSceneWithGameType:(GameType)gameType
{
    SKScene *scene = nil;
    if (gameType == GameTypeFallingTiles) {
        scene = [[FallingTileGameModeScene alloc] initWithSize:self.size];
    }else{
        scene = [[OriginalGameModeScene alloc] initWithSize:self.size andGameType:gameType];
    }

    SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionUp duration:0.35];
    [transition setPausesOutgoingScene:YES];
    [transition setPausesIncomingScene:NO];
    
    [scene setScaleMode:SKSceneScaleModeFill];
    [self.view presentScene:scene transition:transition];
}


@end