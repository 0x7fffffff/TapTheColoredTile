//
//  TutorialOverlayNode.h
//  RunningGame
//
//  Created by Mick on 3/31/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TutorialOverlayNode : SKSpriteNode

- (instancetype)initWithColor:(SKColor *)color size:(CGSize)size andGameType:(GameType)gameType;
- (void)incrementTutorialIndex;

@end
