//
//  TSStar.h
//  takkestar
//
//  Created by muratamuu on 2014/04/27.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TSStar : SKSpriteNode

// 初期化
+(void)opening:(SKScene *)scene;

// コンストラクタ
+ (void)createAtPosition:(CGPoint)position speed:(float)speed speedRate:(float)speedRate angle:(float)angle angleRate:(float)angleRate lifeTime:(float)lifeTime;

+ (void)setlevel:(int)l;

@end
