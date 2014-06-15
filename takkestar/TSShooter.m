//
//  TSShooter.m
//  takkestar
//
//  Created by muratamuu on 2014/04/27.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "TSShooter.h"
#import "TSStar.h"
#import "TSCommonDefine.h"

static dispatch_once_t onceToken;
static float sceneWidth, sceneHeight;
static SKScene *sceneInstance;

@implementation TSShooter {
    float moveSpeed;        // 速度
    float moveSpeedRate;    // 加速度
    float moveAngle;        // 角度
    float moveAngleRate;    // 角速度
    float starSpeed;        // 星の速度
    float starSpeedRate;    // 星の加速度
    float starAngle;        // 星の角度
    float starAngleRate;    // 星の角速度
    float starLifeTime;     // 星の生存時間
    int   shotWay;          // 星の同時発射数
    float shotWayRange;     // 星の発射角度範囲
    int   shotCount;        // 星の発射数
    float shotInterval;     // 星の間隔
}

+ (void)opening:(SKScene *)scene
{
    // シングルトン処理
    dispatch_once(&onceToken, ^{
        // シーンの端を保存
        sceneWidth = scene.size.width;
        sceneHeight = scene.size.height;
        sceneInstance = scene;
    });
}

+ (void)randomShotOnPosition:(CGPoint)position
{
    // シューターの移動設定
    float moveSpeed       = floatRandom() * 90 + 10;   // 10 ~ 99
    float moveSpeedRate   = floatRandom() * 7 - 2.0;   // -2.0 ~ 5.0
    float moveAngle       = floatRandom() * M_PI * 2;  // 0 ~ 6.28 (0 ~ 360°)
    float moveAngleRate   = floatRandom() * 6 - 3.0;   // -3.0 ~ 3.0
    // 星の移動設定
    float starSpeed       = floatRandom() * 80 + 20;   // 20 ~ 99
    float starSpeedRate   = floatRandom() * 6 - 3.0;   // -2.0 ~ 5.0
    float starAngle       = floatRandom() * M_PI * 2;  // 0 ~ 6.28 (0 ~ 360°)
    float starAngleRate   = floatRandom() * 6 - 3.0;   // -3.0 ~ 3.0
    float starLifeTime    = floatRandom() * 5 + 5;     // 5.0 ~ 10.0
    // 星の発射設定
    int   shotWay         = arc4random() % 8 + 3;      // 3 ~ 10
    float shotWayRange    = floatRandom() * M_PI * 11 / 6 + M_PI / 6; // 0.523 ~ 5.76 + 0.523 (30 ~ 360°)
    int   shotCount       = arc4random() % 150 + 100;  // 100 ~ 199;
    float shotInterval    = floatRandom() * 0.1 + 0.1; // 0.1 ~ 0.2
    
    switch (arc4random() % 6) {
        case 0:
        case 1: {
            // 1/3の確率　1シューター
            TSShooter *shooter = [TSShooter createOnPosition:position];
            [shooter startMoveFromPosition:position speed:moveSpeed speedRate:moveSpeedRate angle:moveAngle angleRate:moveAngleRate];
            [shooter shotWithStarSpeed:starSpeed speedRate:starSpeedRate angle:starAngle angleRate:starAngleRate lifetime:starLifeTime way:shotWay wayRange:shotWayRange count:shotCount interval:shotInterval];
            break;
        }
        case 2: {
            // 1/6の確率　加速度、角速度が異なる2シューター
            shotCount = shotCount / 2;
            TSShooter *shooter1 = [TSShooter createOnPosition:position];
            [shooter1 startMoveFromPosition:position speed:moveSpeed speedRate:moveSpeedRate angle:moveAngle angleRate:moveAngleRate];
            [shooter1 shotWithStarSpeed:starSpeed speedRate:starSpeedRate angle:starAngle angleRate:starAngleRate lifetime:starLifeTime way:shotWay wayRange:shotWayRange count:shotCount interval:shotInterval];
            TSShooter *shooter2 = [TSShooter createOnPosition:position];
            [shooter2 startMoveFromPosition:position speed:moveSpeed speedRate:floatRandom() * 7 - 2.0 angle:moveAngle angleRate:floatRandom() * 6 - 3.0];
            [shooter2 shotWithStarSpeed:starSpeed speedRate:floatRandom() * 6 - 3.0 angle:starAngle angleRate:floatRandom() * 6 - 3.0 lifetime:starLifeTime way:shotWay wayRange:shotWayRange count:shotCount interval:shotInterval];
            break;
        }
        case 3: {
            // 1/6の確率　角速度が対象となる2シューター
            shotCount = shotCount / 2;
            TSShooter *shooter1 = [TSShooter createOnPosition:position];
            [shooter1 startMoveFromPosition:position speed:moveSpeed speedRate:moveSpeedRate angle:moveAngle angleRate:moveAngleRate];
            [shooter1 shotWithStarSpeed:starSpeed speedRate:starSpeedRate angle:starAngle angleRate:starAngleRate lifetime:starLifeTime way:shotWay wayRange:shotWayRange count:shotCount interval:shotInterval];
            TSShooter *shooter2 = [TSShooter createOnPosition:position];
            [shooter2 startMoveFromPosition:position speed:moveSpeed speedRate:moveSpeedRate angle:moveAngle angleRate:-moveAngleRate];
            [shooter2 shotWithStarSpeed:starSpeed speedRate:starSpeedRate angle:starAngle angleRate:starAngleRate lifetime:starLifeTime way:shotWay wayRange:shotWayRange count:shotCount interval:shotInterval];
            break;
        }
        case 4: {
            // 1/6の確率　加速度、角速度が異なる3シューター
            shotCount = shotCount / 3;
            TSShooter *shooter1 = [TSShooter createOnPosition:position];
            [shooter1 startMoveFromPosition:position speed:moveSpeed speedRate:moveSpeedRate angle:moveAngle angleRate:moveAngleRate];
            [shooter1 shotWithStarSpeed:starSpeed speedRate:starSpeedRate angle:starAngle angleRate:starAngleRate lifetime:starLifeTime way:shotWay wayRange:shotWayRange count:shotCount interval:shotInterval];
            TSShooter *shooter2 = [TSShooter createOnPosition:position];
            [shooter2 startMoveFromPosition:position speed:moveSpeed speedRate:floatRandom() * 7 - 2.0 angle:moveAngle angleRate:floatRandom() * 6 - 3.0];
            [shooter2 shotWithStarSpeed:starSpeed speedRate:floatRandom() * 6 - 3.0 angle:starAngle angleRate:floatRandom() * 6 - 3.0 lifetime:starLifeTime way:shotWay wayRange:shotWayRange count:shotCount interval:shotInterval];
            TSShooter *shooter3 = [TSShooter createOnPosition:position];
            [shooter3 startMoveFromPosition:position speed:moveSpeed speedRate:floatRandom() * 7 - 2.0 angle:moveAngle angleRate:floatRandom() * 6 - 3.0];
            [shooter3 shotWithStarSpeed:starSpeed speedRate:floatRandom() * 6 - 3.0 angle:starAngle angleRate:floatRandom() * 6 - 3.0 lifetime:starLifeTime way:shotWay wayRange:shotWayRange count:shotCount interval:shotInterval];
            break;
        }
        case 5: {
            // 1/6の確率　角速度が対象となる3シューター
            shotCount = shotCount / 3;
            TSShooter *shooter1 = [TSShooter createOnPosition:position];
            [shooter1 startMoveFromPosition:position speed:moveSpeed speedRate:moveSpeedRate angle:moveAngle angleRate:moveAngleRate];
            [shooter1 shotWithStarSpeed:starSpeed speedRate:starSpeedRate angle:starAngle angleRate:starAngleRate lifetime:starLifeTime way:shotWay wayRange:shotWayRange count:shotCount interval:shotInterval];
            TSShooter *shooter2 = [TSShooter createOnPosition:position];
            [shooter2 startMoveFromPosition:position speed:moveSpeed speedRate:moveSpeedRate angle:moveAngle angleRate:-moveAngleRate];
            [shooter2 shotWithStarSpeed:starSpeed speedRate:starSpeedRate angle:starAngle angleRate:starAngleRate lifetime:starLifeTime way:shotWay wayRange:shotWayRange count:shotCount interval:shotInterval];
            TSShooter *shooter3 = [TSShooter createOnPosition:position];
            [shooter3 startMoveFromPosition:position speed:moveSpeed speedRate:moveSpeedRate angle:moveAngle angleRate:0];
            [shooter3 shotWithStarSpeed:starSpeed speedRate:starSpeedRate angle:starAngle angleRate:starAngleRate lifetime:starLifeTime way:shotWay wayRange:shotWayRange count:shotCount interval:shotInterval];
            break;
        }
    }
}

