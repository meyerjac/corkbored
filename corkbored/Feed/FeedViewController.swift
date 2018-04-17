import UIKit
import Firebase
import FirebaseAuth
import Nuke
import CoreLocation

class FeedViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? FeedViewControllerTableViewCell else { return }
    }
    
    //CORELOCATION, VARIABLES, STORAGE
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var userLocation: CLLocation = CLLocation()
    var clickedCurrentCity: String = ""
    var messageBody: String = ""
    var profilePhotoFileName: String = ""
    var activeUser = Auth.auth().currentUser
    var manager = Nuke.Manager.shared
    var posts = [Post]()
    var reactionEmojiArray = [#imageLiteral(resourceName: "Image"), #imageLiteral(resourceName: "Image-1"), #imageLiteral(resourceName: "Image-2"), #imageLiteral(resourceName: "Image-3"), #imageLiteral(resourceName: "Image-4"), #imageLiteral(resourceName: "Image-5")]
    
    //passing messageData
    var clickedPostMessageBody = ""
    var clickedPostTimeStamp = ""
    var clickedUsername = ""
    var clickedPostOwnerUid = ""
    var clickedPostUid = ""
    var clickedPostProfilePicture: UIImage! = UIImage()
    var clickedPostMedia: UIImage! = UIImage()
    
    //passing profile data
    var clickedProfilePicOwnerUid = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let messageText = self.posts[indexPath.row].postMessage as? String
        let size = CGSize(width: view.frame.size.width - 32, height: 600)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedStringKey.font:  UIFont.systemFont(ofSize: 14)]
        let estimatedFrame = NSString(string: messageText!).boundingRect(with: size, options: options, attributes: attributes, context: nil)

        if posts[indexPath.row].pinnedMediaFileName != "null" {
            if estimatedFrame.height < 20 {
                    return 485
                } else {
                    return 485 + estimatedFrame.height - 16.7
                }
            } else {
                if estimatedFrame.height < 20 {
                    return 130
                } else {
                    return 130 + estimatedFrame.height - 16.7
                                }
                }
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //getting time stamp of users device to to compare to stamp of post
        let nowish = Double(Date().timeIntervalSinceReferenceDate)
        
        //pulling and identifying each post from array as a single post
        let post = posts[indexPath.row]
        
        //getting the correct timestamp label for post
        let postDate = Double(post.pinnedTimeAsInterval)
        let difference = ((nowish - postDate!)/60)
        let stringDifference = String(difference)
        let delimiter = "."
        var numbers = stringDifference.components(separatedBy: delimiter)
        let minutesSince = Int(numbers[0])
        var stringTimeStamp = ""
        if minutesSince! < 1 {
            stringTimeStamp = "just now"
        } else if minutesSince! <= 60 {
            stringTimeStamp = "\(minutesSince ?? 23) min"
        } else if minutesSince! > 60 {
            let hours = minutesSince!/60
            if hours >= 24 {
                
                //choosing not to delete from Feed
                
                //                deletePostFromFeed(postUid: post.postUid)
                stringTimeStamp = "\(hours) hr"
            } else {
                stringTimeStamp = "\(hours) hr"
            }
        }
        
    
        
        //my two type of table cell
        if post.pinnedMediaFileName != "null" {
            
            let textAndImageCell = tableView.dequeueReusableCell(withIdentifier: "postCellWithPhoto", for: indexPath) as! FeedViewControllerTableViewCell
            
            textAndImageCell.separatorInset = UIEdgeInsetsMake(0, textAndImageCell.bounds.size.width, 0, 0)
            textAndImageCell.selectionStyle = .none
            
            //getting Profile picture and username
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            ref.child("users").child(post.ownerUid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                let value = snapshot.value as? NSDictionary
                
                let postProfilePictureStringURL = value?["profilePic"] as? String ?? ""
                let firstName = value?["firstName"] as? String ?? ""
                
                if let urlUrl = URL.init(string: postProfilePictureStringURL) {
                    self.manager.loadImage(with: urlUrl, into: textAndImageCell.profilePhotoImageView)
                }
                
                textAndImageCell.usernameTextField.text = firstName
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            textAndImageCell.profilePhotoImageView?.contentMode = .scaleAspectFill
            textAndImageCell.profilePhotoImageView?.layer.borderWidth = 1.0
            textAndImageCell.profilePhotoImageView?.layer.masksToBounds = false
            textAndImageCell.profilePhotoImageView.layer.borderColor = UIColor.white.cgColor
            textAndImageCell.profilePhotoImageView?.layer.cornerRadius = textAndImageCell.profilePhotoImageView.frame.size.width / 2
            textAndImageCell.profilePhotoImageView?.clipsToBounds = true
            
            
            //setting picture field
            let postPhotoString = URL.init(string: post.pinnedMediaFileName)
            self.manager.loadImage(with: postPhotoString!, into: textAndImageCell.postPhoto)
            
            textAndImageCell.timePosted.text = stringTimeStamp
            textAndImageCell.messageBody.text = post.postMessage
            textAndImageCell.numberOfComments.text = post.numberOfComments
            
            let height = textAndImageCell.messageBody.frame.size.height + 92
            
            textAndImageCell.frame.size.height = height
            textAndImageCell.frame = CGRect(x: textAndImageCell.frame.origin.x, y: textAndImageCell.frame.origin.y, width: textAndImageCell.frame.size.width, height: height)
            
            return textAndImageCell
            
        } else {
            
            let textOnlyCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! FeedViewControllerTableViewCell
            
            //setting tag for comment button
            textOnlyCell.commentButton.tag = indexPath.row
            textOnlyCell.commentButton.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
            
            //setting tag for profile image and username
            let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfile))
            textOnlyCell.profilePhotoImageView.tag = indexPath.row
            textOnlyCell.profilePhotoImageView.addGestureRecognizer(nameTapGesture)
            textOnlyCell.profilePhotoImageView.isUserInteractionEnabled = true
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            ref.child("users").child(post.ownerUid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                let value = snapshot.value as? NSDictionary
                
                let postProfilePictureStringURL = value?["profilePic"] as? String ?? ""
                let username = value?["firstName"] as? String ?? ""
                
                if let urlUrl = URL.init(string: postProfilePictureStringURL) {
                    self.manager.loadImage(with: urlUrl, into: textOnlyCell.profilePhotoImageView)
                }
                
                textOnlyCell.usernameTextField.text = username
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            textOnlyCell.profilePhotoImageView?.contentMode = .scaleAspectFit
            textOnlyCell.profilePhotoImageView?.layer.borderWidth = 1.0
            textOnlyCell.profilePhotoImageView?.layer.masksToBounds = false
            textOnlyCell.profilePhotoImageView.layer.borderColor = UIColor.white.cgColor
            textOnlyCell.profilePhotoImageView?.layer.cornerRadius = textOnlyCell.profilePhotoImageView.frame.size.width / 2
            textOnlyCell.profilePhotoImageView?.clipsToBounds = true
            
            textOnlyCell.timePosted.text = stringTimeStamp
            textOnlyCell.numberOfComments.text = post.numberOfComments
            textOnlyCell.messageBody.text = post.postMessage
        
            return textOnlyCell
        }
    }
    
    @objc func handleComment(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! FeedViewControllerTableViewCell
        
        clickedPostMessageBody = posts[sender.tag].postMessage
        clickedUsername = cell.usernameTextField.text!
        clickedPostTimeStamp = cell.timePosted.text!
        clickedPostOwnerUid = posts[sender.tag].ownerUid
        clickedPostUid = posts[sender.tag].postUid
        clickedPostProfilePicture =  cell.profilePhotoImageView.image
        
        performSegue(withIdentifier: "toComments", sender: nil)
    }
    
    @objc func handleProfile(sender: UIGestureRecognizer) {
        
        clickedProfilePicOwnerUid = posts[(sender.view?.tag)!].ownerUid
        let uid = Auth.auth().currentUser?.uid
        
        if clickedProfilePicOwnerUid == uid {
            self.tabBarController?.selectedIndex = 1
        } else {
            self.performSegue(withIdentifier: "toOtherProfile", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        fetchUserLocation()
        loadBarButtonIcon()
    }
    
    func loadBarButtonIcon() {
        
    }
    
    
    func fetchUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.userLocation = locations[0]
        
        geocoder.reverseGeocodeLocation(userLocation,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                
                                                let location = placemarks?[0]
                                                
                                                let retreivedCity = (location?.locality)!
                                                
                                                UserDefaults.standard.set(retreivedCity, forKey: "currentUserLocation")
                                                
                                                self.clickedCurrentCity = retreivedCity
                                                
                                                self.fetchPosts(city: self.clickedCurrentCity)
                                            }
                                                
                                            else {
                                                // An error occurred during geocoding.
                                                
                                                print("couldnt get users location")
                                                
                                            }
        })
    }
    
    func deletePostFromFeed(postUid: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let postReference = ref.child("posts").child(clickedCurrentCity).child(postUid)
        
        // Remove the post from the DB
        postReference.removeValue()
        return
    }
    
    func fetchPosts(city: String) {
        
        var refExists: DatabaseReference!
        
        refExists = Database.database().reference()
        
        refExists.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(self.clickedCurrentCity) {
                self.tableView.isHidden = false
                
                Database.database().reference().child("posts").child(self.clickedCurrentCity).observe(.childAdded) { (snapshot) in
                    if let dictionary = snapshot.value as? [AnyHashable: AnyObject] {
                        let post = Post(snapshot: snapshot)
                        self.posts.insert(post, at: self.posts.startIndex)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                Database.database().reference().child("posts").child(self.clickedCurrentCity).observe(.childChanged, with: { (snapshot) in
                    self.foundSnapshot(snapshot)
                })
            }else{
                self.tableView.isHidden = true
                self.handleAlertWhenNoTableViewItemsExist()
            }
        })
    }
    
    //commentchanged
    func foundSnapshot(_ snapshot: DataSnapshot){
        let idChanged = snapshot.key
        var numberOfIt = 0
        
        if let dictionary = snapshot.value as? [AnyHashable: AnyObject] {
            let post = Post(snapshot: snapshot)
            
            for i in 0 ... posts.count {
                if numberOfIt >= 1 {
                    //nothing
                    numberOfIt += 1
                } else {
                    if posts[i].postUid == idChanged {
                        self.posts.remove(at: i)
                        self.posts.insert(post, at: i)
                        numberOfIt += 1
                    } else {
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func handleAlertWhenNoTableViewItemsExist() {
        let alert = UIAlertController(title: "Error", message: "corkboard hasn't made it to your city yet, start the conversation!", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { action in
            switch action.style{
            case .cancel:
                print("cancel")
            case .default:
                print("default case")
            case .destructive:
                print("destructive case")
            }
        }))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //failed to get one data point
        print("failed")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            let controller = segue.destination as! PostCommentsViewController
            controller.clickedPostMessageBody = clickedPostMessageBody
            controller.clickedPostOwnerUid = clickedPostOwnerUid
            controller.clickedUsername = clickedUsername
            controller.clickedPostTimeStamp = clickedPostTimeStamp
            controller.clickedCurrentCity = clickedCurrentCity
            controller.clickedPostTimeStamp = clickedPostTimeStamp
            controller.clickedPostUid = clickedPostUid
            controller.clickedPostProfilePicture = clickedPostProfilePicture
            
        } else if segue.identifier == "toOtherProfile" {
            let controller = segue.destination as! OtherProfileViewController
            controller.ownerUid = clickedProfilePicOwnerUid
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
