//
//  SKButton.h
//  SKButton Project
//
//  Created by Mick on 4/1/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    SKButtonActionTypeTouchDown = 1,
    SKButtonActionTypeTouchUpInside = 1 << 1
} SKButtonActionType;

typedef void(^ActionBlock)(void);

@interface SKButton : SKSpriteNode

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *fontName;
@property (strong, nonatomic) SKColor *textColor;
@property (nonatomic, assign) CGFloat textSize;

@property (strong, nonatomic) SKLabelNode *label;

- (void)addActionOfType:(SKButtonActionType)type withBlock:(ActionBlock)actionBlock;

//- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size;

@end
