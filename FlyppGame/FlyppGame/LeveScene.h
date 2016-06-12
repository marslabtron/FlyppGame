//
//  GameScene.h
//  FlyppGame
//

//  Copyright (c) 2016年 dingjian. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LeveScene : SKScene
@property (nonatomic, assign) NSUInteger levelNumber;
@property (nonatomic, assign) NSUInteger playerLives;
@property (nonatomic, assign) BOOL finished;

+ (instancetype)sceneWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber;
- (instancetype)initWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber;


@end
