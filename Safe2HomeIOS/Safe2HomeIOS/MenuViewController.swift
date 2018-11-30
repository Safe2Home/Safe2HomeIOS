//
//  MenuViewController.swift
//  Safe2HomeIOS
//
//  Created by Yafei Liang on 11/24/18.
//  Copyright © 2018 Safe2Home. All rights reserved.
//

import UIKit
import SafariServices
protocol SlideMenuDelegate {
    func slideMenueItemSelectedAtIndex(_ index: Int32)

}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var detailArray = ["Home", "Crime Map", "Emergency Contact", "Profile","Log Out"]
    var arrimage = [#imageLiteral(resourceName: "home"),#imageLiteral(resourceName: "crime"),#imageLiteral(resourceName: "phone"),#imageLiteral(resourceName: "settings"),#imageLiteral(resourceName: "logout")]
    var btnMenu: UIButton!
    var delegate: SlideMenuDelegate?
    
    //var isSideViewOpen: Bool = false
    
    @IBOutlet weak var sideBarTV: UITableView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var btnCloseMenu: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideBarTV.delegate = self
        self.sideBarTV.dataSource = self
        print("in viewdidload menu ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        self.view.backgroundColor = UIColor.init(red: 249, green: 166, blue: 2, alpha: 0)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func TappedBtnAction(_ sender: UIButton) {
        btnMenu.tag = 0
        btnMenu.isHidden = false
        if (self.delegate != nil) {
            var index = Int32(sender.tag)
            if (sender == self.btnCloseMenu) {
                index = -1
            }
            delegate?.slideMenueItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width:
                UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (fninished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()

        })
   
    }
    
  
    
//    @IBAction func HomeBtn(_ sender: Any) {
//        let mainStoreboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let DVC = mainStoreboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        self.navigationController?.pushViewController(DVC, animated: true)
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("in tableview menu ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.detailVC.text = detailArray[indexPath.row]
        cell.menuImg.image = arrimage[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailArray.count
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoreboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if indexPath.row == 0 {
//            let DVC = mainStoreboard.instantiateViewController(withIdentifier: "Text_view_controller") as! Text_view_controller
//            self.navigationController?.pushViewController(DVC, animated: true)
            let home1: HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.performSegue(withIdentifier: "ToHome", sender: (Any).self)
        }
        if indexPath.row == 2 {
            //            let DVC = mainStoreboard.instantiateViewController(withIdentifier: "Text_view_controller") as! Text_view_controller
            //            self.navigationController?.pushViewController(DVC, animated: true)
            let textcall: Text_view_controller = self.storyboard?.instantiateViewController(withIdentifier: "Text_view_controller") as! Text_view_controller
            self.navigationController?.pushViewController(textcall, animated: true)
        }
        
        if indexPath.row == 3 {
            //            let DVC = mainStoreboard.instantiateViewController(withIdentifier: "Text_view_controller") as! Text_view_controller
            //            self.navigationController?.pushViewController(DVC, animated: true)
            let textcall: LogInViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
            self.navigationController?.pushViewController(textcall, animated: true)
        }
        if indexPath.row == 4 {
            //            let DVC = mainStoreboard.instantiateViewController(withIdentifier: "Text_view_controller") as! Text_view_controller
            //            self.navigationController?.pushViewController(DVC, animated: true)
            let dele = AppDelegate()
            dele.firebaseSignOut()
            
            let alertController = UIAlertController(title: "Logged Out", message: "Please Sign in with Another Account.", preferredStyle: .alert)
            
            let CreateProfileAction = UIAlertAction(title: "Sign In", style: .default){
                
                action in self.performSegue(withIdentifier: "ToSignIn", sender: self)
            }
            
            alertController.addAction(CreateProfileAction)
            self.present(alertController, animated: true, completion: nil)
            
        }

        if indexPath.row == 1 {
            if let myLocation = global_location {
                let myLatitude: String = String(format: "%f", myLocation.coordinate.latitude)
                let myLongitude: String = String(format:"%f", myLocation.coordinate.longitude)
                
                let url = URL(string:  "https://m.spotcrime.com/mobile/map/index.html#" + myLatitude + "%2C%20" + myLongitude)
                let vc = SFSafariViewController(url: url!)
                present(vc, animated: true, completion: nil)
                
                
            } else {
                print("location failed in crime view.")
            }
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
