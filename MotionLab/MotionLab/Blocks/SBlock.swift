
import Foundation
import SpriteKit

class SBlock: BlockBase {
    
    var rotationDisplace: Dictionary<Double, CGPoint>
    var node: SKShapeNode
    var screenSize: CGSize
    var angle: Double
    
    init(screenSize: CGSize) {
        self.screenSize = screenSize
        self.angle = 0.0
        self.rotationDisplace = [
            0.5: CGPoint(x: 2.5,  y:0.5),
            1.0: CGPoint(x: -0.5, y: 2.5),
            1.5: CGPoint(x: -2.5, y:-0.5),
            2.0: CGPoint(x: 0.5,  y:-2.5),
            0.0: CGPoint(x: 0.5,  y:-2.5)
        ]
                
        node = SKShapeNode()
        
        let blockWidth = getBlockWidth(size:screenSize)
        let path = CGMutablePath()

        path.move(to: CGPoint(x:0, y:0))
        path.addLine(to: CGPoint(x:blockWidth.width,y:0))
        path.addLine(to: CGPoint(x:blockWidth.width,y:blockWidth.height))
        path.addLine(to: CGPoint(x:blockWidth.width*2,y:blockWidth.height))
        path.addLine(to: CGPoint(x:blockWidth.width*2,y:blockWidth.height*3))
        path.addLine(to: CGPoint(x:blockWidth.width,y:blockWidth.height*3))
        path.addLine(to: CGPoint(x:blockWidth.width,y:blockWidth.height*2))
        path.addLine(to: CGPoint(x:0,y:blockWidth.height*2))
        path.addLine(to: CGPoint(x:0,y:0))
        node = SKShapeNode(path: path)
        
        node.lineWidth = 1
        node.fillColor = .blue
        
        let randNumber = GameScene.random(min: CGFloat(0.1), max: CGFloat(0.9))
        node.position = CGPoint(x: screenSize.width * randNumber, y: screenSize.height * 0.75)

        node.physicsBody = SKPhysicsBody(polygonFrom: path)
        setPhysics()
        
    }
}
