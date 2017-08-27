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
    @IBOutlet weak var previousTaskLabel: UILabel!
    @IBOutlet weak var nextTaskLabel: UILabel!
    @IBOutlet weak var pomoCircle1: UIImageView!
    @IBOutlet weak var pomoCircle2: UIImageView!
    @IBOutlet weak var pomoCircle3: UIImageView!
    
    let animationView = LOTAnimationView(name: "CirclesRotating_v1")
    
    var seconds = 10
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    let alarmSound = SimpleSound(named: "alarmSound")
    let completeSound = SimpleSound(named: "completeSound")
    let taskList = TaskListViewController()
    
    var numberOfPomos = 0
    var totalNumberOfPomos = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetTimer()
        resetTotalPomos()
        setPreviousTask(previousTask: taskList)
        setCurrentTask(currentTask: taskList)
        setNextTask(nextTask: taskList)
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
        if numberOfPomos == totalNumberOfPomos - 1 {
            completeSound.play()
        } else {
            alarmSound.play()
        }
        
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
        
        if numberOfPomos == 0 {
            pomoCircle1.image = UIImage(named: "Icon_PomoStatus")
            pomoCircle2.image = UIImage(named: "Icon_PomoStatus")
            pomoCircle3.image = UIImage(named: "Icon_PomoStatus")
        } else if numberOfPomos == 1 {
            pomoCircle1.image = UIImage(named: "Icon_PomoStatusDone")
            pomoCircle2.image = UIImage(named: "Icon_PomoStatus")
            pomoCircle3.image = UIImage(named: "Icon_PomoStatus")
        } else if numberOfPomos == 2 {
            pomoCircle1.image = UIImage(named: "Icon_PomoStatusDone")
            pomoCircle2.image = UIImage(named: "Icon_PomoStatusDone")
            pomoCircle3.image = UIImage(named: "Icon_PomoStatus")
        } else if numberOfPomos == 3 {
            pomoCircle1.image = UIImage(named: "Icon_PomoStatusDone")
            pomoCircle2.image = UIImage(named: "Icon_PomoStatusDone")
            pomoCircle3.image = UIImage(named: "Icon_PomoStatusDone")
        }
    }
    
//    func updatePomoCircles() {
//        
//    }
//    
    func setCurrentTask(currentTask: TaskListViewController) {
        currentTaskLabel.text = currentTask.items[1]
    }
    
    func setPreviousTask(previousTask: TaskListViewController) {
        previousTaskLabel.text = previousTask.items[0]
    }
    
    func setNextTask(nextTask: TaskListViewController) {
        nextTaskLabel.text = nextTask.items[2]
    }
    
    
    
    
}
