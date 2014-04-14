//
//  AppDelegate.m
//  RunningGame
//
//  Created by Michael MacCallum on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "MKiCloudSync.h"
#import "Appirater.h"
@import SpriteKit;
@import AVFoundation;
@import GameKit;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appirater setAppId:@"851869611"];
    [Appirater setDaysUntilPrompt:14];
    [Appirater setUsesUntilPrompt:30];
    [Appirater setSignificantEventsUntilPrompt:20];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setOpenInAppStore:NO];
    [Appirater setDebug:NO];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Last set on v2.0 update
    if (![defaults boolForKey:xxxHasPreviouslyRun]) {

        [defaults removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
        [defaults synchronize];

        [defaults setBool:YES forKey:xxxShouldPlaySoundsKey];
        [defaults setBool:YES forKey:xxxShouldShowAdsKey];
        [defaults setBool:NO forKey:xxxHasShownTutorialKey];
        [defaults setBool:YES forKey:xxxHasPreviouslyRun];
        [defaults synchronize];
    }

    
    [MKiCloudSync start];
    [Appirater appLaunched:YES];

    return YES;
}

- (void)authenticateLocalPlayer
{
    [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {

        if (!error && ![[NSUserDefaults standardUserDefaults] boolForKey:xxxHasPreviouslyRun]) {
            GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:xxLeaderboardKeySprintBestTimes];
            [score setValue:0];

            [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
                NSLog(@"Reporting Error: %@",error);
            }];
        }
    }];
}


- (SKView *)getSKViewSubview
{
    if ([self.window.rootViewController.view respondsToSelector:@selector(scene)]) {
        return (SKView *)self.window.rootViewController.view;
    }else{
        for (UIView *subview in self.window.rootViewController.view.subviews) {
            if ([subview isKindOfClass:[SKView class]]) {
                return (SKView *)subview;
            }
        }
    }
    return nil;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];

    SKView *view = [self getSKViewSubview];
    if ([view respondsToSelector:@selector(setPaused:)]) {
        [view setPaused:YES];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self authenticateLocalPlayer];

    SKView *view = [self getSKViewSubview];
    if ([view respondsToSelector:@selector(setPaused:)]) {
        [view setPaused:NO];
    }
}


@end