// コンストラクタ
+ (id)createOnPosition:(CGPoint)position
{
    TSShooter *shooter = [[TSShooter alloc] init];
    shooter.position = position;
    [sceneInstance addChild:shooter];
    return shooter;
}

// 移動開始
- (void)startMoveFromPosition:(CGPoint)position speed:(float)speed speedRate:(float)speedRate angle:(float)angle angleRate:(float)angleRate
{
    self.position = position;
    moveSpeed = speed;
    moveSpeedRate = speedRate;
    moveAngle = angle;
    moveAngleRate = angleRate;
    [self setMoveAction];
}

// 移動アクション設定
- (void)setMoveAction
{
    __block float prevTime = 0;
    
    SKAction *action = [SKAction customActionWithDuration:10 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        // フレームレートの経過時間を計算する
        float frameTime = elapsedTime - prevTime;
        prevTime = elapsedTime;
        if (frameTime < 0) frameTime = 0;
        // 経過時間分を移動させる
        [self move:frameTime];
    }];
    [self runAction:[SKAction repeatActionForever:action]];
}

// フレームレートで呼ばれる移動処理
- (void)move:(float)frameTime
{
    // 速度、角度を決める
    moveSpeed = moveSpeed + moveSpeedRate * frameTime;
    moveAngle = moveAngle + moveAngleRate * frameTime;
    self.zRotation = moveAngle;
    
    // 位置を決める
    float x = self.position.x + cos(moveAngle) * moveSpeed * frameTime; // x + dx
    float y = self.position.y + sin(moveAngle) * moveSpeed * frameTime; // y + dy
    self.position = CGPointMake(x, y);
    
    if (x < 0 || x > sceneWidth || y < 0 || y > sceneHeight) {
        // 画面から外れたら削除
        [self removeAllActions];
        [self removeFromParent];
    }
}

