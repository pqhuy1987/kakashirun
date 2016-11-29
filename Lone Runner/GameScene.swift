//
//  GameScene.swift
//  Lone Runner
//
//  Created by Siddarth Patel on 7/9/16.
//  Copyright (c) 2016 Appworks. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation
import DynamicButton



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ninjaRunArray :[SKTexture] = [SKTexture(imageNamed: "Run__000"),SKTexture(imageNamed: "Run__001"),SKTexture(imageNamed: "Run__002"),SKTexture(imageNamed: "Run__003"),SKTexture(imageNamed: "Run__004"),SKTexture(imageNamed: "Run__005"),SKTexture(imageNamed: "Run__006"),SKTexture(imageNamed: "Run__007"),SKTexture(imageNamed: "Run__008"),SKTexture(imageNamed: "Run__009")]

    var ninjaRun = SKSpriteNode()
    var column = SKSpriteNode()
    var column2 = SKSpriteNode()
    var invisibleButton = SKSpriteNode()
    var defenceButton = SKSpriteNode()
    var speedButton = SKSpriteNode()
    var bg = SKSpriteNode()

    
    var ableToJump = true
    var viewController: UIViewController?
    
    
    var gameOver = false
    var swipedRight = false
    var swipedRightOnce = false
    
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var movingObjects = SKSpriteNode()
    var labelContainer = SKSpriteNode()
    var backgroundContainer = SKSpriteNode()
    
    var invisible = false
    var count = 0
    var used = 0
    var isActivated = false
    
    var defence = false
    var count2 = 0
    var used2 = 0
    var isActivated2 = false
    
    var superSpeed = false
    var count3 = 0
    var used3 = 0
    var isActivated3 = false

    var myTimer: NSTimer?
    var myTimer2: NSTimer?
    var myTimer3: NSTimer?
    var bgTimer:NSTimer?
    
    let right = SKAction.moveByX(350, y:0,duration: 0.3)
    let left = SKAction.moveByX(-350, y:0, duration: 0.8)

    var dynamicButton2 = DynamicButton()
    var player:AVAudioPlayer = AVAudioPlayer()
    var runMusic = true
    var inAir = false
    var newGame = false
    
    var isRunning = true
    var gapHeight = CGFloat (0)
    
    enum ColliderType : UInt32{
       case ninja = 1
       case wall = 2
       case floor = 4
       case Gap = 8
    }
    
    func movebg(){
    
        let bgTexture = SKTexture(imageNamed: "jungle.jpg")
        let movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 5.5)
        let replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        let movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg,replacebg]))
        
        for i in 0..<3 {
            
            let c = CGFloat (i)
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width*c, y: CGRectGetMidY(self.frame))
            bg.zPosition = -0.5
            bg.size.height = self.frame.height
            bg.runAction(movebgForever)
            backgroundContainer.addChild(bg)
        
        }
    }
    
    func makeNinja(){

        let ninjaRunTexture = SKTexture(imageNamed: "Run__000")
        let animationRun = SKAction.animateWithTextures(ninjaRunArray, timePerFrame: 0.04)
        let makeNinjaRun = SKAction.repeatActionForever(animationRun)
        ninjaRun = SKSpriteNode(texture: ninjaRunTexture)
        ninjaRun.position = CGPoint(x: CGRectGetMidX(self.frame)-175,  y: CGRectGetMidY(self.frame)-210)
        ninjaRun.zPosition = +0.5
        ninjaRun.runAction(makeNinjaRun)
        ninjaRun.physicsBody = SKPhysicsBody(circleOfRadius: ninjaRunTexture.size().height/2)
        ninjaRun.physicsBody?.restitution = 0
        ninjaRun.physicsBody?.dynamic = true
        ninjaRun.physicsBody?.categoryBitMask = ColliderType.ninja.rawValue
        ninjaRun.physicsBody?.contactTestBitMask = ColliderType.ninja.rawValue
        ninjaRun.physicsBody?.collisionBitMask = ColliderType.floor.rawValue | ColliderType.wall.rawValue
        ninjaRun.physicsBody?.usesPreciseCollisionDetection = true
        ninjaRun.physicsBody?.friction = 1
        ninjaRun.physicsBody?.restitution = 0
        self.addChild(ninjaRun)
        
    }
    
   
    override func didMoveToView(view: SKView) {
        
        self.speed = 1.3
        
        self.physicsWorld.contactDelegate = self
        
        self.addChild(movingObjects)
        
        self.addChild(labelContainer)
        
        self.addChild(backgroundContainer)
        
        movebg()
        
        scoreLabel.fontName = "Marker Felt"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame),  y: self.frame.size.height - 70)
        self.addChild(scoreLabel)
        
        makeNinja()
        
        invisibleButton = SKSpriteNode(texture: SKTexture(imageNamed: "invisible"))
        invisibleButton.position = CGPoint(x: CGRectGetMidX(self.frame)-60,  y: CGRectGetMidY(self.frame)-320)
        invisibleButton.zPosition = +0.5
        self.addChild(invisibleButton)
        
        invisibleButton.alpha = 0.3
        
        defenceButton = SKSpriteNode(texture: SKTexture(imageNamed: "2"))
        defenceButton.position = CGPoint(x: CGRectGetMidX(self.frame),  y: CGRectGetMidY(self.frame)-320)
        defenceButton.zPosition = +0.5
        self.addChild(defenceButton)
        
        defenceButton.alpha = 0.3
        
        speedButton = SKSpriteNode(texture: SKTexture(imageNamed: "speedIcon"))
        speedButton.position = CGPoint(x: CGRectGetMidX(self.frame)+60,  y: CGRectGetMidY(self.frame)-320)
        speedButton.zPosition = +0.5
        self.addChild(speedButton)
        
        speedButton.alpha = 0.3
        
        let ground = SKNode()
        ground.position = CGPointMake(CGRectGetMidX(self.frame) - 175, CGRectGetMidY(self.frame) - 250)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.restitution = 0
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = ColliderType.floor.rawValue
        ground.physicsBody?.contactTestBitMask = ColliderType.ninja.rawValue
        ground.physicsBody?.collisionBitMask = ColliderType.floor.rawValue
        
        self.addChild(ground)
        
        bgTimer = NSTimer.scheduledTimerWithTimeInterval(2.3, target: self, selector: #selector(GameScene.makeColumns), userInfo: nil, repeats: true)
        
        
        let dynamicButton = DynamicButton(frame: CGRectMake(0,15,35,35))
        dynamicButton.style = DynamicButtonStyle.CaretLeft
        dynamicButton.lineWidth           = 5
        dynamicButton.strokeColor         = .orangeColor()
        dynamicButton.highlightStokeColor = .whiteColor()
        view.addSubview(dynamicButton)
        dynamicButton.addTarget(self, action: #selector(GameScene.backButtonTapped), forControlEvents: .TouchUpInside)
        
        
        dynamicButton2 = DynamicButton(frame: CGRectMake(self.view!.frame.size.width-35 , 20 ,  30, 30))
        dynamicButton2.style = DynamicButtonStyle.Pause
        dynamicButton2.lineWidth           = 5
        dynamicButton2.strokeColor         = .orangeColor()
        dynamicButton2.highlightStokeColor = .whiteColor()
        view.addSubview(dynamicButton2)
        dynamicButton2.addTarget(self, action: #selector(GameScene.pauseButtonTapped), forControlEvents: .TouchUpInside)
        
        let center = NSNotificationCenter.defaultCenter()
        
        center.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        center.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        center.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)

    }
    
    func applicationWillResignActive(notification: NSNotification){
        
        bgTimer?.invalidate()
      
    }
    
    func applicationDidEnterBackground(notification: NSNotification){
       
         bgTimer?.invalidate()
    }

    func applicationDidBecomeActive(notification: NSNotification){
       
        bgTimer = NSTimer.scheduledTimerWithTimeInterval(2.3, target: self, selector: #selector(GameScene.makeColumns), userInfo: nil, repeats: true)

    }

    
    
    func backButtonTapped(){
        
        self.speed = 0
        player.pause()
        used = 0
        isActivated = false
        invisibleButton.alpha = 0.3
        used2 = 0
        isActivated2 = false
        defenceButton.alpha = 0.3
        used3 = 0
        isActivated3 = false
        speedButton.alpha = 0.3
        scoreLabel.text = "0"
        movingObjects.removeAllChildren()
        backgroundContainer.removeAllChildren()
        labelContainer.removeAllChildren()
        ninjaRun.removeFromParent()
        self.viewController!.performSegueWithIdentifier("back", sender: viewController)
        
    }
    
    func pauseButtonTapped(){
        
        if gameOver == false{
            
            if isRunning == true && gameOver == false{
                
                dynamicButton2.style = DynamicButtonStyle.Play
                self.speed = 0
                bgTimer?.invalidate()
                myTimer?.invalidate()
                myTimer2?.invalidate()
                myTimer3?.invalidate()
                player.pause()
                isRunning = false
                gameOverLabel.fontName = "Marker Felt"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "Paused"
                gameOverLabel.position = CGPoint(x: CGRectGetMidX(self.frame),  y: CGRectGetMidY(self.frame))
                labelContainer.addChild(gameOverLabel)
            
            }else{
                
                player.play()
                labelContainer.removeAllChildren()
                dynamicButton2.style = DynamicButtonStyle.Pause
                
                if gameOver == false{
                    
                    self.speed = 1.3
                    bgTimer = NSTimer.scheduledTimerWithTimeInterval(2.3, target: self, selector: #selector(GameScene.makeColumns), userInfo: nil, repeats: true)
                    isRunning = true
                }
                
                if invisible == true {
                    
                    myTimer = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(GameScene.invisibleCounter), userInfo: nil, repeats: true)
                }
                else if defence == true{
                    
                    myTimer2 = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(GameScene.defenceCounter), userInfo: nil, repeats: true)
                }
                else if superSpeed == true{
                    
                    myTimer3 = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(GameScene.speedCounter), userInfo: nil, repeats: true)
                }
            }
        }
       
    }
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == ColliderType.floor.rawValue || contact.bodyB.categoryBitMask == ColliderType.floor.rawValue{
            runAction(SKAction.playSoundFileNamed("land.wav", waitForCompletion: false))
            inAir = false
            if runMusic == true{
                let audioPath = NSBundle.mainBundle().pathForResource("run", ofType: "wav")
                do{
                    
                    try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath!))
                    player.play()
                    player.numberOfLoops = -1
                }
                catch{
                    print("error")
                }
                
            }
            if swipedRight == true {
                ninjaRun.runAction(left)
                swipedRight = false
            }

        }
        
        
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue{
            runAction(SKAction.playSoundFileNamed("Pickup_Coin_new.wav", waitForCompletion: false))
            if defence == true{
                score = score + 2
                scoreLabel.text = String(score)
            }else{
                score = score + 1
                scoreLabel.text = String(score)
            }
            if score > highscore{
                highscore = score
                NSUserDefaults.standardUserDefaults().setObject(highscore, forKey: "highscore")
            }
        }
        
        
        else if contact.bodyA.categoryBitMask == ColliderType.wall.rawValue || contact.bodyB.categoryBitMask == ColliderType.wall.rawValue{
            
            if invisible == true{
                return
            }
            
            else if superSpeed == true{
                return
            }
                
            
            else if gameOver == false{
    
               swipedRight = false
               ninjaRun.physicsBody?.allowsRotation = false
               runMusic = false
               player.pause()
               runAction(SKAction.playSoundFileNamed("hurt1.wav", waitForCompletion: false))
               gameOver = true
               self.speed = 0
               let animationFly = SKAction.animateWithTextures([SKTexture(imageNamed: "Dead")], timePerFrame: 0.04)
               ninjaRun.zPosition = +0.5
               ninjaRun.runAction(animationFly)
               gameOverLabel.fontName = "Marker Felt"
               gameOverLabel.fontSize = 30
               gameOverLabel.text = "Game Over! tap to play again."
               gameOverLabel.position = CGPoint(x: CGRectGetMidX(self.frame),  y: CGRectGetMidY(self.frame))
               labelContainer.addChild(gameOverLabel)
               defence = false
            
            }
            
        }
      
        
     }
    
    
    
    func makeColumns(){
        
        
        
        if Int(scoreLabel.text!) == 10 || Int(scoreLabel.text!) == 60 || Int(scoreLabel.text!) == 61 && isActivated == false{
            if used == 3{
                
                used = 0
                runAction(SKAction.playSoundFileNamed("bunshin out 9.wav", waitForCompletion: false))
                invisibleButton.alpha = 1
                isActivated = true
            
            }else{
                
                runAction(SKAction.playSoundFileNamed("bunshin out 9.wav", waitForCompletion: false))
                invisibleButton.alpha = 1
                isActivated = true
            
            }
        }
        
        if Int(scoreLabel.text!) == 30 || Int(scoreLabel.text!) == 70 && isActivated2 == false{
            
            if used2 == 3{
                
                used2 = 0
                runAction(SKAction.playSoundFileNamed("bunshin out 9.wav", waitForCompletion: false))
                defenceButton.alpha = 1
                isActivated2 = true
                
            }else{
                
                runAction(SKAction.playSoundFileNamed("bunshin out 9.wav", waitForCompletion: false))
                defenceButton.alpha = 1
                isActivated2 = true
                
            }
         }
    
        if (Int(scoreLabel.text!) == 50||Int(scoreLabel.text!) == 51 || Int(scoreLabel.text!) == 90 || Int(scoreLabel.text!) == 91) && isActivated3 == false{
            
            if used3 == 3{
                used3 = 0
                runAction(SKAction.playSoundFileNamed("bunshin out 9.wav", waitForCompletion: false))
                speedButton.alpha = 1
                isActivated3 = true
            }
            else{
                runAction(SKAction.playSoundFileNamed("bunshin out 9.wav", waitForCompletion: false))
                speedButton.alpha = 1
                isActivated3 = true
            }
        }
        
        if Int(scoreLabel.text!) >= 10 && Int(scoreLabel.text!) <= 30 && gameOver == false{
            gapHeight = ninjaRun.size.height * 2.4
            self.speed = 1.5
        }
        
        else if Int(scoreLabel.text!) >= 31 && Int(scoreLabel.text!) <= 50 && gameOver == false{
            gapHeight = ninjaRun.size.height * 2.2
            self.speed = 1.7
        }
        
        else if Int(scoreLabel.text!) >= 51 && gameOver == false{
            gapHeight = ninjaRun.size.height * 2.0
        }
        
        else{
            gapHeight = ninjaRun.size.height * 2.6
        }
        
        
       
        let movementAmount = arc4random() % UInt32(self.frame.size.height/2)
        let columnOffset = CGFloat(movementAmount) - self.frame.size.height/4
        
        let moveColumns = SKAction.moveByX(-self.frame.size.width*2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
        let removeColumns = SKAction.removeFromParent()
        let moveAndRemoveCol = SKAction.sequence([moveColumns,removeColumns])
        
        let columnTexture = SKTexture(imageNamed: "pipe2n.png")
        column = SKSpriteNode(texture: columnTexture)
        column.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - columnTexture.size().height/2-gapHeight/2 + columnOffset)
        column.zPosition = -0.4
        column.runAction(moveAndRemoveCol)
        
        column.physicsBody = SKPhysicsBody(texture: columnTexture, size: columnTexture.size())
        column.physicsBody!.dynamic = false
        column.physicsBody?.restitution = 0
        column.physicsBody?.categoryBitMask = ColliderType.wall.rawValue
        column.physicsBody?.contactTestBitMask = ColliderType.ninja.rawValue | ColliderType.wall.rawValue
        column.physicsBody?.collisionBitMask = ColliderType.wall.rawValue
    
        movingObjects.addChild(column)
        
        let columnTexture2 = SKTexture(imageNamed: "pipe1n.png")
        column2 = SKSpriteNode(texture: columnTexture2)
        column2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + columnTexture2.size().height/2+gapHeight/2 + columnOffset)
        column2.zPosition = -0.4
        column2.runAction(moveAndRemoveCol)
        
        column2.physicsBody = SKPhysicsBody(texture: columnTexture2, size: columnTexture2.size())
        column2.physicsBody!.dynamic = false
        column2.physicsBody?.restitution = 0
        column2.physicsBody?.categoryBitMask = ColliderType.wall.rawValue
        column2.physicsBody?.contactTestBitMask = ColliderType.ninja.rawValue
        column2.physicsBody?.collisionBitMask = ColliderType.wall.rawValue
        
        
        movingObjects.addChild(column2)
        
        let gap = SKNode()
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + columnOffset)
        gap.runAction(moveAndRemoveCol)
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(column.size.width - 107, gapHeight))
        gap.physicsBody?.dynamic = false
        gap.physicsBody?.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody?.contactTestBitMask = ColliderType.ninja.rawValue
        gap.physicsBody?.collisionBitMask = ColliderType.Gap.rawValue
        gap.physicsBody?.usesPreciseCollisionDetection = true
        backgroundContainer.addChild(gap)
        
    
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        
        if let touch = touches.first {
            
            let location = touch.locationInNode(self)
            
            if invisibleButton.containsPoint(location) {
                
               return
            }
                
            if defenceButton.containsPoint(location){
                
                return
            }
            
            if speedButton.containsPoint(location){
               
                return
            }
            
            else if isRunning == false{
            
                return
            
            }
           
        
            else if gameOver == false{
                if ableToJump == true{
                    
                    inAir = true
                    swipedRightOnce = false
                    player.pause()
                    runAction(SKAction.playSoundFileNamed("leap.wav", waitForCompletion: false))
                    let animationJump = SKAction.animateWithTextures([SKTexture(imageNamed: "Jump__005")], timePerFrame: 1.5)
                    ninjaRun.zPosition = +0.5
                    ninjaRun.runAction(animationJump)
                    ninjaRun.physicsBody?.applyImpulse(CGVectorMake(0, 350))
                    
                }
            }
            else{
                
                newGame = true
                used = 0
                isActivated = false
                invisibleButton.alpha = 0.3
                used2 = 0
                isActivated2 = false
                defenceButton.alpha = 0.3
                used3 = 0
                isActivated3 = false
                speedButton.alpha = 0.3
                runMusic = true
                score = 0
                scoreLabel.text = "0"
                ninjaRun.physicsBody?.velocity = CGVectorMake(0,0)
                ninjaRun.physicsBody?.friction = 1
                movingObjects.removeAllChildren()
                backgroundContainer.removeAllChildren()
                movebg()
                self.speed = 1.3
                gameOver = false
                labelContainer.removeAllChildren()
                let audioPath = NSBundle.mainBundle().pathForResource("run", ofType: "wav")
                do{
                    try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath!))
                    player.play()
                    player.numberOfLoops = -1
                    
                }
                catch{
                    print("error")
                }
                gapHeight = ninjaRun.size.height * 2.6
                ninjaRun.removeFromParent()
                makeNinja()
                
            }
        }
      
    }
    

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            let location = touch.locationInNode(self)
            
            if gameOver == false && swipedRightOnce == false && isRunning == true && inAir == true{
                
                ninjaRun.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                let animationFly = SKAction.animateWithTextures([SKTexture(imageNamed: "Glide")], timePerFrame: 0.3)
                ninjaRun.runAction(animationFly)
                runAction(SKAction.playSoundFileNamed("swoosh.wav", waitForCompletion: false))
                ninjaRun.runAction(right)
                ninjaRun.physicsBody?.allowsRotation = false
                swipedRight = true
                swipedRightOnce = true
            }

            
            if invisibleButton.containsPoint(location) {
                if gameOver == false && invisible == false && count==0 && used <= 2 && Int(scoreLabel.text!) >= 10 && defence == false && superSpeed == false && isRunning == true{
                    ninjaRun.physicsBody?.collisionBitMask = ColliderType.floor.rawValue
                    invisibleButton.alpha = 0.3
                    runAction(SKAction.playSoundFileNamed("wind 3.wav", waitForCompletion: false))
                    invisible = true
                    ninjaRun.alpha = 0.3
                    used = used + 1
                    myTimer = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(GameScene.invisibleCounter), userInfo: nil, repeats: true)
                }
            }else if defenceButton.containsPoint(location){
            
                if gameOver == false && defence == false && count2==0 && used2 <= 2 && Int(scoreLabel.text!) >= 30 && invisible == false && superSpeed == false && isRunning == true{
                    newGame = false
                    defenceButton.alpha = 0.3
                    runAction(SKAction.playSoundFileNamed("wind 3.wav", waitForCompletion: false))
                    defence = true
                    used2 = used2 + 1
                    myTimer2 = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(GameScene.defenceCounter), userInfo: nil, repeats: true)
                }
            }else if speedButton.containsPoint(location){
            
                if gameOver == false && superSpeed == false && count3==0 && used3 <= 2 && Int(scoreLabel.text!) >= 50 && defence == false && invisible == false && isRunning == true{
                
                    ninjaRun.physicsBody?.collisionBitMask = ColliderType.floor.rawValue
                    self.speed = 3.3
                    speedButton.alpha = 0.3
                    runAction(SKAction.playSoundFileNamed("wind 3.wav", waitForCompletion: false))
                    superSpeed = true
                    ninjaRun.colorBlendFactor = 1
                    ninjaRun.color = .redColor()
                    used3 = used3 + 1
                    myTimer3 = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(GameScene.speedCounter), userInfo: nil, repeats: true)
                   
            }
            
         }
      }
    }
    
    func invisibleCounter(){
        count += 1
        if count == 1{
            if used == 3{
                ninjaRun.physicsBody?.collisionBitMask = ColliderType.floor.rawValue | ColliderType.wall.rawValue
                myTimer?.invalidate()
                runAction(SKAction.playSoundFileNamed("bunshin out 6.wav", waitForCompletion: false))
                ninjaRun.alpha = 1
                invisibleButton.alpha = 0.3
                count = 0
                invisible = false
                return
            }
            else{
                ninjaRun.physicsBody?.collisionBitMask = ColliderType.floor.rawValue | ColliderType.wall.rawValue
                myTimer?.invalidate()
                runAction(SKAction.playSoundFileNamed("bunshin out 6.wav", waitForCompletion: false))
                ninjaRun.alpha = 1
                invisibleButton.alpha = 1
                count = 0
                invisible = false
                return
            }
        }
        
    }
    
    func defenceCounter(){
       count2 += 1
        if count2 == 1{
            if used2 == 3{
                
                runAction(SKAction.playSoundFileNamed("bunshin out 6.wav", waitForCompletion: false))
                defence = false
                myTimer2!.invalidate()
                defenceButton.alpha = 0.3
                count2 = 0
                return
            }
            else{
                
                myTimer2?.invalidate()
                runAction(SKAction.playSoundFileNamed("bunshin out 6.wav", waitForCompletion: false))
                if newGame == false{
                    defenceButton.alpha = 1
                }
                count2 = 0
                defence = false
                return
            
            }
        }
    }
    
    func speedCounter(){
        count3 += 1
        if count3 == 1{
            if used3 == 3{
                self.speed = 1.7
                ninjaRun.physicsBody?.collisionBitMask = ColliderType.floor.rawValue | ColliderType.wall.rawValue
                runAction(SKAction.playSoundFileNamed("bunshin out 6.wav", waitForCompletion: false))
                superSpeed = false
                ninjaRun.colorBlendFactor = 0
                myTimer3!.invalidate()
                speedButton.alpha = 0.3
                count3 = 0
                return
            }
            else{
                self.speed = 1.7
                ninjaRun.physicsBody?.collisionBitMask = ColliderType.floor.rawValue | ColliderType.wall.rawValue
                myTimer3?.invalidate()
                runAction(SKAction.playSoundFileNamed("bunshin out 6.wav", waitForCompletion: false))
                ninjaRun.colorBlendFactor = 0
                speedButton.alpha = 1
                count3 = 0
                superSpeed = false
                return
                
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
            
                if ninjaRun.physicsBody?.velocity.dy == 0 {
                    ableToJump = true
                }
                else {
                    ableToJump = false
                }
      }
    

}
