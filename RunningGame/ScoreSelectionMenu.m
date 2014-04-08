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
#import "ScoreViewOnlyScene.h"
@import GameKit;

@interface ScoreSelectionMenu () < GKGameCenterControllerDelegate >

@end

@implementation ScoreSelectionMenu

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {
        [self setBackgroundColor:[SKColor _nonStepTileColor]];
        
        SKLabelNode *titleLabelNode = [[SKLabelNode alloc] initWithFontNamed:xxFileNameComicSansNeueFont];
        [titleLabelNode setText:@"Scores"];
        [titleLabelNode setPosition:CGPointMake(size.width / 2.0, size.height - 60.0)];
        [titleLabelNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [titleLabelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [titleLabelNode setFontColor:[SKColor _stepTileColor]];
        [titleLabelNode setFontSize:34.0];
        [self addChild:titleLabelNode];
        
        CGSize buttonSize = CGSizeMake(size.width, 44.0);
        CGFloat xStart = size.width / 2.0;
        CGFloat yStart = titleLabelNode.position.y / 2.0 + 60.0;
        
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
        
        
        SKButton *enduranceScoreButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [enduranceScoreButton setPosition:CGPointMake(xStart, yStart - 27.0)];
        [enduranceScoreButton setText:@"Endurance"];
        [enduranceScoreButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            [self showScoresPageForGameType:GameTypeEndurance];
        }];
        [self addChild:enduranceScoreButton];
        
        
        SKButton *gameCenterButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [gameCenterButton setPosition:CGPointMake(xStart, yStart - 81.0)];
        [gameCenterButton setText:@"Game Center"];
        [gameCenterButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            
            GKGameCenterViewController *controller = [[GKGameCenterViewController alloc] init];
            [controller setViewState:GKGameCenterViewControllerStateLeaderboards];
            [controller setGameCenterDelegate:self];
            
            [self.view.window.rootViewController presentViewController:controller animated:YES completion:nil];
        }];
        [self addChild:gameCenterButton];
        
    
        SKButton *backbutton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [backbutton setPosition:CGPointMake(xStart, 90.0)];
        [backbutton setText:@"Main Menu"];
        [backbutton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            MenuScene *scene = [[MenuScene alloc] initWithSize:size];
            [scene setScaleMode:SKSceneScaleModeFill];
            
            [self.view presentScene:scene transition:[SKTransition doorsCloseHorizontalWithDuration:0.35]];
        }];
        [self addChild:backbutton];
    }
    
    return self;
}

- (void)showScoresPageForGameType:(GameType)gameType
{
    ScoreViewOnlyScene *scene = [[ScoreViewOnlyScene alloc] initWithSize:self.size andGameType:gameType];
    [scene setScaleMode:SKSceneScaleModeFill];
    
    [self.view presentScene:scene transition:[SKTransition doorwayWithDuration:0.35]];
    
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
