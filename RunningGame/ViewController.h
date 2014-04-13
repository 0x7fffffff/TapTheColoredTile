//
//  ViewController.h
//  RunningGame
//

//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
@class ADBannerView;
@interface ViewController : UIViewController

@property (nonatomic, assign) BOOL isAdBannerCurrentlyVisible;
@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;

@end
