//
//  AppDelegate.m
//  RunningGame
//
//  Created by Michael MacCallum on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "MKiCloudSync.h"
@import SpriteKit;
@import AVFoundation;
@import GameKit;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
        // Last set on V 1.1 update
    if (![defaults boolForKey:xxxIsFirstRunKey]) {
        [defaults setBool:YES forKey:xxxShouldShowAdsKey];
        [defaults setBool:YES forKey:xxxShouldPlaySoundsKey];
        [defaults setBool:YES forKey:xxxIsFirstRunKey];

        [defaults synchronize];
    }
    
    [MKiCloudSync start];

    return YES;
}

- (void)authenticateLocalPlayer
{
    if(![GKLocalPlayer localPlayer].authenticated) {
        
//        [[NSNotificationCenter defaultCenter] addObserverForName:GKPlayerDidChangeNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//            NSLog(@"%@",note.userInfo);
//        }];
        
        [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
//            NSLog(@"Error%@",error);
        }];
    }
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