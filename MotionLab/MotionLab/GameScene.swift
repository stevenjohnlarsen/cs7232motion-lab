//
//  Adopted from GameScene.swift
//  Commotion
//
//  Created by Nick larsen on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var numBlockTypes = 1
    var lockedBlocks:[BlockBase] = []
    var lost:Bool = false
    enum BlockTypes {
        case LINE_BLOCK
        case TBLOCK
        case SBLOCK
        case RSBLOCK
        case LBLOCK
        case RLBLOCK
        case SQ_BLOCK
    }

    var activePiece:BlockBase? = nil
    var activePieceStartingPoint:CGPoint = CGPoint(x: 0.0,y: 0.0)
    
    // MARK: Raw Motion Functions
    let motion = CMMotionManager()
    func startMotionUpdates(){
        // if motion is available, start updating the device motion
        if self.motion.isDeviceMotionAvailable{
            self.motion.deviceMotionUpdateInterval = 0.2
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: self.handleMotion )
        }
    }
    
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        // make gravity in the game als the simulator gravity\
        
        if let gravity = motionData?.gravity {
            self.physicsWorld.gravity = CGVector(dx: CGFloat(9.8*gravity.x), dy: -1.0)
        }
    }
    
    // MARK: View Hierarchy Functions
    // this is like out "View Did Load" function
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.white
        
        // start motion for gravity
        self.startMotionUpdates()
        
        // make sides to the screen
        self.addSidesAndTop()
        
        // add in the interaction sprite
        self.addNewBlock()
        
        // add a scorer
        self.addScore()
        
        // update a special watched property for score
        self.score = 0
    }
    
    // MARK: Create Sprites Functions
    let bottom = SKSpriteNode()
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var score:Int = 0 {
        willSet(newValue){
            DispatchQueue.main.async{
                self.scoreLabel.text = "Score: \(newValue)"
            }
        }
    }
    
    func addScore(){

    }
    
    
    func addNewBlock(){
        
        let randy:BlockTypes = [
            BlockTypes.LINE_BLOCK,
            BlockTypes.TBLOCK,
            BlockTypes.SBLOCK,
            BlockTypes.RSBLOCK
//            ,BlockTypes.LBLOCK
        ].randomElement() as! GameScene.BlockTypes
        
        var block:BlockBase?
        switch randy {
        case BlockTypes.LINE_BLOCK:
            block = LineBlock(screenSize: size)
        case BlockTypes.TBLOCK:
            block = TBlock(screenSize: size)
        case BlockTypes.SBLOCK:
            block = SBlock(screenSize: size)
        case BlockTypes.RSBLOCK:
            block = RSBlock(screenSize: size)
        case BlockTypes.LBLOCK:
            block = LBlock(screenSize: size)
        case .RLBLOCK:
            block = RLBlock(screenSize: size)
        case .SQ_BLOCK:
            block = SqBlock(screenSize: size)
        }
        
        self.addChild(block!.node)
        activePiece = block
        activePieceStartingPoint = block!.node.position
    }
    
    func addSidesAndTop(){
        let left = SKSpriteNode()
        let right = SKSpriteNode()
        let top = SKSpriteNode()
        
        print(size)
        
        left.size = CGSize(width:size.width*0.1,height:size.height)
        left.position = CGPoint(x:0, y:size.height*0.5)
        
        right.size = CGSize(width:size.width*0.1,height:size.height)
        right.position = CGPoint(x:size.width, y:size.height*0.5)
        
        top.size = CGSize(width:size.width,height:size.height*0.1)
        top.position = CGPoint(x:size.width*0.5, y:size.height)
        
        bottom.size = CGSize(width:size.width, height:size.height*0.1)
        bottom.position = CGPoint(x:size.width*0.5, y:0)
        
        for obj in [left,right,top,bottom]{
            obj.color = UIColor.red
            obj.physicsBody = SKPhysicsBody(rectangleOf:obj.size)
            obj.physicsBody?.isDynamic = true
            obj.physicsBody?.pinned = true
            obj.physicsBody?.allowsRotation = false
            self.addChild(obj)
        }
    }
    
    // MARK: =====Delegate Functions=====
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if var piece = activePiece {
            DispatchQueue.main.async {
                piece.rotate()
            }
            
        }
    }
    
    // here is our collision function
    func didBegin(_ contact: SKPhysicsContact) {
        
        var tetrisBlock:SKNode? = nil
        var otherContact:SKNode? = nil
        if contact.bodyA.node == activePiece?.node {
            tetrisBlock = contact.bodyA.node
            otherContact = contact.bodyB.node
        } else if contact.bodyB.node == activePiece?.node {
            tetrisBlock = contact.bodyB.node
            otherContact = contact.bodyA.node
        }
        
        if let t = tetrisBlock, let o = otherContact {
            
            var found = false
            for n in lockedBlocks {
                if n.node == o {
                    found = true // the other contact was one of the locked pieces
                }
            }
            
            if o == bottom || found {
                if activePieceStartingPoint == activePiece!.node.position {
                    lost = true
                }
                t.physicsBody?.pinned = true
                lockedBlocks.append(activePiece!)
                if !self.lost {
                    addNewBlock()
                }
                
                return
            }
        }
    }
    
    // MARK: Utility Functions (thanks ray wenderlich!)
    // generate some random numbers for cor graphics floats
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(Int.max))
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
