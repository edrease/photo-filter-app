//
//  FilterService.swift
//  ParseStarterProject
//
//  Created by Edrease Peshtaz on 8/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class FilterService {

  class func distortedImageForOriginalImage(image: UIImage, context: CIContext) -> UIImage? {
    let imageToPrepare = CIImage(image: image)
    let filterToApply = CIFilter(name: "CIBumpDistortionLinear")
    filterToApply.setValue(imageToPrepare, forKey: kCIInputImageKey)
    return FilterService.filteredImageFromFilter(filterToApply, context: context)
  }
  
  class func invertedImageForOriginalImage (image: UIImage, context: CIContext) -> UIImage? {
    let imageToPrepare = CIImage(image: image)
    let filterToApply = CIFilter(name: "CIColorInvert")
    filterToApply.setValue(imageToPrepare, forKey: kCIInputImageKey)
    return FilterService.filteredImageFromFilter(filterToApply, context: context)
  }
  
  class func posterizedImageForOriginalImage(image: UIImage, context: CIContext) -> UIImage? {
    let imageToPrepare = CIImage(image: image)
    let filterToApply = CIFilter(name: "CIColorPosterize")
    filterToApply.setValue(imageToPrepare, forKey: kCIInputImageKey)
    return FilterService.filteredImageFromFilter(filterToApply, context: context)
  }

  class func filteredImageFromFilter (filter: CIFilter, context: CIContext) -> UIImage? {
    let outputImage = filter.outputImage
    let extent = outputImage.extent()
    let cgImage = context.createCGImage(outputImage, fromRect: extent)
    let finalImage = UIImage(CGImage: cgImage)
    return finalImage
  }

}