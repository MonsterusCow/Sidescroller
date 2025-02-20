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

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var climbButton: UIButton!
    
    var points = 0
    var play: GameScene!
    var xpos = 0.0
    var ypos = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterButton.isHidden = true
        enterButton.isEnabled = false
        climbButton.isHidden = true
        climbButton.isEnabled = false
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
                    UIDevice.current.setValue(value, forKey: "orientation")
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                scene.scaleMode = .aspectFill
                scene.viewController = self
                play = scene as? GameScene
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
        if play.onFloor{
            play.ball.physicsBody?.velocity = CGVector(dx: Int((play.ball.physicsBody?.velocity.dx)!), dy: 1000)
            play.onFloor = false
        }
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
    @IBAction func climb(_ sender: Any) {
        play.climbing = true
        play.onFloor = true
    }
    @IBAction func stopClimbing(_ sender: Any) {
        play.climbing = false
        play.ball.physicsBody?.velocity = CGVector(dx: Int((play.ball.physicsBody?.velocity.dx)!), dy: 0)
    }
    @IBAction func enterexit(_ sender: Any) {
        play.ball.physicsBody?.velocity.dy = 0
        play.ball.physicsBody?.velocity.dx = 0
        play.ball.position.x = xpos
        play.ball.position.y = ypos
    }
    
}
