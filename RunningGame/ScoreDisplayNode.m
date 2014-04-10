//
//  ScoreDisplayNode.m
//  RunningGame
//
//  Created by Mick on 3/29/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "ScoreDisplayNode.h"
#import "SKColor+Colors.h"

@interface ScoreDisplayNode ()

@property (strong, nonatomic) NSArray *scores;
@property (assign, nonatomic) GameType gameType;

@end

@implementation ScoreDisplayNode

- (instancetype)initWithSize:(CGSize)size
                 andPosition:(CGPoint)position
             andListOfScores:(NSArray *)scores
         andIndexOfLastScore:(NSInteger)index
                 andGameType:(GameType)gameType
{
    self = [super initWithColor:[SKColor clearColor] size:size];
    
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setAnchorPoint:CGPointMake(0.5, 0.5)];
        [self setPosition:position];
        [self setScores:scores];
        [self setGameType:gameType];
        
        int i = 4;
        int n = 1;
        
        SKColor *color = [SKColor _stepTileColor];
        
        while ([color isEqual:[SKColor _redColor]]) {
            color = [SKColor _stepTileColor];
        }
        
        for (NSNumber *score in scores) {
            
            SKLabelNode *scoreLabel = [[SKLabelNode alloc] initWithFontNamed:xxFileNameComicSansNeueFont];
            SKLabelNode *numberLabel = [[SKLabelNode alloc] initWithFontNamed:xxFileNameComicSansNeueFont];

            [scoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
            [numberLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
            
            [scoreLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
            [numberLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
            
            [scoreLabel setUserData:[@{@"id": @(n)} mutableCopy]];
            [numberLabel setUserData:[@{@"id": @(n)} mutableCopy]];
            
            [scoreLabel setText:[NSString stringWithFormat:@"\t%.3f",score.doubleValue]];
            
            
            [numberLabel setText:[NSString stringWithFormat:@"%d:\t",n]];
            
            [scoreLabel setFontSize:28.0];
            [numberLabel setFontSize:30.0];
            
            [scoreLabel setPosition:CGPointMake(100.0, i * 30.0 + 4)];
            [numberLabel setPosition:CGPointMake(-100.0, i * 30.0 + 4)];

            if (n - 1 == index) {
                [scoreLabel setFontColor:[SKColor redColor]];
                [numberLabel setFontColor:[SKColor redColor]];
            }else{
                [scoreLabel setFontColor:color];
                [numberLabel setFontColor:color];
            }
            
            [self addChild:scoreLabel];
            [self addChild:numberLabel];
            
            n ++ ;
            i -- ;
        }
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    
    NSInteger index = (NSInteger)(10 - (ceil(location.y / 30.0) + 5));
    
    [self shareScoreAtIndex:index];
}

- (void)shareScoreAtIndex:(NSInteger)index
{
    NSMutableArray *arr = [NSMutableArray new];
    
    if (index < self.scores.count) {
        
        NSString *sharingString = nil;
        
        NSString *sub = nil;
        if (self.gameType == GameTypeSprint) {
            sub = @"Sprint";
        }else{
            sub = @"Marathon";
        }
        
        sharingString = [NSString stringWithFormat:@"I just scored \"%.3f\" in %@ Mode on \"Tap the Colored Tile\"",[self.scores[index] doubleValue],sub];
        
        
        [arr addObject:sharingString];
        if (arr.count > 0) {
            UIActivityViewController *sharingController = [[UIActivityViewController alloc] initWithActivityItems:arr applicationActivities:nil];
            [self.scene.view.window.rootViewController presentViewController:sharingController animated:YES completion:nil];
        }
    }
}

@end
