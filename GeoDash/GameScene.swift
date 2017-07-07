//
//  GameScene.swift
//  GeometryDash
//
//  Created by Ronak Chaudhri on 7/2/17.
//  Copyright (c) 2017 Ronak Chaudhri. All rights reserved.
//

import SpriteKit



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var objTimer = Timer()
    
    var person = SKSpriteNode()
    
    var isJumping = false
    var isTouching = false
    
    var ObsArray = [String]()
    
    var score = Int()
    var highScore = Int()
    var scoreTimer = Timer()
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        highScoreLabel = childNode(withName: "highScoreLabel") as! SKLabelNode
        score = 0
        let def = UserDefaults.standard
        if def.integer(forKey: "highScore") != 0{
            highScore = def.integer(forKey: "highScore")
        }else{
            highScore = 0
        }
        updateLabel()
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -30)
        person = scene?.childNode(withName: "person") as! SKSpriteNode
        
        
        objTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(GameScene.pickobj), userInfo: nil, repeats: true)
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.addScore), userInfo: nil, repeats: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        isTouching = true
        
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if node.name == "retryBtn"{
                restartScene()
            }
            
        }
        
        jump()
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let a = contact.bodyA.node
        let b = contact.bodyB.node
        
        let result = (a?.physicsBody?.categoryBitMask)! | (b?.physicsBody?.categoryBitMask)!
        
        if result == 3 || result == 6{
            if self.physicsWorld.body(at: CGPoint(x: person.position.x - 49, y: person.position.y - 51)) == nil &&
            self.physicsWorld.body(at: CGPoint(x: person.position.x + 49, y: person.position.y - 51)) == nil {
                // No body directly under the person, cannot jump
                print("test")
                return
            }
            isJumping = false
            jump()
        }else if result == 10{
            for node in self.children{
                node.removeAllActions()
            }
            objTimer.invalidate()
           
        }
    }
    
    func jump(){
        if isTouching {
            
            if isJumping == false {
                isJumping = true
                person.physicsBody?.applyImpulse(CGVector(dx: 0,dy: 700))
            }
        }
    }
    
    func pickobj(){
        
        ObsArray = ["Obstacle1","Obstacle2","Obstacle3"]
        
        let randomNumber = arc4random() % UInt32(ObsArray.count)
        
        addobj(ObsArray[Int(randomNumber)])
        
    }
    
    func addobj(_ obsName: String){
        
        let obj = Bundle.main.path(forResource: obsName, ofType: "sks")
        
        let objNode = SKReferenceNode(url: URL(fileURLWithPath: obj!))
        
        objNode.position = CGPoint(x: (scene?.frame.size.width)!, y: 100)
        self.addChild(objNode)
        
        let moveAction = SKAction.moveTo(x: -objNode.scene!.frame.width, duration: 8)
        let removeAction = SKAction.removeFromParent()
        objNode.run(SKAction.sequence([moveAction,removeAction]))
        
    }
    
    
    
    func die(){
        
        scoreTimer.invalidate()
        let retryButton = SKSpriteNode(imageNamed: "retry")
        retryButton.name = "retryBtn"
        
        let wait = SKAction.wait(forDuration: 1.0)
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        
        retryButton.alpha = 0
        retryButton.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        self.addChild(retryButton)
        retryButton.run(SKAction.sequence([wait, fadeIn]))
    }
    
    func restartScene(){
        let scene = GameScene(fileNamed: "GameScene")
        let transition = SKTransition.crossFade(withDuration: 0.5)
        let view = self.view as SKView!
        scene?.scaleMode = SKSceneScaleMode.aspectFill
        view?.presentScene(scene!, transition: transition)
        score = 0
        updateLabel()
    }
    
    func addScore(){
        score += 1
        
        if score > highScore {
            highScore = score
            let def = UserDefaults.standard
            def.set(highScore, forKey: "highScore")
        }
        updateLabel()
    }
    
    func updateLabel(){
        scoreLabel.text = "\(score)"
        highScoreLabel.text = "Highscore: \(highScore)"
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if person.position.x <= 0 - person.frame.width / 2 {
            for node in self.children{
                if node.name != "retryBtn"{
                    node.removeAllActions()
                }
            }
            objTimer.invalidate()
            die()
        }
    }
}
