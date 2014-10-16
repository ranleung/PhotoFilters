//
//  GalleryViewController.swift
//  PhotoFilters
//
//  Created by Randall Leung on 10/13/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    
    //This can be any type since its a protocol now, must be optional
    weak var delegate: PhotoDelegate?

    //Creating an empty array for image storage
    var images = [UIImage]()
    
    var flowlayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pinch = UIPinchGestureRecognizer(target: self, action: "pinchAction:")
        self.collectionView.addGestureRecognizer(pinch)
        
        self.flowlayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
    
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        //Getting the images from assets
        var image1 = UIImage(named: "photo2.jpg")
        var image2 = UIImage(named: "photo3.jpg")
        var image3 = UIImage(named: "photo4.jpg")
        var image4 = UIImage(named: "photo5.jpg")
        var image5 = UIImage(named: "photo6.jpg")
        var image6 = UIImage(named: "photo7.jpg")
        var image7 = UIImage(named: "photo8.jpg")
        
        //Appending the found images from assets into our array
        self.images.append(image1)
        self.images.append(image2)
        self.images.append(image3)
        self.images.append(image4)
        self.images.append(image5)
        self.images.append(image6)
        self.images.append(image7)
    }
    
    func pinchAction(pinch: UIPinchGestureRecognizer) {
        println("Pinched")
        
        if pinch.state == UIGestureRecognizerState.Ended {
            println("ended")
            println(pinch.velocity)
            self.collectionView.performBatchUpdates({ () -> Void in
                if pinch.velocity > 0 {
                    self.flowlayout.itemSize = CGSize(width: self.flowlayout.itemSize.width * 2, height: self.flowlayout.itemSize.height * 2)
                } else {
                    self.flowlayout.itemSize = CGSize(width: self.flowlayout.itemSize.width * 0.5, height: self.flowlayout.itemSize.height * 0.5)
                }
            }, completion: nil )
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as GalleryCell
        cell.imageView.image = self.images[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //The image is now being stored in the custom delegate.
        self.delegate?.didTapOnPicture(self.images[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //For Gallery Header and Footer
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        //For Header
        //A supplementary view that identifies the header for a given section.
        if kind == UICollectionElementKindSectionHeader {
            var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "GALLERY_HEADER", forIndexPath: indexPath) as GalleryHeaderView
            headerView.headerLabel.text = "My Trip"
            return headerView
        } else {
            var footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "GALLERY_FOOTER", forIndexPath: indexPath) as GalleryFooterView
            footerView.footerLabel.text = "\(self.images.count) Photos"
            return footerView
        }
    }
    
}







