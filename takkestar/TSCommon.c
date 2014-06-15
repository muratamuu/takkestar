//
//  TSCommon.c
//  takkestar
//
//  Created by muratamuu on 2014/05/01.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

float floatRandom()
{
    return (float)arc4random() / (float)UINT_MAX;
}