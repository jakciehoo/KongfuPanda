//
//  BackGround.swift
//场景的动态背景图类
//  KongfuPanda
//
//  Created by HooJackie on 15/7/1.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

import SpriteKit

class Background:SKNode {
    //近处的背景
    var arrBG = [SKSpriteNode]()
    //远处的背景
    var arrFar = [SKSpriteNode]()
    
    override init() {
        super.init()
        let farTexture = SKTexture(imageNamed: "background_f1")
        let farBg0 = SKSpriteNode(texture: farTexture)
        farBg0.position.y = 150
        farBg0.zPosition = 9
        farBg0.anchorPoint = CGPointMake(0, 0)
        

        let farBg1 = SKSpriteNode(texture: farTexture)
        farBg1.position.y = 150
        farBg1.zPosition = 9
        farBg1.anchorPoint = CGPointMake(0, 0)
        farBg1.position.x = farBg1.frame.width
        
        let farBg2 = SKSpriteNode(texture: farTexture)
        farBg2.position.y = 150
        farBg2.zPosition = 9
        farBg2.anchorPoint = CGPointMake(0, 0)
        farBg2.position.x = farBg2.frame.width*2
        
        self.addChild(farBg0)
        self.addChild(farBg1)
        self.addChild(farBg2)
        arrFar.append(farBg0)
         arrFar.append(farBg1)
         arrFar.append(farBg2)
        
        let texture = SKTexture(imageNamed: "background_f0")
        let bg0 = SKSpriteNode(texture: texture)
        bg0.anchorPoint = CGPointMake(0, 0)
        bg0.position.y = 70
        bg0.zPosition = 10
        
        let bg1 = SKSpriteNode(texture: texture)
        bg1.anchorPoint = CGPointMake(0, 0)
        bg1.position.y = 70
        bg1.zPosition = 10
        bg1.position.x = bg0.frame.size.width
        self.addChild(bg0)
        self.addChild(bg1)
        arrBG.append(bg0)
        arrBG.append(bg1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(speed:CGFloat){
        //近景
        for bg in arrBG {
            bg.position.x -= speed
        }
        if arrBG[0].position.x + arrBG[0].frame.size.width < speed {
            arrBG[0].position.x = 0
            arrBG[1].position.x = arrBG[0].frame.size.width
        }
        //远景
        for far in arrFar {
            far.position.x -= speed/4
            
        }
        if arrFar[0].position.x + arrFar[0].frame.size.width < speed/4 {
            arrFar[0].position.x = 0
            arrFar[1].position.x = arrFar[0].frame.size.width
            arrFar[2].position.x = arrFar[0].frame.size.width * 2
        }
        
    }
    
}
