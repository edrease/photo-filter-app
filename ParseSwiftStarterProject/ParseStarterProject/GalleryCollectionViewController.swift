//
//  GalleryCollectionViewController.swift
//  ParseStarterProject
//
//  Created by Edrease Peshtaz on 8/13/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Photos

protocol ImageSelectedDelegate: class {
  func controllerDidSelectImage(UIImage) -> (Void)
}

class GalleryCollectionViewController: UIViewController {
  
//MARK: Constants/Variables
  var fetchResult: PHFetchResult!
  let cellSize = CGSize(width: 100, height: 100)
  var desiredFinalImageSize: CGSize!
  var startingScale: CGFloat = 0
  var scale: CGFloat = 0
  weak var delegate: ImageSelectedDelegate?
  
//MARK: Outlets
  @IBOutlet weak var collectionView: UICollectionView!

//MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
    
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: "pinchRecognized:")
    collectionView.addGestureRecognizer(pinchGesture)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
//MARK: Helper Functions
  func pinchRecognized(pinch: UIPinchGestureRecognizer) {
    
    if pinch.state == UIGestureRecognizerState.Began {
      startingScale = pinch.scale
    }
    
    if pinch.state == UIGestureRecognizerState.Changed {
      println("do nothing")
    }
    
    if pinch.state == UIGestureRecognizerState.Ended {
      scale = startingScale * pinch.scale
      let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      let newSize = CGSize(width: layout.itemSize.width * scale, height: layout.itemSize.height * scale)
      
      collectionView.performBatchUpdates({ () -> Void in
        layout.itemSize = newSize
        layout.invalidateLayout()
        }, completion: nil)
      
    }
  } 

}

//MARK: UICollectionViewDataSource
extension GalleryCollectionViewController: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return fetchResult.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as! ThumbnailCell
    
    if let asset = fetchResult[indexPath.row] as? PHAsset {
      PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: cellSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image, info) -> Void in
        
        if let image = image {
          cell.imageView.image = image
        }
      })
    }
    return cell
  }
}

//MARK: UICollectionViewDelegate
extension GalleryCollectionViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    let options = PHImageRequestOptions()
    options.synchronous = true
    
    if let asset = fetchResult[indexPath.row] as? PHAsset {
      PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: desiredFinalImageSize, contentMode: PHImageContentMode.AspectFill, options: options, resultHandler: { (image, info) -> Void in
        
        if let image = image {
          self.delegate?.controllerDidSelectImage(image)
          self.navigationController?.popViewControllerAnimated(true)
        }
      })
    }
  }
}
