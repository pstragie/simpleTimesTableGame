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

    // MARK: - Outlets
    @IBOutlet weak var buttonResetStars: UIButton!
    @IBOutlet weak var DifficultyControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            try self.fetchedResultsController.performFetch()
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

    // MARK: - Unwind
    @IBAction func unwindToOverview(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? ExerciseViewController {
            let finished = sourceViewController.finished
            //let timestable = sourceViewController.selectedTable!
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
        switch segue.identifier! {
        case "SegueToExercise":
            let destination = segue.destination as! ExerciseViewController
            let indexPath = tableView.indexPathForSelectedRow!
            destination.selectedTable = String(describing: indexPath)
            destination.difficultyLevel = Int(DifficultyControl.selectedSegmentIndex)

        //            print("Segue: \(segue.identifier!)!")
        default:
            //            print("Segue: \(segue.identifier!)!")
            break
        }
        
    }

    // MARK: - fetchedResultsController
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<TimesTable> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<TimesTable> = TimesTable.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestable", ascending: true)]
        // Create Fetched Results Controller
        //let predicate = NSPredicate(format: "timestable BEGINSWITH[c] %@", "1")
        //fetchRequest.predicate = predicate
        let context = self.appDelegate.persistentContainer.viewContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        return fetchedResultsController
    }()

    // MARK: - Table data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let timestables = fetchedResultsController.fetchedObjects else { return 0 }
        tableView.layer.cornerRadius = 3
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 1
        print("number of rows: \(timestables.count)")
        return timestables.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
        
        cell.timesTable.text = stars.timestable
        cell.star1.image = #imageLiteral(resourceName: "empty_star")
        cell.star2.image = #imageLiteral(resourceName: "empty_star")
        cell.star3.image = #imageLiteral(resourceName: "empty_star")
        
        return cell
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

