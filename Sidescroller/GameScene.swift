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
    
    weak var viewController: GameViewController?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.camera = cam
        ball = self.childNode(withName: "ball") as? SKSpriteNode
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "floor" || contact.bodyB.node?.name == "floor"{
            onFloor = true
        }
        
        if contact.bodyA.node?.name == "coin" && contact.bodyB.node?.name == "ball"{
            viewController?.points += 10
            viewController?.pointsLabel.text = "Points: \(Int(viewController!.points))"
            contact.bodyA.node?.isHidden = true
            contact.bodyA.node?.physicsBody?.contactTestBitMask = 0
        } else if contact.bodyB.node?.name == "coin" && contact.bodyA.node?.name == "ball"{
            viewController?.points += 10
            viewController?.pointsLabel.text = "Points: \(Int(viewController!.points))"
            contact.bodyB.node?.isHidden = true
            contact.bodyB.node?.physicsBody?.contactTestBitMask = 0
        }
        
        if contact.bodyA.node?.name == "enterCow" || contact.bodyB.node?.name == "enterCow"{
            
            viewController?.x = -17586.008
            viewController?.y = -1539.059
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
