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

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKView *skView = (SKView *)self.view;
    
    MenuScene *scene = [[MenuScene alloc] initWithSize:skView.bounds.size];
    [scene setScaleMode:SKSceneScaleModeFill];

    [skView presentScene:scene];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"shouldShowAds"]) {
        [self setCanDisplayBannerAds:YES];
    }
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