// 星の発射
- (void)shotWithStarSpeed:(float)speed speedRate:(float)speedRate angle:(float)angle angleRate:(float)angleRate lifetime:(float)lifetime way:(int)way wayRange:(float)wayRange count:(int)count interval:(float)interval
{
    starSpeed = speed;
    starSpeedRate = speedRate;
    starAngle = angle;
    starAngleRate = angleRate;
    starLifeTime = lifetime;
    shotWay = way;
    shotWayRange = wayRange;
    if (shotWayRange >= M_PI * 2 && shotWay > 0)
        shotWayRange = shotWayRange - shotWayRange / shotWay;
    shotCount = count;
    shotInterval = interval;
    [self setStarAction];
}

// 星の発射アクション
- (void)setStarAction
{
    __block float prevTime = 0;
    __block float interval = 0;
    
    SKAction *action = [SKAction customActionWithDuration:10 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        // フレームレートの経過時間を計算する
        float frameTime = elapsedTime - prevTime;
        prevTime = elapsedTime;
        if (frameTime < 0) frameTime = 0;
        
        // 経過時間を足し込む
        interval += frameTime;
        
        if (interval > shotInterval) {
            // 弾の発射間隔になったので発射する
            interval = 0;
            
            // 発射台の回転に向きを合わせる
            starAngle = moveAngle;
            
            // 同時発射数分ループ
            for (int i = 0; i < shotWay; i++) {
                
                // 指定数を発射したら終了
                if (shotCount-- < 0) {
                    [self removeAllActions];
                    [self removeFromParent];
                    return;
                }
                
                // 弾を生成
                if (shotWay > 1) {
                    // 発射範囲に同時発射数分ずらして打ち込む
                    [TSStar createAtPosition:self.position speed:starSpeed speedRate:starSpeedRate angle:starAngle + shotWayRange * ((float)i / (shotWay - 1) - 0.5f) angleRate:starAngleRate lifeTime:starLifeTime];
                } else {
                    // 1-way発射
                    [TSStar createAtPosition:self.position speed:starSpeed speedRate:starSpeedRate angle:starAngle angleRate:starAngleRate lifeTime:starLifeTime];
                }
            }
        }
    }];
    [self runAction:[SKAction repeatActionForever:action]];
}

@end
