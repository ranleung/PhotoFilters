//
//  PhotosFrameworkViewController.swift
//  PhotoFilters
//
//  Created by Randall Leung on 10/15/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit
import Photos

class PhotosFrameworkViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    
    weak var delegate: PhotoDelegate?
    
    //Fetches or generates image data for photo or video assets.
    var imageManager: PHCachingImageManager!
    
    //A container for an ordered list of photo entity objects.
    var assetFetchResults: PHFetchResult!
    
    //Represents a collection of photo or video asset
    var assetCollection: PHAssetCollection!
    
    var assetCellSize: CGSize!
    
    var flowlayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fetch all assets, pass nil
        self.assetFetchResults = PHAsset.fetchAssetsWithOptions(nil)
        
        //Get the image, asset fetch results
        self.imageManager = PHCachingImageManager()
        
        //Determind device scale, adjust cell size
        var scale = UIScreen.mainScreen().scale
        //organizes items into a grid with optional header and footer views for each section
        var flowLayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        
        var cellSize = flowLayout.itemSize
        self.assetCellSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)
        
        var pinch = UIPinchGestureRecognizer(target: self, action: "pinchAction:")
        self.collectionView.addGestureRecognizer(pinch)
        
        self.flowlayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func pinchAction(pinch: UIPinchGestureRecognizer) {
        println("Just pinched")
        
        if pinch.state == UIGestureRecognizerState.Ended {
            println("Pinch Ended")
            println(pinch.velocity)
            
            self.collectionView.performBatchUpdates({ () -> Void in
                //Zooming in
                if pinch.velocity > 0 {
                    
                    if self.flowlayout.itemSize != CGSize(width: 300, height: 300) {
                        self.flowlayout.itemSize = CGSize(width: self.flowlayout.itemSize.width * 2, height: self.flowlayout.itemSize.height * 2)
                        println("THE ITEMSIZE IS: \(self.flowlayout.itemSize)")
                    }
                } else {
                    //Zoom out
                    if self.flowlayout.itemSize != CGSize(width: 75, height: 75) {
                        self.flowlayout.itemSize = CGSize(width: self.flowlayout.itemSize.width * 0.5, height: self.flowlayout.itemSize.height * 0.5)
                        println("THE ITEMSIZE IS: \(self.flowlayout.itemSize)")
                    }
                }
            }, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetFetchResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PHOTOS_CELL", forIndexPath: indexPath) as PhotosFrameworkCell
        
        //To make sure that the cell doesn't get repeated
        //cell.tag = 0
        var currentTag = cell.tag + 1
        //cell.tag = 1
        cell.tag = currentTag
        println(cell.tag)
        
        var asset = self.assetFetchResults[indexPath.row] as PHAsset
        
        self.imageManager.requestImageForAsset(asset, targetSize: self.assetCellSize, contentMode: PHImageContentMode.AspectFit, options: nil) { (image, info) -> Void in
            
            if cell.tag == currentTag {
                cell.imageView.image = image
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var newImage: UIImage?
        var asset = self.assetFetchResults[indexPath.row] as PHAsset
        
        //For the bigger picture
        self.imageManager.requestImageDataForAsset(asset, options: nil) { (data, string, orientation, info) -> Void in
            println(info.description)
            newImage = UIImage(data: data)
            self.delegate?.controller(self, didTapOnPicture: newImage)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    

    
}



















