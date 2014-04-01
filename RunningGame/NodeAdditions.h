//
//  NodeAdditions.h
//  RunningGame
//
//  Created by Mick on 3/30/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (NodeAdditions)

- (BOOL)shouldPlaySounds;

- (SKAction *)_winSoundAction;
- (SKAction *)_loseSoundAction;
- (SKAction *)_beepSoundAction;
- (SKAction *)_tapSoundAction;


@end
