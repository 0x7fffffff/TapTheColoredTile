//
//  ScoreSelectionMenu.m
//  TapTheColoredTile
//
//  Created by Mick on 4/7/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "ScoreSelectionMenu.h"
#import "SKButton.h"
#import "SKColor+Colors.h"
#import "MenuScene.h"
#import "NewGameOverScene.h"
@import GameKit;

@interface ScoreSelectionMenu () < GKGameCenterControllerDelegate >

@end

@implementation ScoreSelectionMenu

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {

        [self.titleLabel setText:@"Scores"];

        
        CGSize buttonSize = CGSizeMake(size.width, 44.0);
        CGFloat xStart = size.width / 2.0;
        CGFloat yStart = self.titleLabel.position.y / 2.0 + 54.0;

        SKButton *sprintScoreButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [sprintScoreButton setPosition:CGPointMake(xStart, yStart + 81.0)];
        [sprintScoreButton setText:@"Sprint"];
        [sprintScoreButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            [self showScoresPageForGameType:GameTypeSprint];
        }];
        [self addChild:sprintScoreButton];
        
        
        SKButton *marathonScoreButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [marathonScoreButton setPosition:CGPointMake(xStart, yStart + 27.0)];
        [marathonScoreButton setText:@"Marathon"];
        [marathonScoreButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            [self showScoresPageForGameType:GameTypeMarathon];
        }];
        [self addChild:marathonScoreButton];
        
        
        SKButton *fallingTilesScoreButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [fallingTilesScoreButton setPosition:CGPointMake(xStart, yStart - 27.0)];
        [fallingTilesScoreButton setText:@"Falling Tiles"];
        [fallingTilesScoreButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            [self showScoresPageForGameType:GameTypeFallingTiles];
        }];
        [self addChild:fallingTilesScoreButton];
        
        
        SKButton *gameCenterButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [gameCenterButton setPosition:CGPointMake(xStart, yStart - 81.0)];
        [gameCenterButton setText:@"Game Center"];
        [gameCenterButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{

            dispatch_async(dispatch_get_main_queue(), ^{
                GKGameCenterViewController *controller = [[GKGameCenterViewController alloc] init];
                [controller setViewState:GKGameCenterViewControllerStateLeaderboards];
                [controller setGameCenterDelegate:self];

                [self.view.window.rootViewController presentViewController:controller animated:YES completion:^{
                    [self setPaused:YES];
                }];
            });
        }];
        [self addChild:gameCenterButton];
        
    
        SKButton *backbutton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [backbutton setPosition:CGPointMake(xStart, 90.0)];
        [backbutton setText:@"Back"];
        [backbutton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            MenuScene *scene = [[MenuScene alloc] initWithSize:size];
            [scene setScaleMode:SKSceneScaleModeFill];
            
            [self.view presentScene:scene transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.35]];
        }];
        [self addChild:backbutton];
    }
    
    return self;
}

- (void)showScoresPageForGameType:(GameType)gameType
{
    NewGameOverScene *scene = [[NewGameOverScene alloc] initWithSize:self.size
                                                         andGameType:gameType
                                                           andDidWin:NO
                                                  withReportingScore:0.0
                                                 canReturnToGameMode:NO];

    SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionUp duration:0.35];
    [transition setPausesOutgoingScene:YES];
    [transition setPausesIncomingScene:NO];

    [scene setScaleMode:SKSceneScaleModeFill];
    [self.view presentScene:scene transition:transition];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [self setPaused:NO];
    }];
}

@end
