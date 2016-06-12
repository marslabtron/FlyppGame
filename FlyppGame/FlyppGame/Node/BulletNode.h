//
//  BulletNode.h
//  FlyppGame
//
//  Created by dingjianjaja on 16/6/2.
//  Copyright © 2016年 dingjian. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BulletNode : SKNode
+ (instancetype)bulletFrom:(CGPoint)start toward:(CGPoint)destination;
- (void)applyRecurringForce;
@end
