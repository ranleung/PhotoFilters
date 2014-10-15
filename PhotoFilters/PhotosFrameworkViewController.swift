//
//  PhotosFrameworkViewController.swift
//  PhotoFilters
//
//  Created by Randall Leung on 10/15/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit
import Photos

class PhotosFrameworkViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    
    
    //Fetches or generates image data for photo or video assets.
    var imageManager: PHCachingImageManager!
    
    //A container for an ordered list of photo entity objects.
    var assetFetchResults: PHFetchResult!
    
    //Represents a collection of photo or video asset
    var assetCollection: PHAssetCollection!

    
    var assetCellSize: CGSize!    
    
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
        
        self.collectionView.dataSource = self
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
        
        self.imageManager.requestImageForAsset(asset, targetSize: self.assetCellSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
            
            if cell.tag == currentTag {
                cell.imageView.image = image
            }
            
        }
        return cell
    }

}



















