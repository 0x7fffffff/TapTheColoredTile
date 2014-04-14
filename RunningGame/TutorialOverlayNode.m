//
//  TutorialOverlayNode.m
//  RunningGame
//
//  Created by Mick on 3/31/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "TutorialOverlayNode.h"
#import "SKColor+Colors.h"
#import "OriginalGameModeScene.h"
#import "DSMultilineLabelNode.h"
#import "FallingTileGameModeScene.h"

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
        
        SKLabelNode *tutorialLabel = [[SKLabelNode alloc] initWithFontNamed:xxFileNameComicSansNeueFont];
        
        [tutorialLabel setText:@"Tutorial Mode"];
        [tutorialLabel setFontSize:28.0];
        [tutorialLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
        [tutorialLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [tutorialLabel setPosition:CGPointMake(0.0, size.height / 2.0 - 10.0)];
        [tutorialLabel setFontColor:[SKColor _stepTileColor]];
        
        [self addChild:tutorialLabel];
        
        
        DSMultilineLabelNode *mainLabel = [[DSMultilineLabelNode alloc] initWithFontNamed:xxFileNameComicSansNeueFont];
        [mainLabel setParagraphWidth:size.width - 20.0];
        [mainLabel setFontSize:24.0];
        [mainLabel setName:@"mainLabel"];
        [mainLabel setText:[self textArrayForGameType:self.gameType][self.index]];
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
    
    if (self.index < [self textArrayForGameType:self.gameType].count) {
        SKLabelNode *mainLabel = (SKLabelNode *)[self childNodeWithName:@"mainLabel"];
        [mainLabel setText:[self textArrayForGameType:self.gameType][self.index]];
        [mainLabel setFontColor:[SKColor _stepTileColor]];
    }else{
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:xxxHasShownTutorialKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

        SKScene *scene = nil;

        if (self.gameType == GameTypeFallingTiles) {
            scene = [[FallingTileGameModeScene alloc] initWithSize:self.scene.size];
        }else{
            scene = [[OriginalGameModeScene alloc] initWithSize:self.scene.size andGameType:self.gameType];
        }
        [scene setScaleMode:SKSceneScaleModeFill];

        SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionUp duration:0.35];
        [transition setPausesIncomingScene:NO];
        [transition setPausesOutgoingScene:NO];

        [self.scene.view presentScene:scene transition:transition];
    }
}

- (NSArray *)textArrayForGameType:(GameType)gameType
{
    if (gameType == GameTypeFallingTiles) {
        return [self fallingTilesModeTextArray];
    }else{
        return [self sprintAndMarathonModesTextArray];
    }
}

- (NSArray *)sprintAndMarathonModesTextArray
{
    static NSArray *array = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = @[@"Tap the tile at the bottom of the screen.", @"You can only tap the bottom most full tile.", @"Tapping anywhere else will cause you to lose!", @"Tap as quickly as you can. The faster you are the better!", @"Sprint mode goes to 50 and Marathon mode goes to 250!", @"It looks like you're getting it. Good luck!"];
    });
    
    return array;
}

- (NSArray *)fallingTilesModeTextArray
{
    static NSArray *array = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = @[@"Tap the tiles before they fall off the screen!", @"The order that you tap the tiles doesn't matter!", @"Tapping anywhere else will cause you to lose!", @"The tiles will progressively move faster and faster!", @"Try to go for as long as you can!", @"It looks like you're getting it. Good luck!"];
    });

    return array;
}



@end
