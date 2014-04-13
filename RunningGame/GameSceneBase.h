//
//  GameSceneBase.h
//  TapTheColoredTile
//
//  Created by Michael MacCallum on 4/12/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class SKButton;

typedef void(^CountDownCompletionBlock)(void);
static NSString *tileName = @"Tile";
static CGFloat leadingSpace = 50.0;

@interface GameSceneBase : SKScene

@property (nonatomic, assign) GameType gameType;
@property (nonatomic, assign) BOOL gameCanContinue;
@property (nonatomic, assign) CGFloat reportingScore;
@property (nonatomic, assign) double startTime;
@property (getter = isFirstRun, assign) BOOL firstRun;

- (instancetype)initWithSize:(CGSize)size andGameType:(GameType)gameType;

- (void)win;
- (void)lose;
- (void)runCountDownWithCompletion:(CountDownCompletionBlock)countDownCompletionBlock;
- (void)runTutorialModeWithReturnGameType:(GameType)returnGameType;
- (void)incrementTutorialNode;

- (BOOL)hasShownTutorial;

@end
