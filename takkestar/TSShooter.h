//
//  TSShooter.h
//  takkestar
//
//  Created by muratamuu on 2014/04/27.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TSShooter : SKNode

// 初期化
+ (void)opening:(SKScene *)scene;

// ランダムショット
+ (void)randomShotOnPosition:(CGPoint)position;

@end
