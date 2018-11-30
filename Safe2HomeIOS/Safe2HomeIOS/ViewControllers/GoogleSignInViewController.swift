import UIKit
import Firebase
import GoogleSignIn

var currentUser: User?

class GoogleSignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    
    @IBOutlet weak var GIDSignInButton: GIDSignInButton!
    @IBOutlet weak var GIDSignOutButton: UIButton!
    
    
    
    let dele = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        
        print("user")
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("error")
            return
        }
        
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            
            if let error = error {
                //...
                return
            }
            self.checkIfUserIsLoggedIn()
            //cUser = Auth.auth().currentUser
            //self.SignIn.checkIfUserIsLoggedIn()
            print("User logged in")
            //currentUser = Auth.auth().currentUser
            // User is signed in
            // ...
            
            
        }
    }
    
    
    func checkIfUserIsLoggedIn(){
        if let current = Auth.auth().currentUser{
            //performSelector(#selector(dele.firebaseSignOut),withObjec : nil, afterDelay : 0)
            
            
            Database.database().reference().child("Users").child(current.uid).observeSingleEvent(of: .value, with:{Snapshot -> Void in
                if Snapshot.exists(){
                    
                    print(Snapshot)
                    var welcomemessage : String = "Welcome Back!"
                    let objectUserName = Snapshot.childSnapshot(forPath: "Username").value as! String
                    print(objectUserName)
                    
                    welcomemessage = "\(objectUserName) \(",")\(welcomemessage)"
                    let alertController = UIAlertController(title: welcomemessage, message: "You've Already Signed In", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Safe To Home", style: .default){
                        action in self.performSegue(withIdentifier: "SkipProfile", sender: self)
                    }
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    print("exists")
                    
                }
                else{
                    var welcomemessage : String = "Welcome"
                    let GoogleName: String = current.displayName as! String
                    welcomemessage = "\(welcomemessage) \(GoogleName)"
                    let alertController = UIAlertController(title: welcomemessage, message: "Please create your Profile.", preferredStyle: .alert)
                    
                    let CreateProfileAction = UIAlertAction(title: "Create Profile", style: .default){
                        
                        action in self.performSegue(withIdentifier: "ToProfile", sender: self)
                        }
                    
                    alertController.addAction(CreateProfileAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    print("CreateProfile")
                    
                }
            })
            
            
            //if Auth.auth()?.currentUse?.uid == nil{
            
        }
        
    }
    

    @IBAction func GIDSignOutAction(_ sender: Any) {
        let dele = AppDelegate()
        dele.firebaseSignOut()
    
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
