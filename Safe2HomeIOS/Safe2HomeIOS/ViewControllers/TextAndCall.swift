//
//  Text view controller.swift
//  Safe2HomeIOS
//
//  Created by Kan Liu on 11/16/18.
//  Copyright © 2018 Safe2Home. All rights reserved.
//
import UIKit
import MessageUI

class Text_view_controller: BaseViewController, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //
    //    func displayMessageInterface() {
    //        let composeVC = MFMessageComposeViewController()
    //        composeVC.messageComposeDelegate = self
    //
    //        // Configure the fields of the interface.
    //        composeVC.recipients = ["5107357766"]
    //        composeVC.body = "Test message. HELPPPPPPPPP!"
    //
    //        // Present the view controller modally.
    //        if MFMessageComposeViewController.canSendText() {
    //            self.present(composeVC, animated: true, completion: nil)
    //        } else {
    //            print("Can't send messages.")
    //        }
    //
    //
    //    }
    
    //
    //    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
    //        controller.dismiss(animated: true, completion: nil)
    //    }
    
    let messageComposer = MessageComposer()
    
    @IBAction func sendMessageButton(_ sender: Any) {
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController()
            
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            present(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }    }
    
    @IBAction func CallButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: "telprompt://5105705197")!)
    }
}
