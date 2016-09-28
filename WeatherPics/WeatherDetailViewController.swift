//
//  WeatherDetailViewController.swift
//  WeatherPics
//
//  Created by Tracy Richard on 7/8/16.
//  Copyright © 2016 Jack Richard. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    var managedObjectContext : NSManagedObjectContext?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var weatherImage : WeatherImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: #selector(WeatherDetailViewController.showEditWeatherCaptionDialog))
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.captionLabel.text = "Loading Image..."
        self.spinner.startAnimating()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.captionLabel.text = weatherImage?.caption
        if let imageString = weatherImage?.imageUrl {
            if let imageUrl = NSURL(string: imageString) {
                if let imageData = NSData(contentsOfURL: imageUrl) {
                    imageView.image = UIImage(data: imageData)
                    self.spinner.stopAnimating()
                } else {
                    print("No Data for The given URL")
                }
            }
        }
    }

    func showEditWeatherCaptionDialog() {
        let alertController = UIAlertController(title: "Edit Image Caption", message: "", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler {(textField) -> Void in
            textField.placeholder = "Caption"
            textField.text = self.weatherImage?.caption
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) -> Void in
            print("Pressed Cancel.")
        }
        let editAction = UIAlertAction(title: "Edit Caption", style: .Default) {
            (action) -> Void in
            let captionTextField = alertController.textFields![0] as UITextField
            self.weatherImage?.caption = captionTextField.text!

            self.weatherImage?.lastTouchDate = NSDate()
            
            do {
                try self.managedObjectContext?.save()
            } catch {
                print("error")
                abort()
            }
            
            
            
            self.updateView()
        }
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(editAction)
        
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    func updateView() {
        captionLabel.text = weatherImage?.caption
    }
  

}
