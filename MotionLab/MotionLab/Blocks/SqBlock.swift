//
//  RLBlock.swift
//  MotionLab
//
//  Created by Nicholas Larsen on 10/8/21.
//

// Reverse L Block

import Foundation
import SpriteKit

class SqBlock: BlockBase {
    
    var rotationDisplace: Dictionary<Double, CGPoint>
    var node: SKShapeNode
    var screenSize: CGSize
    var angle: Double
    
    init(screenSize: CGSize) {
        self.screenSize = screenSize
        self.angle = 0.0
        self.rotationDisplace = [
            0.5: CGPoint(x:  2.0, y: 0.0),
            1.0: CGPoint(x:  0.0, y: 2.0),
            1.5: CGPoint(x: -2.0, y: 0.0),
            2.0: CGPoint(x:  0.0, y: -2.0),
            0.0: CGPoint(x:  0.0, y: -2.0)
        ]
                
        node = SKShapeNode()
        
        let blockWidth = getBlockWidth(size:screenSize)
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x:0, y:0))
        path.addLine(to: CGPoint(x:blockWidth.width*2, y:0))
        path.addLine(to: CGPoint(x:blockWidth.width*2, y:blockWidth.width*2))
        path.addLine(to: CGPoint(x:0, y:blockWidth.width*2))
        path.addLine(to: CGPoint(x:0, y:0))
        
        node = SKShapeNode(path: path)
        
        node.lineWidth = 1
        node.fillColor = .blue
        
        let randNumber = GameScene.random(min: CGFloat(0.1), max: CGFloat(0.9))
        node.physicsBody = SKPhysicsBody(polygonFrom: path)
        node.position = CGPoint(x: screenSize.width * randNumber, y: screenSize.height * 0.75)
        setPhysics()
        
    }
}
