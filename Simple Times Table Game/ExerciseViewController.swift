//
//  ExerciseViewController.swift
//  Simple Times Table Game
//
//  Created by Pieter Stragier on 06/03/2018.
//  Copyright © 2018 PWS-apps. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class ExerciseViewController: UIViewController {
    
    // MARK: - var&let
    var selectedTable: String? = "All"
    var selectedTables: [IndexPath]?
    var tablesDict: Dictionary<Int,Array<Int>>? = [0:[]]
    var multiplier: Int?
    var tableMult: Int?
    var finished: Bool = false
    var score: Int = 0
    var scorePerTable: Dictionary<Int, Int> = [99: 0]
    var difficultyLevel: Int?
    var numberOfExercises: Int = 10
    var tablesArray: Array<Int> = []
    var numberArray: Array<Int> = [1,2,3,4,5,6,7,8,9,10]
    var shuffledArray: Array<Int>? = []
    var shuffledTable: Array<Int>? = []
    var seconds = 60 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var player: AVAudioPlayer?
    var starProgress = UIView()
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var randomNumber: UILabel!
    @IBOutlet weak var tableNumber: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
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
            viewWillAppear(false)
        } else {
            resultInputField.placeholder = "Enter the result..."
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print("View did Load")
        setupLayout()
        prepareNumbers()
        DispatchQueue.main.async {
            self.runTimer()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //print("view will layout subviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //print("view did layout Subviews")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        //print("view will appear")
        if self.numberOfExercises > 0 {
            resultInputField.becomeFirstResponder()
            let randomTable = Int(arc4random_uniform(UInt32(self.tablesArray.count)))
            tableMult = self.tablesArray[randomTable]
            multiplier = tablesDict?[tableMult!]?[0]
            
            randomNumber.text = String(describing: multiplier!)
            tableNumber.text = String(describing: tableMult!)
            tablesDict?[tableMult!]?.remove(at: 0)
            if tablesDict?[tableMult!]?.count == 0 {
                let emptyIndex = self.tablesArray.index(of: tableMult!)
                self.tablesArray.remove(at: emptyIndex!)
            }
        }
        print(self.scorePerTable)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLayout() {
        backButton.layer.cornerRadius = 5
        submitButton.layer.cornerRadius = 5
    }
    // MARK: - setup progress bar
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
    
    // MARK: - prepare numbers
    func prepareNumbers() {
        // Fill tablesArray from selected rows
        for x in selectedTables! {
            self.tablesArray.append(x.row + 1)
        }
        print("tablesArray: \(tablesArray)")
        // Fill numberArray from selected difficulty level
        if difficultyLevel == 1 {
            numberArray = [0,1,2,3,4,5,6,7,8,9,10]
        } else if difficultyLevel == 2 {
            numberArray = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
        }
        // Set number of exercises
        numberOfExercises = numberArray.count * tablesArray.count
        // Shuffle multipliers and add to tableDict
        for x in 0..<tablesArray.count {
            shuffledArray = shuffleArray(array: numberArray)
            self.tablesDict?[tablesArray[x]] = shuffledArray
        }
        print("tablesDict: \(self.tablesDict!)")
        // Reset global score
        score = 0
        // Prepare score per table
        for t in self.tablesArray {
            self.scorePerTable[t] = 0
        }
        print("score per table: \(self.scorePerTable)")
        // Set timer
        self.seconds = (3 - Int(difficultyLevel!)) * 20 * self.tablesArray.count
        timerLabel.text = String(self.seconds)
        // Set inputfield
        resultInputField.becomeFirstResponder()
        resultInputField.placeholder = "Your answer..."
    }
    
    // MARK: - shuffle Array
    func shuffleArray(array: Array<Int>) -> Array<Int> {
        var tempShuffled: Array<Int> = []
        var tempArray = array
        while 0 < tempArray.count {
            let rand = Int(arc4random_uniform(UInt32(tempArray.count)))
            tempShuffled.append(tempArray[rand])
            tempArray.remove(at: rand)
        }
        return tempShuffled
    }
    
    // MARK: - Timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
    }
    
    func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        if seconds == 0 {
            timerLabel.textColor = UIColor.red
            timerLabel.text = "\(seconds)"
            timer.invalidate()
//            playSound(resource: "AirHorn", ext: "mp3", vol: 0.5)
        } else if seconds < 6 {
            timerLabel.textColor = UIColor.orange
            timerLabel.text = "\(seconds)"
//            playSound(resource: "Tick", ext: "mp3", vol: 0.7)
        } else {
            timerLabel.textColor = UIColor.green
            timerLabel.text = "\(seconds)"
//            playSound(resource: "Tick", ext: "mp3", vol: 0.5)
        }
    }
    
    // MARK: - play tocking clock sound
    func playSound(resource: String, ext: String, vol: Float) {
        guard let url = Bundle.main.url(forResource: resource, withExtension: ext) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.play()
            player.setVolume(vol, fadeDuration: 0)
        } catch let error as NSError {
            print(error.description)
        }
    }
    // MARK: - Check answer
    func checkAnswer() {
        //print("Checking answer...")
        //print(Int(resultInputField.text!)!)
        //print(self.multiplier!)
        //print(Int(tableNumber.text!)!)
        if Int(resultInputField.text!)! == self.multiplier! * self.tableMult! {
            //print("Correct answer")
            score += 1
            let tableScore = self.scorePerTable[self.tableMult!]
            let newScore = tableScore! + 1
            scorePerTable[tableMult!] = newScore
        } else {
            //print("Wrong answer")
        }
        numberOfExercises -= 1
        //print("number of Exercises: \(numberOfExercises)")
        var answerString: String = "answers"
        if numberOfExercises == 0 {
            print(self.scorePerTable)
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
