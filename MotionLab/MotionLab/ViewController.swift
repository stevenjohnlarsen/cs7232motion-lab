//
//  ViewController.swift
//  MotionLab
//
//  Created by Steven Larsen on 10/6/21.
//

import UIKit
import CoreMotion
import Charts

class ViewController: UIViewController, ChartViewDelegate{
    
    var pieChartToday = PieChartView()
    var pieChartYesterDay = PieChartView()

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
        self.yesterDayDaySteps = 210
        self.stepGoal = 200
        //END DELETE
        
        //set up the UI elements
        pieChartToday.delegate = self
        pieChartYesterDay.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        //calculate values of the pie chart
        var stepsDisplayedToday = 0
        var stepsLeftToday = self.stepGoal
        var stepsDisplayedYesterday = 0
        var stepsLeftYesterday = self.stepGoal
        
        if let todaySteps = self.todayDaySteps{
            if todaySteps > self.stepGoal {
                stepsDisplayedToday = stepGoal
                stepsLeftToday = 0
            }
            else{
                stepsDisplayedToday = todaySteps
                stepsLeftToday = stepGoal - todaySteps
            }
        }
        if let yesterdaySteps = self.yesterDayDaySteps{
            if yesterdaySteps > self.stepGoal {
                stepsDisplayedYesterday = stepGoal
                stepsLeftYesterday = 0
            }
            else{
                stepsDisplayedYesterday = yesterdaySteps
                stepsLeftYesterday = stepGoal - yesterdaySteps
            }
        }
        //Setup the Today graph
        let frameToday = CGRect(x:0,
                     y: self.view.frame.size.height / 3.0,
                     width: self.view.frame.size.width / 2.0,
                     height: self.view.frame.size.height / 2.0)
        
        let frameYesterday = CGRect(x:self.view.frame.size.width / 2.0,
                     y: self.view.frame.size.height / 3.0,
                     width: self.view.frame.size.width / 2.0,
                     height: self.view.frame.size.height / 2.0)
        
        self.renderChart(chart:self.pieChartToday, frame:frameToday, stepsDisplayed: stepsDisplayedToday, stepsLeft: stepsLeftToday, title: "Today")
        self.renderChart(chart: self.pieChartYesterDay, frame: frameYesterday, stepsDisplayed: stepsDisplayedYesterday, stepsLeft: stepsLeftYesterday, title: "Yesterday")
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
    private func renderChart(chart: PieChartView, frame: CGRect, stepsDisplayed: Int, stepsLeft: Int, title:String){
        
        var label = UILabel()
        label.text = title
        
        chart.frame = frame
        view.addSubview(chart)
        var data = PieChartDataSet()
        data = PieChartDataSet(entries: [
            ChartDataEntry(x: 1, y: Double(stepsDisplayed)),
            ChartDataEntry(x: 2, y: Double(stepsLeft))
        ])
        data.colors = [UIColor.init(red: 78/255.0, green: 120/255.0, blue: 85/255.0, alpha: 1), .red]
        chart.data = PieChartData(dataSet:data)
        chart.legend.enabled = false
        
        label.frame = CGRect(x:frame.minX + (frame.width / 3),
                             y:frame.minY + (frame.height / 6),
                             width: CGFloat(title.count) * 10,
                             height:20)
        
        self.view.addSubview(label)
        
    }
}
