//
//  TimerViewController.swift
//  Timer
//
//  Created by Delano Kamp on 08/07/2017.
//  Copyright © 2017 Delano Kamp. All rights reserved.
//

import UIKit
import Lottie

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var toggleStartButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var circlesClosedPassive: UIImageView!
    @IBOutlet weak var pomoStatus: UILabel!
    @IBOutlet weak var currentTaskLabel: UILabel!
    
    
    let animationView = LOTAnimationView(name: "CirclesRotating_v1")
    
    var seconds = 10
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    let alarmSound = SimpleSound(named: "alarmSound")
    let taskList = TaskListViewController()
    
    var numberOfPomos = 0
    var totalNumberOfPomos = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetTimer()
        resetTotalPomos()
        setCurrentTask(currentTask: taskList)
    }
    
    @IBAction func toggleStartButtonTapped(_ sender: UIButton) {
        if self.resumeTapped == false && isTimerRunning {
            timer.invalidate()
            self.resumeTapped = true
            self.toggleStartButton.setImage(#imageLiteral(resourceName: "startBlue"), for: .normal)
            animationView.pause()
        } else {
            runTimer()
            self.resumeTapped = false
            self.toggleStartButton.setImage(#imageLiteral(resourceName: "pauseBlue"), for: .normal)
        }

    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        resetTimer()
        
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TimerViewController.updateTimer)), userInfo: nil, repeats: true)
        
        isTimerRunning = true
        
        
        self.resetButton.isEnabled = true
        timerLabel.textColor = UIColor(red:0.05, green:0.31, blue:1.00, alpha:1.0)
        showAnimation() //Start Animation
        self.view.bringSubview(toFront: toggleStartButton) //Put the toggle button in front of the animation
        
        
        UIView.animate(withDuration: 1) {
            self.circlesClosedPassive.alpha = 0
            
        }
    }
    //Makes the timer run and if time is up resets.
    func updateTimer() {
        if seconds < 1 {
            //Let the user know that the time is up.
            playSound()
            resetTimer()
            updateTotalPomos()
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func timeString(time:TimeInterval) -> String {
//        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func resetTimer() {
        timer.invalidate()
        seconds = 10 //should be timer goal
        timerLabel.text = timeString(time: TimeInterval(seconds))
        
        isTimerRunning = false
        self.toggleStartButton.setImage(#imageLiteral(resourceName: "startBlue"), for: .normal)
        self.resetButton.isEnabled = false
        
        //Set timer color back to lightgrey
        timerLabel.textColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
        
//        circlesClosedPassive.isHidden = false
        circlesClosedPassive.frame = CGRect(x: (self.view.frame.size.width/2) - (156/2), y: 300, width: 156, height: 156)
        
        UIView.animate(withDuration: 1) {
            self.circlesClosedPassive.alpha = 1
            self.animationView.alpha = 0
        }
        
        
    }
    
    func showAnimation() {
        animationView.frame = CGRect(x: (self.view.frame.size.width/2) - (156/2), y: 300, width: 156, height: 156)
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
        animationView.animationSpeed = 0.5
        
        
        
        self.view.addSubview(animationView)
        animationView.play(completion: { finished in
            // Do Something
            
        })
        
        UIView.animate(withDuration: 1) {
            self.animationView.alpha = 1
        }
    }
    
    func playSound() {
        alarmSound.play()
    }
    
    func resetTotalPomos(){
        pomoStatus.text = "Total \(numberOfPomos)/\(totalNumberOfPomos)"
        pomoStatus.textColor = UIColor(red:0.00, green:0.25, blue:0.34, alpha:1.0)
    }
    
    func updateTotalPomos() {
        numberOfPomos += 1
        pomoStatus.text = "Total \(numberOfPomos)/\(totalNumberOfPomos)"
        
        if numberOfPomos < totalNumberOfPomos {
            pomoStatus.textColor = UIColor(red:0.00, green:0.25, blue:0.34, alpha:1.0)
        } else {
            pomoStatus.textColor = UIColor(red:0.29, green:0.81, blue:0.29, alpha:1.0)
        }
        
    }
    
    func setCurrentTask(currentTask: TaskListViewController) {
        currentTaskLabel.text = currentTask.items[0]
    }
    
}
