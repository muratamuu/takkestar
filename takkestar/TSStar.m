//
//  TSStar.m
//  takkestar
//
//  Created by muratamuu on 2014/04/27.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "TSStar.h"
#import "TSMyScene.h"
#import "TSCommonDefine.h"

static dispatch_once_t onceToken;
static NSMutableArray *whiteTextures;
static NSMutableArray *pinkTextures;
static NSMutableArray *yellowTextures;
static NSMutableArray *redTextures;
static float sceneWidth, sceneHeight;
static float sinkAngle[4];
static SKScene *sceneInstance;
static float holesize[4];
static float moveSpeedRateUpMax[4] = {10, 15, 20, 25};
static int level = 0;

@implementation TSStar {
    float moveSpeed;     // 速度
    float moveSpeedRate; // 加速度
    float moveAngle;     // 角度
    float moveAngleRate; // 角速度
    int   maxLifeTime;   // 最大生存時間
    int   textureIdx;    // テクスチャ番号
    BOOL  inBlackHole;   // ブラックホール内かどうか
    int   score;         // 得点
}

// 初期化
+(void)opening:(SKScene *)scene
{
    // シングルトン処理
    dispatch_once(&onceToken, ^{
        // テクスチャイメージのロード
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"star"];
        whiteTextures = @[].mutableCopy;
        [whiteTextures addObject:[atlas textureNamed:@"img01w"]];
        [whiteTextures addObject:[atlas textureNamed:@"img02w"]];
        [whiteTextures addObject:[atlas textureNamed:@"img03w"]];
        [whiteTextures addObject:[atlas textureNamed:@"img04w"]];
        //[whiteTextures addObject:[atlas textureNamed:@"img05w"]];
        [whiteTextures addObject:[atlas textureNamed:@"img06w"]];
        [whiteTextures addObject:[atlas textureNamed:@"img07w"]];
        [whiteTextures addObject:[atlas textureNamed:@"img08w"]];
        [whiteTextures addObject:[atlas textureNamed:@"img09w"]];
        [whiteTextures addObject:[atlas textureNamed:@"img10w"]];
        //[whiteTextures addObject:[atlas textureNamed:@"img11w"]];
        [whiteTextures addObject:[atlas textureNamed:@"img12w"]];
        
        yellowTextures = @[].mutableCopy;
        [yellowTextures addObject:[atlas textureNamed:@"img01y"]];
        [yellowTextures addObject:[atlas textureNamed:@"img02y"]];
        [yellowTextures addObject:[atlas textureNamed:@"img03y"]];
        [yellowTextures addObject:[atlas textureNamed:@"img04y"]];
        //[yellowTextures addObject:[atlas textureNamed:@"img05y"]];
        [yellowTextures addObject:[atlas textureNamed:@"img06y"]];
        [yellowTextures addObject:[atlas textureNamed:@"img07y"]];
        [yellowTextures addObject:[atlas textureNamed:@"img08y"]];
        [yellowTextures addObject:[atlas textureNamed:@"img09y"]];
        [yellowTextures addObject:[atlas textureNamed:@"img10y"]];
        //[yellowTextures addObject:[atlas textureNamed:@"img11y"]];
        [yellowTextures addObject:[atlas textureNamed:@"img12y"]];
        
        pinkTextures = @[].mutableCopy;
        [pinkTextures addObject:[atlas textureNamed:@"img01p"]];
        [pinkTextures addObject:[atlas textureNamed:@"img02p"]];
        [pinkTextures addObject:[atlas textureNamed:@"img03p"]];
        [pinkTextures addObject:[atlas textureNamed:@"img04p"]];
        //[pinkTextures addObject:[atlas textureNamed:@"img05p"]];
        [pinkTextures addObject:[atlas textureNamed:@"img06p"]];
        [pinkTextures addObject:[atlas textureNamed:@"img07p"]];
        [pinkTextures addObject:[atlas textureNamed:@"img08p"]];
        [pinkTextures addObject:[atlas textureNamed:@"img09p"]];
        [pinkTextures addObject:[atlas textureNamed:@"img10p"]];
        //[pinkTextures addObject:[atlas textureNamed:@"img11p"]];
        [pinkTextures addObject:[atlas textureNamed:@"img12p"]];
        
        redTextures = @[].mutableCopy;
        [redTextures addObject:[atlas textureNamed:@"img01r"]];
        [redTextures addObject:[atlas textureNamed:@"img02r"]];
        [redTextures addObject:[atlas textureNamed:@"img03r"]];
        [redTextures addObject:[atlas textureNamed:@"img04r"]];
        //[redTextures addObject:[atlas textureNamed:@"img05r"]];
        [redTextures addObject:[atlas textureNamed:@"img06r"]];
        [redTextures addObject:[atlas textureNamed:@"img07r"]];
        [redTextures addObject:[atlas textureNamed:@"img08r"]];
        [redTextures addObject:[atlas textureNamed:@"img09r"]];
        [redTextures addObject:[atlas textureNamed:@"img10r"]];
        //[redTextures addObject:[atlas textureNamed:@"img11r"]];
        [redTextures addObject:[atlas textureNamed:@"img12r"]];
        
        // シーンの端を保存
        sceneWidth = scene.size.width;
        sceneHeight = scene.size.height;
        
        sinkAngle[0] = tanf(4.0f / 180 * M_PI); // 吸い込まれる角度
        sinkAngle[1] = tanf(4.0f / 180 * M_PI); // 吸い込まれる角度
        sinkAngle[2] = tanf(4.0f / 180 * M_PI); // 吸い込まれる角度
        sinkAngle[3] = tanf(4.0f / 180 * M_PI); // 吸い込まれる角度
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            holesize[0] = 70;
            holesize[1] = 80;
            holesize[2] = 90;
            holesize[3] = 100;
        } else {
            holesize[0] = 150;
            holesize[1] = 170;
            holesize[2] = 200;
            holesize[3] = 210;
        }
        
        sceneInstance = scene;
        
    });
}

