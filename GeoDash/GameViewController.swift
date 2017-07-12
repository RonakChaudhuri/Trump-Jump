//
//  GameViewController.swift
//  GeoDash
//
//  Created by Ronak Chaudhuri on 7/2/17.
//  Copyright (c) 2017 Ronak Chaudhuri. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    
    var character = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            // Sprite Kit applies additional optimizations to improve rendering performance
            skView.ignoresSiblingOrder = true
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    }
