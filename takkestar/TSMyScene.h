//
//  TSMyScene.h
//  takkestar
//

//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TSTakke.h"

@interface TSMyScene : SKScene <SKPhysicsContactDelegate>

@property TSTakke *takke;
- (void)scoreUp:(int)point;

@end
