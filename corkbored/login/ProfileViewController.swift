import UIKit
import Firebase
import SVProgressHUD
import CoreLocation
import RSKImageCropper


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,  CLLocationManagerDelegate {
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.mainImage.image = croppedImage
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var userLocation: CLLocation = CLLocation()
    var currentCity:String = ""
    var currentStateCode: String = ""
    var birthday: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var bio: String = ""
    
    var deliminatedMonth = 0
    var deliminatedDay = 0
    var deliminatedYear = 0
    var todaysYear = 0
    
    var imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var firstAndLastNametextView: UITextField!
    
    @IBOutlet weak var bioTextField: UITextView!
   
    
    @IBAction func birthdayPickView(_ sender: Any) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: (sender as AnyObject).date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            birthday = "\(month) \(day) \(year)"
            
            let delimiter = " "
            var token = birthday.components(separatedBy: delimiter)
            deliminatedMonth = Int(token[0])!
            deliminatedDay = Int(token[1])!
            deliminatedYear = Int(token[2])!
            
            let date = Date()
            let calender = Calendar.current
            let components = calender.dateComponents([.year,.month,.day], from: date)
            
            //current date
            let year = components.year
            let month = components.month
            let day = components.day
            
            //current differnece
            var daysApart = day! - deliminatedDay
            var monthsApart = month! - deliminatedMonth
            var yearsApart = year! - deliminatedYear
            
            print(todaysYear - deliminatedYear, "YEAR")
            
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
            bio = (bioTextField.text)!
            var name = firstAndLastNametextView.text!
        
            let delimiter = " "
            var token = name.components(separatedBy: delimiter)
            firstName = token[0]
            let lastnamePresent = token.indices.contains(1)
        
            if lastnamePresent == false {
                let alert = UIAlertController(title: "Whoopsie daisy", message: "you must enter your last name", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    switch action.style{
                        
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }}))
                
            } else {
                goButton.isEnabled = false
                SVProgressHUD.setDefaultAnimationType(.flat)
                SVProgressHUD.setDefaultStyle(.dark)
                SVProgressHUD.setForegroundColor(UIColor.cyan)           //Ring Color
                SVProgressHUD.setBackgroundColor(UIColor.black)        //HUD Color
                SVProgressHUD.setBackgroundLayerColor(UIColor.clear) //Background Color
                SVProgressHUD.setDefaultMaskType(.clear)
                SVProgressHUD.showProgress(0.1, status: "Creating your profile...")
                SVProgressHUD.showProgress(0.2, status: "Creating your profile...")
                
                let userInfo = Auth.auth().currentUser
                let uid = userInfo?.uid
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profileImages").child("\(imageName).png")
                
                if let uploadData = UIImagePNGRepresentation(self.mainImage.image!) {
                    
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        
                        if error != nil {
                            print(error ?? "error")
                            return
                        }
                        SVProgressHUD.showProgress(0.4, status: "Creating your profile...")
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                            SVProgressHUD.showProgress(0.6, status: "Creating your profile...")
                            let values = [ "bio": self.bio, "birthday": self.birthday,"currentCity": self.currentCity, "currentState": self.currentStateCode, "firstName": self.firstName, "lastName": self.lastName,"profilePic": profileImageUrl]
                            
                            self.registerUserIntoDatabaseWithUid(uid: uid!, values: values as [String : AnyObject])
                        }
                    }
                )}
            }
        }
    
    func registerUserIntoDatabaseWithUid(uid: String, values:[String: AnyObject]) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        SVProgressHUD.showProgress(0.7, status: "Creating your profile...")
        
        
        ref.child("users").child(uid).updateChildValues(values) { (err, ref) in
            SVProgressHUD.showProgress(0.9, status: "Creating your profile...")
            if err != nil {
                print(err!)
                let alert = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
                
                alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: { action in
                    switch action.style{
                    case .cancel:
                        self.goButton.isEnabled = true
                        print("cancel")
                    case .default:
                        self.goButton.isEnabled = true
                        print("default case")
                    case .destructive:
                        self.goButton.isEnabled = true
                        print("destructive case")
                    }
                }))
            } else {
                SVProgressHUD.showProgress(1.0, status: "Creating your profile...")
                SVProgressHUD.dismiss()
//                self.performSegue(withIdentifier: "profileSetUpToHashtags", sender: nil)
                 self.performSegue(withIdentifier: "profileToNavigationalController", sender: nil)
                
            }
        }
    }
    
    @objc func handleLargeProfileImageView(_ sender: UIImageView) {
        var imagePicker : UIImagePickerController!
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            mainImage.image = selectedImage
            mainImage.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations[0]
        print(userLocation)
        
        geocoder.reverseGeocodeLocation(userLocation,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let location = placemarks?[0]
                                                print(location!)
                                                self.currentCity = (location?.locality)!
                                                print(self.currentCity)
                                                self.currentStateCode = (location?.administrativeArea)!
                                                print(self.currentStateCode)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                print("couldnt get users location")
                                            }
        })
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("cancelled picker")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUIViews()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mainImage.contentMode = .scaleAspectFit
        mainImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLargeProfileImageView)))
        mainImage.isUserInteractionEnabled = true
    }
    
    func loadUIViews() {
        mainImage.layer.cornerRadius = mainImage.frame.width / 2
        mainImage.layer.masksToBounds = true;
        mainImage.layer.borderWidth = 0;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

