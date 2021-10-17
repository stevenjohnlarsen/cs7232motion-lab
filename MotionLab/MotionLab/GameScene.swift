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
    
    
    var amountOfSwaps = 0
    private let activity: ActivityModel = ActivityModel.init()
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
//            self.physicsWorld.gravity = CGVector(dx: CGFloat(0.0), dy: 0.0)
        }
    }
    
    // MARK: View Hierarchy Functions
    // this is like out "View Did Load" function
    override func didMove(to view: SKView) {
    
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.white
        self.amountOfSwaps = activity.GetTodaySteps() - activity.getStepGoal()
        if self.amountOfSwaps < 0 {
            self.amountOfSwaps = 0
        }
        
        self.removeAllChildren()
        
        // make sides to the screen
        self.addSidesAndTop()
        
        // add a scorer
        self.addScore()
        
        // update a special watched property for score
        self.score = 0
        
        self.amountOfSwaps = 10
        
        self.addSwapButton()
        
        self.addNewBlock()
    
        
        // start motion for gravity
        self.startMotionUpdates()
    }
    
    override func sceneDidLoad() {
    }
    // MARK: Create Sprites Functions
    let bottom = SKSpriteNode()
    let scoreLabel = SKLabelNode(fontNamed: "Courier-BoldOblique")
    var score:Int = 0 {
        willSet(newValue){
            DispatchQueue.main.async{
                self.scoreLabel.text = "Score: \(newValue)"
            }
        }
    }
    
    func addScore(){
        scoreLabel.text = "Score: 1"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y:frame.minY)
        
        addChild(scoreLabel)
    }
    
    // Swap button
    let swapButton = SKLabelNode(fontNamed: "Courier-BoldOblique")
    func addSwapButton() {
        self.swapTextChange()
        swapButton.fontSize = 20
        swapButton.position = CGPoint(x: frame.midX+70, y: frame.maxY-80)
        swapButton.name = "SwapFalling"
        swapButton.physicsBody?.isDynamic = false
        addChild(swapButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func swapActive() {
        if self.amountOfSwaps > 0 {
            activePiece?.node.removeFromParent()
            self.amountOfSwaps -= 1
            addNewBlock(force: true)
            self.swapTextChange()
        }
    }
    func swapTextChange() {
        if self.amountOfSwaps > 0 {
            swapButton.text = "Swap (\(self.amountOfSwaps))"
            swapButton.fontColor = SKColor.blue
        }
        else{
            swapButton.text = "OUT OF SWAPS"
            swapButton.fontColor = SKColor.red
        }
    }
    func addNewBlock(force:Bool=false){
        
        // if the piece is now falling bail and cotinue
        if let piece = activePiece, let pBody = piece.node.physicsBody {
            if pBody.velocity.dy < -0.00001 && !force {
                return
            }
            pBody.pinned = true
        }
        
        // The block is not falling, add new block and award a score.
        if !force {
            score += 1
        }
        
        if lost {
            return
        }
        
        let randy:BlockTypes = [
            BlockTypes.LINE_BLOCK,
            BlockTypes.TBLOCK,
            BlockTypes.SBLOCK,
            BlockTypes.RSBLOCK,
            BlockTypes.LBLOCK,
            BlockTypes.RLBLOCK,
            BlockTypes.SQ_BLOCK
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
        
        activePiece?.node.physicsBody?.velocity.dy = -0.001
    }
    
    func addSidesAndTop(){
        let left = SKSpriteNode()
        let right = SKSpriteNode()
        let top = SKSpriteNode()
        
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
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "SwapFalling" {
                swapActive()
                return
            }
        }
        if var piece = activePiece {
            DispatchQueue.main.async {
                piece.rotate()
            }
            
        }
    }
    
    // here is our collision function
    func didBegin(_ contact: SKPhysicsContact) {
        
        var tetrisBlock:SKNode? = nil
        if contact.bodyA.node == activePiece?.node {
            tetrisBlock = contact.bodyA.node
        } else if contact.bodyB.node == activePiece?.node {
            tetrisBlock = contact.bodyB.node
        }
        
        if let t = tetrisBlock {
            
            if let pBody = t.physicsBody {
                if activePieceStartingPoint == activePiece!.node.position {
                    lost = true
                    pBody.pinned = true
                    showLostScreen()
                }
                if pBody.velocity.dy >= 0.0 && !lost {
                    pBody.velocity.dy = 0.0
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.addNewBlock()
                    }
                }
            }
        }
    }
    
    func showLostScreen() {
        self.removeAllChildren()
        let gameOver = SKLabelNode(fontNamed: "Courier-BoldOblique")
        gameOver.text = "Game Over!!"
        gameOver.fontColor = .blue
        self.addChild(gameOver)
        gameOver.position = CGPoint(x:size.width/2, y:size.height/2)
        
        let score = SKLabelNode(fontNamed: "Courier-BoldOblique")
        score.text = "Your Score: \(self.score)"
        score.fontColor = .blue
        self.addChild(score)
        score.position = CGPoint(x:size.width/2, y:size.height/2 - gameOver.frame.size.height - 5)
    }
    
    // MARK: Utility Functions (thanks ray wenderlich!)
    // generate some random numbers for cor graphics floats
    static func random() -> CGFloat {
//        let randy = CGFloat(Float(arc4random()) / Float(Int.max))
        let randy = Float.random(in: 0..<1)
        return CGFloat(randy)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        let randy = random() * (max - min) + min
        return randy
    }
}
