//
//  TSRetryButton.m
//  takkestar
//
//  Created by muratamuu on 2014/04/27.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "TSRetryButton.h"

@implementation TSRetryButton

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(retry)]) {
        [self.delegate retry];
    }
}

@end
