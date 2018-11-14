//
//  PostsTableViewController.swift
//  SnapchatProject
//
//  Created by Paige Plander on 3/9/17.
//  Copyright © 2017 org.iosdecal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD

class PostsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum Constants {
        static let postBackgroundColor = UIColor.black
        static let postPhotoSize = UIScreen.main.bounds
    }
    
    // Dictionary that maps IDs of images to the actual UIImage data
    var loadedImagesById: [String:UIImage] = [:]
    
    
    let currentUser = CurrentUser()
    
    /// Table view holding all posts from each thread
    @IBOutlet weak var postTableView: UITableView!
    
    /// Button that displays the image of the post selected by the user
    var postImageViewButton: UIButton = {
        var button = UIButton(frame: Constants.postPhotoSize)
        button.backgroundColor = Constants.postBackgroundColor
        // since we only want the button to appear when the user taps a cell, hide the button until a cell is tapped
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.delegate = self
        postTableView.dataSource = self
        
        // add the button that displays the selected post's image to this view
        view.addSubview(postImageViewButton)
        
        // By adding a target here, every time the button is pressed, hidePostImage will be called 
        // (this is the programmatic way of adding an IBAction to a button)
        postImageViewButton.addTarget(self, action: #selector(self.hidePostImage(sender:)), for: UIControlEvents.touchUpInside)
        
//        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(refreshEvery15Secs), userInfo: nil, repeats: true)
        
    }
    
    

//    var gameTimer: NSTimer!
//    var refresher: UIRefreshControl!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        yourButton.addTarget(self, action: "refresh:", forControlEvents: .TouchUpInside)
//        refresher = UIRefreshControl()
//        refresher.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
//
//        timer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector:"refreshEvery15Secs", userInfo: nil, repeats: true)
//    }
    
//    func refreshEvery15Secs(){
//
//    }
    
//    func refresh(sender: AnyObject){
//
//        refreshEvery15Secs() // calls when ever button is pressed
//    }
    
    
    
    // Remember that this method will be called everytime this view appears.
    override func viewWillAppear(_ animated: Bool) {
        // Reload the tablebview.
        postTableView.reloadData()
        // Update the data from Firebase
        updateData()
    }
    
    
    /*
     This function uses the 'getPosts' function to retrieve all of the posts in the database. We pass in the currentUser property declared above so that we know if the posts have been read or not.
     Using the posts variable that is returned, we are doing the following:
     - First clearing the current dictionary of posts (in case we're reloading this feed again). We are doing this by calling the 'clearThreads' function.
     - For each post in the array:
     - We are adding the post to the thread using the 'addPostToThread' function
     - Using the postImagePath property of the post, we are retrieving the image data from the storage module (there is a function in ImageFeed.swift that does this for us already, implemented by you. *Thanks!*).
     - We are creating a UIImage from the data and adding a new element to the 'loadedImagesById' variable using the image and post ID.
     - After iterating through all the posts, we are reloading the tableview.
     
     */
    func updateData() {
        getPosts(user: currentUser) { (posts) in
            if let posts = posts {
                clearThreads()
                for post in posts {
                    addPostToThread(post: post)
                    getDataFromPath(path: post.postImagePath, completion: { (data) in
                        if let data = data {
                            if let image = UIImage(data: data) {
                                self.loadedImagesById[post.postId] = image
                            }
                        }
                    })
                }
                self.postTableView.reloadData()
            }
        }
    }

    
    // MARK: Custom methods (relating to UI)
    @objc func hidePostImage(sender: UIButton) {
        sender.isHidden = true
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    // TODO:
    // Uncomment all the commented lines in this function.
    // This is where we are actually calling some methods to fetch the image
    // from database and presenting it to the user.
    func presentPostImage(forPost post: Post) {
        if let image = loadedImagesById[post.postId] {
            postImageViewButton.isHidden = false
            postImageViewButton.setImage(image, for: .normal)
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.isHidden = true
        } else {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            getDataFromPath(path: post.postImagePath, completion: { (data) in
                if let data = data {
                    let image = UIImage(data: data)
                    self.loadedImagesById[post.postId] = image
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.postImageViewButton.isHidden = false
                    self.postImageViewButton.setImage(image, for: .normal)
                    // hide the navigation and tab bar for presentation
                    self.navigationController?.navigationBar.isHidden = true
                    self.tabBarController?.tabBar.isHidden = true
                }
            })
        }
    }
    
    // MARK: Table view delegate and datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return threadNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return threadNames[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostsTableViewCell
        if let post = getPostFromIndexPath(indexPath: indexPath) {
            if post.read {
                cell.readImageView.image = UIImage(named: "read")
            }
            else {
                cell.readImageView.image = UIImage(named: "unread")
            }
            cell.usernameLabel.text = post.username
            cell.timeElapsedLabel.text = post.getTimeElapsedString()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let threadName = threadNames[section]
        return threads[threadName]!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let post = getPostFromIndexPath(indexPath: indexPath), !post.read {
            presentPostImage(forPost: post)
            post.read = true
            
            // Adding the selected post as one of the current user's read posts
            currentUser.addNewReadPost(postID: post.postId)
            
            // Reloading the cell that the user tapped so the unread/read image updates
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
     
    }
    
}
