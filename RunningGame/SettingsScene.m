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
@import MessageUI;
@interface SettingsScene () < UIAlertViewDelegate , MFMailComposeViewControllerDelegate >

@end

@implementation SettingsScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {        
        [self setBackgroundColor:[SKColor _nonStepTileColor]];
        
        SKLabelNode *titleLabelNode = [[SKLabelNode alloc] initWithFontNamed:xxFileNameComicSansNeueFont];
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
        [backButton setPosition:CGPointMake(size.width / 2.0, 90.0)];
        [backButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            MenuScene *scene = [[MenuScene alloc] initWithSize:self.size];
            [scene setScaleMode:SKSceneScaleModeFill];
            
            [self.view presentScene:scene
                         transition:[SKTransition moveInWithDirection:SKTransitionDirectionLeft
                                                             duration:0.35]];
        }];
        [self addChild:backButton];

        
        CGFloat yStart = (titleLabelNode.position.y + (backButton.frame.origin.y + backButton.frame.size.height)) / 2.0;

        
        
        
        
        
        SKButton *rateButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        
        [rateButton setPosition:CGPointMake(size.width / 2.0, yStart - 60.0)];
        [rateButton setText:@"Rate This App!"];
        [rateButton setName:@"rateButton"];
        [rateButton addActionOfType:SKButtonActionTypeTouchUpInside withBlock:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"You are about to exit this app and switch to the App Store." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
            [alertView show];
        }];
        [self addChild:rateButton];
        
        SKButton *supporButton = [[SKButton alloc] initWithColor:[SKColor _stepTileColor] size:buttonSize];
        [supporButton setPosition:CGPointMake(size.width / 2.0, yStart - 90.0)];
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
        
        
        
        
        
        __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        BOOL shouldPlaySounds = [defaults boolForKey:xxxShouldPlaySoundsKey];
        
        SKButton *soundsToggleButton = [[SKButton alloc] initWithColor:shouldPlaySounds ?
                                        [SKColor _stepTileColor] : [SKColor lightGrayColor]
                                                                  size:buttonSize];
        
        [soundsToggleButton setPosition:CGPointMake(size.width / 2.0, yStart + 60.0)];
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
        
        
        __block BOOL hasShownTutorial = [defaults boolForKey:xxxHasShownTutorialKey];
        
        SKButton *toggleTutorialMode = [[SKButton alloc] initWithColor:hasShownTutorial ? [SKColor lightGrayColor] : [SKColor _stepTileColor] size:buttonSize];
        
        __weak SKButton *weakTutorialButton = toggleTutorialMode;
        
        [toggleTutorialMode setPosition:CGPointMake(size.width / 2.0, yStart)];
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
        }];
        [self addChild:toggleTutorialMode];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSDictionary *info = [[[NSBundle mainBundle] infoDictionary] copy];
        
        NSURL *url = [NSURL URLWithString:info[@"iTunesURL"]];
        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            [(SKButton *)[self childNodeWithName:@"rateButton"] setText:@"Error: Try later"];
        }
    }
}

@end
