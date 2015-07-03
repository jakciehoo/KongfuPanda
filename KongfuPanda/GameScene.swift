

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate , ProtocolMainscreen{
    lazy var panda  = Panda()
    lazy var platformFactory = PlatformFactory()
    lazy var sound = SoundManager()
    lazy var bg = Background()
    lazy var appleFactory = AppleFactory()
    let scoreLab = SKLabelNode(fontNamed:"Chalkduster")
    let appLab = SKLabelNode(fontNamed:"Chalkduster")
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    var appleNum = 0
    
    
    var moveSpeed :CGFloat = 15.0
    var maxSpeed :CGFloat = 50.0
    var distance:CGFloat = 0.0
    var lastDis:CGFloat = 0.0
    var theY:CGFloat = 0.0
    var isLose = false
    override func didMoveToView(view: SKView) {
        
        let skyColor = SKColor(red:113.0/255.0, green:197.0/255.0, blue:207.0/255.0, alpha:1.0)
        self.backgroundColor = skyColor
        scoreLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreLab.position = CGPointMake(20, self.frame.size.height-150)
        scoreLab.text = "run: 0 km"
        self.addChild(scoreLab)
        
        appLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        appLab.position = CGPointMake(400, self.frame.size.height-150)
        appLab.text = "eat: \(appleNum) apple"
        self.addChild(appLab)
        
        myLabel.text = "";
        myLabel.fontSize = 65;
        myLabel.zPosition = 100
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody!.categoryBitMask = BitMaskType.scene
        self.physicsBody!.dynamic = false
        
        panda.position = CGPointMake(200, 400)
        self.addChild(panda)
        self.addChild(platformFactory)
        platformFactory.screenWdith = self.frame.width
        platformFactory.delegate = self
        platformFactory.createPlatform(3, x: 0, y: 200)
        
        self.addChild(bg)
        
        self.addChild(sound)
        sound.playBackgroundMusic()
        
        appleFactory.onInit(self.frame.width, y: theY)
        self.addChild( appleFactory )
        
    }
    func didBeginContact(contact: SKPhysicsContact){
        
        //熊猫和苹果碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.apple | BitMaskType.panda){
            sound.playEat()
            self.appleNum++
            if contact.bodyA.categoryBitMask == BitMaskType.apple {
                contact.bodyA.node!.hidden = true
            }else{
                contact.bodyB.node!.hidden = true
            }
            
            
        }
        
        //熊猫和台子碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.platform | BitMaskType.panda){
            var isDown = false
            var canRun = false
            if contact.bodyA.categoryBitMask == BitMaskType.platform {
                if (contact.bodyA.node as! Platform).isDown {
                    isDown = true
                    contact.bodyA.node!.physicsBody!.dynamic = true
                    contact.bodyA.node!.physicsBody!.collisionBitMask = 0
                }else if (contact.bodyA.node as! Platform).isShock {
                    (contact.bodyA.node as! Platform).isShock = false
                    downAndUp(contact.bodyA.node!, down: -50, downTime: 0.2, up: 100, upTime: 1, isRepeat: true)
                }
                if contact.bodyB.node!.position.y > contact.bodyA.node!.position.y {
                    canRun=true
                }
                
            }else if contact.bodyB.categoryBitMask == BitMaskType.platform  {
                if (contact.bodyB.node as! Platform).isDown {
                    contact.bodyB.node!.physicsBody!.dynamic = true
                    contact.bodyB.node!.physicsBody!.collisionBitMask = 0
                    isDown = true
                }else if (contact.bodyB.node as! Platform).isShock {
                    (contact.bodyB.node as! Platform).isShock = false
                    downAndUp(contact.bodyB.node!, down: -50, downTime: 0.2, up: 100, upTime: 1, isRepeat: true)
                }
                if contact.bodyA.node!.position.y > contact.bodyB.node!.position.y {
                    canRun=true
                }
                
            }
            
            panda.jumpEnd = panda.position.y
            if panda.jumpEnd-panda.jumpStart <= -70 {
                panda.roll()
                sound.playRoll()
                
                if !isDown {
                    downAndUp(contact.bodyA.node!)
                    downAndUp(contact.bodyB.node!)
                }
                
            }else{
                if canRun {
                    panda.run()
                }
                
            }
        }
        
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.scene | BitMaskType.panda) {
            println("game over")
            myLabel.text = "game over";
            sound.playDead()
            isLose = true
            sound.stopBackgroundMusic()
            

        }
        
        //落地后jumpstart数据要设为当前位置，防止自由落地计算出错
        panda.jumpStart = panda.position.y
    }
    func didEndContact(contact: SKPhysicsContact){
        panda.jumpStart = panda.position.y
        
    }
    func downAndUp(node :SKNode,down:CGFloat = -50,downTime:CGFloat=0.05,up:CGFloat=50,upTime:CGFloat=0.1,isRepeat:Bool=false){
        let downAct = SKAction.moveByX(0, y: down, duration: Double(downTime))
        //moveByX(CGFloat(0), y: down, duration: downTime)
        let upAct = SKAction.moveByX(0, y: up, duration: Double(upTime))
        let downUpAct = SKAction.sequence([downAct,upAct])
        if isRepeat {
            node.runAction(SKAction.repeatActionForever(downUpAct))
        }else {
            node.runAction(downUpAct)
        }
        
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if isLose {
            reSet()
        }else{
            if panda.status != Status.jump2 {
                sound.playJump()
            }
            panda.jump()
        }
        
        
    }
    //重新开始游戏
    func reSet(){
        isLose = false
        panda.position = CGPointMake(200, 400)
        myLabel.text = ""
        moveSpeed  = 15.0
        distance = 0.0
        lastDis = 0.0
        self.appleNum = 0
        platformFactory.reset()
        appleFactory.reSet()
        platformFactory.createPlatform(3, x: 0, y: 200)
        sound.playBackgroundMusic()
    }
    override func update(currentTime: CFTimeInterval) {
        if isLose {
            
        }else{
            if panda.position.x < 200 {
                var x = panda.position.x + 1
                panda.position = CGPointMake(x, panda.position.y)
            }
            distance += moveSpeed
            lastDis -= moveSpeed
            var tempSpeed = CGFloat(5 + Int(distance/2000))
            if tempSpeed > maxSpeed {
                tempSpeed = maxSpeed
            }
            if moveSpeed < tempSpeed {
                moveSpeed = tempSpeed
            }
            
            if lastDis < 0 {
                platformFactory.createPlatformRandom()
            }
            distance += moveSpeed
            scoreLab.text = "run: \(Int(distance/1000*10)/10) km"
            appLab.text = "eat: \(appleNum) apple"
            platformFactory.move(moveSpeed)
            bg.move(moveSpeed/5)
            appleFactory.move(moveSpeed)
        }
        
    }
    
    func onGetData(dist:CGFloat,theY:CGFloat){
        
        self.lastDis = dist
        self.theY = theY
        appleFactory.theY = theY
    }
    
}

protocol ProtocolMainscreen {
    func onGetData(dist:CGFloat,theY:CGFloat)
}
