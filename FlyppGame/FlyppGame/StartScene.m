//
//  StartScene.m
//  FlyppGame
//
//  Created by dingjianjaja on 16/6/2.
//  Copyright © 2016年 dingjian. All rights reserved.
//

#import "StartScene.h"
#import "LeveScene.h"
@implementation StartScene
- (instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor greenColor];
        
        SKLabelNode *topLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        topLabel.text = @"FlyppGame";
        topLabel.fontColor = [SKColor blackColor];
        topLabel.fontSize = 40;
        topLabel.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.7);
        [self addChild:topLabel];
        
        SKLabelNode *bottomLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        bottomLabel.text = @"Touch anywhere to start";
        bottomLabel.fontColor = [SKColor blackColor];
        bottomLabel.fontSize = 20;
        bottomLabel.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.3);
        [self addChild:bottomLabel];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SKTransition *transition = [SKTransition doorwayWithDuration:1.0];
    SKScene *game = [[LeveScene alloc]initWithSize:self.frame.size];
    [self.view presentScene:game transition:transition];
    [self runAction:[SKAction playSoundFileNamed:@"gameStart.wav" waitForCompletion:NO]];
}


@end
