//
//  MenuButtonNode.m
//  RunningGame
//
//  Created by Mick on 3/28/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import "MenuButtonNode.h"
#import "SKColor+Colors.h"
@interface MenuButtonNode ()
@property (strong, nonatomic) SKLabelNode *labelNode;
@end

@implementation MenuButtonNode

- (instancetype)initWithColor:(SKColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size];
    
    if (self) {
            
        self.labelNode = [[SKLabelNode alloc] initWithFontNamed:@"ComicNeueSansID"];
        [self.labelNode setFontColor:[SKColor _nonStepTileColor]];
        [self.labelNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [self.labelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [self.labelNode setPosition:CGPointMake(size.width / 2.0, size.height / 2.0)];
        [self addChild:self.labelNode];
    }
    
    return self;
}



- (void)setText:(NSString *)text
{
    _text = text;
    [self.labelNode setText:text];
}



@end
