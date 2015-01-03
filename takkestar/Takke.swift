//
//  Takke.swift
//  takkestar
//
//  Created by muratamuu on 2014/12/29.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

import SpriteKit

let TEXTURE_WIDTH:CGFloat = 100
let TEXTURE_HEIGHT:CGFloat = 100
let INIT_POS_X:CGFloat = 0.5
let INIT_POS_Y:CGFloat = 0.86
let INIT_POS_Z:CGFloat = 0.6
let textures = [SKTexture(imageNamed: "takke1"), SKTexture(imageNamed: "takke2"), SKTexture(imageNamed: "takke3"), SKTexture(imageNamed: "takke4")]

class Takke: SKSpriteNode {

    var dx: CGFloat = 0
    var dy: CGFloat = 0

    convenience override init() {

        self.init(texture: textures[1], color: nil, size: CGSizeMake(TEXTURE_WIDTH, TEXTURE_HEIGHT))

        let appSize = UIScreen.mainScreen().applicationFrame.size
        position = CGPointMake(appSize.width * INIT_POS_X, appSize.height * INIT_POS_Y)
        zPosition = INIT_POS_Z
        userInteractionEnabled = true
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            let location = touch.locationInView(touch.view)
            dx = position.x - location.x;
            dy = position.y - (scene!.size.height - location.y);
        }
    }

    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            let location = touch.locationInView(touch.view)
            position = CGPointMake(location.x + dx, (scene!.size.height - location.y) + dy)
        }
    }
}
