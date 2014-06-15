//
//  TSPatternShooter.m
//  takkestar
//
//  Created by muratamuu on 2014/04/27.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "TSPatternShooter.h"
#import "TSStar.h"

@implementation TSPatternShooter {
    float starSpeed;     // 星の速度
    float starAngle;     // 星の角度
    float starLifeTime;  // 星の生存時間
    float shotRange;     // 星の発射角度範囲
    int   shotCount;     // 星の発射数
    float shotInterval;  // 星の間隔
    char  *shotPattern;  // パターン文字列
    int   patternWidth;  // パターンの幅(文字数)
    int   patternHeight; // パターンの高さ(文字数)
}

static char *fussa =
"                                         "
"                                         "
"                                ##   ##  "
"##### #   #  ####  ####   #   #   ##    #"
"#     #   # #     #      # #  #         #"
"####  #   #  ###   ###   ###   #       # "
"#     #   #     #     # #   #    #   #   "
"#      ###  ####  ####  #   #      #     ";

static char *takke =
"                                         "
"                                         "
"                                ##   ##  "
"#####   #   #   # #   # ##### #   ##    #"
"  #    # #  #  #  #  #  #     #         #"
"  #    ###  ###   ###   ####   #       # "
"  #   #   # #  #  #  #  #        #   #   "
"  #   #   # #   # #   # #####      #     ";

static char *thanks =
"                                        "
"                                        "
"                                        "
"##### #   #   #   #   # #   #  ####  # #"
"  #   #   #  # #  ##  # #  #  #      # #"
"  #   #####  ###  # # # ###    ###   # #"
"  #   #   # #   # #  ## #  #      #     "
"  #   #   # #   # #   # #   # ####   # #";

static char *heart =
"                                     "
"                                     "
"                                     "
"  ##   ##      ##   ##      ##   ##  "
"#   ##    #  #   ##    #  #   ##    #"
"#         #  #         #  #         #"
" #       #    #       #    #       # "
"   #   #        #   #        #   #   "
"     #            #            #     ";

+ (void)startRandomOnScene:(SKScene *)scene position:(CGPoint)position
{
    float lifetime;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        lifetime= 15;
    } else {
        lifetime = 30;
    }
    TSPatternShooter *shooter = [TSPatternShooter createOnScene:scene position:position];
    
    switch (arc4random() % 4) {
        case 0:
            [shooter shotWithPattern:fussa width:41 height:8 speed:35 angle:-M_PI_2 range:0.9 interval:0.2 lifeTime:lifetime];
            break;
        case 1:
            [shooter shotWithPattern:takke width:41 height:8 speed:35 angle:-M_PI_2 range:0.9 interval:0.2 lifeTime:lifetime];
            break;
        case 2:
            [shooter shotWithPattern:thanks width:40 height:8 speed:35 angle:-M_PI_2 range:0.9 interval:0.2 lifeTime:lifetime];
            break;
        case 3:
            [shooter shotWithPattern:heart width:37 height:9 speed:35 angle:-M_PI_2 range:0.6 interval:0.2 lifeTime:lifetime];
            break;

    }
}

// コンストラクタ
+ (id)createOnScene:(SKScene *)scene position:(CGPoint)position
{
    TSPatternShooter *shooter = [[TSPatternShooter alloc] init];
    shooter.position = position;
    [scene addChild:shooter];
    return shooter;
}

// 星の発射
- (void)shotWithPattern:(char *)pattern width:(int)width height:(int)height speed:(float)speed angle:(float)angle range:(float)range interval:(float)interval lifeTime:(float)lifeTime
{
    shotPattern = pattern;
    patternWidth = width;
    patternHeight = height;
    starSpeed = speed;
    starAngle = angle;
    shotRange = range;
    shotInterval = interval;
    starLifeTime = lifeTime;
    [self setStarAction];
}

// 星の発射アクション
- (void)setStarAction
{
    __block float prevTime = 0;
    __block float interval = 0;
    __block int line = patternHeight;
    
    int linelimit;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        linelimit = -10;
    } else {
        linelimit = -30;
    }
    
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
            
            line--;
            if (line < linelimit) line = patternHeight - 1;
            if (line < 0) return;
            
            char *p = shotPattern + line * patternWidth;
            
            for (int i = 0;  i < patternWidth; i++) {
                if (p[i] != ' ') {
                    [TSStar createAtPosition:self.position speed:starSpeed speedRate:0 angle:starAngle + shotRange * ((float)i / (patternWidth - 1) - 0.5f) angleRate:0 lifeTime:starLifeTime];
                }
            }
        }
    }];
    [self runAction:[SKAction repeatActionForever:action]];
}

@end
