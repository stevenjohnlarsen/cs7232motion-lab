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
        angle = angle + .pi/2
        if angle == .pi*2 {
            angle = 0
        }
        node.physicsBody?.node?.zRotation = angle
    }
    
}
