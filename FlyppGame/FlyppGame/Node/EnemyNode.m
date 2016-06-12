//
//  EnemyNode.m
//  FlyppGame
//
//  Created by dingjianjaja on 16/6/2.
//  Copyright © 2016年 dingjian. All rights reserved.
//

#import "EnemyNode.h"
#import "PhysicsCategory.h"
#import "Geometry.h"
@implementation EnemyNode

- (instancetype)init{
    if (self = [super init]) {
        self.name = [NSString stringWithFormat:@"Enemy %p",self];
        [self initNodeGraph];
        [self initPhysicsBody];
    }
    return self;
}


- (void)initNodeGraph{
    SKLabelNode *topRow = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    topRow.fontColor = [SKColor brownColor];
    topRow.fontSize = 20;
    topRow.text = @"x x";
    topRow.position = CGPointMake(0, 15);
    [self addChild:topRow];
    
    SKLabelNode *middleRow = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    middleRow.fontColor = [SKColor brownColor];
    middleRow.fontSize = 20;
    middleRow.text = @"x";
    [self addChild:middleRow];
    
    SKLabelNode *bottomRow = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    bottomRow.fontColor = [SKColor brownColor];
    bottomRow.fontSize = 20;
    bottomRow.text = @"x x";
    bottomRow.position = CGPointMake(0, -15);
    [self addChild:bottomRow];
}

- (void)initPhysicsBody{
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 40)];
    body.affectedByGravity = NO;                                  //是否受到重力
    body.categoryBitMask = EnemyCategory;                         //碰撞类型
    body.contactTestBitMask = PlayerCategory | EnemyCategory;     //碰撞类型
    body.mass = 0.2;                                              //重量
    body.angularDamping = 0.0f;                                   //角速度阻力
    body.linearDamping = 0.0f;                                    //线速度阻力
    self.physicsBody = body;
}

//重写父类（分类）方法
- (void)friendlyBumpFrom:(SKNode *)node{
    self.physicsBody.affectedByGravity = YES;
}

- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact{
    self.physicsBody.affectedByGravity = YES;
    CGVector force = VectorMultiply(attacker.physicsBody.velocity,contact.collisionImpulse);
    CGPoint myContact = [self.scene convertPoint:contact.contactPoint toNode:self];
    [self.physicsBody applyForce:force atPoint:myContact];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MissileExplosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.numParticlesToEmit = 20;
    explosion.position = contact.contactPoint;
    
    [self runAction:[SKAction playSoundFileNamed:@"enemyHit.wav" waitForCompletion:NO]];
    
    [self.scene addChild:explosion];
}



@end
