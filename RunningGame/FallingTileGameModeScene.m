//
//  FallingTileGameModeScene.m
//  TapTheColoredTile
//
//  Created by Mick on 4/8/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "FallingTileGameModeScene.h"
#import "SKButton.h"
#import "SKColor+Colors.h"

@interface FallingTileGameModeScene ()

@property (nonatomic, assign) CGFloat fallTime;
@property (nonatomic, assign) NSInteger tilesProduced;

@end

@implementation FallingTileGameModeScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size andGameType:GameTypeFallingTiles];
    
    if (self) {
        [self setGameCanContinue:NO];
        [self setTilesProduced:0];
        [self setFallTime:2.5];
        [self setReportingScore:0.0];
        [self setGameType:GameTypeFallingTiles];


        if (self.isFirstRun) {
            [self runTutorialModeWithReturnGameType:GameTypeFallingTiles];
            [self setGameCanContinue:YES];
            [self setGameType:GameTypeFreePlay];
            [self addNewTile];
        }else{
            [self runCountDownWithCompletion:^{
                [self setGameCanContinue:YES];
                [self addNewTile];
            }];
        }
    }

    return self;
}

- (uint32_t)correctedRandomIndex
{
    static NSMutableArray *previous = nil;
    
    if (!previous) {
        previous = [[NSMutableArray alloc] initWithCapacity:2];
    }

    if (previous.count > 0) {
        [previous removeObjectAtIndex:0];
    }
    
    uint32_t randIndex = arc4random_uniform(4);
    
    while (previous.count <= 2) {
        while ([previous containsObject:@(randIndex)]) {
            randIndex = arc4random_uniform(4);
        }
        
        [previous addObject:@(randIndex)];
    }
    
    return randIndex;
}

- (void)addNewTile
{
    if (self.gameCanContinue) {
        self.tilesProduced ++ ;

        SKButton *tile = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:CGSizeMake(xxTileWidth, xxTileHeight)];
        __weak SKButton *weakTile = tile;

        if (((NSInteger)self.tilesProduced) % 5 == 0) {
            if (self.gameType == GameTypeFallingTiles) {
                [tile setText:[NSString stringWithFormat:@"%ld",(long)self.tilesProduced]];
                [tile setTextColor:[SKColor _nonStepTileColor]];
            }
        }

        [tile setPosition:CGPointMake([self correctedRandomIndex] * xxTileWidth + xxTileWidth / 2.0, self.size.height + xxTileHeight / 2.0)];
        [tile addActionOfType:SKButtonActionTypeTouchDown withBlock:^{
            if (self.gameCanContinue) {
                self.reportingScore ++ ;
                [weakTile runAction:[self removeTappedTileAction:weakTile]];

                if (self.gameType == GameTypeFreePlay) {
                    [self incrementTutorialNode];
                }
            }
        }];
        [self addChild:tile];
        

        SKAction *moveAction = [SKAction moveTo:CGPointMake(tile.position.x, -xxTileHeight / 2.0)
                                       duration:self.fallTime];
        
        SKAction *movementCompletionAction = [SKAction runBlock:^{
            [self removeAllActions];
            if (self.gameCanContinue) {
                if (self.gameType == GameTypeFallingTiles) {
                    [self lose];
                }
            }
        }];
        
        SKAction *completionAction = [SKAction runBlock:^{
            [self addNewTile];
        } queue:dispatch_get_main_queue()];
        
        SKAction *waitAction = [SKAction waitForDuration:(self.fallTime * xxTileHeight) / (self.size.height + xxTileHeight + 50.0)];
        
        SKAction *recursiveAction = [SKAction sequence:@[waitAction, completionAction]];
        
        [self runAction:recursiveAction withKey:@"recursionAction"];

        [tile runAction:[SKAction sequence:@[moveAction,movementCompletionAction]] withKey:@"moveAction"];

        if (self.gameType == GameTypeFallingTiles) {
            self.fallTime -= self.fallTime >= 0.85 ? 0.01 : 0.0;
        }
    }
}

- (SKAction *)removeTappedTileAction:(SKButton *)tile
{
    SKAction *removeMovement = [SKAction runBlock:^{
        [tile removeActionForKey:@"moveAction"];
    }];
    
    SKAction *fade = [SKAction fadeAlphaTo:0.0 duration:0.05];

    SKAction *remove = [SKAction removeFromParent];
    
    return [SKAction sequence:@[removeMovement,fade,remove]];
}

@end