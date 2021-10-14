//
//  ActivityModel.swift
//  MotionLab
//
//  Created by Steven Larsen on 10/6/21.
//

import Foundation
import CoreMotion

class ActivityModel {
    //MARK: Properties
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    let motion = CMMotionManager()
    let defaults = UserDefaults.init()
    
    private var isWalking: Bool = false
    private var isStationary: Bool = false
    private var isRunning: Bool = false
    private var isCylcing: Bool = false
    private var isUnknown: Bool = false
    private var yesterDaySteps:Int? = nil
    private var todayDaySteps:Int? = nil
    
    //MARK: Public Functions
    func GetActivity(handler:@escaping CMMotionActivityHandler) {
        activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: handler)
    }
    
    public  func LoadYesterDaySteps(withHandler:@escaping CMPedometerHandler){
        let range = GetYesterDayDateRange()
        if CMPedometer.isStepCountingAvailable(){
            pedometer.queryPedometerData(from: range.1, to: range.0,withHandler: withHandler)
        }
    }
    
    public func LoadTodaySteps(withHandler:@escaping CMPedometerHandler){
        let range = GetTodayDateRange()
        if CMPedometer.isStepCountingAvailable(){
            pedometer.queryPedometerData(from: range.1, to: range.0, withHandler: withHandler)
        }
    }
    
    //MARK: Private Fucntions
    public func GetTodayDateRange() -> (Date,Date) {
        let to = Date()
        let from =  Calendar.current.startOfDay(for: Date())
        return (to,from)
    }
    
    public  func GetYesterDayDateRange() -> (Date,Date){
        let to = Calendar.current.startOfDay(for: Date())
        let from = Date(timeInterval: -60*60*25, since: to)
        return (to,from)
    }
    public func startActivityMonitoring(withHandler:@escaping CMMotionActivityHandler) -> Bool{        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
    // update from this queue (should we use the MAIN queue here??.... )
            DispatchQueue.main.async {
                self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: withHandler)
            }
            return true
        }
        else{
            return false
        }
    }
    public func getStepGoal() -> Int {
        let steps = defaults.integer(forKey: "stepGoal")
        if steps == 0{
            defaults.setValue(200, forKey:"stepGoal")
            return 200
        }
        else {
            return steps
        }
    }
    
    public func setStepGoal(steps:Int){
        defaults.setValue(steps, forKey:"stepGoal")
    }
}
