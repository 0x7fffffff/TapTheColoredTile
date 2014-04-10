//
//  GameOverScene.m
//  RunningGame
//
//  Created by Mick on 3/29/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "GameOverScene.h"
#import "ScoreDisplayNode.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "SKColor+Colors.h"
#import "NodeAdditions.h"
#import "SKButton.h"
@import GameKit;

@interface GameOverScene ()
@property (strong, nonatomic) NSArray *scores;
@property (nonatomic, assign) GameType returningGameType;
@property (strong, nonatomic) NSString *leaderboardID;
@end

@implementation GameOverScene

- (instancetype)initWithSize:(CGSize)size andReturningGameType:(GameType)returningGameType andDidWin:(BOOL)won withTapCount:(NSInteger)tapCount
{
    self = [super initWithSize:size];
    
    if (self) {
        [self setReturningGameType:returningGameType];
        [self setBackgroundColor:[SKColor _nonStepTileColor]];
        
        NSString *bestTimesKey = nil;
        NSString *lastTimeKey = nil;
        
        if (returningGameType == GameTypeSprint) {
            bestTimesKey = @"SprintLeaderBoard"; // NEVER CHANGE
            lastTimeKey = @"lastSprintTimeKey"; // NEVER CHANGE
        }else if (returningGameType == GameTypeMarathon) {
            bestTimesKey = @"MarathonLeaderBoard"; // NEVER CHANGE
            lastTimeKey = @"lastMarathonTimeKey"; // NEVER CHANGE
        }/*else if (returningGameType == GameTypeEndurance) {
            bestTimesKey = @"EnduranceLeaderBoard"; // NEVER CHANGE
            lastTimeKey = @"lastEnduranceScoreKey"; // NEVER CHANGE
        }*/else{
            return self;
        }
        
        [self setLeaderboardID:bestTimesKey];
        
        NSMutableArray *array = [NSMutableArray new];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSArray *oldScores = nil;
        NSArray *oldDefaults = [self attemptToLoadScoresByOldNames];
        if (oldDefaults) {
            oldScores = oldDefaults;
        }else{
            oldScores = [defaults objectForKey:bestTimesKey];
        }
        
        if (oldScores) {
            [array addObjectsFromArray:oldScores];
        }
        
        NSNumber *lastScore = [[defaults objectForKey:lastTimeKey] copy];

        if (lastScore) {
            [array addObject:lastScore];
            [defaults removeObjectForKey:lastTimeKey];
        }
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];

        [array sortUsingDescriptors:@[sortDescriptor]];
        
        static int maxEntries = 10;
        
        if (array.count > maxEntries) {
            array = [[array subarrayWithRange:NSMakeRange(0, maxEntries)] mutableCopy];
        }
        
        [defaults setObject:array forKey:bestTimesKey];
        [defaults synchronize];
        
        [self setScores:[array copy]];
        
        NSInteger index = NSNotFound;
        
        if ([self.scores containsObject:lastScore]) {
            index = [self.scores indexOfObject:lastScore];
        }
        
        NSString *titleText = nil;
        
//        if (![defaults boolForKey:@"hasEverReportedScore"]) {
//            [self reportHighestScore];
//            [defaults setBool:YES forKey:@"hasEverReportedScore"];
//            [defaults synchronize];
//        }
        
        if (index == 0) {
            [self reportHighestScore];
            titleText = @"New Record!";
        }else{
            if (returningGameType == GameTypeSprint || returningGameType == GameTypeMarathon) {
                if (won) {
                    if (index == NSNotFound) {
                        titleText = [NSString stringWithFormat:@"You Scored: %0.3f",lastScore.doubleValue];
                    }else{
                        titleText = @"You Won!";
                    }
                }else{
                    titleText = @"You Lose";
                }
            }else{
                if (index == NSNotFound) {
                    titleText = [NSString stringWithFormat:@"You Scored: %li",(long)lastScore.integerValue];
                }else{
                    titleText = @"You Won!";
                }
            }
        }
        
        
        ScoreDisplayNode *scoresNode = [[ScoreDisplayNode alloc] initWithSize:CGSizeMake(260.0, 308.0)
                                                                  andPosition:CGPointMake(size.width / 2.0, size.height / 2.0 + 25.0)
                                                              andListOfScores:self.scores
                                                          andIndexOfLastScore:index
                                                                  andGameType:returningGameType];
        [self addChild:scoresNode];
        
        SKLabelNode *titleLabelNode = [[SKLabelNode alloc] initWithFontNamed:xxFileNameComicSansNeueFont];
        [titleLabelNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [titleLabelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [titleLabelNode setText:titleText];
        [titleLabelNode setFontColor:[SKColor _stepTileColor]];
        [titleLabelNode setPosition:CGPointMake(size.width / 2.0, scoresNode.frame.origin.y + scoresNode.frame.size.height + 42.0)];
        [self addChild:titleLabelNode];
        
        SKLabelNode *subTitleNode = [[SKLabelNode alloc] initWithFontNamed:xxFileNameComicSansNeueFont];
        [subTitleNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [subTitleNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [subTitleNode setFontSize:16.0];
        [subTitleNode setText:@"Tap a Score to Share"];
        [subTitleNode setFontColor:[SKColor _stepTileColor]];
        [subTitleNode setPosition:CGPointMake(size.width / 2.0, scoresNode.frame.origin.y + scoresNode.frame.size.height + 12)];
        [self addChild:subTitleNode];
        
        CGSize buttonSize = CGSizeMake(120.0, 44.0);
        
        SKButton *retryButton = [[SKButton alloc] initWithColor:[SKColor _stepConfirmationColor] size:buttonSize];
        [retryButton setText:@"Retry"];
        [retryButton setPosition:CGPointMake(scoresNode.frame.origin.x + buttonSize.width / 2.0, scoresNode.frame.origin.y - 24.0)];
        [retryButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            GameScene *scene = [[GameScene alloc] initWithSize:self.size andGameType:self.returningGameType];
            [scene setScaleMode:SKSceneScaleModeFill];
            
            [self.view presentScene:scene transition:[SKTransition flipVerticalWithDuration:0.35]];
        }];
        [self addChild:retryButton];
        
        SKButton *quitButton = [[SKButton alloc] initWithColor:[SKColor _stepDestructiveColor] size:buttonSize];
        [quitButton setText:@"Quit"];
        [quitButton setPosition:CGPointMake(scoresNode.frame.origin.x + scoresNode.frame.size.width - buttonSize.width / 2.0, scoresNode.frame.origin.y - 24.0)];
        [quitButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            MenuScene *scene = [[MenuScene alloc] initWithSize:self.size];
            [scene setScaleMode:SKSceneScaleModeFill];
            
            [self.view presentScene:scene transition:[SKTransition doorsCloseHorizontalWithDuration:0.35]];
        }];
        [self addChild:quitButton];
    }
    
    return self;
}

- (NSArray *)attemptToLoadScoresByOldNames
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (self.returningGameType == GameTypeSprint) {
        
        NSString *key = @"bestSprintTimeKey";
        
        NSArray *candidate = [[defaults objectForKey:key] copy];
        if (candidate) {
            
            [defaults removeObjectForKey:key];
            [defaults synchronize];
            return candidate;
        }
        return nil;
        
    }else if (self.returningGameType == GameTypeMarathon) {
        
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

@end