//
//  ScoreDisplayNode.h
//  RunningGame
//
//  Created by Mick on 3/29/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScoreDisplayNode : SKSpriteNode

- (instancetype)initWithSize:(CGSize)size
                 andPosition:(CGPoint)position
             andListOfScores:(NSArray *)scores
         andIndexOfLastScore:(NSInteger)index
                 andGameType:(GameType)gameType;

- (void)shareScoreAtIndex:(NSInteger)index;

@end
