//
//  Star.swift
//  takkestar
//
//  Created by muratamuu on 2015/01/03.
//  Copyright (c) 2015年 muratamuu. All rights reserved.
//

import SpriteKit

private let INIT_POS_Z:CGFloat = 0.6

class Star: SKSpriteNode {

    var moveSpeed: CGFloat
    let moveSpeedRate: CGFloat
    var moveAngle: CGFloat
    let moveAngleRate: CGFloat
    let maxLifeTime: CGFloat

    init(position: CGPoint, speed: CGFloat, speedRate: CGFloat, angle: CGFloat, angleRate: CGFloat, lifeTime: CGFloat) {

        moveSpeed = speed
        moveSpeedRate = speedRate
        moveAngle = angle
        moveAngleRate = angleRate
        maxLifeTime = lifeTime

        let atlas = SKTextureAtlas(named: "star")
        let texture = atlas.textureNamed("img01y")

        super.init(texture: texture, color: nil, size: CGSizeMake(100, 100))

        zPosition = INIT_POS_Z
        self.position = position

        setMoveAction()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func delete() {
        removeAllActions()
        removeFromParent()
    }

    private func setMoveAction() {
        var prevTime: CGFloat = 0.0
        var lifeTime: CGFloat = 0.0

        let action = SKAction.customActionWithDuration(10, actionBlock: {(node, elapsedTime) in
            // フレームレートの経過時間を計算する
            let frameTime = (elapsedTime - prevTime) > 0 ? (elapsedTime - prevTime) : 0
            prevTime = elapsedTime
            lifeTime += frameTime
            if lifeTime > self.maxLifeTime {
                self.delete()
                return;
            }
            // 移動
            self.move(frameTime)
        })
        // アクション開始
        runAction(SKAction.repeatActionForever(action))
    }

    // フレームレートで呼ばれる移動処理
    private func move(frameTime: CGFloat) {

        if scene == nil {
            return
        }

        let gameScene = scene! as GameScene

        var x = position.x
        var y = position.y
        let dx = gameScene.takke.position.x - x
        let dy = gameScene.takke.position.y - y

        if x < 0 || x > gameScene.size.width || y < 0 || y > gameScene.size.height {
            // 画面から外れたら削除
            delete()
            return
        }

        // 速度、角度を更新する
        moveSpeed += moveSpeedRate * frameTime
        moveAngle += moveAngleRate * frameTime

        // 位置を更新する
        x += cos(moveAngle) * moveSpeed * frameTime
        y += sin(moveAngle) * moveSpeed * frameTime
        position = CGPointMake(x, y)
    }
}
