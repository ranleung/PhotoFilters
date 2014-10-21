//
//  FilterThumbnail.swift
//  PhotoFilters
//
//  Created by Randall Leung on 10/14/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class FilterThumbnail {
    
    var originalThumbnail: UIImage
    var filteredThumbnail: UIImage?
    var imageQueue: NSOperationQueue
    var gpuContext: CIContext
    var filter: CIFilter?
    var filterName: String
    
    //Takes in the filter name, "Sepia", and returns the filtered photo
    init(name: String, thumbnail: UIImage, queue: NSOperationQueue, context: CIContext) {
        self.filterName = name
        self.originalThumbnail = thumbnail
        self.imageQueue = queue
        self.gpuContext = context
    }
    
    //Takes in an image and async return competionHandler with filtered image
    func generateThumbnail ( completionHandler: (image: UIImage)->Void ) {
        //Going to another thread to filter
        self.imageQueue.addOperationWithBlock { () -> Void in
            
            //Setting up the filter with CIImage from the original thumbnail
            var image = CIImage(image: self.originalThumbnail)
            //Calling the filter name to make it into CIFilter
            var imageFilter = CIFilter(name: self.filterName)
            //Sets all input values for a filter to default values.
            imageFilter.setDefaults()
            
            if self.filterName == "CIBloom" {
                imageFilter.setValue(10.0, forKey: kCIInputRadiusKey)
                imageFilter.setValue(5.0, forKey: kCIInputIntensityKey)
            }
            
            //kCIInputImageKey - A key for the CIImage object to use as an input image. For filters that also use a background image, this key refers to the foreground image.
            imageFilter.setValue(image, forKey: kCIInputImageKey)
            
            //Now to generate the results
            var result = imageFilter.valueForKey(kCIOutputImageKey) as CIImage
            //extent - Returns a rectangle that specifies the extent of the image.
            var extent = result.extent()
            var imageRef = self.gpuContext.createCGImage(result, fromRect: extent)
            self.filter = imageFilter
            self.filteredThumbnail = UIImage(CGImage: imageRef)
            
            //Back to main queue to pass back the image
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completionHandler(image: self.filteredThumbnail!)
            })
            
        }
    }
    
    func filterImage (image : UIImage, completionHandler : (filteredImage : UIImage) -> Void) {
        //Going to a different thread
        self.imageQueue.addOperationWithBlock({ () -> Void in
            //Setting up the filter with a CIImage, changes UIImage to CIImage
            var image = CIImage(image: image)
            self.filter!.setValue(image, forKey: kCIInputImageKey)
            
            if self.filterName == "CIBloom" {
                self.filter!.setValue(10.0, forKey: kCIInputRadiusKey)
                self.filter!.setValue(5.0, forKey: kCIInputIntensityKey)
            }
            
            //Generate the results
            var result = self.filter!.valueForKey(kCIOutputImageKey) as CIImage
            var extent = result.extent()
            //Filters in createCGImage
            var imageRef = self.gpuContext.createCGImage(result, fromRect: extent)
            let filteredImage = UIImage(CGImage: imageRef)
            
            //Back to main queue to pass back the image
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(filteredImage: filteredImage!)
            })
        })
    }
    
    
}










