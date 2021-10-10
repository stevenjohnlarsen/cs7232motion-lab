//
//  BlockBase.swift
//  MotionLab
//
//  Created by Nicholas Larsen on 10/8/21.
//

import Foundation
import SpriteKit

protocol BlockBase {
    
    var screenSize: CGSize {
        get
    }
    var angle:Double {
        get set
    }
    var node: SKShapeNode {
        get
    }
    var rotationDisplace: Dictionary<Double, CGPoint> {
        get
    }
}

extension BlockBase {
    
    func setPhysics() {
        node.physicsBody?.restitution = 0.2
        node.physicsBody?.isDynamic = true
        // for collision detection we need to setup these masks
        node.physicsBody?.contactTestBitMask = 0x00000001
        node.physicsBody?.collisionBitMask = 0x00000001
        node.physicsBody?.categoryBitMask = 0x00000001
        node.physicsBody?.pinned = false

        node.physicsBody?.allowsRotation = false
    }
    
    func getBlockWidth(size:CGSize) -> CGSize{
        return CGSize(width: size.width*0.1 - 0.1,
                      height: size.width*0.1 - 0.1)
    }
    
    mutating func rotate() {
        angle = angle + 0.5
        let blockWidth = CGSize(width: screenSize.width*0.1, height: screenSize.width*0.1)
        
        
        node.physicsBody?.node?.zRotation = .pi*angle
        if angle == 2.0 {
            angle = 0.0
        }
        if let delta = rotationDisplace[angle] {
            translate(block: blockWidth,
                      position: &node.position,
                      x: delta.x,
                      y: delta.y)
        }
    }
    
    private func translate(block:CGSize, position:inout CGPoint, x:CGFloat, y:CGFloat){
        position.x = node.position.x + x*block.width
        position.y = node.position.y + y*block.width
    }
    
}
