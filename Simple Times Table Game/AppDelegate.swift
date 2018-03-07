//
//  AppDelegate.swift
//  Simple Times Table Game
//
//  Created by Pieter Stragier on 06/03/2018.
//  Copyright © 2018 PWS-apps. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var errorHandler: (Error) -> Void = {_ in }
    var appVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
    var appBuild: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String)!
    var newBuild:Bool = false
    var newDbFiles: Bool = false
    let localdata = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: Check current version
        let defaults = UserDefaults.standard
        
        guard let currentAppVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, let previousVersion = defaults.string(forKey: "appVersion") else {
            // Key does not exist in UserDefaults, must be a fresh install
            print("Fresh install")
            // Writing version to UserDefaults for the first time
            defaults.set(appBuild, forKey: "appVersion")
            
            // MARK: Load from CSV, for update of database!
            // Developer use only! Load persistent store with data from csv files.
            // Step 1: Delete the database files (3) in the Main folder (on the left and in Finder)
            // Step 2: Delete the app from the simulator
            // Step 3: Delete the csv files and add the new csv files
            // Step 4: Set the newDbFiles to "true"
            newDbFiles = false

            // Step 5: Run the app (10 seconds or more to read and load all the files)
            // Step 6a: Locate the database files (3)
            // Step 6b: Copy the database files (3) from the "NSHomeDir" folder
            // Step 7: Set the newDbFiles to "false"
            
            
            if newDbFiles == false {
                print("No new csv files")
                preloadDBData()
                print("NSHomeDir: \(NSHomeDirectory())")
            } else {
                print("New csv files")
                let moc = persistentContainer.viewContext
                seedPersistentStoreWithManagedObjectContext(moc)
                print("NSHomeDir: \(NSHomeDirectory())")
            }
            
            //             Print local file directory
            //            let fm = FileManager.default
            //            let appdir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            //            print("appdir: \(appdir)")
            
            // Save Managed Object Context
            self.saveContext()
            
            return false
        }
        
        //        print("currentAppVersion: \(currentAppVersion)")
        //        print("previousAppVersion: \(previousVersion)")
        let comparisonResult = currentAppVersion.compare(previousVersion, options: .numeric, range: nil, locale: nil)
        switch comparisonResult {
        case .orderedSame:
            //            print("Same build is running like before")
            newBuild = false
            break
        case .orderedAscending:
            //            print("older build installed")
            newBuild = true
            break
        case .orderedDescending:
            //            print("new build installed")
            newBuild = true
            break
        }
        
        // Updating new version to UserDefaults
        defaults.set(currentAppVersion, forKey: "appVersion")
        
        // MARK: preloaDBData of three database files included in the app
        // For distribution purposes!
        // Unmark simultaneously with marking the seedPersistentDatabase function to import csv!
        
        preloadDBData()
        
        // Save Managed Object Context
        self.saveContext()
        
        return true

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func parseCSV (contentsOf: NSURL, encoding: String.Encoding, error: NSErrorPointer) -> [(Array<String>,Array<Array<String>>)]? {
        // Load the CSV file and parse it
        
        print("Loading CSV file...")
        let delimiter = ";"
        //let content = "(contentsOf: contentsOf, encoding: encoding, error: error)"
        var keys = [String]()
        var lines = [String]()
        var items = [[String]]()
        
        
        do {
            lines = try String(contentsOf: contentsOf as URL, encoding: encoding).components(separatedBy: NSCharacterSet.newlines)
        } catch {
            print("Error reading line.")
        }
        
        for line in lines[0...0] {
            keys = line.components(separatedBy: ";")
        }
        
        for line in lines[1..<lines.endIndex] {
            var values:[String] = []
            //print("line: \(line)")
            if line != "" {
                // For a line with double quotes
                // we use NSScanner to perform the parsing
                if line.range(of: "\"") != nil {
                    //                    print(line)
                    var textToScan:String = line
                    var value:NSString?
                    var textScanner:Scanner = Scanner(string: textToScan)
                    while textScanner.string != "" {
                        if (textScanner.string as NSString).substring(to: 1) == "\"" {
                            textScanner.scanLocation += 1
                            textScanner.scanUpTo("\"", into: &value)
                            textScanner.scanLocation += 1
                        } else {
                            textScanner.scanUpTo(delimiter, into: &value)
                        }
                        // Store the value into the values array
                        values.append(value! as String)
                        // Retrieve the unscanned remainder of the string
                        if textScanner.scanLocation < textScanner.string.characters.count {
                            textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                        } else {
                            textToScan = ""
                        }
                        textScanner = Scanner(string: textToScan)
                    }
                    
                    // For a line without double quotes, we can simply separate the string
                    // by using the delimiter (e.g. comma)
                } else  {
                    values = line.components(separatedBy: delimiter)
                    
                }
                // Put the values into a dictionary and add it to the items dictionary
                //print(values)
                items.append(values)
                
            }
        }
        //print("parsing: \([(keys, items)])")
        return [(keys, items)]
    }

    // MARK: - CSV Parsing
    func parseCSV2Dict (keys: [String], values: [[String]]) -> [Dictionary<String,String>] {
        print("CSV to dictionary")
        
        //print("keys ok: \(keys)")
        //print("values ok: \(values)")
        var items = [Dictionary<String,String>]()
        for v in values {
            var subd = [String:String]()
            for val in 0..<v.endIndex {
                //print("\(keys[val]) : \(v[val])")
                subd[keys[val].lowercased()] = v[val]
            }
            items.append(subd)
        }
        //print("items: \(items)")
        return items
    }

    // MARK: Preload all data from csv file
    func preloadData (entitynaam: String) -> [Dictionary<String,String>] {
        
        // Store date to track updates
        UserDefaults.standard.setValue(Date(), forKey: "last_update")
        let filename = "begindata"
        var items:[Dictionary<String,String>] = [[:]]
        print("Preloading data...")
        // Retrieve data from the source file
        if let path = Bundle.main.path(forResource: filename, ofType: "csv") {
            let contentsOfURL = NSURL(fileURLWithPath: path)
            var error:NSError?
            if let values = parseCSV(contentsOf: contentsOfURL, encoding: String.Encoding.utf8, error: &error) {
                print("parsing data successful...")
                //item -> Dictionary<String,String>
                let keys = values[0].0
                //print("keys: \(keys)")
                let val = values[0].1
                //print("val: \(val)")
                items = parseCSV2Dict(keys: keys, values: val) /* items = list of dictionaries */
                
            } else {
                print("Parsing of data failed")
            }
        } else {
            print("File not found!")
        }
        return items
    }

    
    func loadAllAttributes(entitynaam: String) {
        print("loading attributes...")
        let items = preloadData(entitynaam: entitynaam)
        var readLines: Float = 0.0
        var progressie: Float = 0.0
        let totalLines = Float(items.count)
        for item in items {
            readLines += 1
            progressie = readLines/totalLines
            print("progressie: \(progressie)")
            //            print("saveAttributes: \(entitynaam), \(dict)")
            var newdict: Dictionary<String,Any> = [:]
            for (key, value) in item {
                let key = key.replacingOccurrences(of: "\"", with: "")
                newdict[key] = value
            }
            
            self.saveAttributes(entitynaam: entitynaam, dict: newdict)
        }
    }
    
    // MARK: - seedPersistentStoreWithManagedObjectContext
    // CSV load version: obsolete!
    func seedPersistentStoreWithManagedObjectContext(_ managedObjectContext: NSManagedObjectContext) {
        if seedCoreDataContainerIfFirstLaunch() {
            //destroyPersistentStore()
            print("First Launch!!!")
            let Entities = ["TimesTable"]
            for entitynaam in Entities {
                //cleanCoreData(entitynaam: entitynaam)
                print(entitynaam)
                loadAllAttributes(entitynaam: entitynaam)
            }
        } else {
            print("Not the first launch!!!")
            // Check for updates
            /* let Entities = ["MPP"]
             for entitynaam in Entities {
             updateAllAttributes(entitynaam: entitynaam)
             } */
        }
    }

    // MARK: - Check for first launch
    func seedCoreDataContainerIfFirstLaunch() -> Bool {
        //1
        let previouslyLaunched = UserDefaults.standard.bool(forKey: "previouslyLaunched")
        if !previouslyLaunched {
            UserDefaults.standard.set(true, forKey: "previouslyLaunched")
            return true
            
        } else {
            
            return false
        }
    }
    
    // MARK: - createRecordForEntity
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
    
    // MARK: - fetchRecordsForEntity
    private func fetchRecordsForEntity(_ entity: String, key: String, arg: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let predicate = NSPredicate(format: "%K == %@", key, arg)
        fetchRequest.predicate = predicate
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
    
    // MARK: - saveAttributes
    func saveAttributes(entitynaam: String, dict: [String:Any]) {
        let managedObjectContext = persistentContainer.viewContext
        print("saving attributes...")
        
        if entitynaam == "TimesTable" {
            if let newTable = createRecordForEntity(entitynaam, inManagedObjectContext: managedObjectContext) {
                for (key, value) in dict {
                    newTable.setValue(value, forKey: key)
                }
            }
        }
        
        do {
            try managedObjectContext.save()
            print("context saved")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }

    
    // MARK: - preloadDBData Core Data stack
    func preloadDBData() {
        //        print("Preloading DB...")
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Datamodel.sqlite") {
            print("Files do not exist!")
            let sourceSqliteURLs = [URL(fileURLWithPath: Bundle.main.path(forResource: "Datamodel", ofType: "sqlite")!), URL(fileURLWithPath: Bundle.main.path(forResource: "Datamodel", ofType: "sqlite-wal")!), URL(fileURLWithPath: Bundle.main.path(forResource: "Datamodel", ofType: "sqlite-shm")!)]
            let destSqliteURLs = [URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Datamodel.sqlite"), URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Datamodel.sqlite-wal"), URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Datamodel.sqlite-shm")]
            //            print("destination: \(destSqliteURLs)")
            for index in 0 ..< sourceSqliteURLs.count {
                do {
                    try fileManager.copyItem(at: sourceSqliteURLs[index], to: destSqliteURLs[index])
                    //                    print("Files Copied!")
                } catch {
                    fatalError("Could not copy sqlite to destination.")
                }
            }
            // MARK: Print UserDefaults
            /*print("localdata: ", localdata)
             for (key, value) in localdata.dictionaryRepresentation() {
             print("\(key) = \(value) \n")
             }*/
        } else {
            //            print("Files Exist!")
            if newBuild == true {
                //                print("New build") // Copy the files
                
                let sourceSqliteURLs = [URL(fileURLWithPath: Bundle.main.path(forResource: "Datamodel", ofType: "sqlite")!), URL(fileURLWithPath: Bundle.main.path(forResource: "Datamodel", ofType: "sqlite-wal")!), URL(fileURLWithPath: Bundle.main.path(forResource: "Datamodel", ofType: "sqlite-shm")!)]
                let destSqliteURLs = [URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Datamodel.sqlite"), URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Datamodel.sqlite-wal"), URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Datamodel.sqlite-shm")]
                //                print("destination: \(destSqliteURLs)")
                // Delete old db files
                //                print("...deleting old sqlite files")
                for index in 0 ..< sourceSqliteURLs.count {
                    do {
                        try fileManager.removeItem(at: destSqliteURLs[index])
                    } catch {
                        fatalError("Could not delete old sqlite files at destination")
                    }
                }
                // Copy new db files to destination
                for index in 0 ..< sourceSqliteURLs.count {
                    do {
                        try fileManager.copyItem(at: sourceSqliteURLs[index], to: destSqliteURLs[index])
                    } catch {
                        fatalError("Could not copy sqlite to destination.")
                    }
                }
                //                print("Files Copied!")
                //ViewController().copyUserDefaultsToUserData(managedObjectContext: persistentContainer.viewContext)
            } else {
                //                print("Same build") // No need to copy the files.
            }
        }
    }

    
    // MARK: - persistentContainer
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Datamodel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

