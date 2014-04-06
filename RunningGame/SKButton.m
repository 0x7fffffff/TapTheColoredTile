//
//  SKButton.m
//  SKButton Project
//
//  Created by Mick on 4/1/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "SKButton.h"
#import "SKColor+Colors.h"
#import "NodeAdditions.h"

@interface SKButton ()
@property (nonatomic, assign) NSUInteger actionBitmask;
@property (nonatomic, assign) CGPoint startingTouchLocation;
@property (strong, nonatomic) ActionBlock touchDownBlock;
@property (strong, nonatomic) ActionBlock touchUpInsideBlock;
@end

@implementation SKButton

- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size];
    
    if (self) {
        [self setAnchorPoint:CGPointMake(0.5, 0.5)];
        [self setUserInteractionEnabled:YES];
        [self setStartingTouchLocation:CGPointZero];
        [self setActionBitmask:0];
        [self setOverrideSoundSettings:NO];
        [self addChild:self.label];
    }
    
    return self;
}

- (SKLabelNode *)label
{
    if (!_label) {
        _label = [SKLabelNode new];
        [_label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [_label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        
        [_label setPosition:CGPointZero];
        [_label setFontName:xxFileNameComicSansNeueFont];
    }
    
    return _label;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.actionBitmask > 0) {
        CGPoint location = [[touches anyObject] locationInNode:self];

        if (self.actionBitmask & SKButtonActionTypeTouchDown) {
            self.touchDownBlock();
        }else if (self.actionBitmask & SKButtonActionTypeTouchUpInside) {
            self.startingTouchLocation = location;
        }
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (self.actionBitmask > 0) {
        if (self.actionBitmask & SKButtonActionTypeTouchUpInside) {
            CGPoint location = [[touches anyObject] locationInNode:self];
            
            if (fabs(location.x - self.startingTouchLocation.x) <= self.frame.size.width / 2.0 && fabs(location.y - self.startingTouchLocation.y) <= self.frame.size.height / 2.0) {
                if (self.overrideSoundSettings) {
                    if (![self shouldPlaySounds]) {
                        [self runAction:[self _tapSoundAction]];
                    }
                }else{
                    if ([self shouldPlaySounds]) {
                        [self runAction:[self _tapSoundAction]];
                    }
                }

                self.touchUpInsideBlock();
                [self setStartingTouchLocation:CGPointZero];
            }
            
        }
    }
}

- (void)addActionOfType:(SKButtonActionType)type withBlock:(ActionBlock)actionBlock;
{
    if (type == SKButtonActionTypeTouchDown) {
        [self setTouchDownBlock:actionBlock];
    }else if (type == SKButtonActionTypeTouchUpInside) {
        [self setTouchUpInsideBlock:actionBlock];
    }
    self.actionBitmask = self.actionBitmask | type;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    [self.label setText:text];
}

- (void)setFontName:(NSString *)fontName
{
    _fontName = fontName;
    
    [self.label setFontName:fontName];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    [self.label setFontColor:textColor];
}

- (void)setTextSize:(CGFloat)textSize
{
    _textSize = textSize;
    
    [self.label setFontSize:textSize];
}

@end
