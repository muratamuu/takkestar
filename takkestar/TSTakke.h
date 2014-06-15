//
//  TSTakke.h
//  takkestar
//
//  Created by muratamuu on 2014/04/30.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TSTakke : SKSpriteNode

+ (id)createWithScene:(SKScene *)scene;
- (void)changeTexture:(int)i;

@end
