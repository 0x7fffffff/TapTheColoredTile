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
#import <sys/utsname.h>
#import "Appirater.h"
@import MessageUI;
@interface SettingsScene () < MFMailComposeViewControllerDelegate >

@end

@implementation SettingsScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {

        [self.titleLabel setText:@"Settings"];

        
        CGSize buttonSize = CGSizeMake(size.width, 44.0);
        
        SKButton *backButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor]
                                                          size:buttonSize];
        [backButton setText:@"Back"];
        [backButton setPosition:CGPointMake(size.width / 2.0, 90.0)];
        [backButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            MenuScene *scene = [[MenuScene alloc] initWithSize:self.size];
            [scene setScaleMode:SKSceneScaleModeFill];
            
            [self.view presentScene:scene transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.35]];
        }];
        [self addChild:backButton];

        
        CGFloat yStart = self.titleLabel.position.y / 2.0 + 54.0;

        
        
        SKButton *supporButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [supporButton setPosition:CGPointMake(size.width / 2.0, yStart - 81.0)];
        [supporButton setText:@"Customer Support"];

        __weak SKButton *weakSupport = supporButton;

        [supporButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
                [composer setMailComposeDelegate:self];
                [composer setMessageBody:[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPlease leave the lines below intact for diagnostic purposes.\n%@\n%@",[self machineName],[[UIDevice currentDevice] systemVersion]] isHTML:NO];
                [composer setSubject:@"Customer Support - Tap the Colored Tile"];
                [composer setTitle:@"Customer Support"];
                [composer setToRecipients:@[@"help.happtech@gmail.com"]];
                [self.view.window.rootViewController presentViewController:composer animated:YES completion:nil];
            }else{
                [weakSupport setText:@"Can't Send Mail"];
            }
        }];
        [self addChild:supporButton];


        
        SKButton *rateButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        
        [rateButton setPosition:CGPointMake(size.width / 2.0, yStart - 27.0)];
        [rateButton setText:@"Rate This App!"];
        [rateButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [Appirater rateApp];
            });
        }];
        [self addChild:rateButton];
        


        __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];


        __block BOOL hasShownTutorial = [defaults boolForKey:xxxHasShownTutorialKey];

        SKButton *toggleTutorialMode = [[SKButton alloc] initWithColor:hasShownTutorial ? [SKColor lightGrayColor] : [SKColor _stepTileColor] size:buttonSize];

        __weak SKButton *weakTutorialButton = toggleTutorialMode;

        [toggleTutorialMode setPosition:CGPointMake(size.width / 2.0, yStart + 27.0)];
        [toggleTutorialMode setText:hasShownTutorial ? @"Reactivate Tutorials" : @"Deactivate Tutorials"];
        [toggleTutorialMode addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            if (hasShownTutorial) {
                [weakTutorialButton setText:@"Deactivate Tutorials"];
                [weakTutorialButton setColor:[SKColor _stepTileColor]];
            }else{
                [weakTutorialButton setText:@"Reactivate Tutorials"];
                [weakTutorialButton setColor:[SKColor lightGrayColor]];
            }
            hasShownTutorial = !hasShownTutorial;
            [defaults setBool:hasShownTutorial forKey:xxxHasShownTutorialKey];
            [defaults synchronize];
        }];
        [self addChild:toggleTutorialMode];


        BOOL shouldPlaySounds = [defaults boolForKey:xxxShouldPlaySoundsKey];
        
        SKButton *soundsToggleButton = [[SKButton alloc] initWithColor:shouldPlaySounds ?
                                        [SKColor _stepTileColor] : [SKColor lightGrayColor]
                                                                  size:buttonSize];
        
        [soundsToggleButton setPosition:CGPointMake(size.width / 2.0, yStart + 81.0)];
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
            [defaults setObject:@(weakSound.tag) forKey:xxxShouldPlaySoundsKey];
            [defaults synchronize];
        }];
        
        [self addChild:soundsToggleButton];
    }
    
    return self;
}

- (NSString *)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
