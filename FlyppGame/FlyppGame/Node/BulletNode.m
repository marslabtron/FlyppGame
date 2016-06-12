//
//  BulletNode.m
//  FlyppGame
//
//  Created by dingjianjaja on 16/6/2.
//  Copyright © 2016年 dingjian. All rights reserved.
//

#import "BulletNode.h"
#import "PhysicsCategory.h"
#import "Geometry.h"

@interface BulletNode ()

@property (nonatomic, assign)CGVector thrust;

@end

@implementation BulletNode

- (instancetype)init{
    if (self = [super init]) {
        SKLabelNode *dot = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        dot.fontColor = [SKColor blackColor];
        dot.fontSize = 40;
        dot.text = @".";
        [self addChild:dot];
        
        SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:1];
        body.dynamic = YES;
        body.categoryBitMask = PlayerMissileCategory;
        body.contactTestBitMask = EnemyCategory;
        body.collisionBitMask = EnemyCategory;
        body.mass = 0.01;
        
        self.physicsBody = body;
        self.name = [NSString stringWithFormat:@"Bullet %p",self];
    }
    return self;
}

+ (instancetype)bulletFrom:(CGPoint)start toward:(CGPoint)destination{
    BulletNode *bullet = [[self alloc] init];
    bullet.position = start;
    
    CGVector movement = VectorBetweenpoints(start,destination);
    CGFloat magnitude = VectorLength(movement);
    if (magnitude == 0.0f) {
        return nil;
    }
    
    CGVector scaledMovement = VectorMultiply(movement,1/magnitude);
    
    CGFloat thrustMagnitude = 100.0;
    bullet.thrust = VectorMultiply(scaledMovement,thrustMagnitude);
    
    [bullet runAction:[SKAction playSoundFileNamed:@"shoot.wav" waitForCompletion:NO]];
    
    return bullet;
}

- (void)applyRecurringForce{
    [self.physicsBody applyForce:self.thrust];
}


@end
