//
//  PlayerNode.m
//  FlyppGame
//
//  Created by dingjianjaja on 16/6/1.
//  Copyright © 2016年 dingjian. All rights reserved.
//

#import "PlayerNode.h"
#import "Geometry.h"
#import "PhysicsCategory.h"
#import "SKNode+Extra.h"

@implementation PlayerNode
- (instancetype)init{
    if (self = [super init]) {
        self.name = [NSString stringWithFormat:@"Player %p",self];
        [self initNodeGraph];
        [self initPhysicsBody];
    }
    return self;
}

- (void)initNodeGraph{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    label.fontColor = [SKColor darkGrayColor];
    label.fontSize = 40;
    label.text = @"V";
    label.zRotation = M_PI;
    label.name = @"label";
    
    [self addChild:label];
}

- (CGFloat)moveToward:(CGPoint)location{
    [self removeActionForKey:@"movement"];
    [self removeActionForKey:@"wobbling"];//摆动
    
    CGFloat distance = PointDistance(self.position,location);
    CGFloat pixels = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 2.0 * distance / pixels;
    
    [self runAction:[SKAction moveTo:location duration:duration] withKey:@"movement"];
    
    CGFloat wobbleTime = 0.3;
    CGFloat halfwobbleTime = wobbleTime * 0.5;
    SKAction *wobbling = [SKAction sequence:@[[SKAction scaleXTo:0.2
                                                        duration:halfwobbleTime],
                                              [SKAction scaleXTo:1.0
                                                        duration:halfwobbleTime]
                                              ]];
    NSUInteger wobbleCount = duration / wobbleTime;
    
    [self runAction:[SKAction repeatAction:wobbling count:wobbleCount] withKey:@"wobbling"];
    
    return duration;
}

- (void)initPhysicsBody{
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    body.affectedByGravity = NO;                                  //是否受到重力
    body.categoryBitMask = PlayerCategory;                        //它标记了物体属于那一类物体，默认值为0xffffffff
    body.contactTestBitMask = EnemyCategory;                      //它标记了哪些物体会和其发生碰撞后产生一些影响
    body.collisionBitMask = 0;                                    //它标记了哪些物体会和其发生碰撞后产生一些影响
    body.mass = 0.2;                                              //重量
    self.physicsBody = body;
}


- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EnemyExplosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.numParticlesToEmit = 50;
    explosion.position = contact.contactPoint;
    
    [self runAction:[SKAction playSoundFileNamed:@"playerHit.wav" waitForCompletion:NO]];
    
    [self.scene addChild:explosion];
}


@end
