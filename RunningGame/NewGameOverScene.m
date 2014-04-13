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

@interface NewGameOverScene ()

@property (nonatomic, assign) GameType gameType;
@property (nonatomic, assign) CGFloat reportingScore;
@property (nonatomic, assign) BOOL didWin;
@property (nonatomic, assign) BOOL canReturn;
@property (nonatomic, strong) NSArray *currentScoresArray;

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
        previousScoresKey = xxLeaderboardKeyFallingTilesBestTimes; // NEVER CHANGE
    }else{
        return;
    }

    NSArray *legacyRecoveryAttempt = [self attemptToLoadLegacyScores];
    NSArray *newScoresArray = nil;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (legacyRecoveryAttempt) {
        newScoresArray = legacyRecoveryAttempt;
    }else{
        newScoresArray = [defaults objectForKey:previousScoresKey];
    }

    NSMutableSet *workingMutableArray = [NSMutableSet new];

    if (newScoresArray) {
        [workingMutableArray addObjectsFromArray:newScoresArray];
    }

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


- (NSArray *)attemptToLoadLegacyScores
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (self.gameType == GameTypeSprint) {

        NSString *key = @"bestSprintTimeKey";

        NSArray *candidate = [[defaults objectForKey:key] copy];
        if (candidate) {

            [defaults removeObjectForKey:key];
            [defaults synchronize];
            return candidate;
        }
        return nil;

    }else if (self.gameType == GameTypeMarathon) {

        NSString *key = @"bestMarathonTimeKey";

        NSArray *candidate = [[defaults objectForKey:key] copy];
        if (candidate) {

            [defaults removeObjectForKey:key];
            [defaults synchronize];
            return candidate;
        }
        return nil;

    }else{
        return nil;
    }
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

/*
 - (void)reportHighestScore
 {

 if ([GKLocalPlayer localPlayer].isAuthenticated) {
 [self submitScore];
 }else{
 [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
 [self submitScore];
 }];
 }
 }

 - (void)submitScore
 {
 uint64_t scoreValue = [self scorePreparedForGameCenter];

 if (scoreValue > 0) {

 GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:self.leaderboardID];
 [score setValue:scoreValue];

 [GKScore reportScores:@[score] withCompletionHandler:nil];
 }
 }

 - (int64_t)scorePreparedForGameCenter
 {
 double input = DBL_MAX;

 if (self.scores.count > 0) {
 if (self.returningGameType == GameTypeSprint || self.returningGameType == GameTypeMarathon) {
 input = [self.scores[0] doubleValue] * 1000;

 }
 }

 return (int64_t)input;
 }
 */


@end
