//
//  TSMyScene.m
//  takkestar
//
//  Created by muratamuu on 2014/06/07.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "TSMyScene.h"

#import "TSRetryButton.h"
#import "TSShooter.h"
#import "TSPatternShooter.h"
#import "TSStar.h"
#import "TSBalloon.h"
#import "TSBullet.h"
#import "TSCommonDefine.h"
#import "TSTakke.h"

static const CFTimeInterval GameInterval = 30;

@implementation TSMyScene {
    dispatch_once_t lastUpdatedAtInitToken;
    CFTimeInterval lastUpdatedAt;
    int score;
    SKLabelNode *scoreLabel;
    SKLabelNode *timeLabel;
    TSRetryButton *retryButton;
    CFTimeInterval gameTime;
    BOOL isTimeRemaining;
    SKSpriteNode *backImage;
    int backTextureIdx;
    NSMutableArray *backTexture;
}
@synthesize takke;

-(id)initWithSize:(CGSize)size {    
    
    if (self = [super initWithSize:size]) {
        
        // 物理オブジェクトの進行方向
        self.physicsWorld.gravity = (CGVector){0, 2.0f};
        
        // 衝突デリゲートを設定
        self.physicsWorld.contactDelegate = self;
        // シーン背景を設定
        backTexture = @[].mutableCopy;
        [backTexture addObject:[SKTexture textureWithImageNamed:@"back01.jpg"]];
        [backTexture addObject:[SKTexture textureWithImageNamed:@"back02.jpg"]];
        [backTexture addObject:[SKTexture textureWithImageNamed:@"back03.jpg"]];
        backTextureIdx = arc4random() % 3;
        SKTexture *texture = [backTexture objectAtIndex:backTextureIdx];
        backImage = [[SKSpriteNode alloc] initWithTexture:texture];
        float backImageScale = (self.frame.size.width + 1) / texture.size.width;
        backImage.xScale = backImageScale;
        backImage.yScale = backImageScale;
        backImage.anchorPoint = CGPointMake(0, 0);
        backImage.position = CGPointMake(0, 0);
        
        // リトライボタン生成
        retryButton = [TSRetryButton labelNodeWithFontNamed:@"Chalkduster"];
        retryButton.text = @"Retry?";
        retryButton.fontSize = 30;
        retryButton.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height * 0.7);
        retryButton.userInteractionEnabled = YES;
        retryButton.delegate = self;
        retryButton.zPosition = 0.4;
        
        // タイマラベル生成
        timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        timeLabel.text = @"";
        timeLabel.fontSize = 30;
        timeLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height * 0.5);
        
        // スコアラベル生成
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        scoreLabel.text = @"score: 0";
        scoreLabel.fontSize = 20;
        scoreLabel.position = CGPointMake(self.frame.size.width * 0.03, self.frame.size.height * 0.03);
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        
        [self opening];
        [self gameInit];
    }
    
    return self;
}


-(void)opening
{
    [TSStar opening:self];
    [TSShooter opening:self];
    [TSBullet opening];
    [TSBalloon opening:self];
}

-(void)update:(CFTimeInterval)currentTime {
    dispatch_once(&lastUpdatedAtInitToken, ^{
        lastUpdatedAt = currentTime;
    });
    
    // 前回フレーム更新からの経過時間
    CFTimeInterval timeSinceLastUpdated = currentTime - lastUpdatedAt;
    lastUpdatedAt = currentTime;
    
    gameTime += timeSinceLastUpdated;
    CFTimeInterval timeRemaining = GameInterval - gameTime;
    
    if (timeRemaining > 0.0) {
        // 時間を減らす
        timeLabel.text = [NSString stringWithFormat:@"%d", (int)ceil(timeRemaining)];
        isTimeRemaining = YES;
    } else {
        if (isTimeRemaining) {
            [self gameOver];
            isTimeRemaining = NO;
        }
    }
}

- (void)scoreUp:(int)point
{
    if (isTimeRemaining == YES) {
        score += point;
        scoreLabel.text = [NSString stringWithFormat:@"score: %d", score];
        
        if (score >= 10000 && score < 30000) {
            [takke changeTexture:1];
            [TSStar setlevel:1];
        } else if (score >= 30000 && score < 50000) {
            [takke changeTexture:2];
            [TSStar setlevel:2];
        } else if (score >= 50000) {
            [takke changeTexture:3];
            [TSStar setlevel:3];
        }
    }
}

- (void)gameInit
{
    [self removeAllChildren];
    [self addChild:backImage];
    [self addChild:timeLabel];
    [self addChild:scoreLabel];
    
    backTextureIdx = (backTextureIdx + 1) % 3;
    [backImage setTexture:[backTexture objectAtIndex:backTextureIdx]];
    
    int balloonNum;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        balloonNum = 5;
    } else {
        balloonNum = 10;
    }
    for (int i = 0; i < balloonNum; i++) {
        [TSBalloon createWithScene:self];
    }
    
    takke = [TSTakke createWithScene:self];
    isTimeRemaining = YES;
    gameTime = 0.0;
    score = 0;
    scoreLabel.text = [NSString stringWithFormat:@"score: %d", score];
    
    [takke changeTexture:0];
    [TSStar setlevel:0];
}

-(void)gameOver
{
    // ゲームオーバー
    timeLabel.text = @"Game over!";
    [self addChild:retryButton];
    [TSPatternShooter startRandomOnScene:self position:CGPointMake(self.size.width/2, self.size.height * 0.65)];
    takke.position = CGPointMake(self.size.width / 2, self.size.height * TAKKE_POS);
}

- (void)retry
{
    [self gameInit];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask & PHYSICS_CATEGORY_BALLOON) {
        [(TSBalloon *)contact.bodyA.node explosion];
    }
    if (contact.bodyB.categoryBitMask & PHYSICS_CATEGORY_BALLOON) {
        [(TSBalloon *)contact.bodyB.node explosion];
    }
    if (contact.bodyA.categoryBitMask & PHYSICS_CATEGORY_BULLET) {
        [(SKNode *)contact.bodyA.node removeFromParent];
    }
    if (contact.bodyB.categoryBitMask & PHYSICS_CATEGORY_BULLET) {
        [(SKNode *)contact.bodyB.node removeFromParent];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [TSBullet createWithScene:self at:CGPointMake([[touches anyObject] locationInNode:self].x, 0)];
}

@end
