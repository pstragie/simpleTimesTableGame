//
//  ViewController.swift
//  Simple Times Table Game
//
//  Created by Pieter Stragier on 06/03/2018.
//  Copyright © 2018 PWS-apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var buttonAll: UIButton!
    @IBOutlet weak var buttonResetStars: UIButton!

    @IBOutlet weak var DifficultyControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Unwind
    @IBAction func unwindToOverview(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? ExerciseViewController {
            let finished = sourceViewController.finished
            let timestable = sourceViewController.selectedTable!
            let score = sourceViewController.score
            let timer = Int(sourceViewController.timer.text!)
            if finished == true {
                if score < 10 {
                    print("one bronze star")

                } else if score == 10 && timer == 0 {
                    print("two bronze stars")
                } else if score == 10 && timer != 0 {
                    print("three bronze stars")
                }
            }
            
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ExerciseViewController
        var selectedTable = "0"
        let S1 = "Segue1"
        let S2 = "Segue2"
        let S3 = "Segue3"
        let S4 = "Segue4"
        let S5 = "Segue5"
        let S6 = "Segue6"
        let S7 = "Segue7"
        let S8 = "Segue8"
        let S9 = "Segue9"
        let SAll = "SegueAll"
        switch segue.identifier! {
        case S1:
            selectedTable = "1"
        case S2:
            selectedTable = "2"
        case S3:
            selectedTable = "3"
       case S4:
            selectedTable = "4"
       case S5:
            selectedTable = "5"
       case S6:
            selectedTable = "6"
       case S7:
            selectedTable = "7"
       case S8:
            selectedTable = "8"
        case S9:
            selectedTable = "9"
        case SAll:
            selectedTable = "All"
        default:
            //            print("Segue: \(segue.identifier!)!")
            break
        }
        destination.selectedTable = selectedTable
        destination.difficultyLevel = Int(DifficultyControl.selectedSegmentIndex)
    }

    // MARK: - fetchedResultsController
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Tables> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Tables> = Tables.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "mppnm", ascending: true)]
        var format: String = "mppnm BEGINSWITH[c] %@"
        let predicate = NSPredicate(format: format, "AlotofMumboJumboblablabla")
        fetchRequest.predicate = predicate
        // Create Fetched Results Controller
        
        let context = self.appDelegate.persistentContainer.viewContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    // MARK: - Table data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let medicijnen = fetchedResultsController.fetchedObjects else { return 0 }
        tableView.layer.cornerRadius = 3
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 1
        return medicijnen.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // MARK: Add to Medicijnkast
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.reuseIdentifier, for: indexPath) as? TableCell else {
            fatalError("Unexpected Index Path")
        }
        
        cell.selectionStyle = .none
        
        //         Fetch Stars
        let stars = fetchedResultsController.object(at: indexPath)
        
        //         Configure Cell
        cell.layer.cornerRadius = 3
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        
        cell.timestable.text = stars.table
        
        return cell
    }

}

