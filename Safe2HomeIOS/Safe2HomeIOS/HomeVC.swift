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



final class HomeVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    
    let manager: CLLocationManager = global_manager
    var current_location: CLLocation?
    let regionRadius: CLLocationDistance = 1000
    var selected_annotation: MKAnnotation?
    
    var destPlacemark: MKPlacemark?
    var sourcePlacemark: MKPlacemark?
    
    let currentUser = CurrentUser()
    
    var posts_array: [Post] = []
    
    var currentPost = Post(username: "dummyname", dateString: "dummystring", gender: "dummygender", major: "dummymajor")
    
    
    @IBOutlet weak var map: HomeMapView!
    
    @IBOutlet weak var RequestMatchTableView: UITableView!
    
    
    //    var isSearching = false
    //    // more about search bar see
    //    // https://www.youtube.com/watch?v=zgP_VHhkroE
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var destinationText: UITextField!
    
    @IBOutlet weak var searchRoute: UIButton!
    
    
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
        
        print(4)
        currentPost = Post(username: currentUser.username, dateString: dateString, gender: currentUser.gender, major: currentUser.major)
        print(5)
        let postVC = PostsTableViewController()
        
        postVC.match(currentPost: currentPost, posts_array: posts_array)
        //        RequestTableView.reloadData()
        //addPost(client: currentPost)
        print(6)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pcell = RequestMatchTableView.dequeueReusableCell(withIdentifier: "RequestMatchCell", for: indexPath) as! MatchTableViewCell
        // can't find comment
        //pcell.commentmessage.text = comments[indexPath.row]["message"] as! String
        
        //        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PostsTableViewController.runTimedCode), userInfo: nil, repeats: true)
        getPosts() { (matches) in
//            client1Name: currentUser.username
            if let matches = matches {
                print(3)
                //pcell.MatcherName.text = posts[0].username
                self.RequestMatchTableView.reloadData()
            }
        }
        return pcell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RequestMatchTableView.delegate = self
        RequestMatchTableView.dataSource = self
        
        var mainColor = UIColor(red: 24,
                                green: 59,
                                blue: 29,
                                alpha: 1)
        
        //destinationLabel.textColor = UIColor.blue
        
        destinationLabel.textAlignment = .center
        destinationLabel.font = UIFont(name: "Superclarendon-Bold", size: 17)
        
        searchRoute.layer.cornerRadius = 4
        searchRoute.backgroundColor = .blue
        searchRoute.center.x = self.view.center.x
        searchRoute.center.y = self.view.center.y
        

        destinationText.textAlignment = .center
        
        getPosts() { (posts) in
            print("maybe")
            if let posts = posts {
                self.posts_array = posts
                print(posts)
            }
        }
        
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
            centerMapOnLocation(location: location)
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
    
    
    
    
}





