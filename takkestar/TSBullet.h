//
//  TSBullet.h
//  takkestar
//
//  Created by muratamuu on 2014/04/29.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TSBullet : SKSpriteNode

+ (void)createWithScene:(SKScene *)scene at:(CGPoint)position;

+(void)opening;

@end
