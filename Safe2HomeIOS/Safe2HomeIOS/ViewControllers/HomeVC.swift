//
//  ViewController.swift
//  Safe2HomeIOS
//
//  Created by Eric Le Ge on 11/1/18.
//  Copyright © 2018 Safe2Home. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseAuth
import SwiftGifOrigin



final class HomeVC: BaseViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    let manager: CLLocationManager = global_manager
    let gif = UIImage.gif(url: "https://www.mellatweb.com/uploads/posts/image/2018/2018-07/20-VnKCQ-2018-07-08-14:02.jpg")
    var current_location: CLLocation?
    let regionRadius: CLLocationDistance = 1000
    var selected_annotation: MKAnnotation?
    var match_permit = false
    var destPlacemark: MKPlacemark?
    var sourcePlacemark: MKPlacemark?
    
    var currentUser =  CurrentUser(id: (Auth.auth().currentUser?.uid)!)
    
    
    
    
    
    @IBOutlet weak var map: HomeMapView!
    
    @IBOutlet weak var RequestMatchTableView: UITableView!
    
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var destinationText: UITextField!
    
    @IBOutlet weak var searchRoute: UIButton!
    
    //********************
    //CHANNEL ZONE
    
    var current_channel:Channel?
    private var channelReference: CollectionReference {
        return Firestore.firestore().collection("channels")
    }
    
    //CHANNEL ZONE
    //********************
    
    //********************
    //MATCHING SUCESS ZONE
    //********************
    @IBOutlet weak var match_success_view: UIView!
    @IBOutlet weak var LoadingGif: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var affiliation: UILabel!
    @IBAction func GoToChat(_ sender: UIButton) {
        if let channel = current_channel{
            let vc = ChatVC(user: Auth.auth().currentUser!, channel: channel)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
   
    @IBAction func Conclude(_ sender: UIButton) {
    let alertController = UIAlertController(
            title: "Conclude Session?",
            message: "You will not be able to chat with your walking buddy anymore", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:
            "Cancel", style: .cancel, handler: nil)
        let concludeAction = UIAlertAction(title:
            "Conclude", style: .default, handler: { void in
                self.setView(view: self.matching_view, hidden: true)
                self.setView(view: self.match_success_view, hidden: true)
                deleteMatch(username: self.currentUser.username)
                if let other_match = self.name.text{
                    deleteMatch(username: other_match)
                }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(concludeAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func matchSuccess(post:[Post]?){
        guard let post = post else{
            print("Warning: No post found")
            return
        }
        match_permit = false
        setView(view: matching_view, hidden: true)
        setView(view: match_success_view, hidden: false)
        name.text = post[1].username
        major.text = post[1].major
        gender.text = post[1].gender
        affiliation.text = post[1].affiliation
        //Make a new channel
        let ref:DocumentReference = channelReference.document()
        let myId:String = ref.documentID
        let channel = Channel(name: (name.text ?? "anonymous") + " ∞ " + currentUser.username, id: myId)
        channelReference.document(myId).setData(channel.representation, completion:{ error in
            if let e = error {
                print("Error saving channel: \(e.localizedDescription)")
            }
        }
        )
        addMatch(client1: post[1], client2: post[0], chatId:myId)
        current_channel = channel
        return
    }
    
    func matchSuccess2(post: Post){
        match_permit = false
        setView(view: matching_view, hidden: true)
        setView(view: match_success_view, hidden: false)
        name.text = post.username
        major.text = post.major
        gender.text = post.gender
        affiliation.text = post.affiliation
        guard let myId = post.chat_id else {
            print("Warning: Match with no chat room id")
            return
        }
        current_channel = Channel(name: currentUser.username + " ∞ " + post.username, id: myId)
    }
    
    
    //********************
    //MATCHING SUCESS ZONE
    //********************
    
    //********************
    //MATCHING BOX ZONE
    //********************
    @IBOutlet weak var matching_view: UIView!
    @IBAction func cancel_matching(_ sender: UIButton) {
        setView(view: matching_view, hidden: true)
        match_permit = false
        deletePost(username: currentUser.username)
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionFlipFromTop, animations: {
            view.isHidden = hidden
        })
    }
    //********************
    //MATCHING BOX ZONE
    //********************
    @IBAction func Navigate(_ sender: UIButton) {
        
        guard let start = sourcePlacemark else{
            print("No start place")
            return
        }
        guard let dest = destPlacemark else{
            print("No dest place")
            return
            
        }
        let sourceItem = MKMapItem(placemark: start)
        let destItem = MKMapItem(placemark: dest)
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = MKDirectionsTransportType.walking
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: { response, error in
            guard let response = response else{
                if let error = error{
                    print("Unable to handle request")
                    print(error.localizedDescription)
                }
                return
            }
            let route = response.routes[0]
            print(route)
            
            self.map.addOverlay(route.polyline, level: .aboveRoads)
            let rekt = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegion(rekt), animated: true)
        })
        
        
    }
    
    
    @IBAction func RequestPostButton(_ sender: UIButton) {
        //        var _:String = CommentTextField.text ?? ""
        //        addPost(username: (Auth.auth().currentUser?.displayName)!, comment: CommentTextField.text!)
        //?? fill in the blank of current user
        //?? observe
        
        //get date again
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
        let dateString = dateFormatter.string(from: Date())
        
        guard let destination = selected_annotation else{
            let alertController = UIAlertController(
                title: "Destination Not Selected",
                message: "In order to be matched with a walking buddy, select your destination on the map", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title:
                "Okay", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let start = current_location else{
            let alertController = UIAlertController(
                title: "Location Disabled",
                message: "In order to be matched with a walking buddy, enable your location services", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title:
                "Okay", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let raw_affiliation = currentUser.email
        let affiliation_index = raw_affiliation.firstIndex(of: "@")
        var sliced_affiliation = raw_affiliation
        if let aff_index = affiliation_index{
            let nextIndex = raw_affiliation.index(aff_index, offsetBy: 1)
            sliced_affiliation = String(raw_affiliation.suffix(from: nextIndex))
        }
        
        let currentPost = Post(username: currentUser.username, dateString: dateString, gender: currentUser.gender, major: currentUser.major, major_pref: currentUser.major_pref, gender_pref: currentUser.gender_pref, profile_image_url: currentUser.profile_image_url, affiliation: sliced_affiliation, start_lat:start.coordinate.latitude, dest_lat:destination.coordinate.latitude, start_lon:start.coordinate.longitude, dest_lon:destination.coordinate.longitude)
        
        let postVC = PostsTableViewController()
        self.setView(view: self.matching_view, hidden: false)
        getPosts() { (posts) in
            if let posts = posts {
                print(posts)
                
                if let post = postVC.match(currentPost: currentPost, posts_array: posts){
                    self.matchSuccess(post:post)
                    return
                }
                
            }
            self.match_permit = true
            self.RequestMatchTableView.reloadData()
            //        RequestTableView.reloadData()
            addPost(client: currentPost)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pcell = RequestMatchTableView.dequeueReusableCell(withIdentifier: "RequestMatchCell", for: indexPath) as! MatchTableViewCell
        // can't find comment
        //pcell.commentmessage.text = comments[indexPath.row]["message"] as! String
        
        //        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PostsTableViewController.runTimedCode), userInfo: nil, repeats: true)
        if !match_permit{
            return pcell
        }
        getMatches(client1Name: currentUser.username) { (matches) in
            //            client1Name: currentUser.username
            if let matches = matches {
                for match in matches{
                    
                    self.matchSuccess2(post: match)
                    
                    return
                }
                print(matches, self.currentUser.username)
                
            }
            sleep(3)
            self.RequestMatchTableView.reloadData()
        }
        print("waiting for matches ...")
        return pcell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //ART
    func setParameters(){
        //destinationLabel.textAlignment = .center
        //destinationLabel.font = UIFont(name: "Superclarendon-Bold", size: 17)
        searchRoute.layer.cornerRadius = 4
        searchRoute.center.x = self.view.center.x
        searchRoute.center.y = self.view.center.y
        matching_view.layer.cornerRadius = 10
        matching_view.layer.shadowColor = UIColor.black.cgColor
        matching_view.layer.shadowOffset = CGSize(width: 3, height: 3)
        matching_view.layer.shadowOpacity = 0.7
        matching_view.layer.shadowRadius = 4.0
        match_success_view.layer.cornerRadius = 10
        match_success_view.layer.shadowColor = UIColor.black.cgColor
        match_success_view.layer.shadowOffset = CGSize(width: 3, height: 3)
        match_success_view.layer.shadowOpacity = 0.7
        match_success_view.layer.shadowRadius = 4.0
        match_success_view.layer.zPosition = 2000
        //destinationText.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        LoadingGif.image = gif
        
        let id = Auth.auth().currentUser!.uid
        
        getProfile(uid: id){ (user) in
            
            self.currentUser = user!
        }
        
        RequestMatchTableView.delegate = self
        RequestMatchTableView.dataSource = self
        
        //destinationLabel.textColor = UIColor.blue
        setParameters()
        
        
        
        //        searchDestination.delegate = self
        //        searchDestination.returnKeyType = UIReturnKeyType.done
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse,.authorizedAlways:
            break
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .restricted, .denied:
            //prompt notification: see next slides
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to see your location, please open Settings and set location access for this app to 'Always'.", preferredStyle: .alert)
            let openAction = UIAlertAction(title: "My Alert",
                                           style: .default, handler: { _ in
                                            NSLog("The \"OK\" alert occurred.")
            })
            alertController.addAction(openAction)
            let cancelAction = UIAlertAction(title:
                "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        manager.delegate = self
        map.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestLocation()
        
        map.showsUserLocation = true;
        
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        map.mapType = MKMapType(rawValue: 0)!
        map.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeVC.LocationTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        map.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
        matching_view.isHidden = true
        match_success_view.isHidden = true
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 5.0
        return renderer
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        current_location = locations.last
        if let location = current_location{
            //centerMapOnLocation(location: location)
            global_location = location
            self.sourcePlacemark = MKPlacemark(coordinate: location.coordinate)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion =
            MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: regionRadius * 2.0,
                longitudinalMeters: regionRadius * 2.0)
        map.setRegion(coordinateRegion,animated: true)
        
    }
    
    @objc func LocationTapped(_ sender: UITapGestureRecognizer){
        
        let pt:CGPoint = sender.location(in: map)
        let location = map.convert(pt, toCoordinateFrom: map)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        if let desel = self.selected_annotation{
            map.removeAnnotation(desel)
        }
        map.addAnnotation(annotation)
        self.selected_annotation = annotation
        self.destPlacemark = MKPlacemark(coordinate: location)
        self.map.removeOverlays(self.map.overlays)
    }
    
    //    func showChatController() {
    //        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
    //        navigationController?.pushViewController(ChatLogController, animated: true)
    //    }
    // error here. this func has to be indside a tableview controller
    
    
    
    
}
