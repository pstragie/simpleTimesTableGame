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
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var randomNumber: UILabel!
    @IBOutlet weak var tableNumber: UILabel!
    @IBOutlet weak var timer: UILabel!
    
    @IBAction func goBack(_ sender: UIButton) {
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
        resultInputField.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("View did Load")
        tableNumber.text = selectedTable
        shuffledArray = shuffleArray()
        print(self.shuffledArray!)
        resultInputField.addTarget(self, action: #selector(checkAnswer), for: .editingDidEnd)
        score = 0
        print("difficulty level: \(difficultyLevel!)")
        timer.text = String((3 - Int(difficultyLevel!)) * 20)
        resultInputField.becomeFirstResponder()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("view will layout subviews")
        if (self.shuffledArray?.count)! > 0 {
            resultInputField.becomeFirstResponder()
            multiplier = self.shuffledArray?[0]
            randomNumber.text = String(describing: multiplier!)
            shuffledArray?.remove(at: 0)
            print("shuffledArray: \(String(describing: shuffledArray))")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("view did layout Subviews")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func shuffleArray() -> Array<Int> {
        for _ in 0..<numberArray.count {
            let rand = Int(arc4random_uniform(UInt32(numberArray.count)))
            self.shuffledArray?.append(numberArray[rand])
            numberArray.remove(at: rand)
        }
        return self.shuffledArray!
    }
    
    func checkAnswer() {
        print(Int(resultInputField.text!)!)
        print(self.multiplier!)
        print(Int(tableNumber.text!)!)
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
