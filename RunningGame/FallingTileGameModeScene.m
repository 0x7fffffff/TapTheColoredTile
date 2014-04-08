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

@interface FallingTileGameModeScene ()

@property (nonatomic, assign) CGFloat fallTime;
@property (nonatomic, assign) CGFloat tileRecursionDelay;
@property (nonatomic, assign) BOOL gameCanContinue;

@end

@implementation FallingTileGameModeScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {
        [self setGameCanContinue:YES];
        [self setBackgroundColor:[SKColor _nonStepTileColor]];
        [self setFallTime:2.0];
        [self setTileRecursionDelay:1.0];
        [self addNewTile];
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

    while (previous.count < 2) {
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
        
        SKAction *moveAction = [SKAction moveTo:CGPointMake(tile.position.x, -tileHeight / 2.0) duration:self.fallTime];
        SKAction *movementCompletionAction = [SKAction runBlock:^{
            [self removeAllActions];
            if (self.gameCanContinue) {
                [self setGameCanContinue:NO];
                
                NSLog(@"Lose");
            }
        }];
        
        SKAction *completionAction = [SKAction runBlock:^{
            [self addNewTile];
        }];
        
        SKAction *waitAction = [SKAction waitForDuration:self.tileRecursionDelay withRange:0];
        
        SKAction *recursiveAction = [SKAction sequence:@[waitAction, completionAction]];
        
        [self runAction:recursiveAction withKey:@"recursionAction"];
        
        [tile runAction:[SKAction sequence:@[moveAction,movementCompletionAction]] withKey:@"moveAction"];

        //((-3sin(x))/x)+4
//        CGFloat decrement = 1.0 / tileNumber;
        CGFloat x = tileNumber + 10;

//        self.fallTime -= fabs(((sin(x)) / (pow(x, 1.4))));
//        self.tileRecursionDelay -= fabs(((sin(x)) / (pow(x, 1.3))));
        CGFloat decrement = pow(2.0 * atan(x) / x, 2.0);

        self.fallTime -= self.fallTime >= 0.5 ? decrement * 1.1 : 0.0;
        self.tileRecursionDelay -= self.tileRecursionDelay >= 0.275 ? decrement : 0.0;

        NSLog(@"Recursion time: %f                        fall time: %f",self.tileRecursionDelay,self.fallTime);
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

}

@end
