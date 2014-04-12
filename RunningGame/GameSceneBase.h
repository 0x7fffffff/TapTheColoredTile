//
//  GameSceneBase.h
//  TapTheColoredTile
//
//  Created by Michael MacCallum on 4/12/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameSceneBase : SKScene

@property (nonatomic, assign) GameType gameType;
@property (nonatomic, assign) BOOL gameCanContinue;
@property (nonatomic, assign) CGFloat reportingScore;
@property (nonatomic, assign) double startTime;


- (void)win;
- (void)lose;

@end
