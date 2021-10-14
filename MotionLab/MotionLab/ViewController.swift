//
//  ViewController.swift
//  MotionLab
//
//  Created by Steven Larsen on 10/6/21.
//

import UIKit
import CoreMotion
import Charts
import simd

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
        self.todayDaySteps = 201
        self.yesterDayDaySteps = 210
        //END DELETE
        
        //set up the UI elements
        pieChartToday.delegate = self
        pieChartYesterDay.delegate = self
        goalInput.delegate = self
        
        self.goalInput.text = String(self.stepGoal)

        self.updatePlayButtonText()
    }
    
    override func viewDidLayoutSubviews() {
        //Setup the Today graph
        setUpTodayChart()
        setUpYesterdayChart()
    }
    
    func setUpTodayChart() {
        
        view.addSubview(pieChartToday)
        pieChartToday.legend.enabled = false

        pieChartToday.translatesAutoresizingMaskIntoConstraints = false
        // Add constraints for the
        NSLayoutConstraint.activate([
            pieChartToday.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/4),
            pieChartToday.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pieChartToday.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            pieChartToday.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])

        
        // Set up auto layout constraints with the title label
        let todayLabel = UILabel()
        todayLabel.text = "Today"
        view.addSubview(todayLabel)

        todayLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            todayLabel.centerXAnchor.constraint(equalTo: pieChartToday.centerXAnchor),
            todayLabel.centerYAnchor.constraint(equalTo: pieChartToday.centerYAnchor),
            todayLabel.widthAnchor.constraint(equalToConstant: 50),
            todayLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setUpYesterdayChart() {
        
        view.addSubview(pieChartYesterDay)
        pieChartYesterDay.legend.enabled = false

        pieChartYesterDay.translatesAutoresizingMaskIntoConstraints = false
        // Add constraints for the
        NSLayoutConstraint.activate([
            pieChartYesterDay.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width/4),
            pieChartYesterDay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pieChartYesterDay.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            pieChartYesterDay.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        // Set up auto layout constraints with the title label
        let yesterdayLabel = UILabel()
        yesterdayLabel.textAlignment = .center
        yesterdayLabel.text = "Yesterday"
        view.addSubview(yesterdayLabel)

        yesterdayLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            yesterdayLabel.centerXAnchor.constraint(equalTo: pieChartYesterDay.centerXAnchor),
            yesterdayLabel.centerYAnchor.constraint(equalTo: pieChartYesterDay.centerYAnchor),
            yesterdayLabel.widthAnchor.constraint(equalToConstant: 80),
            yesterdayLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.updateBothCharts()
    }
    
    //MARK: Properties
    private var todayDaySteps:Int? = nil {
        didSet{
            DispatchQueue.main.async {
                self.updateBothCharts()
            }
            self.updatePlayButtonText()
        }
        
    }
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
            updatePlayButtonText()
            textField.resignFirstResponder()
            return true
        }
        else {
            textField.resignFirstResponder()
            return false
        }
    }
    private func updatePlayButtonText(){
        if let steps = self.todayDaySteps{
            if self.stepGoal > steps {
                DispatchQueue.main.async {
                    self.playButton.setTitle("Not Enough Steps", for: .normal)
                }
            }
            else{
                DispatchQueue.main.async {
                    self.playButton.setTitle("Play Game", for: .normal)
                }
            }
        }
    }
    	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let steps = self.todayDaySteps{
            if self.stepGoal > steps{
                return false
            }
        }
        return true
    }
}
