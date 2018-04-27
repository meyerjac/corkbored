import UIKit
import Firebase
import FirebaseAuth
import Nuke
import CoreLocation
import ChameleonFramework

class FeedViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBAction func toMessagingBarButton(_ sender: Any) {
          self.performSegue(withIdentifier: "feedToMessagingSegue", sender: self)
    }
    @IBAction func createPostBarButton(_ sender: Any) {
          self.performSegue(withIdentifier: "createPost", sender: self)
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
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
                
                deletePostFromFeed(postUid: post.postUid)
                stringTimeStamp = "\(hours) hr"
            } else {
                stringTimeStamp = "\(hours) hr"
            }
        }
    
        //my table cell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! FeedViewControllerTableViewCell
            
            //setting tag for comment button
            cell.commentButton.tag = indexPath.row
            cell.commentButton.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
            
            //setting tag for profile image and username
            let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfile))
            cell.profilePhotoImageView.tag = indexPath.row
            cell.profilePhotoImageView.addGestureRecognizer(nameTapGesture)
            cell.profilePhotoImageView.isUserInteractionEnabled = true
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            ref.child("users").child(post.ownerUid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                let value = snapshot.value as? NSDictionary
                
                let postProfilePictureStringURL = value?["profilePic"] as? String ?? ""
                let username = value?["firstName"] as? String ?? ""
                
                if let urlUrl = URL.init(string: postProfilePictureStringURL) {
                    self.manager.loadImage(with: urlUrl, into: cell.profilePhotoImageView)
                }
                
                cell.usernameTextField.text = username
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            cell.profilePhotoImageView?.contentMode = .scaleAspectFit
            cell.profilePhotoImageView?.layer.borderWidth = 1.5
            cell.profilePhotoImageView?.layer.masksToBounds = false
            cell.profilePhotoImageView.layer.borderColor = UIColor.flatYellow().cgColor
            cell.profilePhotoImageView?.layer.cornerRadius = 5
            cell.profilePhotoImageView?.clipsToBounds = true
            
            cell.timePosted.text = stringTimeStamp
            cell.numberOfComments.text = post.numberOfComments
            cell.DescriptionLabel.text = post.postMessage
            cell.hangoutDate.text = "March 13th, 8ish"
            cell.hangoutTitle.text = "Beer pong tournament, cash prizes"
        
            return cell
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
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
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
