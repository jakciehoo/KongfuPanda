//
//  Platform.swift
//  KongfuPanda
//
//  Created by HooJackie on 15/7/1.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

import SpriteKit

class Platform:SKNode {
    var width:CGFloat = 0.0
    var height:CGFloat = 10.0
    var isDown = false
    var isShock = false
    //创建平台
    func onCreate(arrSprite:[SKSpriteNode]){
        for platform in arrSprite {
            platform.position.x = self.width
            self.addChild(platform)
            self.width += platform.size.width
        }
        //短到只有三小块的平台会下落
        if arrSprite.count <= 3 {
            isDown = true
        }else {
            //随机振动
            let random = arc4random() % 10
            if random > 6 {
                isShock = true
            }
        }
         self.height = 10.0

        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.width, self.height),center:CGPointMake(self.width/2, 0))
        self.physicsBody?.categoryBitMask = BitMaskType.platform
        self.physicsBody?.dynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        self.zPosition = 20
        
    }
    
}
