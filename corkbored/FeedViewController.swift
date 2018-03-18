import UIKit
import Firebase
import FirebaseAuth
import Nuke
import CoreLocation

class FeedViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //CORELOCATION, VARIABLES, STORAGE
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var userLocation: CLLocation = CLLocation()
    var currentCity: String = ""
    var messageBody: String = ""
    var profilePhotoFileName: String = ""
    var activeUser = Auth.auth().currentUser
    var manager = Nuke.Manager.shared
    var posts = [Post]()
    
    //passing messageData
    var clickedPostMessageBody = ""
    var clickedTimeLabel = ""
    var clickedUsername = ""
    var clickedPostOwnerUid = ""
    var clickedPostUid = ""
    
    //passing profile data
    var clickedNameUid = ""

    @IBOutlet weak var tableView: UITableView!
    
//    //TABLE VIEW FUNCTIONS
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////            print(posts[indexPath.row].postUid)
//    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if posts[indexPath.row].pinnedMediaFileName != "null" {
            return 450
        } else {
            return 200
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
                deletePostFromFeed(postUid: post.postUid)
            } else {
                stringTimeStamp = "\(hours) hr"
            }
        }
        
        //my two type of table cell
        if post.pinnedMediaFileName != "null" {
            
            let textAndImageCell = tableView.dequeueReusableCell(withIdentifier: "postCellWithPhoto", for: indexPath) as! FeedViewControllerTableViewCell
            textAndImageCell.selectionStyle = .none
            
            //getting Profile picture and username
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            ref.child("users").child(post.ownerUid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                let value = snapshot.value as? NSDictionary
                
                let postProfilePictureStringURL = value?["profilePic"] as? String ?? ""
                print(postProfilePictureStringURL, "URL")
                let firstName = value?["firstName"] as? String ?? ""
                
                if let urlUrl = URL.init(string: postProfilePictureStringURL) {
                    self.manager.loadImage(with: urlUrl, into: textAndImageCell.profilePhotoImageView)
                }
                
                textAndImageCell.usernameTextField.text = firstName
                print(firstName, "NAME")
                
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
            print(post.numberOfComments, "POST")
            textAndImageCell.numberOfComments.text = post.numberOfComments
            
            return textAndImageCell
            
        } else {
            
            let textOnlyCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! FeedViewControllerTableViewCell
            textOnlyCell.selectionStyle = .none
            
            textOnlyCell.commentButton.tag = indexPath.row
            textOnlyCell.commentButton.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
            textOnlyCell.usernameTextField.tag = indexPath.row
            
            let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfile))
            textOnlyCell.usernameTextField.isUserInteractionEnabled = true
            textOnlyCell.usernameTextField.addGestureRecognizer(nameTapGesture)
            
            //react Image
//            textOnlyCell.reactButton.tag = indexPath.row
//            textOnlyCell.reactButton.addTarget(self, action: #selector(handleReaction), for: .touchUpInside)
            
            //getting Profile picture and username
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
        clickedPostMessageBody = posts[sender.tag].postMessage
        clickedUsername = "workingOnUserName"
        clickedTimeLabel = posts[sender.tag].pinnedTimeAsInterval
        clickedPostOwnerUid = posts[sender.tag].ownerUid
        clickedPostUid = posts[sender.tag].postUid
        
        performSegue(withIdentifier: "toComments", sender: nil)
    }
    
    @objc func handleProfile(sender: UIGestureRecognizer) {
        print("handleProfile")
        
        self.performSegue(withIdentifier: "toOtherProfile", sender: self)
        
    }
    
    
//    @objc func handleReaction(sender: UIButton) {
//       print("clicked")
//
//        //cue horizontal scroll view/collectionview of emojis
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserLocation()
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
                                                
                                                self.currentCity = retreivedCity
                                                
                                                self.fetchPosts(city: self.currentCity)
                                            }
                                                
                                            else {
                                                // An error occurred during geocoding.
                                                
                                                print("couldnt get users location")
                                                
                                            }
        })
    }

    func deletePostFromFeed(postUid: String) {
        print("trying to delete")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let postReference = ref.child("posts").child(currentCity).child(postUid)
        
        // Remove the post from the DB
         postReference.removeValue()
         print("trying to delete after remove")
        return
    }
//
//    func fetchCurrentPosition() {
//        let userInfo = Auth.auth().currentUser
//        let uid = userInfo?.uid
//
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//
//        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            self.currentCity = value?["currentCity"] as? String ?? ""
//            self.fetchPosts(city: self.currentCity)
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
    
    func fetchPosts(city: String) {

        var refExists: DatabaseReference!
        
        refExists = Database.database().reference()

        refExists.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.hasChild(self.currentCity) {
                self.tableView.isHidden = false
               
                Database.database().reference().child("posts").child(self.currentCity).observe(.childAdded) { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [AnyHashable: AnyObject] {
                        let post = Post(snapshot: snapshot)
                        self.posts.insert(post, at: self.posts.startIndex)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }else{
                print("city doesn't exist")
                self.tableView.isHidden = true
                self.handleAlertWhenNoTableViewItemsExist()
            }
        })
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
            controller.messageBodyText = clickedPostMessageBody
            controller.postOwnerUid = clickedPostOwnerUid
            controller.username = clickedUsername
            controller.timeSincePost = clickedTimeLabel
            controller.currentCity = currentCity
            controller.postUid = clickedPostUid
        } else if segue.identifier == "toOtherProfile" {
            let controller = segue.destination as! OtherProfileViewController
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
