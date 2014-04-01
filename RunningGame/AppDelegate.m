//
//  AppDelegate.m
//  RunningGame
//
//  Created by Michael MacCallum on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "AppDelegate.h"
@import SpriteKit;
@import AVFoundation;
//@import GameKit;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:NO forKey:@"shouldPlaySounds"];
//    [defaults synchronize];
    
    if (![defaults boolForKey:@"prefsSet"]) {
        [defaults setBool:YES forKey:@"prefsSet"];
        [defaults setBool:YES forKey:@"shouldPlaySounds"];
        
        [defaults synchronize];
    }
    
    return YES;
}

-(void)authenticateLocalPlayer
{
//    if(![GKLocalPlayer localPlayer].authenticated) {
//        
//        [[NSNotificationCenter defaultCenter] addObserverForName:GKPlayerDidChangeNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//            NSLog(@"%@",note.userInfo);
//        }];
//        
//        [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
//            NSLog(@"Error%@",error);
//        }];
//    }
}


- (SKView *)getSKViewSubview
{
    for (UIView *subview in self.window.rootViewController.view.subviews) {
        if ([subview isKindOfClass:[SKView class]]) {
            return (SKView *)subview;
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
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self authenticateLocalPlayer];

    SKView *view = [self getSKViewSubview];
    if ([view respondsToSelector:@selector(setPaused:)]) {
        [view setPaused:NO];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
