//
//  Takke.swift
//  takkestar
//
//  Created by muratamuu on 2014/12/29.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

import SpriteKit

private let TEXTURE_WIDTH:CGFloat = 100
private let TEXTURE_HEIGHT:CGFloat = 100
private let INIT_POS_X:CGFloat = 0.5
private let INIT_POS_Y:CGFloat = 0.86
private let INIT_POS_Z:CGFloat = 0.6
private let textures = [SKTexture(imageNamed: "takke1"), SKTexture(imageNamed: "takke2"), SKTexture(imageNamed: "takke3"), SKTexture(imageNamed: "takke4")]

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
            let location = touch.locationInNode(scene!)
            dx = position.x - location.x;
            dy = position.y - location.y;
        }
    }

    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            let location = touch.locationInNode(scene!)
            position = CGPointMake(location.x + dx, location.y + dy)
        }
    }
}
