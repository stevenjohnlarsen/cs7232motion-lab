//
//  TBlock.swift
//  MotionLab
//
//  Created by Nicholas Larsen on 10/8/21.
//

import Foundation
import SpriteKit

class RSBlock: BlockBase {
    
    var rotationDisplace: Dictionary<Double, CGPoint>
    var node: SKShapeNode
    var screenSize: CGSize
    var angle: Double
    
    init(screenSize: CGSize) {
        self.screenSize = screenSize
        self.angle = 0.0
        self.rotationDisplace = [
            0.5: CGPoint(x: 2.5, y: 0.5),
            1.0: CGPoint(x: -0.5, y: 2.5),
            1.5: CGPoint(x: -2.5, y: -0.5),
            2.0: CGPoint(x: 0.5, y: -2.5),
            0.0: CGPoint(x: 0.5, y: -2.5)
        ]
                
        node = SKShapeNode()
        
        let blockWidth = getBlockWidth(size:screenSize)
        let path = CGMutablePath()

        path.move(to: CGPoint(x:0, y:blockWidth.height))
        path.addLine(to: CGPoint(x:blockWidth.width, y:blockWidth.height))
        path.addLine(to: CGPoint(x:blockWidth.width, y:0))
        path.addLine(to: CGPoint(x:blockWidth.width*2, y:0))
        path.addLine(to: CGPoint(x:blockWidth.width*2, y:blockWidth.height*2))
        path.addLine(to: CGPoint(x:blockWidth.width, y:blockWidth.height*2))
        path.addLine(to: CGPoint(x:blockWidth.width, y:blockWidth.height*3))
        path.addLine(to: CGPoint(x:0, y:blockWidth.height*3))
        path.addLine(to: CGPoint(x:0, y:blockWidth.height))
        
        
        node = SKShapeNode(path: path)
        
        node.lineWidth = 1
        node.fillColor = .red
        
        let pathPhysics = CGMutablePath()
        let d = self.getDelta()
        
        pathPhysics.move(to: CGPoint(x:0 + d, y:blockWidth.height + d))
        pathPhysics.addLine(to: CGPoint(x:blockWidth.width + d, y:blockWidth.height + d))
        pathPhysics.addLine(to: CGPoint(x:blockWidth.width + d, y:0 + d))
        pathPhysics.addLine(to: CGPoint(x:blockWidth.width*2 - d, y:0 + d))
        pathPhysics.addLine(to: CGPoint(x:blockWidth.width*2 - d, y:blockWidth.height*2 - d))
        pathPhysics.addLine(to: CGPoint(x:blockWidth.width - d , y:blockWidth.height*2 - d))
        pathPhysics.addLine(to: CGPoint(x:blockWidth.width - d, y:blockWidth.height*3 - d))
        pathPhysics.addLine(to: CGPoint(x:0 + d, y:blockWidth.height*3 - d))
        pathPhysics.addLine(to: CGPoint(x:0 + d, y:blockWidth.height + d))
        
        node.physicsBody = SKPhysicsBody(polygonFrom: pathPhysics)
        node.physicsBody?.friction = 0
        
        let randNumber = GameScene.random(min: CGFloat(1.0*blockWidth.width),
                                          max: CGFloat(7.0*blockWidth.width))
        
        node.position = CGPoint(x: randNumber, y: screenSize.height * 0.75)

        setPhysics()
        
    }
}
