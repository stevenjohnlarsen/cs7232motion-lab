//
//  ViewController.swift
//  MotionLab
//
//  Created by Steven Larsen on 10/6/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    // MARK: Setup
    override func viewDidLoad() {
	        super.viewDidLoad()
        //Load the steps
        self.activity.LoadTodaySteps(withHandler: self.HandleTodaySteps)
        self.activity.LoadYesterDaySteps(withHandler: HandleYesterDaySteps)
        
        //monitor the activity
        self.ableToMonitor = self.activity.startActivityMonitoring(withHandler: self.HandleActivity)
        if !self.ableToMonitor{
            self.activityImage.image = UIImage(named: "unknown.png")
        }
        
        //DELETE
        self.todayDaySteps = 50
        self.stepGoal = 200
        //END DELETE
        
        //set up the UI elements
        self.stepGoalLabel.text = String(self.stepGoal)
        self.updateProgress()
    }
    //MARK: Properties
    private var todayDaySteps:Int? = nil
    private var yesterDayDaySteps:Int? = nil
    private var isWalking: Bool = false
    private var isStationary: Bool = false
    private var isRunning: Bool = false
    private var isCylcing: Bool = false
    private var isUnknown: Bool = false
    private let activity: ActivityModel = ActivityModel.init()
    private let activityManager = CMMotionActivityManager()
    private var ableToMonitor: Bool = false
    private var stepGoal = 200
    
    //MARK: Outlets
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var stepProgress: UIProgressView!
    @IBOutlet weak var stepGoalLabel: UILabel!
    
    //MARK: Private Functions
    private func HandleTodaySteps(pedData:CMPedometerData?, error:Error?){
        if let steps = pedData?.numberOfSteps{
            DispatchQueue.main.async {
                self.todayDaySteps = Int(truncating: steps)
            }
        }
    }
    
    private func HandleYesterDaySteps(pedData:CMPedometerData?, error:Error?){
        if let steps = pedData?.numberOfSteps{
            DispatchQueue.main.async {
                self.yesterDayDaySteps = Int(truncating: steps)
            }
        }
    }
    
    private func HandleActivity(_ activity:CMMotionActivity?)-> Void {
        if let unwrappedActivity = activity {
            self.isWalking = unwrappedActivity.walking
            self.isStationary = unwrappedActivity.automotive
            self.isRunning = unwrappedActivity.running
            self.isCylcing = unwrappedActivity.cycling
            self.isUnknown = unwrappedActivity.unknown
        }
        self.setActivity()
    }
    
    private func setActivity(){
        DispatchQueue.main.async {
            //self.activity.GetActivity(handler: self.HandleActivity)
            if self.isWalking {
                self.activityImage.image = UIImage(named:"walk.png")
            }
            else if self.isStationary {
                self.activityImage.image = UIImage(named:"sit.png")
            }
            else if self.isRunning {
                self.activityImage.image = UIImage(named:"running.png")
            }
            else if self.isCylcing{
                self.activityImage.image = UIImage(named:"cycling.png")
            }
            else{
                self.activityImage.image = UIImage(named:"unknown.png")
            }
        }
    }
    
    private func updateProgress(){
        if let steps = self.todayDaySteps{
            let value =  Float(steps) / Float(self.stepGoal)
            self.stepProgress.setProgress(value, animated: false)
        }
    }
}
