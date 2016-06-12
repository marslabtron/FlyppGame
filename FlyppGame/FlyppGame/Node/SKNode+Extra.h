//
//  SKNode+Extra.h
//  FlyppGame
//
//  Created by dingjianjaja on 16/6/2.
//  Copyright © 2016年 dingjian. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (Extra)
- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact;
- (void)friendlyBumpFrom:(SKNode *)node;
@end
