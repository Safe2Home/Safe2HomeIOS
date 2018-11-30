import Foundation
import MessageUI

let textMessageRecipients = ["5105705197"] // for pre-populating the recipients list (optional, depending on your needs)

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = textMessageRecipients
        //messageComposeVC.body = "HELP! I am in danger at this location: "
        
        
        if let myLocation = global_location {
            let myLatitude: String = String(format: "%f", myLocation.coordinate.latitude)
            let myLongitude: String = String(format:"%f", myLocation.coordinate.longitude)
            messageComposeVC.body = "HELP!!!!! I am in danger at this location: " + myLatitude + ", " + myLongitude + "     " + "https://www.google.com/maps/search/?api=1&query=" + myLatitude + "," + myLongitude
            
        } else {
            messageComposeVC.body = "HELP ME!!!!!!!!"
        }
        
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

