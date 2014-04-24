//
//  NewGameOverScene.m
//  TapTheColoredTile
//
//  Created by Michael MacCallum on 4/12/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "NewGameOverScene.h"
#import "SKButton.h"
#import "SKColor+Colors.h"
#import "OriginalGameModeScene.h"
#import "ScoreSelectionMenu.h"
#import "FallingTileGameModeScene.h"
#import "MenuScene.h"
#import "Appirater.h"
#import "ScoresListNode.h"
@import GameKit;

@interface NewGameOverScene ()

@property (nonatomic, assign) GameType gameType;
@property (nonatomic, assign) CGFloat reportingScore;
@property (nonatomic, assign) BOOL didWin;
@property (nonatomic, assign) BOOL canReturn;
@property (nonatomic, strong) NSArray *currentScoresArray;
@property (nonatomic, copy) NSString *leaderBoard;

@end

@implementation NewGameOverScene

- (instancetype)initWithSize:(CGSize)size
                 andGameType:(GameType)gameType
                   andDidWin:(BOOL)won
          withReportingScore:(CGFloat)score
         canReturnToGameMode:(BOOL)canReturn
{
    self = [super initWithSize:size];

    if (self) {

        [self setGameType:gameType];
        [self setDidWin:won];
        [self setReportingScore:score];
        [self setCanReturn:canReturn];

        [self evaluteBestScores];
        [self addButtonsAndLabels];

        [Appirater userDidSignificantEvent:YES];
    }

    return self;
}

- (void)evaluteBestScores
{
    CGFloat newScore = self.reportingScore;
    NSString *previousScoresKey = nil;

    if (self.gameType == GameTypeSprint) {
        previousScoresKey = xxLeaderboardKeySprintBestTimes; // NEVER CHANGE
    }else if (self.gameType == GameTypeMarathon) {
        previousScoresKey = xxLeaderboardKeyMarathonBestTimes; // NEVER CHANGE
    }else if (self.gameType == GameTypeFallingTiles) {
        previousScoresKey = xxLeaderboardKeyFallingTilesBestScores; // NEVER CHANGE
    }else{
        return;
    }

    [self setLeaderBoard:previousScoresKey];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSArray *newScoresArray = [defaults objectForKey:previousScoresKey];

    NSMutableSet *workingMutableArray = [NSMutableSet new];

    if (newScoresArray) {
        [workingMutableArray addObjectsFromArray:newScoresArray];
    }
    NSLog(@"++++ %@",workingMutableArray);
    NSNumber *newNumber = @([[NSString stringWithFormat:@"%.3f",newScore] doubleValue]);
    if (newScore > 0) {
        [workingMutableArray addObject:newNumber];
    }

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self"
                                                                     ascending:self.gameType != GameTypeFallingTiles];

    NSArray *finalArray = [workingMutableArray sortedArrayUsingDescriptors:@[sortDescriptor]];

    static NSInteger maxEntries = 10;

    if (workingMutableArray.count > maxEntries) {
        finalArray = [[finalArray subarrayWithRange:NSMakeRange(0, maxEntries)] copy];
    }

    self.currentScoresArray = [NSArray arrayWithArray:finalArray];

    if (finalArray) {
        [defaults setObject:finalArray forKey:previousScoresKey];
        [defaults synchronize];
    }

    NSInteger index = NSIntegerMax;

    if ([finalArray containsObject:newNumber]) {
        index = [finalArray indexOfObject:newNumber];
    }

    CGFloat listHeight = self.size.height - 248.0;

    ScoresListNode *scoresList = [[ScoresListNode alloc] initWithColor:[SKColor clearColor]
                                                                  size:CGSizeMake(260.0, listHeight)
                                                               andData:self.currentScoresArray
                                                           andGameType:self.gameType
                                                   andHighlightedIndex:index];

    [scoresList setPosition:CGPointMake(self.size.width / 2.0, 134.0)];
    [self addChild:scoresList];

    NSString *titleText = nil;

    if (newScore > 0) {
        if (index == 0) {
            titleText = @"New Record!";
            [self attemptGameCenterScoreReporting];
        }else if (index <= 4) {
            if (self.gameType == GameTypeFallingTiles) {
                titleText = @"Nice Score!";
            }else{
                titleText = @"Nice Time!";
            }
        }else{
            titleText = [scoresList listStringFromScore:newNumber forGameType:self.gameType];
        }
    }else{
        if (self.gameType == GameTypeFallingTiles) {
            titleText = @"Best Scores";
        }else{
            titleText = @"Best Times";
        }
    }

    [self.titleLabel setText:titleText];
    [self.subTitleLabel setText:@"Tap any score to share"];
}


