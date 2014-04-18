//
//  ScoresListNode.h
//  TapTheColoredTile
//
//  Created by Michael MacCallum on 4/12/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScoresListNode : SKSpriteNode

- (instancetype)initWithColor:(SKColor *)color
                         size:(CGSize)size
                      andData:(NSArray *)data
                  andGameType:(GameType)gameType
          andHighlightedIndex:(NSInteger)index;

- (NSString *)listStringFromScore:(NSNumber *)score
                      forGameType:(GameType)gameType;

@end