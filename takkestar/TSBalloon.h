//
//  TSBalloon.h
//  takkestar
//
//  Created by muratamuu on 2014/04/27.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TSBalloon : SKSpriteNode
+ (void)createWithScene:(SKScene *)scene;
- (void)explosion;
+(void)opening:(SKScene *)scene;
@end
