//
//  SignUpViewController.swift
//  SnapchatProject
//
//  Created by Daniel Phiri on 10/13/17.
//  Copyright © 2017 org.iosdecal. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func SignOutAction(_ sender: UIButton) {
        let dele = AppDelegate()
        dele.firebaseSignOut()
    }
    @IBOutlet weak var SignOutButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    
    var userName = ""
    var gender = ""
    var academic_Focus = ""
    var preferred_Major = ""
    
    //TODO:
    // Update the method with the instructions in the README.
    @IBAction func signUpPressed(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        guard let gender = gender_dropdown.currentTitle else { return }
        guard let academic_focus = Academic_Focus.currentTitle else { return }
        guard let preferredMajor = preferred_major.currentTitle else { return }
        
        if name == "" || gender == "Gender" || academic_focus == "Academic Focus" || preferredMajor == "Partner's Preferred Major" {
            let alertController = UIAlertController(title: "Form Error.", message: "Please fill in form completely.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            let currentUser = Auth.auth().currentUser
            var userProfile = CurrentUser()
            userProfile.username = name
            userProfile.gender = gender
            userProfile.major = academic_focus
            userProfile.preferredmajor = preferredMajor
            
            createProfile(client: userProfile)
            
        }
        
        
    }
    


    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.nameTextField {
            if textField.text != nil {
                self.userName = textField.text!
            }
        }
    }
    var gender_dropdown = dropDownBtn()
    var Academic_Focus = dropDownBtn()
    var preferred_major = dropDownBtn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.nameTextField.delegate = self
        
        // Do any additional setup after loading the view.
        
        
        //Configure the button
        gender_dropdown = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        gender_dropdown.setTitle("Gender", for: .normal)
        gender_dropdown.translatesAutoresizingMaskIntoConstraints = false
        
        Academic_Focus = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        Academic_Focus.setTitle("Academic Focus", for: .normal)
        Academic_Focus.translatesAutoresizingMaskIntoConstraints = false
        
        preferred_major = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        preferred_major.setTitle("Partner's Preferred Major", for: .normal)
        preferred_major.translatesAutoresizingMaskIntoConstraints = false
        
        //Add Button to the View Controller
        self.view.addSubview(gender_dropdown)
        self.view.addSubview(Academic_Focus)
        self.view.addSubview(preferred_major)
        
        //button Constraints
        gender_dropdown.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        gender_dropdown.centerYAnchor.constraint(equalTo: emailTextField!.centerYAnchor).isActive = true
        gender_dropdown.widthAnchor.constraint(equalToConstant: 260).isActive = true
        gender_dropdown.heightAnchor.constraint(equalToConstant: 37).isActive = true
        
        Academic_Focus.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        Academic_Focus.centerYAnchor.constraint(equalTo: passwordTextField!.centerYAnchor).isActive = true
        Academic_Focus.widthAnchor.constraint(equalToConstant: 260).isActive = true
        Academic_Focus.heightAnchor.constraint(equalToConstant: 37).isActive = true
        
        preferred_major.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        preferred_major.centerYAnchor.constraint(equalTo: passwordVerificationTextField!.centerYAnchor).isActive = true
        preferred_major.widthAnchor.constraint(equalToConstant: 260).isActive = true
        preferred_major.heightAnchor.constraint(equalToConstant: 37).isActive = true
        
        //Set the drop down menu's options
        gender_dropdown.dropView.dropDownOptions = ["Male",
                                                    "Female",
                                                    "Trans Male",
                                                    "Trans Female",
                                                    "Gender Queer/Non-Conforming",
                                                    "Different Identity"]
        
        Academic_Focus.dropView.dropDownOptions =
            ["Arts & Humanities",
             "Biological Sciences",
             "Business",
             "Computer Science",
             "Design",
             "Economic Development",
             "Education",
             "Engineering",
             "Mathematics",
             "Multi-Disciplinary",
             "Natural Resources & Environment",
             "Physical Sciences",
             "Pre-Health/Medicine",
             "Pre-Law",
             "Social Sciences"]
        
        preferred_major.dropView.dropDownOptions =
            ["Arts & Humanities",
             "Biological Sciences",
             "Business",
             "Computer Science",
             "Design",
             "Economic Development",
             "Education",
             "Engineering",
             "Mathematics",
             "Multi-Disciplinary",
             "Natural Resources & Environment",
             "Physical Sciences",
             "Pre-Health/Medicine",
             "Pre-Law",
             "Social Sciences"]
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

protocol dropDownProtocol {
    func dropDownPressed(string : String)
}

class dropDownBtn: UIButton, dropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blue
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.blue
        self.backgroundColor = UIColor.lightGray
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        //self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


