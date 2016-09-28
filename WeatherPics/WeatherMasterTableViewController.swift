//
//  WeatherMasterTableViewController.swift
//  WeatherPics
//
//  Created by Tracy Richard on 7/8/16.
//  Copyright © 2016 Jack Richard. All rights reserved.
//

import UIKit
import CoreData


class WeatherMasterTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext : NSManagedObjectContext?
    
    let weatherImageCellIdentifier = "WeatherImageCell"
    let noWeatherImageCellIdentifier = "NoWeatherImageCell"
    let showDetailSegueIdentifier = "ShowDetailSegue"
    let weatherImageEntityName = "WeatherImage"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = self.editButtonItem()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(WeatherMasterTableViewController.showAddWeatherImageDialog))
    }

    var weatherImageCount : Int {
        return fetchedResultsController.sections![0].numberOfObjects
    }
    func getWeatherImageAtIndexPath(indexPath : NSIndexPath) -> WeatherImage {
        return fetchedResultsController.objectAtIndexPath(indexPath) as! WeatherImage
    }
    
    func showAddWeatherImageDialog() {
        let alertController = UIAlertController(title: "Link and Caption a new weather image.", message: "", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Caption"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Image URL"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) -> Void in
            print("Canceled.")
        }
        let createAction = UIAlertAction(title: "Create Weather Image", style: .Default) {
            (action) -> Void in
            
            let captionTextField = alertController.textFields![0] as UITextField
            let imageUrlTextField = alertController.textFields![1] as UITextField
            let newWeatherImage = NSEntityDescription.insertNewObjectForEntityForName(self.weatherImageEntityName, inManagedObjectContext: self.managedObjectContext!) as! WeatherImage
            newWeatherImage.caption = captionTextField.text
            if imageUrlTextField.text == "" {
                newWeatherImage.imageUrl = self.getRandomImageUrl()
            } else {
            newWeatherImage.imageUrl = imageUrlTextField.text
            }
            newWeatherImage.lastTouchDate = NSDate()
            self.saveManagedObjectContext()
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    func getRandomImageUrl() -> String {
        let testImages = ["http://upload.wikimedia.org/wikipedia/commons/0/04/Hurricane_Isabel_from_ISS.jpg",
                          "http://t.wallpaperweb.org/wallpaper/nature/1920x1080/Lightning_Storm_Over_Fort_Collins_Colorado.jpg",
                          "http://upload.wikimedia.org/wikipedia/commons/0/00/Flood102405.JPG",
                          "http://upload.wikimedia.org/wikipedia/commons/6/6b/Mount_Carmel_forest_fire14.jpg"]
        let randomIndex = Int(arc4random_uniform(UInt32(testImages.count)))
        return testImages[randomIndex];
    }

    func saveManagedObjectContext() {
        do {
            try managedObjectContext?.save()
        } catch {
            abort()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return max(weatherImageCount,1)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        if weatherImageCount == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(noWeatherImageCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(weatherImageCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            
            let weatherImage = self.getWeatherImageAtIndexPath(indexPath)
            cell.textLabel?.text = weatherImage.caption
        }
        
        return cell
        
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return weatherImageCount > 0
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let imageToDelete = self.getWeatherImageAtIndexPath(indexPath)
            managedObjectContext?.deleteObject(imageToDelete)
            saveManagedObjectContext()
            
            
        }
        
    }

    // Mark: - Fetched Results Controller
    
    var fetchedResultsController : NSFetchedResultsController {
        
        let fetchRequest = NSFetchRequest(entityName: weatherImageEntityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastTouchDate", ascending: false)]
        fetchRequest.fetchBatchSize = 20
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        _fetchedResultsController = frc
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            print("Error")
            abort()
        }
        return _fetchedResultsController!
    }
    var _fetchedResultsController : NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if self.weatherImageCount == 1 {
                self.tableView.reloadData()
            } else {
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            }
        case .Delete:
            if (weatherImageCount == 0) {
                tableView.reloadData()
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            }
            
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showDetailSegueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                let weatherImage = self.getWeatherImageAtIndexPath(indexPath)
                (segue.destinationViewController as! WeatherDetailViewController).weatherImage = weatherImage
                
                (segue.destinationViewController as! WeatherDetailViewController).managedObjectContext = managedObjectContext
            }
        }
    }

    
}

