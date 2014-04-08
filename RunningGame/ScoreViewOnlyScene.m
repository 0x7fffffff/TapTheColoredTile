//
//  ScoreViewOnlyScene.m
//  TapTheColoredTile
//
//  Created by Mick on 4/7/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "ScoreViewOnlyScene.h"
#import "SKColor+Colors.h"
#import "ScoreDisplayNode.h"

@interface ScoreViewOnlyScene ()
@property (nonatomic, assign) GameType gameType;
@end

@implementation ScoreViewOnlyScene

- (instancetype)initWithSize:(CGSize)size andGameType:(GameType)gameType
{
    self = [super initWithSize:size];
    
    if (self) {
        [self setBackgroundColor:[SKColor _nonStepTileColor]];

        
        ScoreDisplayNode *scoreListNode = [[ScoreDisplayNode alloc] initWithSize:CGSizeMake(280.0, 310.0) andPosition:CGPointMake(size.width / 2.0, size.height / 2.0 + 50.0) andListOfScores:nil andIndexOfLastScore:0 andGameType:gameType];
        [self addChild:scoreListNode];
    }
    
    return self;
}

@end
