//
//  TSBalloon.m
//  takkestar
//
//  Created by muratamuu on 2014/04/27.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "TSBalloon.h"
#import "TSShooter.h"
#import "TSCommonDefine.h"

static dispatch_once_t onceToken;
static SKTexture *textureImage;
static float sceneWidth, sceneHeight;
static float leftEnd, rightEnd, topEnd, bottomEnd;

@implementation TSBalloon {
    int row;
}

+(void)opening:(SKScene *)scene
{
    // シングルトン処理
    dispatch_once(&onceToken, ^{
        // テクスチャイメージのロード
        textureImage = [SKTexture textureWithImageNamed:@"balloon"];
        // シーンの端を保存
        sceneWidth = scene.size.width;
        sceneHeight = scene.size.height;
        // 風船の存在領域を決定
        leftEnd = 0;
        rightEnd = scene.size.width;
        topEnd = scene.size.height;
        bottomEnd = scene.size.height / 3;
    });
}

+ (void)createWithScene:(SKScene *)scene
{
    // 風船オブジェクトをシーンに追加
    [scene addChild:[[TSBalloon alloc] initBalloon]];
}

- (id)initBalloon
{
    NSArray *textureArray = [self getBalloonTexture];
    
    if (self = [super initWithTexture:[textureArray objectAtIndex:0]]) {

        // 風船アニメーションアクション設定
        [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:textureArray timePerFrame:0.2]]];

        // ランダムに位置を設定 (yは画面下1/3より上にくるように)
        float x = floatRandom() * sceneWidth;
        float y = floatRandom() * sceneHeight;
        if (y < bottomEnd) y += bottomEnd;
        self.position = CGPointMake(x, y);
        
        // 速度
        const float speed = 30.0f;
        // 角度 (初期値90°: 画面上方向)
        __block float angle = M_PI_2;
        // 角速度
        __block float angleRate = floatRandom() * M_PI * 2 - M_PI;
        // フレームレート計算用
        __block float prevTime = 0;
        
        // 移動アクション設定
        [self runAction:[SKAction repeatActionForever:[SKAction customActionWithDuration:10 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
            
            if (floatRandom() < 0.1f) {
                // 10%の確率で角度を変える
                angleRate = floatRandom() * M_PI * 2 - M_PI;
            }
            // フレームレートの経過時間を計算する
            float frameTime = elapsedTime - prevTime;
            prevTime = elapsedTime;
            if (frameTime < 0) frameTime = 0;
            
            // 角度を設定
            angle += angleRate * frameTime;
            
            // 風船が画面下に落ちないように0 < angle < M_PI
            if (angle > M_PI) angle = M_PI;
            if (angle < 0) angle = 0;
            
            // 移動量計算
            float dx = cos(angle) * speed * frameTime;
            float dy = sin(angle) * speed * frameTime;
            
            // 風船移動
            [self moveToX:dx AndY:dy];
        }]]];
        
        // 剛体設定
        SKPhysicsBody *pbody = [SKPhysicsBody bodyWithCircleOfRadius:15]; // or 10
        pbody.categoryBitMask = PHYSICS_CATEGORY_BALLOON;
        pbody.affectedByGravity = NO;
        self.physicsBody = pbody;
    }

    return self;
}

- (void)moveToX:(CGFloat)dx AndY:(CGFloat)dy
{
    CGFloat x = self.position.x + dx;
    CGFloat y = self.position.y + dy;
    
    // 左右は繋がっている
    if (x < leftEnd) x = rightEnd;
    if (x > rightEnd) x = leftEnd;
    if (y < bottomEnd) y = bottomEnd;
    if (y > topEnd) {
        // 画面上部から外れたら消して新しく作る
        [TSBalloon createWithScene:self.scene];
        [self removeFromParent];
    }
    self.position = CGPointMake(x, y);
}

- (NSArray *)getBalloonTexture
{
    
    NSMutableArray *texs = @[].mutableCopy;
    CGFloat x, y, w, h;
    
    row = arc4random() % 10 + 2;
    
    for (int col = 0; col < 3; col++) {
        x = col * 32 / textureImage.size.width;
        y = row * 32 / textureImage.size.height;
        w = 32 / textureImage.size.width;
        h = 32 / textureImage.size.height;
        [texs addObject:[SKTexture textureWithRect:CGRectMake(x, y, w, h) inTexture:textureImage]];
    }
    return texs;
}

- (void)explosion
{
    [self removeAllActions];
    self.physicsBody = nil;
    
    NSMutableArray *texs = @[].mutableCopy;
    CGFloat x, y, w, h;
    
    for (int col = 3; col < 6; col++) {
        x = col * 32 / textureImage.size.width;
        y = row * 32 / textureImage.size.height;
        w = 32 / textureImage.size.width;
        h = 32 / textureImage.size.height;
        [texs addObject:[SKTexture textureWithRect:CGRectMake(x, y, w, h) inTexture:textureImage]];
    }
    
    // 風船破裂アニメーションアクション設定
    [self runAction:[SKAction animateWithTextures:texs timePerFrame:0.2] completion:^{
        [TSBalloon createWithScene:self.scene];
        [self removeFromParent];
    }];
    // スター発射
    [TSShooter randomShotOnPosition:self.position];
}

@end
