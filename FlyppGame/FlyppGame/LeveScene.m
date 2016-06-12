//
//  GameScene.m
//  FlyppGame
//
//  Created by dingjianjaja on 16/6/1.
//  Copyright (c) 2016年 dingjian. All rights reserved.
//

#import "LeveScene.h"
#import "PlayerNode.h"
#import "EnemyNode.h"
#import "BulletNode.h"
#import "SKNode+Extra.h"
#import "Geometry.h"
#import "GameOverScene.h"
#define ARC4RANDOM_MAX 0x100000000

@interface LeveScene ()<SKPhysicsContactDelegate>
@property (nonatomic, retain)PlayerNode *playerNode;
@property (nonatomic, retain)SKNode *enemies;         // 敌人
@property (nonatomic, retain)SKNode *playerBullets;   // 子弹
@end

@implementation LeveScene


+ (instancetype)sceneWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber{
    return [[self alloc] initWithSize:size levelNumber:levelNumber];
}



- (instancetype)initWithSize:(CGSize)size{
    return [self initWithSize:size levelNumber:1];
}


- (instancetype)initWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber{
    if (self = [super initWithSize:size]) {
        _levelNumber = levelNumber;
        _playerLives = 5;
        
        self.backgroundColor = [SKColor whiteColor];
        
        SKLabelNode *lives = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        lives.fontSize = 16;
        lives.fontColor = [SKColor blackColor];
        lives.name = @"LivesLabel";
        lives.text = [NSString stringWithFormat:@"Lives: %lu",(unsigned long)_playerLives];
        lives.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        lives.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        lives.position = CGPointMake(self.frame.size.width, self.frame.size.height);
        [self addChild:lives];
        
        SKLabelNode *level = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        level.fontSize = 16;
        level.fontColor = [SKColor blackColor];
        level.name = @"LevelLabel1";
        level.text = [NSString stringWithFormat:@"Levels: %lu",(unsigned long)_levelNumber];
        level.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        level.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        level.position = CGPointMake(0, self.frame.size.height);
        [self addChild:level];
        
        //加入玩家
        _playerNode = [PlayerNode node];
        _playerNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame)*0.1);
        [self addChild:_playerNode];
        
        //加入敌人
        _enemies = [SKNode node];
        [self addChild:_enemies];
        [self spawnEnemises];
        
        //加入子弹
        _playerBullets = [SKNode node];
        [self addChild:_playerBullets];
        
        //设置物理代理
        self.physicsWorld.gravity = CGVectorMake(0, -1);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (location.y < CGRectGetHeight(self.frame)*0.2) {
            CGPoint target = CGPointMake(location.x, self.playerNode.position.y);
            [self.playerNode moveToward:target];
        }else{
            BulletNode *bullet = [BulletNode bulletFrom:self.playerNode.position toward:location];
            if (bullet) {
                [self.playerBullets addChild:bullet];
            }
        }
    }
}

- (void)spawnEnemises{
    NSUInteger count = log(self.levelNumber) + self.levelNumber;
    for (NSUInteger i = 0; i < count; i++) {
        EnemyNode *enemy = [EnemyNode node];
        CGSize size = self.frame.size;
        CGFloat x = (size.width * 0.8 * arc4random() / ARC4RANDOM_MAX) + (size.width * 0.1);
        CGFloat y = (size.height * 0.5 * arc4random() / ARC4RANDOM_MAX) + (size.height * 0.5);
        enemy.position = CGPointMake(x, y);
        [self.enemies addChild:enemy];
    }
}

//渲染每帧动画都会调用
- (void)update:(NSTimeInterval)currentTime{
    if (self.finished) return;
    
    [self upadateBullets];
    
    [self updateEnemies];
    
    if (![self checkForGameOver]) {
        [self checkForNextLevel];
    }
    
}


//添加子弹
- (void)upadateBullets{
    NSMutableArray *bulletsToRemove = [NSMutableArray array];
    for (BulletNode *bullet in self.playerBullets.children) {
        //清楚所有移动到屏幕外面的导弹
        if (!CGRectContainsPoint(self.frame, bullet.position)) {
            //标记将予以删除的导弹
            [bulletsToRemove addObject:bullet];
            continue;
        }
        //将推力作用于剩下的导弹
        [bullet applyRecurringForce];
    }
    [self.playerBullets removeChildrenInArray:bulletsToRemove];
}

//添加敌人
- (void)updateEnemies{
    NSMutableArray *enemiesToRemove = [NSMutableArray array];
    for (SKNode *node in self.enemies.children) {
        //清楚所有移动到屏幕外面的敌人
        if (!CGRectContainsPoint(self.frame, node.position)) {
            //标记将予以删除的敌人
            [enemiesToRemove addObject:node];
            continue;
        }
        
    }
    if (enemiesToRemove.count > 0) {
        [self.enemies removeChildrenInArray:enemiesToRemove];
    }
}

- (void)checkForNextLevel{
    if (self.enemies.children.count == 0) {
        [self goToNextLevel];
    }
}

- (void)goToNextLevel{
    self.finished = YES;
    
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    label.text = @"Level Complete!";
    label.fontColor = [SKColor blueColor];
    label.fontSize = 32;
    label.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    [self addChild:label];
    
    LeveScene *nextLevel = [[LeveScene alloc] initWithSize:self.frame.size levelNumber:self.levelNumber + 1];
    nextLevel.playerLives = self.playerLives;
    [self.view presentScene:nextLevel transition:[SKTransition flipHorizontalWithDuration:1.0]];
}


#pragma mark Delegate
- (void)didBeginContact:(SKPhysicsContact *)contact{
    if (contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask) {
        // 两种物理形体都属于同一物理类别
        SKNode *nodeA = contact.bodyA.node;
        SKNode *nodeB = contact.bodyB.node;
        
        //这些节点能干什么
        [nodeA friendlyBumpFrom:nodeB];
        [nodeB friendlyBumpFrom:nodeA];
    }else{
        SKNode *attacker = nil;
        SKNode *attackee = nil;
        
        if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
            //body A 正在攻击 B
            attacker = contact.bodyA.node;
            attackee = contact.bodyB.node;
        }else{
            //body B 正在攻击 A
            attackee = contact.bodyA.node;
            attacker = contact.bodyB.node;
        }
        if ([attackee isKindOfClass:[PlayerNode class]]) {
            self.playerLives--;
        }
        //应该怎么处理攻击者和受攻击者的逻辑机制
        if (attacker) {
            [attackee receiveAttacker:attacker contact:contact];
            [self.playerBullets removeChildrenInArray:@[attacker]];
            [self.enemies removeChildrenInArray:@[attacker]];
        }
    }
}



- (void)setPlayerLives:(NSUInteger)playerLives{
    _playerLives = playerLives;
    SKLabelNode *lives = (id)[self childNodeWithName:@"LivesLabel"];
    lives.text = [NSString stringWithFormat:@"Lives: %lu",(unsigned long)_playerLives];
}

- (void)triggerGameOver{
    self.finished = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EnemyExplosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.numParticlesToEmit = 200;
    explosion.position = _playerNode.position;
    [self.scene addChild:explosion];
    [_playerNode removeFromParent];
    
    SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:1.0];
    SKScene *gameOver = [[GameOverScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:gameOver transition:transition];
    
    [self runAction:[SKAction playSoundFileNamed:@"gameOver.wav" waitForCompletion:NO]];
}

- (BOOL)checkForGameOver{
    if (self.playerLives == 0) {
        [self triggerGameOver];
        return YES;
    }
    return NO;
}

@end
