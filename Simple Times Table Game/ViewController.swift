//
//  ViewController.swift
//  Simple Times Table Game
//
//  Created by Pieter Stragier on 06/03/2018.
//  Copyright © 2018 PWS-apps. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants & Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let localdata = UserDefaults.standard
    var errorHandler: (Error) -> Void = {_ in }
    var maxScore: Int = 10
    var geselecteerdeBewerking: Array<String> = ["Vermenigvuldigen"]
    var scorePerTableDV: Dictionary<Int, Int> = [:]

    // MARK: - Outlets
    @IBOutlet weak var buttonResetStars: UIButton!
    @IBOutlet weak var DifficultyControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var BewerkingControl: UISegmentedControl!
    
    @IBAction func BewerkingControlChanged(_ sender: UISegmentedControl) {
        viewWillLayoutSubviews()
    }
    
    @IBAction func resetAllStarsButtonPressed(_ sender: UIButton) {
        let controller = UIAlertController(title: "All stars will be deleted!", message: "Are you sure you want to delete all hard earned stars in this table?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { alertAction in self.resetAllStars() }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in
        }
        
        controller.addAction(ok)
        controller.addAction(cancel)
        
        present(controller, animated: true, completion: nil)

        //resetAllStars()
    }
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        do {
            try self.fetchedResultsControllerV.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
            fatalError("Could not fetch records: \(fetchError)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("view will layout subviews")
        if BewerkingControl.selectedSegmentIndex == 2 {
            do {
                try self.fetchedResultsControllerVD.performFetch()
            } catch {
                let fetchError = error as NSError
                print("Unable to Perform Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
                fatalError("Could not fetch records: \(fetchError)")
            }
        } else if BewerkingControl.selectedSegmentIndex == 1 {
            do {
                try self.fetchedResultsControllerD.performFetch()
            } catch {
                let fetchError = error as NSError
                print("Unable to Perform Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
                fatalError("Could not fetch records: \(fetchError)")
            }
        } else {
            do {
                try self.fetchedResultsControllerV.performFetch()
            } catch {
                let fetchError = error as NSError
                print("Unable to Perform Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
                fatalError("Could not fetch records: \(fetchError)")
            }
        }
        self.tableView.reloadData()
    }

    // MARK: - Unwind
    @IBAction func unwindToOverview(segue: UIStoryboardSegue) {
        startButton.isEnabled = false
        if let sourceViewController = segue.source as? ExerciseViewController {
            //fetch records
            let moc = self.appDelegate.persistentContainer.viewContext
            
            let finished = sourceViewController.finished
            //let timestable = sourceViewController.selectedTable!
            let timer = Int(sourceViewController.timerLabel.text!)
            let diff: Int = sourceViewController.difficultyLevel! + 1
            if diff == 2 {
                self.maxScore = 11
            } else if diff == 3 {
                self.maxScore = 14
            } else {
                self.maxScore = 10
            }
            if BewerkingControl.selectedSegmentIndex == 0 {
                for (tt, score) in sourceViewController.scorePerTableV {
                    if tt != 99 {
                        let table = self.appDelegate.fetchRecordsForEntity("Vermenigvuldigen", key: "timestable", arg: String(tt), inManagedObjectContext: moc)
                        let curstar1 = Int(table.first?.value(forKey: "star1") as! String)
                        let curstar2 = Int(table.first?.value(forKey: "star2") as! String)
                        let curstar3 = Int(table.first?.value(forKey: "star3") as! String)
                        if finished == true {
                            if score < self.maxScore {
                                if diff > curstar1! {
                                    table.first?.setValue(String(diff), forKey: "star1")
                                }
                            } else if score == self.maxScore && timer == 0 {
                                if diff > curstar1! {
                                    table.first?.setValue(String(diff), forKey: "star1")
                                }
                                if diff > curstar2! {
                                    table.first?.setValue(String(diff), forKey: "star2")
                                }
                            } else if score == self.maxScore && timer != 0 {
                                if diff > curstar1! {
                                    table.first?.setValue(String(diff), forKey: "star1")
                                }
                                if diff > curstar2! {
                                    table.first?.setValue(String(diff), forKey: "star2")
                                }
                                if diff > curstar3! {
                                    table.first?.setValue(String(diff), forKey: "star3")
                                }
                            }
                        }
                    }
                }
            } else if BewerkingControl.selectedSegmentIndex == 1 {
                for (tt, score) in sourceViewController.scorePerTableD {
                    if tt != 99 {
                        let table = self.appDelegate.fetchRecordsForEntity("Delen", key: "timestable", arg: String(tt), inManagedObjectContext: moc)
                        let curstar1 = Int(table.first?.value(forKey: "star1") as! String)
                        let curstar2 = Int(table.first?.value(forKey: "star2") as! String)
                        let curstar3 = Int(table.first?.value(forKey: "star3") as! String)
                        if finished == true {
                            if score < self.maxScore {
                                if diff > curstar1! {
                                    table.first?.setValue(String(diff), forKey: "star1")
                                }
                            } else if score == self.maxScore && timer == 0 {
                                if diff > curstar1! {
                                    table.first?.setValue(String(diff), forKey: "star1")
                                }
                                if diff > curstar2! {
                                    table.first?.setValue(String(diff), forKey: "star2")
                                }
                            } else if score == self.maxScore && timer != 0 {
                                if diff > curstar1! {
                                    table.first?.setValue(String(diff), forKey: "star1")
                                }
                                if diff > curstar2! {
                                    table.first?.setValue(String(diff), forKey: "star2")
                                }
                                if diff > curstar3! {
                                    table.first?.setValue(String(diff), forKey: "star3")
                                }
                            }
                        }
                    }
                }
            } else {
                
                for (ttD, valueD) in sourceViewController.scorePerTableD {
                    for (ttV, valueV) in sourceViewController.scorePerTableV {
                        if ttD == ttV {
                            let newScore = valueD + valueV
                            self.scorePerTableDV[ttD] = newScore
                        }
                    }
                }
                print("scorePerTableDV: \(self.scorePerTableDV)")
                for (tt, score) in self.scorePerTableDV {
                    if tt != 99 {
                        let table = self.appDelegate.fetchRecordsForEntity("VermDelen", key: "timestable", arg: String(tt), inManagedObjectContext: moc)
                        let curstar1 = Int(table.first?.value(forKey: "star1") as! String)
                        let curstar2 = Int(table.first?.value(forKey: "star2") as! String)
                        let curstar3 = Int(table.first?.value(forKey: "star3") as! String)
                        if finished == true {
                            if score < self.maxScore * 2 {
                                if diff > curstar1! {
                                    table.first?.setValue(String(diff), forKey: "star1")
                                }
                            } else if score == self.maxScore * 2 && timer == 0 {
                                if diff > curstar1! {
                                    table.first?.setValue(String(diff), forKey: "star1")
                                }
                                if diff > curstar2! {
                                    table.first?.setValue(String(diff), forKey: "star2")
                                }
                            } else if score == self.maxScore * 2 && timer != 0 {
                                if diff > curstar1! {
                                    table.first?.setValue(String(diff), forKey: "star1")
                                }
                                if diff > curstar2! {
                                    table.first?.setValue(String(diff), forKey: "star2")
                                }
                                if diff > curstar3! {
                                    table.first?.setValue(String(diff), forKey: "star3")
                                }
                            }
                        }
                    }
                }
            }


            do {
                try moc.save()
            } catch {
                fatalError("Could not save")
            }
        }
    }
    
    // MARK: - function Reset All Stars
    func resetAllStars() {
        let moc = self.appDelegate.persistentContainer.viewContext
        if BewerkingControl.selectedSegmentIndex == 0 {
            for tt in [1,2,3,4,5,6,7,8,9,10] {
                let table = self.appDelegate.fetchRecordsForEntity("Vermenigvuldigen", key: "timestable", arg: String(tt), inManagedObjectContext: moc)
                table.first?.setValue("0", forKey: "star1")
                table.first?.setValue("0", forKey: "star2")
                table.first?.setValue("0", forKey: "star3")
            }
        } else if BewerkingControl.selectedSegmentIndex == 1 {
            for tt in [1,2,3,4,5,6,7,8,9,10] {
                let table = self.appDelegate.fetchRecordsForEntity("Delen", key: "timestable", arg: String(tt), inManagedObjectContext: moc)
                table.first?.setValue("0", forKey: "star1")
                table.first?.setValue("0", forKey: "star2")
                table.first?.setValue("0", forKey: "star3")
            }
        } else if BewerkingControl.selectedSegmentIndex == 2 {
            for tt in [1,2,3,4,5,6,7,8,9,10] {
                let table = self.appDelegate.fetchRecordsForEntity("VermDelen", key: "timestable", arg: String(tt), inManagedObjectContext: moc)
                table.first?.setValue("0", forKey: "star1")
                table.first?.setValue("0", forKey: "star2")
                table.first?.setValue("0", forKey: "star3")
            }
        }
        do {
            try moc.save()
        } catch {
            fatalError("Could not reset stars")
        }
        tableView.reloadData()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            
        case "SegueToExercise":
            if tableView.indexPathsForSelectedRows?.count == 0 {
                let controller = UIAlertController(title: "No times table selected!", message: "Select at least one table.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                controller.addAction(ok)
                present(controller, animated: true, completion: nil)
        
            } else {
                let destination = segue.destination as! ExerciseViewController
                //let indexPath = tableView.indexPathForSelectedRow!
                if BewerkingControl.selectedSegmentIndex == 1 {
                    self.geselecteerdeBewerking.append("delen")
                    destination.bewerkingen.append("delen")
                } else if BewerkingControl.selectedSegmentIndex == 0 {
                    self.geselecteerdeBewerking.append("vermenigvuldigen")
                    destination.bewerkingen.append("vermenigvuldigen")
                } else {
                    self.geselecteerdeBewerking.append("vermenigvuldigen")
                    self.geselecteerdeBewerking.append("delen")
                    destination.bewerkingen.append("vermenigvuldigen")
                    destination.bewerkingen.append("delen")
                }
                let selTables = tableView.indexPathsForSelectedRows
                destination.selectedTables = selTables
                destination.difficultyLevel = Int(DifficultyControl.selectedSegmentIndex)
            }
            

        //            print("Segue: \(segue.identifier!)!")
        default:
            //            print("Segue: \(segue.identifier!)!")
            break
        }
        
    }

    // MARK: - fetchedResultsController
    fileprivate lazy var fetchedResultsControllerV: NSFetchedResultsController<Vermenigvuldigen> = {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<Vermenigvuldigen>(entityName: "Vermenigvuldigen")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestable", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
        // Create Fetched Results Controller
        let predicate = NSPredicate(format: "timestable in %@", ["1","2","3","4","5","6","7","8","9","10"])
        fetchRequest.predicate = predicate
        let context = self.appDelegate.persistentContainer.viewContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    // MARK: - fetchedResultsController
    fileprivate lazy var fetchedResultsControllerD: NSFetchedResultsController<Delen> = {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<Delen>(entityName: "Delen")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestable", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
        // Create Fetched Results Controller
        let predicate = NSPredicate(format: "timestable in %@", ["1","2","3","4","5","6","7","8","9","10"])
        fetchRequest.predicate = predicate
        let context = self.appDelegate.persistentContainer.viewContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    // MARK: - fetchedResultsController
    fileprivate lazy var fetchedResultsControllerVD: NSFetchedResultsController<VermDelen> = {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<VermDelen>(entityName: "VermDelen")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestable", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
        // Create Fetched Results Controller
        let predicate = NSPredicate(format: "timestable in %@", ["1","2","3","4","5","6","7","8","9","10"])
        fetchRequest.predicate = predicate
        let context = self.appDelegate.persistentContainer.viewContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    // MARK: - setup layout
    func setupLayout() {
        startButton.layer.cornerRadius = 10
        startButton.isEnabled = false
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOffset = CGSize(width: 0.1, height: 3.0)
        startButton.layer.shadowRadius = 0.5
        startButton.layer.shadowOpacity = 0.8
        startButton.layer.masksToBounds = false
        startButton.layer.cornerRadius = 10
        tableView.tableFooterView = UIView()
        
        (DifficultyControl.subviews[2] as UIView).tintColor = UIColor(red: 150/255, green: 90/255, blue:56/255, alpha:1)
        (DifficultyControl.subviews[1] as UIView).tintColor = UIColor(red: 204/255, green: 194/255, blue: 194/255, alpha: 1)
        (DifficultyControl.subviews[0] as UIView).tintColor = UIColor(red: 201/255, green: 137/255, blue: 16/255, alpha: 1)
        
    }
    
}
// MARK: - Extension
extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        //updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            tableView.reloadData()
            break;
        default:
            break
            //print("...")
        }
    }
    
    // MARK: - Table data
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if BewerkingControl.selectedSegmentIndex == 2 {
            guard let rows = fetchedResultsControllerVD.fetchedObjects else { return 0 }
            return rows.count
        } else if BewerkingControl.selectedSegmentIndex == 1 {
            guard let rows = fetchedResultsControllerD.fetchedObjects else { return 0 }
            return rows.count
        } else {
            guard let rows = fetchedResultsControllerV.fetchedObjects else { return 0 }
            return rows.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.indexPathsForSelectedRows?.count != 0 {
            startButton.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.indexPathsForSelectedRows?.count == 0 {
            startButton.isEnabled = false
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? TableCell else {
            fatalError("Unexpected Index Path")
        }
        
        cell.selectionStyle = .blue
        //         Configure Cell
        cell.layer.cornerRadius = 3
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        //         Fetch Stars
        if BewerkingControl.selectedSegmentIndex == 2 {
            let stars = fetchedResultsControllerVD.object(at: indexPath)
            cell.timesTable.text = stars.timestable
            
            if stars.star1 == "0" {
                cell.star1.image = #imageLiteral(resourceName: "empty_star")
            } else if stars.star1 == "1" {
                cell.star1.image = #imageLiteral(resourceName: "bronze_star")
            } else if stars.star1 == "2" {
                cell.star1.image = #imageLiteral(resourceName: "silver_star")
            } else if stars.star1 == "3" {
                cell.star1.image = #imageLiteral(resourceName: "gold_star")
            }
            if stars.star2 == "0" {
                cell.star2.image = #imageLiteral(resourceName: "empty_star")
            } else if stars.star2 == "1" {
                cell.star2.image = #imageLiteral(resourceName: "bronze_star")
            } else if stars.star2 == "2" {
                cell.star2.image = #imageLiteral(resourceName: "silver_star")
            } else if stars.star2 == "3" {
                cell.star2.image = #imageLiteral(resourceName: "gold_star")
            }
            if stars.star3 == "0" {
                cell.star3.image = #imageLiteral(resourceName: "empty_star")
            } else if stars.star3 == "1" {
                cell.star3.image = #imageLiteral(resourceName: "bronze_star")
            } else if stars.star3 == "2" {
                cell.star3.image = #imageLiteral(resourceName: "silver_star")
            } else if stars.star3 == "3" {
                cell.star3.image = #imageLiteral(resourceName: "gold_star")
            }
            return cell
            
        } else if BewerkingControl.selectedSegmentIndex == 1 {
            let stars = fetchedResultsControllerD.object(at: indexPath)
            cell.timesTable.text = stars.timestable
            
            if stars.star1 == "0" {
                cell.star1.image = #imageLiteral(resourceName: "empty_star")
            } else if stars.star1 == "1" {
                cell.star1.image = #imageLiteral(resourceName: "bronze_star")
            } else if stars.star1 == "2" {
                cell.star1.image = #imageLiteral(resourceName: "silver_star")
            } else if stars.star1 == "3" {
                cell.star1.image = #imageLiteral(resourceName: "gold_star")
            }
            if stars.star2 == "0" {
                cell.star2.image = #imageLiteral(resourceName: "empty_star")
            } else if stars.star2 == "1" {
                cell.star2.image = #imageLiteral(resourceName: "bronze_star")
            } else if stars.star2 == "2" {
                cell.star2.image = #imageLiteral(resourceName: "silver_star")
            } else if stars.star2 == "3" {
                cell.star2.image = #imageLiteral(resourceName: "gold_star")
            }
            if stars.star3 == "0" {
                cell.star3.image = #imageLiteral(resourceName: "empty_star")
            } else if stars.star3 == "1" {
                cell.star3.image = #imageLiteral(resourceName: "bronze_star")
            } else if stars.star3 == "2" {
                cell.star3.image = #imageLiteral(resourceName: "silver_star")
            } else if stars.star3 == "3" {
                cell.star3.image = #imageLiteral(resourceName: "gold_star")
            }
            return cell
            
        } else {
            let stars = fetchedResultsControllerV.object(at: indexPath)
            cell.timesTable.text = stars.timestable
            
            if stars.star1 == "0" {
                cell.star1.image = #imageLiteral(resourceName: "empty_star")
            } else if stars.star1 == "1" {
                cell.star1.image = #imageLiteral(resourceName: "bronze_star")
            } else if stars.star1 == "2" {
                cell.star1.image = #imageLiteral(resourceName: "silver_star")
            } else if stars.star1 == "3" {
                cell.star1.image = #imageLiteral(resourceName: "gold_star")
            }
            if stars.star2 == "0" {
                cell.star2.image = #imageLiteral(resourceName: "empty_star")
            } else if stars.star2 == "1" {
                cell.star2.image = #imageLiteral(resourceName: "bronze_star")
            } else if stars.star2 == "2" {
                cell.star2.image = #imageLiteral(resourceName: "silver_star")
            } else if stars.star2 == "3" {
                cell.star2.image = #imageLiteral(resourceName: "gold_star")
            }
            if stars.star3 == "0" {
                cell.star3.image = #imageLiteral(resourceName: "empty_star")
            } else if stars.star3 == "1" {
                cell.star3.image = #imageLiteral(resourceName: "bronze_star")
            } else if stars.star3 == "2" {
                cell.star3.image = #imageLiteral(resourceName: "silver_star")
            } else if stars.star3 == "3" {
                cell.star3.image = #imageLiteral(resourceName: "gold_star")
            }
            return cell
        }
    }
    
    // MARK: - fetch all records from Userdata
    private func fetchAllRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records
            }
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        return result
    }
    
    // MARK: - Copy to Userdefaults
    func copyUserdataToUserdefaults(managedObjectContext: NSManagedObjectContext) {
        //print("Copying Userdata to localdata")
        // Read entity Userdata values
        let userdata = fetchAllRecordsForEntity("TimesTable", inManagedObjectContext: managedObjectContext)
        var tablearray: Array<Any> = []
        // Check if Userdefaults exist
        // Store to Userdefaults - Create array and store in localdata under key: mppcv
        // Read array of userdata in localdata
        if localdata.object(forKey: "userdata") != nil {
            //print("userdata exists in localdata")
            tablearray = localdata.array(forKey: "userdata")!
        } else {
            //print("userdata does not exist in localdata")
            tablearray = [] as [Any]
        }
        
        for userData in userdata {
            //print("userData: ", userData)
            let dict = ["table": (userData.value(forKey: "timestable")) as! String, "star1": (userData.value(forKey: "star1")) as! String, "star2": (userData.value(forKey: "star2")) as! String, "star3": (userData.value(forKey: "star3")) as! String,  "lastupdate": (userData.value(forKey: "lastupdate")) as! Date] as [String : Any]
            //print("dict: ", dict)
            
            
            // Add mppcv to array of userdata in localdata
            tablearray.append(userData.value(forKey: "timestable")!)
            localdata.set(tablearray, forKey: "userdata")
            localdata.set(dict, forKey: (userData.value(forKey: "timestable")) as! String)
            //print("saved \(String(describing: userData.value(forKey: "mppcv"))) to localdata")
        }
    }
    
    // MARK: - private fetch records
    private func fetchRecordsForEntity(_ entity: String, key: String, arg: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records
            }
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        return result
    }
    
    // MARK: - private create record
    private func createRecordForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObject? {
        // Helpers
        var result: NSManagedObject?
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)
        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
        }
        return result
    }
    
    // MARK: - add userdata
    func addUserData(tableValue: String, userkey: String, uservalue: Bool, managedObjectContext: NSManagedObjectContext) {
        // one-to-one relationship
        // Check if record exists
        //print("addUserData: \(mppcvValue), \(userkey), \(uservalue)")
        let userdata = fetchRecordsForEntity("TimesTable", key: "timestable", arg: tableValue, inManagedObjectContext: managedObjectContext)
        if userdata.count == 0 {
            //            print("data line does not exist")
            if let newUserData = createRecordForEntity("TimesTable", inManagedObjectContext: managedObjectContext) {
                newUserData.setValue(uservalue, forKey: userkey)
                newUserData.setValue(tableValue, forKey: "timestable")
                let TT = fetchRecordsForEntity("TimesTable", key: "timestable", arg: tableValue, inManagedObjectContext: managedObjectContext)
                newUserData.setValue(Date(), forKey: "lastupdate")
                for tt in TT {
                    tt.setValue(newUserData, forKeyPath: "userdata")
                }
            } else {
                print("not newUserData")
            }
        } else {
            print("data line exists")
            for userData in userdata {
                userData.setValue(uservalue, forKey: userkey)
                userData.setValue(tableValue, forKey: "timestable")
                userData.setValue(Date(), forKey: "lastupdate")
            }
            
        }
    }
    
    // MARK: - Copy Userdefaults to UserData (DB) --> after update!
    func copyUserDefaultsToUserData(managedObjectContext: NSManagedObjectContext) {
        let context = self.appDelegate.persistentContainer.viewContext
        //        print("Copying localdata to Userdata")
        // Read UserDefaults array: from localdata, key: userdata
        //        print("Localdata: \(String(describing: localdata.array(forKey: "userdata")))")
        // Use UserDefaults array values to obtain dictionary data
        for userData in localdata.array(forKey: "userdata")! {
            //            print("userdata: \(userData)")
            let dict = localdata.dictionary(forKey: (userData as! String))
            //            print("Dict: \(dict!)")
            for (key, value) in dict! {
                if key == "timestable" {
                    addUserData(tableValue: (userData as! String), userkey: key, uservalue: (value as! Bool), managedObjectContext: context)
                }
            }
        }
    }

}
