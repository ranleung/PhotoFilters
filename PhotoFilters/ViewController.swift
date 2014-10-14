//
//  ViewController.swift
//  PhotoFilters
//
//  Created by Randall Leung on 10/13/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit
import CoreImage
import OpenGLES
import CoreData

class ViewController: UIViewController, GalleryDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewBottomConstraint: NSLayoutConstraint!
 
    @IBOutlet var imageView: UIImageView!
    
    let imageQueue = NSOperationQueue()
    
    //core data array, NSManagedObject
    var filters = [Filter]()
    //array of thumbnail wrapper objects
    var filterThumbnails = [FilterThumbnail]()
    var context: CIContext?
    var originalThumbnail: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var image = UIImage(named: "photo2.jpg")
        
        //Setting up our core image context
        self.generateThumbnail()
        var options = [kCIContextWorkingColorSpace: NSNull()]
        var myEAGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        self.context = CIContext(EAGLContext: myEAGLContext, options: options)
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        //Seeding Core Data
        var seeder = CoreDataSeeder(context: appDelegate.managedObjectContext!)
        seeder.seedCoreData()
        
        self.fetchFilters()
        self.resetFilterThumbnails()
        
        self.collectionView.dataSource = self
        
    }
    
    func enterFilterMode() {
        self.imageViewLeadingConstraint.constant = self.imageViewLeadingConstraint.constant * 2
        self.imageViewTrailingConstraint.constant = self.imageViewTrailingConstraint.constant * 2
        self.imageViewBottomConstraint.constant = self.imageViewBottomConstraint.constant * 2
        self.collectionViewBottomConstraint.constant = 100
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            //Lays out the subviews immediately.
            self.view.layoutIfNeeded()
        })
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "exitFilteringMode")
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func fetchFilters() {
        //An instance of NSFetchRequest describes search criteria used to retrieve data from a persistent store.
        var fetchRequest = NSFetchRequest(entityName: "Filter")
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context = appDelegate.managedObjectContext
        
        var error: NSError?
        //Returns an array of objects that meet the criteria specified by a given fetch request.
        let fetchResults = context?.executeFetchRequest(fetchRequest, error: &error)
        if let filters = fetchResults as? [Filter] {
            println("Number of filters: \(filters.count)")
            self.filters = filters
        }
    }
    
    func resetFilterThumbnails() {
        var newFilters = [FilterThumbnail]()
        for var i = 0; i < self.filters.count; ++i {
            var filter = self.filters[i]
            //From the NSManagedObject
            var filterName = filter.name
            //Look over this
            var thumbnail = FilterThumbnail(name: filterName, thumbnail: self.originalThumbnail!, queue: self.imageQueue, context: self.context!)
            newFilters.append(thumbnail)
        }
        self.filterThumbnails = newFilters
    }
    
    func exitFilteringMode() {
        //reset the contraints back to normal values
        //remove the Done button
        self.navigationItem.rightBarButtonItem = nil
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
            self.enterFilterMode()
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
    
    func generateThumbnail() {
        let size = CGSize(width: 100, height: 100)
        //Creates a bitmap-based graphics context and makes it the current context.
        UIGraphicsBeginImageContext(size)
        self.imageView.image?.drawInRect(CGRect(x: 0, y: 0, width: 100, height: 100))
        //Returns an image based on the contents of the current bitmap-based graphics context.
        self.originalThumbnail = UIGraphicsGetImageFromCurrentImageContext()
        //Removes the current bitmap-based graphics context from the top of the stack.
        UIGraphicsEndImageContext()
    }
    
    //Being called automatically from the delegate?
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //For the collectionView, number of filters in the section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FILTER_CELL", forIndexPath: indexPath) as FilterThumbnailCell
        var filterThumbnail = self.filterThumbnails[indexPath.row]
        //Lazy Loading
        if filterThumbnail.filteredThumbnail != nil {
            cell.imageView.image = filterThumbnail.filteredThumbnail
        } else {
            cell.imageView.image = filterThumbnail.originalThumbnail
            filterThumbnail.generateThumbnail({ (image) -> Void in
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? FilterThumbnailCell {
                    cell.imageView.image = image
                }
            })
        }
        return cell
    }
    
    //The function that will be called on by the custom delegate
    func didTapOnPicture(image: UIImage?) {
        println("did tap on picture")
        //From the custom delegate, the image is now the self.imageView.image
        self.imageView.image = image
        self.generateThumbnail()
        self.resetFilterThumbnails()
        self.collectionView.reloadData()
    }

}

