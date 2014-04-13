//
//  NewGameOverScene.h
//  TapTheColoredTile
//
//  Created by Michael MacCallum on 4/12/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MainSceneBaseClass.h"

@interface NewGameOverScene : MainSceneBaseClass

- (instancetype)initWithSize:(CGSize)size andGameType:(GameType)gameType andDidWin:(BOOL)won withReportingScore:(CGFloat)score canReturnToGameMode:(BOOL)canReturn;

@end
