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
    var enterCave: SKSpriteNode!
    var exitCave: SKSpriteNode!
    var enterCastle: SKSpriteNode!
    var exitCastle: SKSpriteNode!
    var enterPath: SKSpriteNode!
    var exitPath: SKSpriteNode!
    let cam = SKCameraNode()
    var onFloor = true
    var climbing = false
    var goingRight = false
    var goingLeft = false
    var ladderContact = false
    var doRespawn = false
    var respawn = CGPoint(x: 32.463, y: -55.633)
    var bites = 0
    
    var startTime: TimeInterval = 0
    var lastUpdate: TimeInterval = 0
    
    weak var viewController: GameViewController?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.camera = cam
        ball = self.childNode(withName: "ball") as? SKSpriteNode
        enterCave = self.childNode(withName: "enterCave") as? SKSpriteNode
        exitCave = self.childNode(withName: "exitCave") as? SKSpriteNode
        enterCastle = self.childNode(withName: "enterCastle") as? SKSpriteNode
        exitCastle = self.childNode(withName: "exitCastle") as? SKSpriteNode
        enterPath = self.childNode(withName: "enterPath") as? SKSpriteNode
        exitPath = self.childNode(withName: "exitPath") as? SKSpriteNode
        cam.setScale(2.0)
        
        startTime = 0
        lastUpdate = 0
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
//        if contact.bodyA.node?.name == "floor" && contact.bodyB.node?.name == "ball"{
//            let characterBottom = (contact.bodyB.node?.position.y)! - ((contact.bodyB.node?.frame.size.height)! / 2)
//            let floorTop = (contact.bodyA.node?.position.y)! + ((contact.bodyA.node?.frame.size.height)! / 2)
//            if characterBottom >= floorTop-20 {
//                onFloor = true
//                print("floor1")
//            }
//        } else if contact.bodyB.node?.name == "floor" && contact.bodyA.node?.name == "ball"{
//            let characterBottom = (contact.bodyA.node?.position.y)! - ((contact.bodyA.node?.frame.size.height)! / 2)
//            let floorTop = (contact.bodyB.node?.position.y)! + ((contact.bodyB.node?.frame.size.height)! / 2)
//            if characterBottom >= floorTop-20 {
//                onFloor = true
//                print("floor2")
//            }
//        }
        
        if contact.bodyA.node?.name == "floor" || contact.bodyB.node?.name == "floor"{
            onFloor = true
        }
        
        if contact.bodyA.node?.name == "coin"{
            viewController?.points += 10
            viewController?.pointsLabel.text = "Points: \(Int(viewController!.points))"
            contact.bodyA.node?.removeFromParent()
        } else if contact.bodyB.node?.name == "coin"{
            viewController?.points += 10
            viewController?.pointsLabel.text = "Points: \(Int(viewController!.points))"
            contact.bodyB.node?.removeFromParent()
        }
        
        if contact.bodyA.node?.name == "bed" && contact.bodyB.node?.name == "ball"{
            respawn.x = (contact.bodyA.node?.position.x)!
            respawn.y = (contact.bodyA.node?.position.y)! + 50
        } else if contact.bodyB.node?.name == "bed" && contact.bodyA.node?.name == "ball"{
            respawn.x = (contact.bodyB.node?.position.x)!
            respawn.y = (contact.bodyB.node?.position.y)! + 50
        }
        
        if contact.bodyA.node?.name == "enterCave" && contact.bodyB.node?.name == "ball" || contact.bodyB.node?.name == "enterCave" && contact.bodyA.node?.name == "ball"{
            viewController?.xpos = exitCave.position.x
            viewController?.ypos = exitCave.position.y
            viewController?.enterButton.isHidden = false
            viewController?.enterButton.isEnabled = true
        }
        
        if contact.bodyA.node?.name == "exitCave" && contact.bodyB.node?.name == "ball" || contact.bodyB.node?.name == "exitCave" && contact.bodyA.node?.name == "ball"{
            viewController?.xpos = enterCave.position.x
            viewController?.ypos = enterCave.position.y
            viewController?.enterButton.isHidden = false
            viewController?.enterButton.isEnabled = true
        }
        
        if contact.bodyA.node?.name == "enterCastle" && contact.bodyB.node?.name == "ball" || contact.bodyB.node?.name == "enterCastle" && contact.bodyA.node?.name == "ball"{
            viewController?.xpos = exitCastle.position.x
            viewController?.ypos = exitCastle.position.y
            viewController?.enterButton.isHidden = false
            viewController?.enterButton.isEnabled = true
        }
        
        if contact.bodyA.node?.name == "exitCastle" && contact.bodyB.node?.name == "ball" || contact.bodyB.node?.name == "exitCastle" && contact.bodyA.node?.name == "ball"{
            viewController?.xpos = enterCastle.position.x
            viewController?.ypos = enterCastle.position.y
            viewController?.enterButton.isHidden = false
            viewController?.enterButton.isEnabled = true
        }
        
        if contact.bodyA.node?.name == "enterPath" && contact.bodyB.node?.name == "ball" || contact.bodyB.node?.name == "enterPath" && contact.bodyA.node?.name == "ball"{
            viewController?.xpos = exitPath.position.x
            viewController?.ypos = exitPath.position.y
            viewController?.enterButton.isHidden = false
            viewController?.enterButton.isEnabled = true
        }
        
        if contact.bodyA.node?.name == "exitPath" && contact.bodyB.node?.name == "ball" || contact.bodyB.node?.name == "exitPath" && contact.bodyA.node?.name == "ball"{
            viewController?.xpos = enterPath.position.x
            viewController?.ypos = enterPath.position.y
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
        
        if contact.bodyA.node?.name == "ladder" && contact.bodyB.node?.name == "ball" || contact.bodyB.node?.name == "ladder" && contact.bodyA.node?.name == "ball"{
            viewController?.climbButton.isHidden = false
            viewController?.climbButton.isEnabled = true
        }
        
        if contact.bodyA.node?.name == "lava" && contact.bodyB.node?.name == "ball" || contact.bodyB.node?.name == "lava" && contact.bodyA.node?.name == "ball"{
            doRespawn = true
        }
        
        if contact.bodyA.node?.name == "stag" && contact.bodyB.node?.name == "ball" || contact.bodyB.node?.name == "stag" && contact.bodyA.node?.name == "ball"{
            doRespawn = true
        }
        
        if contact.bodyA.node?.name == "bed" && contact.bodyB.node?.name == "ball"{
            respawn.x = (contact.bodyA.node?.position.x)!
            respawn.y = (contact.bodyA.node?.position.y)! + 50
        } else if contact.bodyB.node?.name == "bed" && contact.bodyA.node?.name == "ball"{
            respawn.x = (contact.bodyB.node?.position.x)!
            respawn.y = (contact.bodyB.node?.position.y)! + 50
        }
        
        if contact.bodyA.node?.name == "bites" && contact.bodyB.node?.name == "ball"{
            contact.bodyA.node?.removeFromParent()
            viewController?.fillLabel.frame.size.width += 270/7.0
            bites += 1
        } else if contact.bodyB.node?.name == "bites" && contact.bodyA.node?.name == "ball"{
            contact.bodyB.node?.removeFromParent()
            viewController?.fillLabel.frame.size.width += 270/7.0
            bites += 1
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "enterCave" || contact.bodyB.node?.name == "enterCave"{
            viewController?.enterButton.isHidden = true
            viewController?.enterButton.isEnabled = false
        }
        
        if contact.bodyA.node?.name == "exitCave" || contact.bodyB.node?.name == "exitCave"{
            viewController?.enterButton.isHidden = true
            viewController?.enterButton.isEnabled = false
        }
        
        if contact.bodyA.node?.name == "enterCastle" || contact.bodyB.node?.name == "enterCastle"{
            viewController?.enterButton.isHidden = true
            viewController?.enterButton.isEnabled = false
        }
        
        if contact.bodyA.node?.name == "exitCastle" || contact.bodyB.node?.name == "exitCastle"{
            viewController?.enterButton.isHidden = true
            viewController?.enterButton.isEnabled = false
        }
        
        if contact.bodyA.node?.name == "enterPath" || contact.bodyB.node?.name == "enterPath"{
            viewController?.enterButton.isHidden = true
            viewController?.enterButton.isEnabled = false
        }
        
        if contact.bodyA.node?.name == "exitPath" || contact.bodyB.node?.name == "exitPath"{
            viewController?.enterButton.isHidden = true
            viewController?.enterButton.isEnabled = false
        }
        
        if contact.bodyA.node?.name == "ladder" || contact.bodyB.node?.name == "ladder"{
            climbing = false
            ball.physicsBody?.affectedByGravity = true
            viewController?.climbButton.isHidden = true
            viewController?.climbButton.isEnabled = false
        }
        
        if contact.bodyA.node?.name == "floor" || contact.bodyB.node?.name == "floor"{
            onFloor = false
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
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
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
        if bites == 7 {
            ball.position.x = 9091.958
            ball.position.y = 4611.239
            cam.setScale(3.0)
            bites = 0
        }
        if doRespawn{
            ball.position = respawn
            doRespawn = false
        }
        if goingLeft{
            ball.physicsBody?.velocity.dx = -750
        }
        if goingRight{
            ball.physicsBody?.velocity.dx = 750
        }
        if startTime == 0 {
            startTime = currentTime
        }
            if currentTime - lastUpdate >= 1 {
            let elapsedTime = Int(currentTime - startTime)
            viewController?.pointsLabel.text = "Time: \(elapsedTime)s"
            lastUpdate = currentTime
        }
    }
}
