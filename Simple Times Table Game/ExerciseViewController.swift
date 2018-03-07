//
//  ExerciseViewController.swift
//  Simple Times Table Game
//
//  Created by Pieter Stragier on 06/03/2018.
//  Copyright © 2018 PWS-apps. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {
    
    var selectedTable: String? = "All"
    var multiplier: Int?
    var finished: Bool = false
    var score: Int = 0
    var difficultyLevel: Int?
    var numberOfExercises: Int = 10
    var numberArray: Array<Int> = [1,2,3,4,5,6,7,8,9,10]
    var shuffledArray: Array<Int>? = [99]
    var seconds = 60 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var starProgress = UIView()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var randomNumber: UILabel!
    @IBOutlet weak var tableNumber: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func goBack(_ sender: UIButton) {
        print("Back button pressed!")
        let controller = UIAlertController(title: "Progress will be lost!", message: "Are you sure you want to go back?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { alertAction in self.performSegue(withIdentifier: "unwindToOverview", sender: self) }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in
        }
        
        controller.addAction(ok)
        controller.addAction(cancel)
        
        present(controller, animated: true, completion: nil)

    }
    @IBOutlet weak var resultInputField: UITextField!
    
    @IBAction func submitAnswer(_ sender: UIButton) {
        if resultInputField.text != "" {
            checkAnswer()
        } else {
            resultInputField.placeholder = "Enter the result..."
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print("View did Load")
        tableNumber.text = selectedTable
        if difficultyLevel == 1 {
            numberArray = [0,1,2,3,4,5,6,7,8,9,10]
        } else if difficultyLevel == 2 {
            numberArray = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
        }
        shuffledArray = shuffleArray()
        print(self.shuffledArray!)
        score = 0
        //print("difficulty level: \(difficultyLevel!)")
        timerLabel.text = String((3 - Int(difficultyLevel!)) * 20)
        resultInputField.becomeFirstResponder()
        resultInputField.placeholder = "Your answer..."
        DispatchQueue.main.async {
            self.runTimer()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //print("view will layout subviews")
        if (self.shuffledArray?.count)! > 0 {
            resultInputField.becomeFirstResponder()
            multiplier = self.shuffledArray?[0]
            randomNumber.text = String(describing: multiplier!)
            shuffledArray?.remove(at: 0)
            //print("shuffledArray: \(String(describing: shuffledArray))")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //print("view did layout Subviews")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProgressStars() {
        self.starProgress=UIView(frame:CGRect(x: self.view.bounds.width-52, y: self.view.bounds.height-400, width: 250, height: 50))
        
        starProgress.backgroundColor = UIColor.white.withAlphaComponent(0.50)
        starProgress.layer.cornerRadius = 25
        //upArrow.layer.borderWidth = 1
        //upArrow.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(starProgress)
        let horStack = UIStackView()
        horStack.axis = .horizontal
        horStack.alignment = .fill
        horStack.distribution = .fillEqually
        self.starProgress.addSubview(horStack)
    }
    
    func shuffleArray() -> Array<Int> {
        for _ in 0..<numberArray.count {
            let rand = Int(arc4random_uniform(UInt32(numberArray.count)))
            self.shuffledArray?.append(numberArray[rand])
            numberArray.remove(at: rand)
        }
        return self.shuffledArray!
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
    }
    
    func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = "\(seconds)" //This will update the label.
        //timerLabel.reloadInputViews()
    }
    
    func checkAnswer() {
        print("Checking answer...")
        //print(Int(resultInputField.text!)!)
        //print(self.multiplier!)
        //print(Int(tableNumber.text!)!)
        if Int(resultInputField.text!)! == self.multiplier! * Int(tableNumber.text!)! {
            print("Correct answer")
            score += 1
        } else {
            print("Wrong answer")
        }
        numberOfExercises -= 1
        print("number of Exercises: \(numberOfExercises)")
        var answerString: String = "answers"
        if numberOfExercises == 0 {
            timer.invalidate()
            finished = true
            if score == 1 {
                answerString = "answer"
            } else if score > 1 {
                answerString = "answers"
            }
            let finishedAlert = UIAlertController(title: "Finished", message: "You have \(score) correct \(answerString).", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { alertAction in self.performSegue(withIdentifier: "unwindToOverview", sender: self) }
            
            finishedAlert.addAction(ok)
        
            present(finishedAlert, animated: true, completion: nil)
        }
        resultInputField.text = ""
        reloadInputViews()
    }
    
}
