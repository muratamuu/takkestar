//
//  TSPatternShooter.h
//  takkestar
//
//  Created by muratamuu on 2014/04/27.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TSPatternShooter : SKNode

// ランダムにパターンを選択して開始するメソッド
+ (void)startRandomOnScene:(SKScene *)scene position:(CGPoint)position;

@end
