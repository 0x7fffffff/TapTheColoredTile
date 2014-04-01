//
//  MyScene.m
//  RunningGame
//
//  Created by Michael MacCallum on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "GameScene.h"
#import "SKColor+Colors.h"
#import "MenuScene.h"
#import "CountDownNode.h"
#import "GameOverScene.h"
#import "NodeAdditions.h"
#import "TutorialOverlayNode.h"
#import "CancelButtonNode.h"
//@import GameKit;

static NSString *tileName = @"Tile";
static CGFloat tileWidth = 80.0;
static CGFloat tileHeight = 170.0;
static CGFloat leadingSpace = 35.0;

@interface GameScene ()
@property (strong, nonatomic) NSMutableArray *tilesArray;
@property (nonatomic, assign) NSInteger requiredSteps;
@property (nonatomic, assign) NSInteger currentStep;
@property (nonatomic, assign) NSInteger rowsProduced;
@property (nonatomic, assign) double startTime;
@property (nonatomic, assign) GameType gameType;
@property (nonatomic, assign) BOOL canContinuePlaying;
@property (nonatomic, strong) NSMutableArray *last15Taps;
@property (strong, nonatomic) NSTimer *tapTimer;
@property (getter = isFirstRun, assign) BOOL firstRun;
@end

@implementation GameScene

- (instancetype)initWithSize:(CGSize)size andGameType:(GameType)gameType
{
    if (self = [super initWithSize:size]) {
        
        [self setFirstRun:![self hasShownTutorial]];
        if (self.tapTimer.isValid) {
            [self.tapTimer invalidate];
        }

        self.last15Taps = [NSMutableArray new];
        
        [self setBackgroundColor:[SKColor _nonStepTileColor]];
        [self setGameType:gameType];
        
        switch (gameType) {
            case GameTypeSprint:{
                [self setRequiredSteps:50];
            }break;
                
            case GameTypeMarathon:{
                [self setRequiredSteps:250];
            }break;
                
            case GameTypeEndurance:{
                [self setRequiredSteps:NSIntegerMax];
            }break;
                
            default:
                break;
        }
        
        [self setRowsProduced:0];
        [self setCanContinuePlaying:NO];
        
        CancelButtonNode *backButton = [[CancelButtonNode alloc] initWithColor:[SKColor _stepTileColor]
                                                                          size:CGSizeMake(88.0, 88.0)];
        [backButton setAnchorPoint:CGPointMake(0.5, 0.5)];
        [backButton setZPosition:1000.0];
        [backButton setPosition:CGPointMake(self.frame.size.width - 44.0, self.frame.size.height - 44.0)];
        [backButton setName:@"backButton"];
        [self addChild:backButton];
        
        if (!self.isFirstRun) {
            CountDownNode *countDownNode = [[CountDownNode alloc] initWithColor:[SKColor _nonStepTileColor]
                                                                           size:size];
            [countDownNode startCountDownWithCompletion:^{
                SKAction *completionAction = [SKAction runBlock:^{
                    [self setCanContinuePlaying:YES];
                    [countDownNode removeFromParent];
                    [self setStartTime:CFAbsoluteTimeGetCurrent()];
                }];
                
                [countDownNode runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.0
                                                                           duration:0.2],completionAction]]];
            }];
            
            [self addChild:countDownNode];            
        }else{
            CGFloat tutHeight = self.size.height - tileHeight - leadingSpace;
            TutorialOverlayNode *tutorialNode = [[TutorialOverlayNode alloc] initWithColor:[SKColor _nonStepTileColor]
                                                                                      size:CGSizeMake(self.size.width, tutHeight)
                                                                               andGameType:gameType];
            [tutorialNode setAnchorPoint:CGPointMake(0.5, 0.5)];
            [tutorialNode setPosition:CGPointMake(size.width / 2.0, size.height - tutHeight / 2.0)];
            [tutorialNode setName:@"tutorialNode"];
            [tutorialNode setZPosition:1321.0];
            [self addChild:tutorialNode];
        
        }

        [self generateTiles];
    }
    
    return self;
}


- (BOOL)hasShownTutorial
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL beenRun = [defaults boolForKey:@"hasShownTutorial"];
    
    return beenRun;
}



