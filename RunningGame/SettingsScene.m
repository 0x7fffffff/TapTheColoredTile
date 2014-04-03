//
//  SettingsScene.m
//  TapTheColoredTile
//
//  Created by Mick on 4/1/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "SettingsScene.h"
#import "SKColor+Colors.h"
#import "SKButton.h"
#import "MenuScene.h"

@implementation SettingsScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {
            // settings to add
            // sounds on/off
            // re-enable tutorial mode
            // possibly color themes
        
        [self setBackgroundColor:[SKColor _nonStepTileColor]];
        
        SKLabelNode *titleLabelNode = [[SKLabelNode alloc] initWithFontNamed:@"ComicNeueSansID"];
        [titleLabelNode setText:@"Settings"];
        [titleLabelNode setPosition:CGPointMake(size.width / 2.0, size.height - 60.0)];
        [titleLabelNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [titleLabelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [titleLabelNode setFontColor:[SKColor _stepTileColor]];
        [titleLabelNode setFontSize:30.0];
        [self addChild:titleLabelNode];
        
        
        __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        BOOL shouldPlaySounds = [defaults boolForKey:@"shouldPlaySounds"];
        
        SKButton *soundsToggleButton = [[SKButton alloc] initWithColor:shouldPlaySounds ?
                                        [SKColor _stepTileColor] : [SKColor lightGrayColor]
                                                                  size:CGSizeMake(size.width, 50.0)];
        
        [soundsToggleButton setPosition:CGPointMake(size.width / 2.0, size.height / 2.0)];
        [soundsToggleButton setText:shouldPlaySounds ? @"Turn Sounds Off" : @"Turn Sounds On"];
        [soundsToggleButton setTag:(NSInteger)shouldPlaySounds];
        [soundsToggleButton setOverrideSoundSettings:YES];
        
        __weak SKButton *weakSound = soundsToggleButton;
        
        [soundsToggleButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            if (weakSound.tag) {
                [weakSound setTag:0];
                [weakSound setColor:[UIColor lightGrayColor]];
                [weakSound setText:@"Turn Sounds On"];
            }else{
                [weakSound setTag:1];

                [weakSound setColor:[SKColor _stepTileColor]];
                [weakSound setText:@"Turn Sounds Off"];
            }
            [defaults setObject:@(weakSound.tag) forKey:@"shouldPlaySounds"];
            [defaults synchronize];
        }];
        
        [self addChild:soundsToggleButton];
        
        
        
        SKButton *backButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor]
                                                          size:CGSizeMake(size.width, 50.0)];
        [backButton setText:@"Back"];
        [backButton setPosition:CGPointMake(size.width / 2.0, 35.0)];
        [backButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            MenuScene *scene = [[MenuScene alloc] initWithSize:self.size];
            [scene setScaleMode:SKSceneScaleModeFill];
            
            [self.view presentScene:scene
                         transition:[SKTransition moveInWithDirection:SKTransitionDirectionLeft
                                                             duration:0.35]];
        }];
        [self addChild:backButton];
    }
    
    return self;
}

@end
