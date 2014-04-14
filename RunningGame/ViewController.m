//
//  ViewController.m
//  RunningGame
//
//  Created by Michael MacCallum on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "ViewController.h"
#import "MenuScene.h"
@import iAd;

@interface ViewController () < ADBannerViewDelegate >
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKView *skView = (SKView *)self.view;
    
    MenuScene *scene = [[MenuScene alloc] initWithSize:skView.bounds.size];
    [scene setScaleMode:SKSceneScaleModeFill];
    [skView presentScene:scene];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    SKView *skView = (SKView *)self.view;
    
    if ([skView respondsToSelector:@selector(setPaused:)]) {
        [skView setPaused:NO];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:xxxShouldShowAdsKey]) {
        [self.adBanner removeFromSuperview];
    }
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    SKView *skView = (SKView *)self.view;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([skView respondsToSelector:@selector(setPaused:)]) {
            [skView setPaused:NO];
        }        
    });
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self.adBanner.layer setZPosition:10000.0];
    [UIView animateWithDuration:0.15 animations:^{
        [self.adBanner setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self setIsAdBannerCurrentlyVisible:YES];
    }];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView animateWithDuration:0.15 animations:^{
        [self.adBanner setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self setIsAdBannerCurrentlyVisible:NO];
    }];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner
               willLeaveApplication:(BOOL)willLeave
{
    SKView *skView = (SKView *)self.view;
    
    if ([skView respondsToSelector:@selector(setPaused:)]) {
        [skView setPaused:YES];
    }
    
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
