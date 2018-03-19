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
    var bewerkingen: Array<String> = []
    var bewerking: String = "vermenigvuldigen"
    var AllSelect: Int = 1
    //var selectedTable: String? = "All"
    var selectedTables: [IndexPath]?
    var tablesDictV: Dictionary<Int,Array<Int>>? = [:]
    var tablesDictD: Dictionary<Int, Array<Int>>? = [:]
    var multiplier: Int?
    var tableMult: Int?
    var finished: Bool = false
    var score: Int = 0
    var scorePerTableV: Dictionary<Int, Int> = [:]
    var scorePerTableD: Dictionary<Int, Int> = [:]
    var scorePerTableDV: Dictionary<Int, Int> = [:]
    var difficultyLevel: Int?
    var numberOfExercises: Int = 10
    var tablesArrayV: Array<Int> = []
    var tablesArrayD: Array<Int> = []
    var numberArray: Array<Int> = []
    var divideArray: Array<Int> = []
    var shuffledArray: Array<Int>? = []
    var shuffledTable: Array<Int>? = []
    var shuffledDivide: Array<Int>? = []
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
    @IBOutlet weak var bewerkingsTeken: UILabel!
    
    @IBOutlet weak var grassImagePattern: UIImageView!
    @IBAction func goBack(_ sender: UIButton) {
        //print("Back button pressed!")
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
            if self.bewerking == "vermenigvuldigen" {
                checkAnswerV()
            } else if self.bewerking == "delen" {
                checkAnswerD()
            }
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
//        print("Number of Ex.: \(self.numberOfExercises)")
        if self.AllSelect == 1 {
            timerLabel.isHidden = false
            DispatchQueue.main.async {
                self.runTimer()
            }
        } else {
            timerLabel.isHidden = true
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
        if bewerkingen.count == 1 {
            for bew in bewerkingen {
                if bew == "vermenigvuldigen" {
                    self.bewerking = bew
                    if self.numberOfExercises > 0 {
                        resultInputField.becomeFirstResponder()
                        let randomTable = Int(arc4random_uniform(UInt32(self.tablesArrayV.count)))
                        tableMult = self.tablesArrayV[randomTable]
                        multiplier = tablesDictV?[tableMult!]?[0]
                        self.bewerkingsTeken.text = "X"
                        randomNumber.text = String(describing: multiplier!)
                        tableNumber.text = String(describing: tableMult!)
                        tablesDictV?[tableMult!]?.remove(at: 0)
                        if tablesDictV?[tableMult!]?.count == 0 {
                            let emptyIndex = self.tablesArrayV.index(of: tableMult!)
                            self.tablesArrayV.remove(at: emptyIndex!)
                        }
                    }
                }
                if bew == "delen" {
                    self.bewerking = bew
                    if self.numberOfExercises > 0 {
                        resultInputField.becomeFirstResponder()
                        let randomTable = Int(arc4random_uniform(UInt32(self.tablesArrayD.count)))
                        tableMult = self.tablesArrayD[randomTable]
                        multiplier = tablesDictD?[tableMult!]?[0]
                        self.bewerkingsTeken.text = ":"
                        randomNumber.text = String(describing: multiplier!)
                        tableNumber.text = String(describing: tableMult!)
                        tablesDictD?[tableMult!]?.remove(at: 0)
                        if tablesDictD?[tableMult!]?.count == 0 {
                            let emptyIndex = self.tablesArrayD.index(of: tableMult!)
                            self.tablesArrayD.remove(at: emptyIndex!)
                        }
                    }
                }

            }
        } else if bewerkingen.count == 2 {
            // Mixed exercise muliply and divide
            // Kies een bewerking ad random
            let randombew = Int(arc4random_uniform(UInt32(self.bewerkingen.count)))
            let bew = self.bewerkingen[randombew]
            if self.numberOfExercises > 0 {
                resultInputField.becomeFirstResponder()
                if bew == "vermenigvuldigen" {
                    self.bewerking = "vermenigvuldigen"
                    let randomTable = Int(arc4random_uniform(UInt32(self.tablesArrayV.count)))
                    tableMult = self.tablesArrayV[randomTable]
                    multiplier = tablesDictV?[tableMult!]?[0]
                    bewerkingsTeken.text = "X"
                    randomNumber.text = String(describing: multiplier!)
                    tableNumber.text = String(describing: tableMult!)
                    self.tablesDictV?[tableMult!]?.remove(at: 0)
                    if self.tablesDictV?[tableMult!]?.count == 0 {
                        let emptyIndex = self.tablesArrayV.index(of: tableMult!)
                        self.tablesArrayV.remove(at: emptyIndex!)
                    }
                    if tablesArrayV.count == 0 {
                        let emptyBew = self.bewerkingen.index(of: "vermenigvuldigen")
                        self.bewerkingen.remove(at: emptyBew!)
                    }
                } else if bew == "delen" {
                    self.bewerking = "delen"
                    let randomTable = Int(arc4random_uniform(UInt32(self.tablesArrayD.count)))
                    tableMult = self.tablesArrayD[randomTable]
                    multiplier = self.tablesDictD?[tableMult!]?[0]
                    bewerkingsTeken.text = ":"
                    randomNumber.text = String(describing: multiplier!)
                    tableNumber.text = String(describing: tableMult!)
                    self.tablesDictD?[tableMult!]?.remove(at: 0)
                    if self.tablesDictD?[tableMult!]?.count == 0 {
                        let emptyIndex = self.tablesArrayD.index(of: tableMult!)
                        self.tablesArrayD.remove(at: emptyIndex!)
                    }

                    if tablesArrayD.count == 0 {
                        let emptyBew = self.bewerkingen.index(of: "delen")
                        self.bewerkingen.remove(at: emptyBew!)
                    }
                }
            }
        }
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
        self.grassImagePattern.image = UIImage(named: "grassTextureTransparent.png")!.resizableImage(withCapInsets: UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0))
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
            self.tablesArrayV.append(x.row + 1)
            self.tablesArrayD.append(x.row + 1)
        }
        // Fill numberArray from selected difficulty level1
        if difficultyLevel == 0 {
            numberArray = [1,2,3,4,5,6,7,8,9,10]
            for x in self.tablesArrayD {
                for y in numberArray {
                    if ((self.tablesDictD?[x]) != nil) {
                        var arr: Array<Int> = (self.tablesDictD?[x])!
                        arr.append(x * y)
                        self.tablesDictD?[x] = arr
                    } else {
                        let mult = [x * y]
                        self.tablesDictD?[x] = mult
                    }
                }
            }
        } else if difficultyLevel == 1 {
            numberArray = [0,1,2,3,4,5,6,7,8,9,10]
            for x in self.tablesArrayD {
                if x != 0 {
                    for y in numberArray {
                        if ((tablesDictD?[x]) != nil) {
                            var arr: Array<Int> = (self.tablesDictD?[x])!
                            arr.append(x * y)
                            self.tablesDictD?[x] = arr
                        } else {
                            self.tablesDictD?[x] = [x * y]
                        }
                    }
                }
            }
        } else if difficultyLevel == 2 {
            numberArray = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
            for x in self.tablesArrayD {
                if x != 0 {
                    for y in numberArray {
                        if ((tablesDictD?[x]) != nil) {
                            var arr: Array<Int> = (self.tablesDictD?[x])!
                            arr.append(x * y)
                            self.tablesDictD?[x] = arr
                        } else {
                            self.tablesDictD?[x] = [x * y]
                        }
                    }
                }
            }
        }
        
        // Set number of exercises
        if self.AllSelect == 1 {
            numberOfExercises = numberArray.count * tablesArrayV.count * self.bewerkingen.count
        } else if self.AllSelect == 0 {
            numberOfExercises = 20 - max((20 - ((selectedTables?.count)! * 5)),0)
        }
        // Shuffle multipliers and add to tableDictV
        for x in 0..<tablesArrayV.count {
            shuffledArray = shuffleArray(array: self.numberArray)
            self.tablesDictV?[tablesArrayV[x]] = shuffledArray
        }
        // Shuffle dividing numbers and add to tableDictD
        for x in 0..<tablesArrayD.count {
            self.divideArray = (self.tablesDictD?[tablesArrayD[x]])!
            let shuffledDividers = shuffleArray(array: self.divideArray)
            self.tablesDictD?[tablesArrayD[x]] = shuffledDividers
        }
        // Reset global score
        score = 0
        // Prepare score per table
        for t in self.tablesArrayV {
            self.scorePerTableV[t] = 0
            self.scorePerTableD[t] = 0
        }
        // Set timer
        self.seconds = ((3 - Int(difficultyLevel!)) * 20 * self.tablesArrayV.count * self.bewerkingen.count) + 5
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
    func checkAnswerV() {
        if Int(resultInputField.text!)! == self.multiplier! * self.tableMult! {
            //print("Correct answer")
            score += 1
            let tableScore = self.scorePerTableV[self.tableMult!]
            let newScore = tableScore! + 1
            scorePerTableV[tableMult!] = newScore
        } else {
            //print("Wrong answer")
        }
        numberOfExercises -= 1
        //print("number of Exercises: \(numberOfExercises)")
        var answerString: String = "answers"
        if numberOfExercises == 0 {
            timer.invalidate()
            // Stop sound
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(false)
            } catch let error as NSError {
                print(error.description)
            }

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
    func checkAnswerD() {
        if Int(resultInputField.text!)! == self.multiplier! / self.tableMult! {
            //print("Correct answer")
            score += 1
            let tableScore = self.scorePerTableD[self.tableMult!]
            let newScore = tableScore! + 1
            scorePerTableD[tableMult!] = newScore
        } else {
            //print("Wrong answer")
        }
        numberOfExercises -= 1
        //print("number of Exercises: \(numberOfExercises)")
        var answerString: String = "answers"
        if numberOfExercises == 0 {
            timer.invalidate()
            // Stop sound
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(false)
            } catch let error as NSError {
                print(error.description)
            }
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
