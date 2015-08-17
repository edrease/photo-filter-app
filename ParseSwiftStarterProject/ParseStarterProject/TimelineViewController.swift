//
//  TimelineViewController.swift
//  ParseStarterProject
//
//  Created by Edrease Peshtaz on 8/11/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController {
  
//MARK: Constants/Variables
  var postArray = []

//MARK: Outlets
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var tableView: UITableView!
  
//MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.estimatedRowHeight = 300
    tableView.rowHeight = UITableViewAutomaticDimension
    
    let query = PFQuery(className: "Post")
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      if let error = error {
        println(error.localizedDescription)
      } else if let posts = results as? [PFObject] {
        self.postArray = posts
        println(posts.count)
        self.tableView.reloadData()
      }
    }
  
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

//MARK: UITableViewDataSource
extension TimelineViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return postArray.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! TableViewCell
    
    var post: AnyObject = postArray[indexPath.row]
    
    if let imageFile = post["image"] as? PFFile {
      imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
        if let error = error {
          println(error.localizedDescription)
        } else if let data = data,
          image = UIImage(data: data) {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              cell.postImageView?.image = image
              })
            }
        })
      }
    return cell
    
  }
}