+ (void)setlevel:(int)l;
{
    level = l;
}

// コンストラクタ
+ (void)createAtPosition:(CGPoint)position speed:(float)speed speedRate:(float)speedRate angle:(float)angle angleRate:(float)angleRate lifeTime:(float)lifeTime;
{
    // スターオブジェクトをシーンに追加
    TSStar *star = [[TSStar alloc] initStar];
    [sceneInstance addChild:star];
    [star startMoveFromPosition:position speed:speed speedRate:speedRate angle:angle angleRate:angleRate lifeTime:lifeTime];
}

// コンストラクタ
- (id)initStar
{
    textureIdx = arc4random() % whiteTextures.count;
    if (self = [super initWithTexture:[whiteTextures objectAtIndex:textureIdx]]) {
        //float scale = 1.0f / (floatRandom() * 2.5f + 3.3f); // 1/30.0 ~ 1/50.0
        //float scale = 1.0f / (floatRandom() * 0.0f + 16.0f); // 1/30.0 ~ 1/50.0
        float scale = 0.06f;
        self.xScale = scale;
        self.yScale = scale;
        self.zPosition = 0.2;
        score = 10;
        inBlackHole = NO;
    }
    return self;
}

// 移動開始
- (void)startMoveFromPosition:(CGPoint)position speed:(float)speed speedRate:(float)speedRate angle:(float)angle angleRate:(float)angleRate lifeTime:(float)lifeTime
{
    self.position = position;
    moveSpeed = speed;
    moveSpeedRate = speedRate;
    moveAngle = angle;
    moveAngleRate = angleRate;
    maxLifeTime = lifeTime;
    [self setMoveAction];
}

// 移動アクション設定
- (void)setMoveAction
{
    __block float prevTime = 0;
    __block float lifeTime = 0;
    
    SKAction *action = [SKAction customActionWithDuration:10 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        // フレームレートの経過時間を計算する
        float frameTime = elapsedTime - prevTime;
        prevTime = elapsedTime;
        if (frameTime < 0) frameTime = 0;
        lifeTime += frameTime;
        if (maxLifeTime > 0 && lifeTime > maxLifeTime) {
            [self removeFromParent];
            return;
        }
        // 経過時間分を移動させる
        [self move:frameTime];
    }];
    [self runAction:[SKAction repeatActionForever:action]];
}

// フレームレートで呼ばれる移動処理
- (void)move:(float)frameTime
{
    float x = self.position.x;
    float y = self.position.y;
    float dx = (((TSMyScene *)self.scene).takke).position.x - x;
    float dy = (((TSMyScene *)self.scene).takke).position.y - y;
    
    if (x < 0 || x > sceneWidth || y < 0 || y > sceneHeight) {
        // 画面から外れたら削除
        [self removeAllActions];
        [self removeFromParent];
        return;
    }
    
    if (fabsf(dx) < 20 && fabsf(dy) < 20) {
        // ブラックホールに吸い込まれた
        [(TSMyScene *)self.scene scoreUp:score];
        [self removeAllActions];
        [self removeFromParent];
        return;
    }

    // 速度、角度を決める
    moveSpeed = moveSpeed + moveSpeedRate * frameTime;
    moveAngle = moveAngle + moveAngleRate * frameTime;
    
    if (fabsf(dx) < holesize[level] && fabsf(dy) < holesize[level]) {
        
        // ブラックホール圏内
        if (inBlackHole == NO) {
            if (level >= 3) {
                [self setTexture:[redTextures objectAtIndex:textureIdx]];
                score = 50;
            } else {
                [self setTexture:[yellowTextures objectAtIndex:textureIdx]];
            }
            inBlackHole = YES;
        }

        moveAngleRate = 0;
        
        if (moveSpeedRate < moveSpeedRateUpMax[level]) moveSpeedRate += 1;
        
        moveAngle = fmod(moveAngle, M_PI * 2);
        if (moveAngle < 0) moveAngle += M_PI * 2;
        
        float angle = atan2f(dy, dx);
        if (angle < 0) angle += M_PI * 2;
        
        float angleDiff = angle - moveAngle;
        
        if (angleDiff < -M_PI) {
            angle += M_PI * 2;
            angleDiff = angle - moveAngle;
        }
        
        if (fabs(angleDiff) < sinkAngle[level]) {
            moveAngle = angle;
        } else {
            moveAngle += (angleDiff > 0) ? sinkAngle[level] : -sinkAngle[level];
        }
    } else {
        if (inBlackHole == YES) {
            [self setTexture:[pinkTextures objectAtIndex:textureIdx]];
            score = 30; // スコアが上がる仕掛け
            inBlackHole = NO;
        }
    }
    
    // 位置を決める
    x += cos(moveAngle) * moveSpeed * frameTime;
    y += sin(moveAngle) * moveSpeed * frameTime;
    self.position = CGPointMake(x, y);
}

@end
