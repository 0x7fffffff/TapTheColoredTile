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
            bestTimesKey = @"SprintLeaderBoard";
            lastTimeKey = @"lastSprintTimeKey";
        }else if (returningGameType == GameTypeMarathon) {
            bestTimesKey = @"MarathonLeaderBoard";
            lastTimeKey = @"lastMarathonTimeKey";
        }else if (returningGameType == GameTypeEndurance) {
            bestTimesKey = @"EnduranceLeaderBoard";
            lastTimeKey = @"lastEnduranceScoreKey";
        }else{
            return self;
        }
        
        [self setLeaderboardID:bestTimesKey];
        
        NSMutableArray *array = [NSMutableArray new];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSArray *oldScores = [defaults objectForKey:bestTimesKey];
        
        if (oldScores) {
            [array addObjectsFromArray:oldScores];
        }
        
        NSNumber *lastScore = [[defaults objectForKey:lastTimeKey] copy];

        if (lastScore) {
            [array addObject:lastScore];
            [defaults removeObjectForKey:lastTimeKey];
        }
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:(returningGameType == GameTypeEndurance) ? NO : YES];

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
        
        if (index == 0) {
            titleText = @"New Record!";
            [self reportHighestScore];
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
                                                                  andPosition:CGPointMake(size.width / 2.0, size.height / 2.0)
                                                              andListOfScores:self.scores
                                                          andIndexOfLastScore:index
                                                                  andGameType:returningGameType];
        [self addChild:scoresNode];
        
        SKLabelNode *titleLabelNode = [[SKLabelNode alloc] initWithFontNamed:@"ComicNeueSansID"];
        [titleLabelNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [titleLabelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [titleLabelNode setText:titleText];
        [titleLabelNode setFontColor:[SKColor _stepTileColor]];
        [titleLabelNode setPosition:CGPointMake(size.width / 2.0, scoresNode.frame.origin.y + scoresNode.frame.size.height + 52.0)];
        [self addChild:titleLabelNode];
        
        SKLabelNode *subTitleNode = [[SKLabelNode alloc] initWithFontNamed:@"ComicNeueSansID"];
        [subTitleNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [subTitleNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [subTitleNode setFontSize:16.0];
        [subTitleNode setText:@"Tap a Score to Share"];
        [subTitleNode setFontColor:[SKColor _stepTileColor]];
        [subTitleNode setPosition:CGPointMake(size.width / 2.0, scoresNode.frame.origin.y + scoresNode.frame.size.height + 22)];
        [self addChild:subTitleNode];
        
        CGSize buttonSize = CGSizeMake(120.0, 44.0);
        
        SKButton *retryButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [retryButton setName:@"retryButton"];
        [retryButton setText:@"Retry"];
        [retryButton setPosition:CGPointMake(scoresNode.frame.origin.x + buttonSize.width / 2.0, scoresNode.frame.origin.y - 54.0)];
        [retryButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            GameScene *scene = [[GameScene alloc] initWithSize:self.size andGameType:self.returningGameType];
            [scene setScaleMode:SKSceneScaleModeFill];
            
            [self.view presentScene:scene transition:[SKTransition flipVerticalWithDuration:0.35]];
        }];
        [self addChild:retryButton];
        
        SKButton *quitButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [quitButton setName:@"retryButton"];
        [quitButton setText:@"Quit"];
        [quitButton setPosition:CGPointMake(scoresNode.frame.origin.x + scoresNode.frame.size.width - buttonSize.width / 2.0, scoresNode.frame.origin.y - 54.0)];
        [quitButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            MenuScene *scene = [[MenuScene alloc] initWithSize:self.size];
            [scene setScaleMode:SKSceneScaleModeFill];
            
            [self.view presentScene:scene transition:[SKTransition doorsCloseHorizontalWithDuration:0.35]];
        }];
        [self addChild:quitButton];
    }
    
    return self;
}

- (void)reportHighestScore
{
    NSLog(@"%s",__PRETTY_FUNCTION__);

    uint64_t scoreValue = [self scorePreparedForGameCenter];
    
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:self.leaderboardID];
    [score setValue:scoreValue];
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (int64_t)scorePreparedForGameCenter
{
    double input = DBL_MAX;
    
    if (self.scores.count > 0) {
        if (self.returningGameType == GameTypeSprint || self.returningGameType == GameTypeMarathon) {
            input = [self.scores[0] doubleValue] * 1000;
            
        }else if (self.returningGameType == GameTypeEndurance) {
            input = [self.scores[0] longValue];
        }
    }
    
    return (int64_t)input;
}

@end