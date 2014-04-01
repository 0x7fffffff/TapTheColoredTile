//
//  CountDownNode.h
//  RunningGame
//
//  Created by Mick on 3/29/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void(^CountDownCompleteionBlock)(void);

@interface CountDownNode : SKSpriteNode

- (void)startCountDownWithCompletion:(CountDownCompleteionBlock)completionBlock;

@end
