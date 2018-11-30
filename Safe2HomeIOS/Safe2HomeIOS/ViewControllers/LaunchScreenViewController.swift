//
//  LaunchScreenViewController.swift
//  Safe2HomeIOS
//
//  Created by Cong Jin on 11/29/18.
//  Copyright © 2018 Safe2Home. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController,UIViewControllerTransitioningDelegate {

 
    @IBOutlet weak var icon: UIImageView!
    
    let transition = CircularTransition()
    
    @IBOutlet weak var center: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        center.layer.cornerRadius = center.frame.size.width / 2
        let timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
       
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! GoogleSignInViewController
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = center.center
        transition.circleColor = UIColor.init(red: 249, green: 166, blue: 2, alpha: 0)
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = center.center
        transition.circleColor = UIColor.white
        
        return transition
    }
    
    @objc func timeToMoveOn() {
        self.performSegue(withIdentifier: "goToMainUI", sender: self)
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
