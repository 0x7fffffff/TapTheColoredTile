//
//  Globals.h
//  TapTheColoredTile
//
//  Created by Mick on 4/5/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

typedef enum : NSUInteger {
    GameTypeSprint = 1,
    GameTypeMarathon = 2,
    GameTypeEndurance = 4,
    GameTypeFreePlay = 8
} GameType;

    // Max
extern CGFloat const xxFastestPossibleTime;

    // Sound Names
extern NSString * const xxSoundFileNameWin;
extern NSString * const xxSoundFileNameLose;
extern NSString * const xxSoundFileNameTap;
extern NSString * const xxSoundFileNameBeep;

    // NSUserDefaults Keys
extern NSString * const xxxIsFirstRunKey;
extern NSString * const xxxShouldPlaySoundsKey;
extern NSString * const xxxShouldShowAdsKey;
extern NSString * const xxxHasShownTutorialKey;

    // File Names
extern NSString * const xxFileNameComicSansNeueFont;