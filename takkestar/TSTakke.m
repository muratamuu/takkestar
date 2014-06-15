//
//  TSTakke.m
//  takkestar
//
//  Created by muratamuu on 2014/04/30.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "TSTakke.h"
#import "TSCommonDefine.h"

static dispatch_once_t onceToken;
static float sceneWidth, sceneHeight;
static NSMutableArray *textures;

@implementation TSTakke {
    float dx;
    float dy;
}

+ (id)createWithScene:(SKScene *)scene
{
    // シングルトン処理
    dispatch_once(&onceToken, ^{
        // シーンの端を保存
        sceneWidth = scene.size.width;
        sceneHeight = scene.size.height;
        textures = @[].mutableCopy;
        [textures addObject:[SKTexture textureWithImageNamed:@"takke1"]];
        [textures addObject:[SKTexture textureWithImageNamed:@"takke2"]];
        [textures addObject:[SKTexture textureWithImageNamed:@"takke3"]];
        [textures addObject:[SKTexture textureWithImageNamed:@"takke4"]];
    });
    
    TSTakke *takke = [[TSTakke alloc] initTakke];
    [scene addChild:takke];
    return takke;
}

- (id)initTakke
{
    if (self = [super initWithTexture:[textures objectAtIndex:0]]) {
        self.xScale = 0.12f;
        self.yScale = 0.12f;
        self.position = CGPointMake(sceneWidth / 2, sceneHeight * TAKKE_POS);
        self.zPosition = 0.6;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)changeTexture:(int)i
{
    [self setTexture:[textures objectAtIndex:i]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self.scene.view];
    dx = self.position.x - location.x;
    dy = self.position.y - (self.scene.size.height - location.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self.scene.view];
    float x = location.x + dx;
    float y = self.scene.size.height - location.y + dy;
    if (x > 0 && x < self.scene.size.width && y > 0 && y < self.scene.size.height) {
        self.position = CGPointMake(location.x + dx, self.scene.size.height - location.y + dy);
    }
}

@end
