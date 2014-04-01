//
//  GameOverScene.h
//  RunningGame
//
//  Created by Mick on 3/29/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverScene : SKScene

- (instancetype)initWithSize:(CGSize)size andReturningGameType:(GameType)returningGameType andDidWin:(BOOL)won withTapCount:(NSInteger)tapCount;

@end
