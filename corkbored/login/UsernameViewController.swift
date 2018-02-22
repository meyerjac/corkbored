
import UIKit
import Firebase
import FirebaseDatabase

//THIS VIEW IS NOT CURRENTLY IN OUR MAIN STORYBOARD, WE DELETED IT

class UsernameViewController: UIViewController {
    var username = ""
    var newUserUserName: NSString = ""
    
    @IBAction func changeButtonClicked(_ sender: Any) {
        newUserUserName = newUsernameTextField.text! as NSString
        newUsernameTextField.text = ""
        
                    let userInfo = Auth.auth().currentUser
                    let uid = userInfo?.uid
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    ref.child("users").child(uid!).updateChildValues(["username": self.newUserUserName])

                    ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        self.username = value?["username"] as? String ?? ""

                        self.userNameWelcomeTextField.text = "Thankyou for being a user of Corkbored, curing campuses of Boredom, sharing funny thing, and bettering yourself, your new username is \(self.username), you can it this now or later"
                        
                        self.changeButton.isHidden = true
                        self.newUsernameTextField.isHidden = true
                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                }
    }
    
    @IBOutlet weak var newUsernameTextField: UITextField!
    
    @IBOutlet weak var changeUsername: UIButton!
    
    @IBOutlet weak var userNameWelcomeTextField: UILabel!
    
    @IBOutlet weak var changeButton: UIButton!
    
    @IBAction func changeUsernameButtonClicked(_ sender: Any) {
        
        newUsernameTextField.isHidden = false
        changeButton.isHidden = false
        changeUsername.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userInfo = Auth.auth().currentUser
        let uid = userInfo?.uid
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.username = value?["username"] as? String ?? ""
            print(self.username + "2")
            
            self.userNameWelcomeTextField.text = "Thankyou for being a user of Corkbored, curing campuses of boredom... sharing funny things, and collaborating with students, your new username is \(self.username), you can it this now or later"
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
}
