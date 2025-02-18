//
//  GameScene.swift
//  Sidescroller
//
//  Created by RYAN STARK on 2/13/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball: SKSpriteNode!
    let cam = SKCameraNode()
    
    var onFloor = false
    
    var control: GameViewController!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.camera = cam
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        control = scene as? GameViewController
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "floor" || contact.bodyB.node?.name == "floor"{
            print("collision with floor")
        }
        
        if contact.bodyA.node?.name == "coin" && contact.bodyB.node?.name == "ball"{
            print("coin")
        } else if contact.bodyB.node?.name == "coin" && contact.bodyA.node?.name == "ball"{
            print("coin")
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "cloud"{
            contact.bodyA.node?.isHidden = true
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        } else if contact.bodyB.node?.name == "cloud"{
            contact.bodyB.node?.isHidden = true
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
        }
        
        
    }
    
    
    func jump(){
        ball.physicsBody?.velocity.dy = 600
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        cam.position = ball.position
    }
}
