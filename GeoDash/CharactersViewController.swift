//
//  CharactersViewController.swift
//  GeoDash
//
//  Created by Ronak Chaudhuri on 7/10/17.
//  Copyright © 2017 Ronak Chaudhuri. All rights reserved.
//

import UIKit
import SpriteKit
class CharactersViewController: UIViewController
{

    var trump = SKSpriteNode()
    let scene = GameScene(fileNamed: "GameScene")
    var character = ""
    override func viewDidLoad()
        
    {
        super.viewDidLoad()

    }
    @IBAction func curryTapped(_ sender: Any)
    {
        
        
        trump = scene?.childNode(withName: "person") as! SKSpriteNode
        character = "Curry"
        trump.texture = SKTexture(imageNamed: character)

    }
    @IBAction func westbrookTapped(_ sender: Any)
    {
        trump = scene?.childNode(withName: "person") as! SKSpriteNode
        trump.texture = SKTexture(imageNamed: "Westbrook")

    }

    @IBAction func hillaryTapped(_ sender: Any)
    {
        trump = scene?.childNode(withName: "person") as! SKSpriteNode
        trump.texture = SKTexture(imageNamed: "Hilary")

    }
    @IBAction func bernieTapped(_ sender: Any)
    {
        trump = scene?.childNode(withName: "person") as! SKSpriteNode
        trump.texture = SKTexture(imageNamed: "Bernie")

    }
    @IBAction func putinTapped(_ sender: Any)
    {
        trump = scene?.childNode(withName: "person") as! SKSpriteNode
        trump.texture = SKTexture(imageNamed: "Putin")

    }
    @IBAction func babyTapped(_ sender: Any)
    {
        trump = scene?.childNode(withName: "person") as! SKSpriteNode
        trump.texture = SKTexture(imageNamed: "Kid")

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let gvc = segue.destination as! GameScene
        
        
        gvc.character = character
    }


}