- (CGPoint)centerOfOpenGapInNewRow
{
    int i = 0;
    int n = 0;
    CGFloat y = 0.0;
    
    for (SKSpriteNode *node in self.tilesArray[0]) {
        if ([node.userData[@"steppable"] boolValue] == YES) {
            n = i;
            y = node.frame.origin.y + node.frame.size.height / 2.0;
        }
        i ++ ;
    }
    
    CGPoint point = CGPointZero;
    
    switch (n) {
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
    self.tilesArray = [NSMutableArray new];
    
    for (int i = 0; i < 5; i ++) {
        [self addRowAtYIndex:i * tileHeight + leadingSpace];
    }
}

- (void)addRowAtYIndex:(int)yIndex
{
    if (self.rowsProduced < self.requiredSteps) {
        uint32_t rand = arc4random_uniform(4);
        NSMutableArray *tilesInRow = [NSMutableArray new];
        
        for (int i = 0; i < 4; i ++) {
            
            SKColor *color = nil;
            BOOL steppable = NO;
            
            if (i == rand) {
                steppable = YES;
                color = [SKColor _stepTileColor];
            }else{
                color = [SKColor clearColor];
            }
            
            NSMutableDictionary *info = [NSMutableDictionary new];
            
            info[@"xIndex"] = @(i);
            info[@"steppable"] = @(steppable);
            
            
            SKSpriteNode *node = [[SKSpriteNode alloc] initWithColor:color
                                                                size:CGSizeMake(tileWidth, tileHeight)];
            
            [node setYScale:0.99];
            [node setAnchorPoint:CGPointMake(0.0, 0.0)];
            [node setPosition:CGPointMake(i * tileWidth, yIndex)];
            [node setName:tileName];
            [node setUserData:info];
            
            [self addChild:node];
            [tilesInRow addObject:node];
        }
        
        [self.tilesArray insertObject:tilesInRow atIndex:0];
        
        if (!self.isFirstRun) {
            if ((self.rowsProduced + 1) % 5 == 0) {
                SKLabelNode *backgroundCountLabel = [[SKLabelNode alloc] initWithFontNamed:@"ComicNeueSansID"];
                [backgroundCountLabel setName:tileName];
                [backgroundCountLabel setPosition:[self centerOfOpenGapInNewRow]];
                [backgroundCountLabel setText:[NSString stringWithFormat:@"%li",(long)self.rowsProduced + 1]];
                [backgroundCountLabel setFontSize:50.0];
                [backgroundCountLabel setAlpha:1.0];
                [backgroundCountLabel setFontColor:[SKColor _stepTileColor]];
                [backgroundCountLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
                [backgroundCountLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
                [self insertChild:backgroundCountLabel atIndex:0];
            }            
        }
        
        self.rowsProduced ++ ;
    }
}

- (SKSpriteNode *)tappableNodeInBottomRow
{
    SKSpriteNode *tappableNode = nil;
    
    for (SKSpriteNode *node in self.tilesArray[self.tilesArray.count - 1]) {
        if ([node.userData[@"steppable"] boolValue] == YES) {
            tappableNode = node;
            break;
        }
    }
    
    return tappableNode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    if (touchLocation.y <= tileHeight + leadingSpace) {
        SKSpriteNode *tappableNode = [self tappableNodeInBottomRow];
        
        if (tappableNode == [self nodeAtPoint:touchLocation]) {
            if ([self shouldPlaySounds]) {
                [tappableNode runAction:[self _tapSoundAction]];
            }
            if (!self.canContinuePlaying) {
                [(TutorialOverlayNode *)[self childNodeWithName:@"tutorialNode"] incrementTutorialIndex];
            }
            [self takeStep];
        }else{
            if (self.canContinuePlaying) {
                [self lose];
            }
        }
    }else{
        if (self.canContinuePlaying) {
            for (SKNode *node in [self nodesAtPoint:touchLocation]) {
                if (self.tapTimer.isValid) {
                    [self.tapTimer invalidate];
                }
                if ([node isEqual:[self childNodeWithName:@"backButton"]]) {
                    if ([self shouldPlaySounds]) {
                        [self runAction:[self _loseSoundAction]];
                    }
                    MenuScene *scene = [[MenuScene alloc] initWithSize:self.size];
                    [scene setScaleMode:SKSceneScaleModeAspectFill];
                    
                    [self.view presentScene:scene
                                 transition:[SKTransition doorsCloseHorizontalWithDuration:0.35]];
                    break;
                }else{
                    [self lose];
                    break;
                }
            }
        }
    }
}

- (void)tapTimerDidFire:(NSTimer *)timer
{
    double oldestTime = [self.last15Taps[0] doubleValue];
    double currentTime = CFAbsoluteTimeGetCurrent();
    
    
    double tps = 1.0 / ((currentTime - oldestTime) / (double)self.last15Taps.count);

    double offset = log(fabs(log(1.0 / (CFAbsoluteTimeGetCurrent() - self.startTime))));
    
    if (tps <= 1.0 + offset) {
        if (tps <= offset) {
            [timer invalidate];
            [self win];
            
            return;
        }
        [self enumerateChildNodesWithName:tileName usingBlock:^(SKNode *node, BOOL *stop) {
            [node setAlpha:1.0 - (2.5 - tps)];
        }];
    }
}


- (void)takeStep
{
    self.currentStep ++ ;
    
    if (self.gameType == GameTypeEndurance) {
        if (self.currentStep == 15) {
            if (self.tapTimer.isValid) {
                [self.tapTimer invalidate];
            }
            self.tapTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                             target:self
                                                           selector:@selector(tapTimerDidFire:)
                                                           userInfo:nil
                                                            repeats:YES];
        }
        
        [self.last15Taps addObject:@(CFAbsoluteTimeGetCurrent())];
        
        if (self.last15Taps.count >= 15) {
            [self.last15Taps removeObjectAtIndex:0];
        }
    }
    
    if (self.currentStep == self.requiredSteps) {
        
        NSString *key = nil;
        
        if (self.gameType == GameTypeSprint) {
            key = @"lastSprintTimeKey";
        }else if (self.gameType == GameTypeMarathon) {
            key = @"lastMarathonTimeKey";
        }else{

        }
         
        [[NSUserDefaults standardUserDefaults] setObject:@(CFAbsoluteTimeGetCurrent() - self.startTime) forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self win];
    }
    
    [self.tilesArray removeLastObject];
    
    [self enumerateChildNodesWithName:tileName usingBlock:^(SKNode *node, BOOL *stop) {
        SKAction *moveAction = [SKAction moveBy:CGVectorMake(0.0, -tileHeight) duration:0.02];
        [node runAction:moveAction];
    }];
    
    [self addRowAtYIndex:4 * tileHeight + leadingSpace];
}


- (void)win
{
    if (self.tapTimer.isValid) {
        [self.tapTimer invalidate];
    }

    if (self.canContinuePlaying) {
        if ([self shouldPlaySounds]) {
            [self runAction:[self _winSoundAction]];
        }
        
        if (self.gameType == GameTypeEndurance) {
            [[NSUserDefaults standardUserDefaults] setObject:@(self.currentStep) forKey:@"lastEnduranceScoreKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self gameOverWithWin:YES];
        [self setCanContinuePlaying:NO];
    }
}

- (void)lose
{
    if (self.tapTimer.isValid) {
        [self.tapTimer invalidate];
    }

    if (self.canContinuePlaying) {
        if ([self shouldPlaySounds]) {
            [self runAction:[self _loseSoundAction]];
        }
        
        if (self.gameType == GameTypeEndurance) {
            [[NSUserDefaults standardUserDefaults] setObject:@(self.currentStep) forKey:@"lastEnduranceScoreKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self gameOverWithWin:YES];
        }else{
            [self gameOverWithWin:NO];
        }
        [self setCanContinuePlaying:NO];
    }
}

- (void)gameOverWithWin:(BOOL)won
{
    GameOverScene *scene = [[GameOverScene alloc] initWithSize:self.size
                                          andReturningGameType:self.gameType
                                                     andDidWin:won
                                                  withTapCount:self.currentStep];
    [scene setScaleMode:SKSceneScaleModeFill];
    [self.view presentScene:scene
                 transition:[SKTransition flipVerticalWithDuration:0.35]];
}



@end
