//
//  GameViewController.swift
//  MotionLab
//
//  Created by Nicholas Larsen on 10/6/21.
//

import UIKit
import SpriteKit
import CoreMotion

class GameViewController: UIViewController {

    
    // MARK: UI Outlets
    @IBOutlet weak var testingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView // the view in storyboard must be an SKView

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true

        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        

        // Do any additional setup after loading the view.
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portraitUpsideDown
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
