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
    var climbing = false
    var ladderContact = false
    var doRespawn = false
    var respawn = CGPoint(x: 48.756, y: -97.514)
    
    weak var viewController: GameViewController?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.camera = cam
        ball = self.childNode(withName: "ball") as? SKSpriteNode
        cam.setScale(2.0)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "floor" || contact.bodyB.node?.name == "floor"{
            onFloor = true
        }
        
        if contact.bodyA.node?.name == "coin"{
            viewController?.points += 10
            viewController?.pointsLabel.text = "Points: \(Int(viewController!.points))"
            contact.bodyA.node?.isHidden = true
            contact.bodyA.node?.physicsBody?.contactTestBitMask = 0
        } else if contact.bodyB.node?.name == "coin"{
            viewController?.points += 10
            viewController?.pointsLabel.text = "Points: \(Int(viewController!.points))"
            contact.bodyB.node?.isHidden = true
            contact.bodyB.node?.physicsBody?.contactTestBitMask = 0
        }
        
        if contact.bodyA.node?.name == "bed" || contact.bodyB.node?.name == "ball"{
            respawn.x = (contact.bodyA.node?.position.x)!
            respawn.y = (contact.bodyA.node?.position.y)! + 50
            viewController?.enterButton.isHidden = false
            viewController?.enterButton.isEnabled = true
        } else if contact.bodyB.node?.name == "bed" || contact.bodyA.node?.name == "ball"{
            respawn.x = (contact.bodyB.node?.position.x)!
            respawn.y = (contact.bodyB.node?.position.y)! + 50
            viewController?.enterButton.isHidden = false
            viewController?.enterButton.isEnabled = true
        }
        
        if contact.bodyA.node?.name == "enterCave" || contact.bodyB.node?.name == "enterCave"{
            viewController?.xpos = -17600
            viewController?.ypos = -1720.202
            viewController?.enterButton.isHidden = false
            viewController?.enterButton.isEnabled = true
        }
        
        if contact.bodyA.node?.name == "exitCave" || contact.bodyB.node?.name == "exitCave"{
            viewController?.xpos = -5907.685
            viewController?.ypos = 206.7
            viewController?.enterButton.isHidden = false
            viewController?.enterButton.isEnabled = true
        }
        
        if contact.bodyA.node?.name == "cloud" {
            onFloor = true
            fadeOutAndRemove(node: contact.bodyA.node!)
        } else if contact.bodyB.node?.name == "cloud" {
            onFloor = true
            fadeOutAndRemove(node: contact.bodyB.node!)
        }
        
        if contact.bodyA.node?.name == "ladder" || contact.bodyB.node?.name == "ladder"{
            viewController?.climbButton.isHidden = false
            viewController?.climbButton.isEnabled = true
        }
        
        if contact.bodyA.node?.name == "lava" || contact.bodyB.node?.name == "lava"{
            doRespawn = true
            print("respawn 1")
        }
        
        if contact.bodyA.node?.name == "stag" || contact.bodyB.node?.name == "stag"{
            doRespawn = true
            print("respawn 2")
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "enterCave" || contact.bodyB.node?.name == "enterCave"{
            viewController?.enterButton.isHidden = true
            viewController?.enterButton.isEnabled = false
            print("enter")
        }
        
        if contact.bodyA.node?.name == "exitCave" || contact.bodyB.node?.name == "exitCave"{
            viewController?.enterButton.isHidden = true
            viewController?.enterButton.isEnabled = false
            print("exit")
        }
        
        if contact.bodyA.node?.name == "ladder" || contact.bodyB.node?.name == "ladder"{
            climbing = false
            ball.physicsBody?.affectedByGravity = true
            viewController?.climbButton.isHidden = true
            viewController?.climbButton.isEnabled = false
        }
    }
    
    func fadeOutAndRemove(node: SKNode) {
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        node.run(sequence) {
            // Wait for 5 seconds and then add the cloud back
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                self.addCloud(at: node.position)
            }
        }
    }

    func addCloud(at position: CGPoint) {
        // Create a new cloud
        let cloud = SKSpriteNode(imageNamed: "cloud")
        cloud.name = "cloud"
        cloud.position = position
        cloud.alpha = 0.0  // Start invisible
        cloud.zPosition = 0
        cloud.size.width = 320.001
        cloud.size.height = 93.295

        // Add physics body if needed
        cloud.physicsBody = SKPhysicsBody(rectangleOf: cloud.size)
        cloud.physicsBody?.isDynamic = false
        cloud.physicsBody?.categoryBitMask = 2  // Adjust as needed
        cloud.physicsBody?.contactTestBitMask = 1  // Adjust as needed
        cloud.physicsBody?.collisionBitMask = 1  // Adjust as needed
        
        // Add the cloud to the scene
        self.addChild(cloud)
        
        // Fade it in
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        cloud.run(fadeIn)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        cam.position = ball.position
        if climbing {
            ball.physicsBody?.velocity = CGVector(dx: Int((ball.physicsBody?.velocity.dx)!), dy: 500)
                if onFloor{
                    ball.physicsBody?.affectedByGravity = false
                }
        }
        if viewController?.climbButton.isHidden == false {
            if !onFloor{
                ball.physicsBody?.affectedByGravity = true
            }
        }
        if doRespawn{
            ball.position = respawn
            doRespawn = false
        }
    }
}
