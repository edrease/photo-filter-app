//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
  
//MARK: Constants/Variables
  let alert = UIAlertController(title: "Choose an Action", message: "Choose Wisely", preferredStyle: UIAlertControllerStyle.ActionSheet)
  let picker = UIImagePickerController()
  let context = CIContext(options: nil)
  let kBottomCollectionViewBufferShow: CGFloat = 0
  let kBottomCollectionViewBufferHide: CGFloat = -108
  var filterOptionThumbnail: UIImage!
  var kthumbnailSize = CGSize(width: 100, height: 100)
  var displayImage: UIImage! {
    didSet {
      imageView.image = displayImage
      filterOptionThumbnail = ImageResizer.resizeImage(displayImage, size: kthumbnailSize)
      collectionView.reloadData()
    }
  }
  var filters = [FilterService.distortedImageForOriginalImage, FilterService.invertedImageForOriginalImage, FilterService.posterizedImageForOriginalImage]
  
//MARK: Outlets
  @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cameraButtonPressedOutlet: UIButton!
  
//MARK: Actions
  @IBAction func cameraButtonPressed(sender: AnyObject) {
    alert.modalPresentationStyle = UIModalPresentationStyle.Popover
    if let popover = alert.popoverPresentationController {
      popover.sourceView = view
      popover.sourceRect = cameraButtonPressedOutlet.frame
    }
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
//MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self

    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
    
    let uploadPostAction = UIAlertAction(title: "Upload!", style: UIAlertActionStyle.Default) { (alert) -> Void in
      
      if let imageExists = self.imageView.image {
        let post = PFObject(className: "Post")
        if let image = self.imageView.image,
          data = UIImageJPEGRepresentation(image, 1) {
            
            let imageToUpload = PFFile(name: "Picture.jpeg", data: data)
            post["image"] = imageToUpload
        }
        
        post.saveInBackgroundWithBlock({ (success, error) -> Void in
          
        })
      }
    }
    
    let galleryAction = UIAlertAction(title: "Choose Photo", style: UIAlertActionStyle.Default) { (alert) -> Void in
      self.performSegueWithIdentifier("ToGalleryViewController", sender: self)
    }
    
    let filterAction = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default) { (alert) -> Void in
      self.enterFilterMode()
    
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
        self.enterFilterMode()
      }
    }
    
    alert.addAction(galleryAction)
    alert.addAction(filterAction)
    alert.addAction(cancelAction)
    alert.addAction(uploadPostAction)
    
    displayImage = imageView.image
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
//MARK: Helper Functions
  func enterFilterMode() {
    collectionViewBottomConstraint.constant = kBottomCollectionViewBufferShow
    
    UIView.animateWithDuration(0.4, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "closeFilterMode")
    navigationItem.rightBarButtonItem = doneButton
  }
  
  func closeFilterMode() {
    collectionViewBottomConstraint.constant = kBottomCollectionViewBufferHide
    UIView.animateWithDuration(0.4, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ToGalleryViewController" {
      if let galleryViewController = segue.destinationViewController as? GalleryCollectionViewController {
        galleryViewController.delegate = self
        galleryViewController.desiredFinalImageSize = imageView.frame.size
      }
    }
  }
  
}

//MARK: UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
    displayImage = image
    self.picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.picker.dismissViewControllerAnimated(true, completion: nil)
  }
}

//MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filters.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! ThumbnailCell
    let filter = filters[indexPath.row]
    if let filterOptionThumbnail = filterOptionThumbnail {
      let filteredImage = filter(filterOptionThumbnail, context: context)
      cell.imageView.image = filteredImage
    }
    return cell
  }
}

//MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let filter = filters[indexPath.row]
    if let image = imageView.image {
      self.displayImage = filter(image, context: context)
      imageView.image = displayImage
    }
  }
}

//MARK: UIImageSelectedDelegate
extension ViewController: ImageSelectedDelegate {
  func controllerDidSelectImage(newImage: UIImage) {
    displayImage = newImage
  }
}


//      let options = [kCIContextWorkingColorSpace, NSNull()]
//      let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES3)
//      let gpuContext = CIContext(EAGLContext: eaglContext, options: options)

