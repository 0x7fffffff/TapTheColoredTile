//
//  GameSceneBase.m
//  TapTheColoredTile
//
//  Created by Michael MacCallum on 4/12/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "GameSceneBase.h"
#import "SKColor+Colors.h"
#import "SKButton.h"
#import "MenuScene.h"
#import "NodeAdditions.h"
#import "NewGameOverScene.h"
#import "ViewController.h"
#import "CountDownNode.h"
#import "TutorialOverlayNode.h"
@import iAd;

@implementation GameSceneBase

- (instancetype)initWithSize:(CGSize)size andGameType:(GameType)gameType
{
    self = [super initWithSize:size];

    if (self) {
        [self setGameType:gameType];
        [self setBackgroundColor:[SKColor _nonStepTileColor]];
        [self setFirstRun:![self hasShownTutorial]];

        SKButton *cancelButtonNode = [[SKButton alloc] initWithColor:[SKColor clearColor]
                                                                size:CGSizeMake(64.0, 64.0)];
        
        [cancelButtonNode setPosition:CGPointMake(size.width - 32.0, size.height - 32.0)];
        [cancelButtonNode setZPosition:50];
        [cancelButtonNode setText:@"x"];
        [cancelButtonNode setTextSize:40.0];
        [cancelButtonNode setTextColor:[SKColor darkGrayColor]];

        [cancelButtonNode addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            MenuScene *scene = [[MenuScene alloc] initWithSize:self.size];
            [scene setScaleMode:SKSceneScaleModeAspectFill];

            SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:0.35];
            [transition setPausesOutgoingScene:YES];
            [transition setPausesIncomingScene:NO];

            [self.view presentScene:scene
                         transition:transition];

        }];

        [self addChild:cancelButtonNode];
    }

    return self;
}

- (void)runCountDownWithCompletion:(CountDownCompletionBlock)countDownCompletionBlock
{
    CountDownNode *countDownNode = [[CountDownNode alloc] initWithColor:[SKColor _nonStepTileColor]
                                                                   size:self.size
                                                            andGameType:self.gameType];
    [countDownNode startCountDownWithCompletion:^{
        SKAction *completionAction = [SKAction runBlock:^{
            countDownCompletionBlock();
        }];

        [countDownNode runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.0 duration:0.2], completionAction, [SKAction removeFromParent]]]];
    }];

    [self addChild:countDownNode];

}

- (void)runTutorialModeWithReturnGameType:(GameType)returnGameType
{
    CGFloat tutHeight = self.size.height / 2.0;
    TutorialOverlayNode *tutorialNode = [[TutorialOverlayNode alloc] initWithColor:[SKColor _nonStepTileColor]
                                                                              size:CGSizeMake(self.size.width, tutHeight)
                                                                       andGameType:returnGameType];
    [tutorialNode setAnchorPoint:CGPointMake(0.5, 0.5)];
    [tutorialNode setPosition:CGPointMake(self.size.width / 2.0, self.size.height - tutHeight / 2.0)];
    [tutorialNode setZPosition:1321.0];
    [tutorialNode setName:@"tutorialNode"];
    [self addChild:tutorialNode];
}

- (void)incrementTutorialNode
{
    TutorialOverlayNode *tutNode = (TutorialOverlayNode *)[self childNodeWithName:@"tutorialNode"];

    if (tutNode) {
        [tutNode incrementTutorialIndex];
    }
}

- (void)win
{
    if (self.gameCanContinue) {
        if ([self shouldPlaySounds]) {
            [self runAction:[self _winSoundAction]];
        }

        if (self.gameType != GameTypeFreePlay) {
            [self endGameWithWin:YES];
        }
    }
}

- (void)lose
{
    if (self.gameCanContinue) {
        if ([self shouldPlaySounds]) {
            [self runAction:[self _loseSoundAction]];
        }

        if (self.gameType != GameTypeFreePlay) {
            [self endGameWithWin:NO];
        }
    }
}

- (void)endGameWithWin:(BOOL)won
{
    [self setGameCanContinue:NO];

    CGFloat score = self.reportingScore;

    if (won) {
        if (self.gameType != GameTypeFallingTiles) {
            score = CFAbsoluteTimeGetCurrent() - self.startTime;
        }
    }

    NewGameOverScene *scene = [[NewGameOverScene alloc] initWithSize:self.size
                                                         andGameType:self.gameType
                                                           andDidWin:won
                                                  withReportingScore:score
                                                 canReturnToGameMode:YES];

    [scene setScaleMode:SKSceneScaleModeFill];

    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:0.35];
    [transition setPausesIncomingScene:NO];
    [transition setPausesOutgoingScene:NO];
    
    [self.view presentScene:scene
                 transition:transition];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    CGPoint location = [[touches anyObject] locationInNode:self];

    ViewController *viewController = (ViewController *)self.view.window.rootViewController;

    if (viewController.isAdBannerCurrentlyVisible) {
        if (location.y <= viewController.adBanner.frame.size.height) {
            [self setPaused:YES];
            return;
        }
    }

    [self lose];
}

- (BOOL)hasShownTutorial
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    BOOL beenRun = [defaults boolForKey:@"hasShownTutorial"];

    return beenRun;
}

@end