//
//  ViewController.swift
//  SimpleTimer(swift)
//
//  Created by Xinyuan Wang on 12/11/16.
//  Copyright © 2016 AlexW. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerInput: UITextField!
    
    var interval: Int = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timerLabel.layer.borderColor = UIColor.lightGray.cgColor
        timerLabel.layer.borderWidth = 0.2
        timerLabel.text = "00:00:00"
        startButton.setTitle("start", for: UIControlState.normal)
        startButton.isEnabled = false
        
        let center = UNUserNotificationCenter.current()
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION", title: "snooze", options: UNNotificationActionOptions(rawValue: 0))
        let category = UNNotificationCategory(identifier: "TIME_EXPIRED", actions: [snoozeAction], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
        center.setNotificationCategories([category])
        
    }

    @IBAction func startButtonClicked(_ sender: UIButton) {
        if sender.currentTitle == "start" {
            if(!(self.timerInput.text?.isEmpty)!){
                self.timerInput.isEnabled = false
                let timerArray = (self.timerInput.text?.components(separatedBy: ":"))!
                let seconds = Int(timerArray[0])! * 3600 + Int(timerArray[1])! * 60 + Int(timerArray[2])!
                interval = seconds
                updateLabel(seconds)
                timer = Timer(timeInterval: 1, repeats: true, block: { (timer) in
                    if self.interval <= 0 {
                        timer.invalidate()
                        self.startButton.setTitle("start", for: UIControlState.normal)
                        self.interval = seconds
                    }else{
                        self.interval -= 1
                        self.updateLabel(self.interval)
                    }
                })
                RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
                let content = UNMutableNotificationContent()
                content.title = "Time's Up"
                content.body = NSString.init(format: "time is up for %ld", interval) as String
                content.sound = UNNotificationSound.default()
                content.categoryIdentifier = "TIME_EXPIRED"
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: false)
                let request = UNNotificationRequest(identifier: "TimeUpRequest", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                sender.setTitle("stop", for: UIControlState.normal)
            }
        }else if sender.currentTitle == "stop" {
            if let t = timer {
                t.invalidate()
            }
            sender.setTitle("start", for: UIControlState.normal);
        }
    }
    
    func updateLabel(_ inter: Int) -> Void {
        var count = inter
        let hourStr = count / 3600 >= 10 ? String(count / 3600) : "0".appending(String(count / 3600))
        count = count % 3600
        let minStr = count / 60 >= 10 ? String(count / 60) : "0".appending(String(count / 60))
        count = count % 60
        let secStr = count >= 10 ? String(count) : "0".appending(String(count))
        self.timerLabel.text = hourStr + ":" + minStr + ":" + secStr
    }
    
    @IBAction func clearButtonClicked() {
        self.timerInput.text = "00:00:00"
        self.timerInput.isEnabled = true
        self.startButton.isEnabled = false
    }
    //UItextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.startButton.isEnabled = true;
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let intValue = Int(string)
        if range.location <= string.characters.count - 1 {
            return false
        }
        if range.length > 1{
            return false
        }
        if intValue == nil {
           return false
        }
        if let oldString = textField.text{
            let timeArray = oldString.components(separatedBy: ":");
            var hour = Int(timeArray[0])!
            var min = Int(timeArray[1])!
            var sec = Int(timeArray[2])!
            let new = Int(string)!
            var carry = 0;
            carry = sec / 10
            sec = (sec * 10 + new) % 100
            min = min * 10 + carry
            carry = min / 100
            min = min % 100
            hour = (hour * 10 + carry) % 100
            let hourStr = hour < 10 ? "0" + String(hour) : String(hour)
            let minStr = min < 10 ? "0" + String(min) : String(min)
            let secStr = sec < 10 ? "0" + String(sec) : String(sec)
            textField.text = hourStr + ":" + minStr + ":" + secStr
        }
        return false
    }

}

