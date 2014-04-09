//
//  FallingTileGameModeScene.m
//  TapTheColoredTile
//
//  Created by Mick on 4/8/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//


static CGFloat tileWidth = 80.0;
static CGFloat tileHeight = 170.0;


#import "FallingTileGameModeScene.h"
#import "SKButton.h"
#import "SKColor+Colors.h"
#import "ViewController.h"


@interface FallingTileGameModeScene ()

@property (nonatomic, assign) CGFloat fallTime;
@property (nonatomic, assign) BOOL gameCanContinue;

@end

@implementation FallingTileGameModeScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {
        [self setGameCanContinue:YES];
        [self setBackgroundColor:[SKColor _nonStepTileColor]];
        [self setFallTime:2.5];
        [self addNewTile];
        
        SKButton *backButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:CGSizeMake(44.0, 44.0)];
        [backButton setText:@"x"];
        [backButton setZPosition:1000.0];
        [backButton setPosition:CGPointMake(size.width - 66.0, size.height - 66.0)];
        [backButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            
        }];
        [self addChild:backButton];
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
        static int tileNumber = 0;
        
        tileNumber ++ ;
        
        [self correctedRandomIndex];
        SKButton *tile = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:CGSizeMake(tileWidth, tileHeight)];
        __weak SKButton *weakTile = tile;
        
        [tile setName:@"tile"];
        [tile setPosition:CGPointMake([self correctedRandomIndex] * tileWidth + tileWidth / 2.0, self.size.height + tileHeight / 2.0)];
        [tile addActionOfType:SKButtonActionTypeTouchDown withBlock:^{
            if (self.gameCanContinue) {
                [weakTile runAction:[self removeTappedTileActio:weakTile]];
            }
        }];
        [self addChild:tile];
        
    
        SKAction *moveAction = [SKAction moveTo:CGPointMake(tile.position.x, -tileHeight / 2.0)
                                       duration:self.fallTime];
        
        SKAction *movementCompletionAction = [SKAction runBlock:^{
            [self removeAllActions];
            if (self.gameCanContinue) {
                [self setGameCanContinue:NO];
                [self lose];
            }
        }];
        
        SKAction *completionAction = [SKAction runBlock:^{
            [self addNewTile];
        }];
        
        SKAction *waitAction = [SKAction waitForDuration:(self.fallTime * tileHeight) / (self.size.height + tileHeight + 70.0) withRange:0];
        
        SKAction *recursiveAction = [SKAction sequence:@[waitAction, completionAction]];
        
        [self runAction:recursiveAction withKey:@"recursionAction"];
        
        [tile runAction:[SKAction sequence:@[moveAction,movementCompletionAction]] withKey:@"moveAction"];

        self.fallTime -= self.fallTime >= 0.85 ? 0.01 : 0.0;
    }
}

- (SKAction *)removeTappedTileActio:(SKButton *)tile
{
    SKAction *removeMovement = [SKAction runBlock:^{
        [tile removeActionForKey:@"moveAction"];
    }];
    
    SKAction *fade = [SKAction fadeAlphaTo:0.0 duration:0.05];

    SKAction *remove = [SKAction removeFromParent];
    
    return [SKAction sequence:@[removeMovement,fade,remove]];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    
    ViewController *viewController = (ViewController *)self.view.window.rootViewController;
    
    if (viewController.isAdBannerCurrentlyVisible) {
        if (location.y <= 50.0) {
            [self setPaused:YES];
            return;
        }
    }
    
    if (location.y >= self.size.height - 88.0 && location.x >= self.size.width - 88.0) {
        NSLog(@"Back button");
        return;
    }
    
    [self lose];
}

- (void)lose
{
    
}

- (void)win
{
    
}

@end
