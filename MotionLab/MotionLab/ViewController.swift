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
        self.activity.LoadTodaySteps(withHandler: self.HandleTodaySteps)
        self.activity.LoadYesterDaySteps(withHandler: HandleYesterDaySteps)
        self.activity.GetActivity(handler: self.HandleActivity)
        // Do any additional setup after loading the view.
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
    }
    
}

