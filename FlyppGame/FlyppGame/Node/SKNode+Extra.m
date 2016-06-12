//
//  SKNode+Extra.m
//  FlyppGame
//
//  Created by dingjianjaja on 16/6/2.
//  Copyright © 2016年 dingjian. All rights reserved.
//

#import "SKNode+Extra.h"

@implementation SKNode (Extra)
- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact{
    //默认的实现不执行任何操作
}

- (void)friendlyBumpFrom:(SKNode *)node{
    //默认的实现不执行任何操作
}
@end
