//
//  GameViewController.swift
//  Sidescroller
//
//  Created by RYAN STARK on 2/13/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var play: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
                    UIDevice.current.setValue(value, forKey: "orientation")
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                play = scene as? GameScene
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscapeRight
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func jump(_ sender: Any) {
        play.ball.physicsBody?.velocity = CGVector(dx: Int((play.ball.physicsBody?.velocity.dx)!), dy: 1000)
    }
    @IBAction func right(_ sender: Any) {
        play.ball.physicsBody?.velocity = CGVector(dx: 750, dy: Int((play.ball.physicsBody?.velocity.dy)!))
        play.ball.texture = SKTexture(image: UIImage(named: "right")!)
    }
    @IBAction func down(_ sender: Any) {
    }
    @IBAction func left(_ sender: Any) {
        play.ball.physicsBody?.velocity = CGVector(dx: -750, dy: Int((play.ball.physicsBody?.velocity.dy)!))
        play.ball.texture = SKTexture(image: UIImage(named: "left")!)
    }
    @IBAction func up(_ sender: Any) {
    }
    @IBAction func stopX(_ sender: Any){
        play.ball.physicsBody?.velocity = CGVector(dx: 0, dy: Int((play.ball.physicsBody?.velocity.dy)!))
    }
    @IBAction func stopY(_ sender: Any){
        play.ball.physicsBody?.velocity = CGVector(dx: Int((play.ball.physicsBody?.velocity.dx)!), dy: 0)
    }
    
}
