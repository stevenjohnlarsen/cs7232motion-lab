//
//  ViewController.swift
//  MotionLab
//
//  Created by Steven Larsen on 10/6/21.
//

import UIKit
import CoreMotion
import Charts

class ViewController: UIViewController, ChartViewDelegate, UITextFieldDelegate{
    
    var pieChartToday = PieChartView()
    var pieChartYesterDay = PieChartView()
    @IBOutlet var viewOutlet: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    var button:UIButton = UIButton()
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
        //Get the goal
        self.stepGoal = activity.getStepGoal()
        
        //DELETE
        self.todayDaySteps = 50
        self.yesterDayDaySteps = 210
        //END DELETE
        
        //set up the UI elements
        pieChartToday.delegate = self
        pieChartYesterDay.delegate = self
        goalInput.delegate = self
        
        self.goalInput.text = String(self.stepGoal)
        
        DispatchQueue.main.async {
            self.button = UIButton()
            print(self.button.constraints)
            self.button.setTitle("Click Here", for: .normal)
            self.button.setTitleColor(UIColor.blue, for: .normal)
            self.view.addSubview(self.button)
            
//            self.button.frame = CGRect(x: 100, y: 100, width: 300, height: 500)
            self.button.widthAnchor.constraint(equalToConstant: 300).isActive = true
            self.button.heightAnchor.constraint(equalToConstant: 500).isActive = true
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 10).isActive = true
            self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        }


    }
    
    override func viewDidLayoutSubviews() {
        //Setup the Today graph
        let frameToday = CGRect(x:0,
                     y: self.view.frame.size.height / 3.0,
                     width: self.view.frame.size.width / 2.0,
                     height: self.view.frame.size.height / 2.0)
        
        let frameYesterday = CGRect(x:self.view.frame.size.width / 2.0,
                     y: self.view.frame.size.height / 3.0,
                     width: self.view.frame.size.width / 2.0,
                     height: self.view.frame.size.height / 2.0)
        
        self.renderChart(chart:self.pieChartToday, frame:frameToday, title: "Today")
        self.renderChart(chart: self.pieChartYesterDay, frame: frameYesterday, title: "Yesterday")
        self.updateBothCharts()
        
        
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
    private var stepGoal = 200 {
        didSet{
            DispatchQueue.main.async {
                self.updateBothCharts()
            }
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var goalInput: UITextField!
    
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
    @IBOutlet weak var testlabel: UILabel!
    private func renderChart(chart: PieChartView, frame: CGRect, title:String){
        
//        let label = UILabel()
//        label.text = title
//        label.text = title
//
//        chart.frame = frame
//        view.addSubview(chart)
//        chart.legend.enabled = false
//
//        self.view.addSubview(label)
//
//        label.frame = CGRect(x:frame.minX + (frame.width / 4),
//                             y:frame.minY + (frame.height / 6),
//                             width: CGFloat(title.count) * 10,
//                             height:20)
//
  
//        NSLayoutConstraint(item: labeltest!,
//                           attribute: .width,
//                           relatedBy: .equal,
//                           toItem: nil,
//                           attribute: .notAnAttribute,
//                           multiplier: 1,
//                           constant: CGFloat(title.count*10)).isActive = true
//
//        NSLayoutConstraint(item: labeltest!,
//                           attribute: .height,
//                           relatedBy: .equal,
//                           toItem: nil,
//                           attribute: .notAnAttribute,
//                           multiplier: 1,
//                           constant: 20).isActive = true
//
//        NSLayoutConstraint(item: labeltest!,
//                           attribute: .centerX,
//                           relatedBy: .equal,
//                           toItem: view,
//                           attribute: .centerX,
//                           multiplier: 1,
//                           constant: 0).isActive = true
//
//        NSLayoutConstraint(item:labeltest!,
//                           attribute: .centerY,
//                           relatedBy: .equal,
//                           toItem: view,
//                           attribute: .centerY,
//                           multiplier: 1,
//                           constant: 0).isActive = true
    
    }
    private func updateBothCharts(){
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
        self.updateChartValues(chart: self.pieChartToday, stepsLeft: stepsLeftToday, steps: stepsDisplayedToday)
        self.updateChartValues(chart: self.pieChartYesterDay, stepsLeft: stepsLeftYesterday, steps: stepsDisplayedYesterday)
    }
    
    private func updateChartValues(chart:PieChartView, stepsLeft:Int, steps:Int){
        var data = PieChartDataSet()
        data = PieChartDataSet(entries: [
            ChartDataEntry(x: 1, y: Double(steps)),
            ChartDataEntry(x: 2, y: Double(stepsLeft))
        ])
        data.colors = [UIColor.init(red: 78/255.0, green: 120/255.0, blue: 85/255.0, alpha: 1), .red]
        chart.data = PieChartData(dataSet:data)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let num = Int(textField.text!){
            self.stepGoal = num
            return true
        }
        else {
            return false
        }
    }
}
