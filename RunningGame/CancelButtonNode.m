//
//  CancelButtonNode.m
//  RunningGame
//
//  Created by Mick on 3/31/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "CancelButtonNode.h"
#import "SKColor+Colors.h"

@implementation CancelButtonNode

- (instancetype) initWithColor:(SKColor *)color size:(CGSize)size
{
    self = [super initWithColor:[SKColor clearColor] size:size];
    
    if (self) {
        SKSpriteNode *subNode = [[SKSpriteNode alloc] initWithColor:color size:CGSizeMake(size.width / 2.0, size.height / 2.0)];
        
        [subNode setAnchorPoint:CGPointMake(0.5, 0.5)];
        [subNode setPosition:CGPointMake(0.0, 0.0)];
        
        [self addChild:subNode];
        
        
        SKLabelNode *labelNode = [[SKLabelNode alloc] initWithFontNamed:@"ComicNeueSansID"];
        [labelNode setText:@"x"];
        [labelNode setFontSize:32];
        [labelNode setFontColor:[SKColor _nonStepTileColor]];
        [labelNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [labelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [labelNode setPosition:CGPointMake(0.0, 0.0)];
        
        [subNode addChild:labelNode];
    }
    
    return self;
}

@end
