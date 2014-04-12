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

@implementation GameSceneBase

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];

    if (self) {
        [self setBackgroundColor:[SKColor _nonStepTileColor]];


        SKButton *cancelButtonNode = [[SKButton alloc] initWithColor:[SKColor _stepDestructiveColor]
                                                                size:CGSizeMake(44.0, 44.0)];
        [cancelButtonNode setZPosition:50];
        [cancelButtonNode setText:@"x"];
        [cancelButtonNode setPosition:CGPointMake(size.width - 44.0, size.height - 44.0)];
        [cancelButtonNode addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            MenuScene *scene = [[MenuScene alloc] initWithSize:self.size];
            [scene setScaleMode:SKSceneScaleModeAspectFill];

            [self.view presentScene:scene
                         transition:[SKTransition doorsCloseHorizontalWithDuration:0.35]];

        }];
        [self addChild:cancelButtonNode];
    }

    return self;
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
    [self.view presentScene:scene
                 transition:[SKTransition flipVerticalWithDuration:0.35]];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    CGPoint location = [[touches anyObject] locationInNode:self];

    ViewController *viewController = (ViewController *)self.view.window.rootViewController;

    if (viewController.isAdBannerCurrentlyVisible) {
        if (location.y <= 50.0) {
            [self setPaused:YES];
            return;
        }
    }
    
    [self lose];
}

@end
