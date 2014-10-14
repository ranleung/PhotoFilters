//
//  ViewController.swift
//  PhotoFilters
//
//  Created by Randall Leung on 10/13/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, GalleryDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var image = UIImage(named: "photo2.jpg")
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        //Seeding Core Data
        var seeder = CoreDataSeeder(context: appDelegate.managedObjectContext!)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_GALLERY" {
            let destinationVC = segue.destinationViewController as GalleryViewController
            //Setting the destinationVC's delegate back to self.
            destinationVC.delegate = self
        }
    }
    
    @IBAction func photosPressed(sender: AnyObject) {
        println("Button Pressed")
        
        //Setting up the UI Alert
        let alertController = UIAlertController(title: nil, message: "Choose an option", preferredStyle: UIAlertControllerStyle.ActionSheet)
        //Setting up the Gallery button
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.performSegueWithIdentifier("SHOW_GALLERY", sender: self)
        }
        
        //The UIImagePickerController class manages customizable, system-supplied user interfaces for taking pictures and movies on supported devices, and for choosing saved images and movies for use in your app.
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        //Setting the destinationVC's delegate back to self.
        imagePicker.delegate = self
        
        //Cancal Action
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        //Photo Library
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (action) -> Void in
            //UIDevice provides a singleton instance representing the current device
            if UIDevice.currentDevice().model == "iPhone Simulator" {
                imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            } else {
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        //Camera Action
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            //Putting the image picked to presentViewController
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        //Filters
        let filterAction = UIAlertAction(title: "Filters", style: UIAlertActionStyle.Default) { (action) -> Void in
            
        }
        
        //Attaching an action object to the alert or action sheet.
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(filterAction)
        //Check to see if the device has a Camera, if yes, present the option for Camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            alertController.addAction(cameraAction)
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Being called automatically from the delegate?
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //The function that will be called on by the custom delegate
    func didTapOnPicture(image: UIImage?) {
        println("did tap on picture")
        //From the custom delegate, the image is now the self.imageView.image
        self.imageView.image = image
    }
    
    

}

