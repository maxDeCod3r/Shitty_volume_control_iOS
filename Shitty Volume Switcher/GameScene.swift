//
//  GameScene.swift
//  Shitty Volume Switcher
//
//  Created by Max Hunt on 28/11/2019.
//  Copyright © 2019 smt. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import MediaPlayer

var motionManager: CMMotionManager!


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    var lastTouchPosition: CGPoint?
    var ball: SKSpriteNode!
    
    let ballCategory: UInt32 = 0x1
    
    var button: SKNode! = nil


    
    override func didMove(to view: SKView) {
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        physicsWorld.contactDelegate = self
        
        
        
        
//        let collider = SKSpriteNode(imageNamed: "collider")
//        collider.setScale(2)
//        collider.physicsBody = SKPhysicsBody(rectangleOf: collider.size)
//        collider.physicsBody?.restitution = 0.4
//        collider.physicsBody?.isDynamic = false
//        collider.position = CGPoint(x: 0, y: -150)
//        collider.physicsBody?.linearDamping = 0.5
//        addChild(collider)
        
        physicsWorld.gravity = .zero
        
        ball = SKSpriteNode(imageNamed: "ball")
        ball.setScale(2.5)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.restitution = 0.7
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.zPosition = 5
        addChild(ball)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
    let contactNode = contact.bodyA.node as! SKSpriteNode
        MPVolumeView.setVolume(Float(contact.bodyA.contactTestBitMask)/31)
        let scale = SKAction.scale(by: 0.7, duration: 0.15)
        let reverseScale = scale.reversed()
        let actions = [scale, reverseScale]
        let sequence = SKAction.sequence(actions)
        contactNode.run(sequence)
        print(contact.bodyA.contactTestBitMask)
//        print(contact.bodyB.categoryBitMask)
//    if (contact.bodyA.categoryBitMask == 1) &&
//        (contact.bodyB.categoryBitMask == 2) {
//        print("here")
//
//        }
    }
    

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        lastTouchPosition = location
//    }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        lastTouchPosition = location
//    }
//
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        lastTouchPosition = nil
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
            // Check if the location of the touch is within the button's bounds
            if button.contains(touchLocation) {
                MPVolumeView.setVolume(0.5)
            }
    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * 10, dy: accelerometerData.acceleration.x * -10)
        }
        
    }
    
    
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        // Need to use the MPVolumeView in order to change volume, but don't care about UI set so frame to .zero
        let volumeView = MPVolumeView(frame: .zero)
        // Search for the slider
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        // Update the slider value with the desired volume.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
        // Optional - Remove the HUD
//        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//            volumeView.alpha = 0.000001
//            window.addSubview(volumeView)
//        }
    }
}
