//
//  MyScene.m
//  RunningGame
//
//  Created by Michael MacCallum on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "OriginalGameModeScene.h"
#import "SKColor+Colors.h"
#import "NodeAdditions.h"
#import "SKButton.h"
@import GameKit;

@interface OriginalGameModeScene ()
@property (nonatomic, assign) NSInteger tilesCreated;
@property (nonatomic, assign) NSInteger requiredSteps;
@property (nonatomic, assign) NSInteger currentStep;
@property (strong, nonatomic) NSMutableArray *tiles;

@end

@implementation OriginalGameModeScene

- (instancetype)initWithSize:(CGSize)size andGameType:(GameType)gameType
{
    if (self = [super initWithSize:size andGameType:gameType]) {

        [self setTilesCreated:0];
        
        switch (gameType) {
            case GameTypeSprint:{
                [self setRequiredSteps:50];
            }break;
                
            case GameTypeMarathon:{
                [self setRequiredSteps:250];
            }break;
                
            case GameTypeFreePlay:{
                [self setRequiredSteps:NSIntegerMax];
            }break;
                
            default:
                break;
        }

        GameType returnGameType = gameType;

        if (self.isFirstRun) {
            [self setGameType:GameTypeFreePlay];
        }
        
        if (self.gameType == GameTypeFreePlay) {
            [self setGameCanContinue:YES];
        }

        if (self.gameType != GameTypeFreePlay) {
            [self runCountDownWithCompletion:^{
                [self setGameCanContinue:YES];
                [self setStartTime:CFAbsoluteTimeGetCurrent()];
            }];
        }else{
            if (self.isFirstRun) {
                [self runTutorialModeWithReturnGameType:returnGameType];
            }
        }

        [self generateTiles];
    }
    
    return self;
}

- (void)generateTiles
{
    self.tiles = [NSMutableArray new];
    
    for (int i = 0; i < 5; i ++) {
        [self addRowAtYIndex:i * xxTileHeight + leadingSpace + xxTileHeight / 2.0];
    }
}

- (void)addRowAtYIndex:(int)yIndex
{
    if (self.tilesCreated < self.requiredSteps) {
        self.tilesCreated ++ ;

        SKButton *tile = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:CGSizeMake(xxTileWidth, xxTileHeight)];
        __weak SKButton *weakTile = tile;

        [tile setPosition:CGPointMake(arc4random_uniform(4) * xxTileWidth + xxTileWidth / 2.0, yIndex)];
        [tile setName:tileName];
        [tile addActionOfType:SKButtonActionTypeTouchDown withBlock:^{
            [self takeStepFromTile:weakTile];
        }];

        if (!self.isFirstRun) {
            if (self.tilesCreated % 5 == 0) {

                long remaining = 0;

                if (self.gameType == GameTypeFreePlay) {
                    remaining = (long)self.tilesCreated;
                }else{
                    remaining = (long)self.requiredSteps - (long)self.tilesCreated;
                }

                if (remaining > 0) {
                    [tile setText:[NSString stringWithFormat:@"%li",remaining]];
                    [tile setTextColor:[SKColor _nonStepTileColor]];
                }
            }
        }

        [self addChild:tile];
        [self.tiles addObject:tile];
    }
}

- (void)takeStepFromTile:(SKButton *)tile
{
    if ([self.tiles indexOfObject:tile] != 0) {
        [tile removeAllActions];
        [self lose];

        return;
    }
    self.currentStep ++ ;

    if (self.gameType == GameTypeFreePlay) {
        [self incrementTutorialNode];
    }

    if (self.currentStep == self.requiredSteps) {

        [self win];
    }
    
    [self.tiles removeObjectAtIndex:0];
    
    [self enumerateChildNodesWithName:tileName usingBlock:^(SKNode *node, BOOL *stop) {
        SKAction *moveAction = [SKAction moveBy:CGVectorMake(0.0, -xxTileHeight) duration:0.02];
        [node runAction:moveAction completion:^{
            if (node.frame.origin.y + node.frame.size.height <= 0.0) {
                [node removeFromParent];
            }
        }];

    }];
    
    [self addRowAtYIndex:4 * xxTileHeight + leadingSpace + xxTileHeight / 2.0];
}

@end