//
//  TSBullet.m
//  takkestar
//
//  Created by muratamuu on 2014/04/29.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "TSBullet.h"
#import "TSCommonDefine.h"

static dispatch_once_t onceToken;
static SKTexture *texture;

@implementation TSBullet

+(void)opening
{
    // シングルトン処理
    dispatch_once(&onceToken, ^{
        // テクスチャイメージのロード
        texture = [SKTexture textureWithImageNamed:@"sakura.gif"];
    });
}

+ (void)createWithScene:(SKScene *)scene at:(CGPoint)position
{
    [scene addChild:[[TSBullet alloc] initWithScene:scene at:position]];
}

- (id)initWithScene:(SKScene *)scene at:(CGPoint)position
{
    if (self = [super initWithTexture:texture]) {
        self.position = position;
        self.xScale = (float)1/12;
        self.yScale = (float)1/12;

        SKPhysicsBody *pbody = [SKPhysicsBody bodyWithCircleOfRadius:5];
        pbody.categoryBitMask = PHYSICS_CATEGORY_BULLET;
        pbody.contactTestBitMask = PHYSICS_CATEGORY_BALLOON;
        self.physicsBody = pbody;
        
        [self runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI * 2 duration:2]]];
    }
    return self;
}

@end
