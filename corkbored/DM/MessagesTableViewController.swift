import UIKit
import Firebase
import Nuke

class MessagesTableViewController: UITableViewController {
    
    var messages = [Message]()
    var allMessageProfileUid = [String]()
    var ref: DatabaseReference!
    var usersRef: DatabaseReference!
    var uid: String!
    var manager = Nuke.Manager.shared
    var messageSelectedUid: String = ""
    
    override func viewDidLoad() {
        animateTabBarControllerDown()
        super.viewDidLoad()
        uid = (Auth.auth().currentUser?.uid)!
        loadMessages()
        
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            // Your code...
            animateTabBarControllerUp()
        }
    }
    
    func animateTabBarControllerDown() {
        let duration = 0.25
        
        if let nav = self.tabBarController?.tabBar {
            
            //TabBarController
            let xPosition = nav.frame.origin.x
            let yPosition = nav.frame.origin.y + nav.frame.size.height
            let height = nav.frame.size.height
            let width = nav.frame.size.width
            
            UIView.animate(withDuration: duration as! TimeInterval, animations: {
                
                nav.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
                
            }, completion: {(completed) in
                print("in completition")
            })
        } else {
        }
    }
    
    func animateTabBarControllerUp() {
        let duration = 0.25
        
        if let nav = self.tabBarController?.tabBar {
            
            //TabBarController
            let xPosition = nav.frame.origin.x
            let yPosition = nav.frame.origin.y - nav.frame.size.height
            let height = nav.frame.size.height
            let width = nav.frame.size.width
            
            UIView.animate(withDuration: duration as! TimeInterval, animations: {
                
                nav.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
                
            }, completion: {(completed) in
                print("in completition")
            })
        } else {
        }
    }
    
    
    func loadMessages() {
        ref = Database.database().reference().child("users").child(self.uid).child("messaging")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                for messageOwnerUid in (snapshot.children) { //iterate over each user node child
                    //assign the user_child enumerator to a snapshot
                    let allMessagesFromOwnerUidSnapshot = messageOwnerUid as! DataSnapshot
                    
                    self.allMessageProfileUid.insert(allMessagesFromOwnerUidSnapshot.key, at: self.messages.startIndex)
                    
                    for messages in allMessagesFromOwnerUidSnapshot.children { //now iterate over each messObject
                        
                        let messageSnapshot = messages as! DataSnapshot
                        if let dictionary = messageSnapshot.value as? [AnyHashable: AnyObject] {
                            let message = Message(snapshot: messageSnapshot)
                            self.messages.insert(message, at: self.messages.startIndex)
                        }
                    }
                }
            }
            print(self.allMessageProfileUid.count)
            print(self.messages.count)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMessageProfileUid.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagesCell", for: indexPath) as! messagesTableViewCell
        
        let otherUserUid = allMessageProfileUid[indexPath.row]
        let message = messages[indexPath.row]
        
//        cell.messageSeenIndicator.layer.cornerRadius = cell.messageSeenIndicator.frame.size.height / 2
//        cell.messageSeenIndicator.clipsToBounds = true
        
        //Database Ref
        usersRef = Database.database().reference().child("users").child(otherUserUid)
        
        
        usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot, "SNAP")
            let value = snapshot.value as? NSDictionary
            let postProfilePictureStringURL = value?["profilePic"] as? String ?? ""
            print(postProfilePictureStringURL, "URL")
            let usersName = value?["firstName"] as? String ?? ""
            print(usersName, "USERNAME")
            cell.messagesName.text = usersName
            cell.messagesLastMessageSent.text = "11:37am"
            
            if let url = URL.init(string: postProfilePictureStringURL) {
                self.manager.loadImage(with: url, into: cell.messagesProfileView)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        cell.messagesProfileView.contentMode = .scaleAspectFit
        cell.messagesProfileView.layer.cornerRadius = 5
        cell.messagesProfileView.clipsToBounds = true
        cell.messagesLastMessageSent.text = messages[indexPath.row].pinnedTimeAsInterval
        cell.messagesLastMessagePeek.text = messages[indexPath.row].postMessage
        
//        cell.messageSeenIndicator.backgroundColor = UIColor.red
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! SingleMessageViewController
        controller.messageUid = String(messageSelectedUid)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageSelectedUid = allMessageProfileUid[indexPath.row]
        print("just after messageSelected")
        self.performSegue(withIdentifier: "toSelectedDm", sender: self)
    }
}
