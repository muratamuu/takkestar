//
//  GameScene.swift
//  takkestar
//
//  Created by muratamuu on 2014/12/29.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        addChild(myLabel)

        addChild(Takke())
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
