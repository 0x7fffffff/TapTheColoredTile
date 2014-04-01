//
//  TutorialOverlayNode.m
//  RunningGame
//
//  Created by Mick on 3/31/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "TutorialOverlayNode.h"
#import "SKColor+Colors.h"
#import "GameScene.h"

@interface TutorialOverlayNode ()
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) GameType gameType;
@end

@implementation TutorialOverlayNode

- (instancetype)initWithColor:(SKColor *)color size:(CGSize)size andGameType:(GameType)gameType
{
    self = [super initWithColor:color size:size];
    
    if (self) {
        
        [self setIndex:0];
        [self setGameType:gameType];
        
        SKLabelNode *tutorialLabel = [[SKLabelNode alloc] initWithFontNamed:@"ComicNeueSansID"];
        
        [tutorialLabel setText:@"Tutorial Mode"];
        [tutorialLabel setFontSize:28.0];
        [tutorialLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
        [tutorialLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [tutorialLabel setPosition:CGPointMake(0.0, size.height / 2.0 - 10.0)];
        [tutorialLabel setFontColor:[SKColor _stepTileColor]];
        
        [self addChild:tutorialLabel];
        
        
        SKLabelNode *mainLabel = [[SKLabelNode alloc] initWithFontNamed:@"ComicNeueSansID"];
        
        [mainLabel setFontSize:16.0];
        [mainLabel setName:@"mainLabel"];
        [mainLabel setText:[self sprintModeTextArray][self.index]];
        [mainLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [mainLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [mainLabel setPosition:CGPointMake(0.0, 0.0)];
        [mainLabel setFontColor:[SKColor _stepTileColor]];
        
        [self addChild:mainLabel];
    }
    
    return self;
}


- (void)incrementTutorialIndex
{
    self.index ++ ;
    
    if (self.index < [self sprintModeTextArray].count) {
        SKLabelNode *mainLabel = (SKLabelNode *)[self childNodeWithName:@"mainLabel"];
        [mainLabel setText:[self sprintModeTextArray][self.index]];
        [mainLabel setFontColor:[SKColor _stepTileColor]];
    }else{
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasShownTutorial"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GameScene *scene = [[GameScene alloc] initWithSize:self.scene.size andGameType:self.gameType];
        [scene setScaleMode:SKSceneScaleModeFill];
        
        [self.scene.view presentScene:scene transition:[SKTransition doorwayWithDuration:0.35]];
    }
}

- (NSArray *)sprintModeTextArray
{
    static NSArray *array = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = @[@"Tap the tile at the bottom of the screen.",@"Now tap the next one.",@"It looks like you're getting it!",@"Go as quickly as you can.",@"Good luck!"];
    });
    
    return array;
}



@end
