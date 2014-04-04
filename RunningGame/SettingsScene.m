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
        
        CGSize buttonSize = CGSizeMake(size.width, 50.0);
        
        SKButton *backButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor]
                                                          size:buttonSize];
        [backButton setText:@"Back"];
        [backButton setPosition:CGPointMake(size.width / 2.0, 60.0)];
        [backButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            MenuScene *scene = [[MenuScene alloc] initWithSize:self.size];
            [scene setScaleMode:SKSceneScaleModeFill];
            
            [self.view presentScene:scene
                         transition:[SKTransition moveInWithDirection:SKTransitionDirectionLeft
                                                             duration:0.35]];
        }];
        [self addChild:backButton];

        
        CGFloat yStart = (titleLabelNode.position.y + (backButton.frame.origin.y + backButton.frame.size.height)) / 2.0;

        
        __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        BOOL shouldPlaySounds = [defaults boolForKey:@"shouldPlaySounds"];
        
        SKButton *soundsToggleButton = [[SKButton alloc] initWithColor:shouldPlaySounds ?
                                        [SKColor _stepTileColor] : [SKColor lightGrayColor]
                                                                  size:buttonSize];
        
        [soundsToggleButton setPosition:CGPointMake(size.width / 2.0, yStart + 120.0)];
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
        
        
        
        SKButton *toggleTutorialMode = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [toggleTutorialMode setPosition:CGPointMake(size.width / 2.0, yStart + 60.0)];
        [toggleTutorialMode setText:@"Reactivate Tutorials"];
        [toggleTutorialMode addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            
        }];
        [self addChild:toggleTutorialMode];
        
        
        SKButton *toggleThemeButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [toggleThemeButton setPosition:CGPointMake(size.width / 2.0, yStart)];
        [toggleThemeButton setText:@"Change Theme"];
        [toggleThemeButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            for (SKNode *node in self.children) {
                if ([node respondsToSelector:@selector(setColor:)]) {
                    [(SKSpriteNode *)node setColor:[SKColor _stepTileColor]];
                }
            }
        }];
        [self addChild:toggleThemeButton];
        
        SKButton *rateButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        
        __weak SKButton *weakRate = rateButton;
        
        [rateButton setPosition:CGPointMake(size.width / 2.0, yStart - 60.0)];
        [rateButton setText:@"Rate This App!"];
        [rateButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            
            NSDictionary *info = [[[NSBundle mainBundle] infoDictionary] copy];
            
            NSURL *url = [NSURL URLWithString:info[@"iTunesURL"]];
            if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }else{
                [weakRate setText:@"Error: Try later"];
            }
        }];
        [self addChild:rateButton];
        
        SKButton *supporButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [supporButton setPosition:CGPointMake(size.width / 2.0, yStart - 120.0)];
        [supporButton setText:@"Customer Support"];
        [supporButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            
        }];
        [self addChild:supporButton];
    }
    
    return self;
}

@end