- (void)addButtonsAndLabels
{
    CGSize size = self.size;
    CGSize buttonSize = CGSizeMake(120.0, 44.0);

    CGPoint quitButtonPosition = CGPointMake(size.width - 90.0, 92.0);

    BOOL canReturn = self.canReturn;
    GameType gameType = self.gameType;

    if (canReturn) {
        SKButton *retryButton = [[SKButton alloc] initWithColor:[SKColor _stepConfirmationColor] size:buttonSize];
        [retryButton setText:@"Retry"];
        [retryButton setPosition:CGPointMake(90.0, 92.0)];
        [retryButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{

            SKScene *scene = nil;

            if (gameType == GameTypeFallingTiles) {
                scene = [[FallingTileGameModeScene alloc] initWithSize:size];
            }else{
                scene = [[OriginalGameModeScene alloc] initWithSize:size andGameType:gameType];
            }
            [scene setScaleMode:SKSceneScaleModeFill];

            SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionUp duration:0.35];
            [transition setPausesOutgoingScene:YES];
            [transition setPausesIncomingScene:NO];

            [self.view presentScene:scene transition:transition];
        }];
        [self addChild:retryButton];
    }else{
        buttonSize = CGSizeMake(260.0, buttonSize.height);
        quitButtonPosition = CGPointMake(size.width / 2.0, quitButtonPosition.y);
    }


    SKButton *quitButton = [[SKButton alloc] initWithColor:[SKColor _stepDestructiveColor] size:buttonSize];
    [quitButton setText:@"Quit"];
    [quitButton setPosition:quitButtonPosition];
    [quitButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{

        SKScene *scene = nil;

        if (canReturn) {
            scene = [[MenuScene alloc] initWithSize:size];
        }else{
            scene = [[ScoreSelectionMenu alloc] initWithSize:size];
        }

        SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:0.35];
        [transition setPausesOutgoingScene:YES];
        [transition setPausesIncomingScene:NO];

        [scene setScaleMode:SKSceneScaleModeFill];
        [self.view presentScene:scene transition:transition];
    }];
    [self addChild:quitButton];
}

- (void)attemptGameCenterScoreReporting
{
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];

    if (player.isAuthenticated) {
        [self submitScore];
    }else{
        [player setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
            if (!error) {
                [self submitScore];
            }
        }];
    }
}

- (void)submitScore
{
    NSNumber *score = (NSNumber *)[self.currentScoresArray firstObject];

    if (score) {
        int64_t adjustedScore = [self scorePreparedForGameCenter:score];

        GKScore *submissionScore = [[GKScore alloc] initWithLeaderboardIdentifier:self.leaderBoard];
        [submissionScore setValue:adjustedScore];

        [GKScore reportScores:@[submissionScore] withCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"Error submitting score to Game Center");
            }else{
                NSLog(@"Submited Score: %lld",adjustedScore);
            }
        }];
    }
}

- (int64_t)scorePreparedForGameCenter:(NSNumber *)score
{
    int64_t output = score.longLongValue;

    if (self.gameType == GameTypeSprint || self.gameType == GameTypeMarathon) {
        output = [score doubleValue] * 1000;
    }

    return (int64_t)output;
}

@end