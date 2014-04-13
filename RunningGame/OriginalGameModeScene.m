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

- (CGPoint)centerOfOpenGapInNewRow
{
    CGFloat y = 0.0;

    SKButton *tile = [self.tiles lastObject];

    y = tile.frame.origin.y + tile.frame.size.height / 2.0;

    CGPoint point = CGPointZero;
    
    switch ((int)floor(tile.frame.origin.x / xxTileWidth)) {
        case 0:{
            point = CGPointMake(200.0, y);
        }break;
            
        case 1:{
            point = CGPointMake(240.0, y);
        }break;
            
        case 2:{
            point = CGPointMake(80.0, y);
        }break;
            
        case 3:{
            point = CGPointMake(120.0, y);
        }break;
            
        default:
            break;
    }
    
    return point;
}

- (void)generateTiles
{
    self.tiles = [NSMutableArray new];
    
    for (int i = 0; i < 5; i ++) {
        [self addRowAtYIndex:i * xxTileHeight + leadingSpace];
    }
}

- (void)addRowAtYIndex:(int)yIndex
{
    if (self.tilesCreated < self.requiredSteps) {
        self.tilesCreated ++ ;

        SKButton *tile = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:CGSizeMake(xxTileWidth, xxTileHeight)];
        [tile setAnchorPoint:CGPointZero];
        [tile setPosition:CGPointMake(arc4random_uniform(4) * xxTileWidth, yIndex)];
        [tile setName:tileName];
        [tile addActionOfType:SKButtonActionTypeTouchDown withBlock:^{
            [self takeStep];
        }];
        [self addChild:tile];
        [self.tiles addObject:tile];


        if (self.gameType != GameTypeFreePlay) {
            if (self.tilesCreated % 5 == 0) {
                SKLabelNode *backgroundCountLabel = [[SKLabelNode alloc] initWithFontNamed:xxFileNameComicSansNeueFont];
                [backgroundCountLabel setName:tileName];
                [backgroundCountLabel setPosition:[self centerOfOpenGapInNewRow]];
                [backgroundCountLabel setText:[NSString stringWithFormat:@"%li",(long)self.tilesCreated]];
                [backgroundCountLabel setFontSize:50.0];
                [backgroundCountLabel setAlpha:1.0];
                [backgroundCountLabel setFontColor:[SKColor darkGrayColor]];
                [backgroundCountLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
                [backgroundCountLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
                [self insertChild:backgroundCountLabel atIndex:0];
            }            
        }
    }
}

- (void)takeStep
{
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
    
    [self addRowAtYIndex:4 * xxTileHeight + leadingSpace];
}

@end