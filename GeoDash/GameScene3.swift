//
//  GameScene3.swift
//  GeoDash
//
//  Created by Ronak Chaudhuri on 7/14/17.
//  Copyright © 2017 Ronak Chaudhuri. All rights reserved.
//

import UIKit
import SpriteKit
class GameScene3: SKScene, SKPhysicsContactDelegate
{
    
    var objTimer = Timer()  //For when obstacles appear
    var trump = SKSpriteNode()
    var isJumping = false
    var isTouching = false
    
    var ObsArray = [String]()  //array of the obstacles
    var character = ""
    var score = Int()
    var highScore = Int()
    var scoreTimer = Timer()
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var canRestart = Bool()
    
    override func didMove(to view: SKView)
    {
       
        
        
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        highScoreLabel = childNode(withName: "highScoreLabel") as! SKLabelNode
        score = 0
        let def = UserDefaults.standard       // Sets Default HighScore
        if def.integer(forKey: "highScore") != 0
        {
            highScore = def.integer(forKey: "highScore")
        }
        else
        {
            highScore = 0
        }
        updateLabel()
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -30)
        trump = scene?.childNode(withName: "person") as! SKSpriteNode
        
        
        
        
        pickobj()
        objTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(GameScene3.pickobj), userInfo: nil, repeats: true)
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene3.addScore), userInfo: nil, repeats: true)
        // timer for Score and appearance of obstacles
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        isTouching = true
        
        for touch in touches
        {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if node.name == "retryBtn" //pops retry button to reset
            {
                restartScene()
                
            }
            
        }
        
        jump()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        isTouching = false
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        let a = contact.bodyA.node
        let b = contact.bodyB.node
        
        let result = (a?.physicsBody?.categoryBitMask)! | (b?.physicsBody?.categoryBitMask)!
        
        if result == 3 || result == 6
            //contact procedures to match the requirements with contact to die
        {
            if self.physicsWorld.body(at: CGPoint(x: trump.position.x - 49, y: trump.position.y - 51)) == nil &&
                self.physicsWorld.body(at: CGPoint(x: trump.position.x + 49, y: trump.position.y - 51)) == nil
            {
                // No body directly under the trump, cannot jump
                print("test")
                return
            }
            isJumping = false
            jump()
        }
        else if result == 10
        {
            for node in self.children
            {
                node.removeAllActions()
            }
            objTimer.invalidate()
            die()
        }
        
    }
    
    func jump()
    {
        if isTouching
        {
            
            if isJumping == false
            {
                isJumping = true
                trump.physicsBody?.applyImpulse(CGVector(dx: 0,dy: 700))
            }
        }
    }
    
    func pickobj()
    {
        
        ObsArray = ["Obstacle7","Obstacle8", "Obstacle9"]
        //All sks files for the obstacles
        
        let randomNumber = arc4random() % UInt32(ObsArray.count)
        
        addobj(ObsArray[Int(randomNumber)])
        
    }
    
    func addobj(_ obsName: String)  // adding obstacles to the view
    {
        
        let obj = Bundle.main.path(forResource: obsName, ofType: "sks")
        
        let objNode = SKReferenceNode(url: URL(fileURLWithPath: obj!))
        
        objNode.position = CGPoint(x: (scene?.frame.size.width)!, y: 100)
        self.addChild(objNode)
        
        let moveAction = SKAction.moveTo(x: -objNode.scene!.frame.width, duration: 8)
        let removeAction = SKAction.removeFromParent()
        objNode.run(SKAction.sequence([moveAction,removeAction]))
        
    }
    
    
    
    func die()
    {
        
        scoreTimer.invalidate()
        let retryButton = SKSpriteNode(imageNamed: "retry")
        retryButton.name = "retryBtn"
        
        let wait = SKAction.wait(forDuration: 1.0)
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        
        retryButton.alpha = 0
        retryButton.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        print("retry")
        
        self.addChild(retryButton)
        retryButton.run(SKAction.sequence([wait, fadeIn]))
        
        
    }
    
    func restartScene()
    {
        let scene = GameScene3(fileNamed: "GameScene3")
        let transition = SKTransition.crossFade(withDuration: 0.5)
        let view = self.view as SKView!
        scene?.scaleMode = SKSceneScaleMode.aspectFill
        view?.presentScene(scene!, transition: transition)
        score = 0
        updateLabel()
        
    }
    
    func addScore()
    {
        score += 1
        
        if score > highScore
        {
            highScore = score
            let def = UserDefaults.standard
            def.set(highScore, forKey: "highScore")
        }
        updateLabel()
        if score >= 10 && score < 20
        {
            trump.texture = SKTexture(imageNamed: "Curry")
        }
        if score >= 20 && score < 35
        {
            trump.texture = SKTexture(imageNamed: "Hilary")
        }
        if score >= 35 && score < 50
        {
            trump.texture = SKTexture(imageNamed: "Westbrook")
            
        }
        if score >= 50 && score < 75
        {
            trump.texture = SKTexture(imageNamed: "Bernie")
            
        }
        if score >= 75 && score < 90
        {
            trump.texture = SKTexture(imageNamed: "Kid")
            
        }
        if score >= 90 && score < 100
        {
            trump.texture = SKTexture(imageNamed: "Putin")
            
        }
        if score == 100
        {
            let myAlert = UIAlertController(title: "Congradulations", message: "You have beat this level", preferredStyle: UIAlertControllerStyle.alert)
            let dismissButton = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            myAlert.addAction(dismissButton)
            self.view?.window?.rootViewController?.present(myAlert, animated: true, completion: nil)
            stop()
        }
    }
    
    func updateLabel()
    {
        scoreLabel.text = "\(score)"
        highScoreLabel.text = "Highscore: \(highScore)"
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered //
        
        if trump.position.x <= 0 - trump.frame.width / 2
        {
            for node in self.children{
                if node.name != "retryBtn"
                {
                    node.removeAllActions()
                }
            }
            objTimer.invalidate()
        }
    }
    func stop()
    {
        for node in self.children
        {
            node.removeAllActions()
            scoreTimer.invalidate()
            objTimer.invalidate()
        }
    }
}
