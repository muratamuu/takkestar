//
//  TSRetryButton.h
//  takkestar
//
//  Created by muratamuu on 2014/04/27.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TSRetryButton : SKLabelNode
@property (weak) id delegate;
@end

@protocol TSRetryButtonDelegate <NSObject>
- (void)retry;
@end