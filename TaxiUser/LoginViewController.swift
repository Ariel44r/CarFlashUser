//
//  LoginViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 22/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore
import CoreData
import FBSDKShareKit
import FBSDKLoginKit


class LoginViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate,MICountryPickerDelegate,MainCategoryProtocol {

    //MARK: Outlets  
    @IBOutlet var phone: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var container: UIView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var facebokButton: UIButton!
    @IBOutlet var googleButton: UIButton!
    @IBOutlet var lblOrSignUp: UILabel!
    @IBOutlet var lblNewhere: UILabel!
    //@IBOutlet weak var orcreatedemousertextlabel: UILabel!
    @IBOutlet var lblForgotPassword: UILabel!
    //@IBOutlet weak var logindemousertextlabel: UILabel!
    @IBOutlet weak var selectcountrycodelabel: UILabel!
    @IBOutlet weak var selectcountrycodebtntext: UIButton!

    //MARK: Instances
    var selcetcountrycode = "+52"
    var logindata : SignupLoginResponse!
    var firstName = ""
    var lastName = ""
    var fbOrGoogleId = ""
    var fborGoogleImageUrl = ""
    var fbOrGoogleMail = ""
    var buttonPressed = ""

    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblOrSignUp.text = "or sign up with".localized
        self.phone.placeholder = "Phone Number".localized
        self.password.placeholder = "Password".localized
        loginButton.setTitle("Login".localized, for: UIControlState.normal)
        //logindemousertextlabel.text = "Login as Demo User".localized
        //orcreatedemousertextlabel.text = "or Create demo User".localized
        self.lblForgotPassword.text = "Forgot Password ?".localized
        self.lblNewhere.text = "New here? SignUp".localized
        self.loginButton.edgeWithShadow()
        self.facebokButton.edgeWithShadow()
        self.googleButton.edgeWithShadow()
        self.container.edgeWithShadow()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Acions & Methods
    @IBAction func newheresignupbtn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let revealViewController = storyBoard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(revealViewController, animated:true, completion:nil)
        
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        //dismiss(animated: true, completion: nil)
        //label.text = "Selected Country: \(code)"
    }

    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        selcetcountrycode = dialCode
        selectcountrycodelabel.text = dialCode
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popToRootViewController(animated: true)
        //label.text = "Selected Country: \(dialCode)"
        
    }
    
    @IBAction func selectcountrycodebtn(_ sender: Any) {
        
        let picker = MICountryPicker { (name, code) -> () in
            debugPrint(code)
        }
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped))
        picker.navigationItem.leftBarButtonItem = backButton
        picker.delegate = self
        
        // Display calling codes
        picker.showCallingCodes = true
        
        // or closure
        picker.didSelectCountryClosure = { name, code in
        }
        let navcontroller = UINavigationController(rootViewController: picker)        
        self.present(navcontroller,animated: true,completion: nil)

    }
    
    func backButtonTapped() {
        
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func onLogin(_ sender: Any) {
        self.view.endEditing(true)        
        self.buttonPressed = "login"
        let dic=[ loginUrl2:"\(selcetcountrycode + self.phone.text!)",
            loginUrl3:"\(self.password.text!)",
            loginUrl4:"\(GlobalVarible.languagecode)"
        ]
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.postData(dictonary: dic as NSDictionary, url: loginUrl)
        //ApiController.sharedInstance.parsPostData(dic, url: loginUrl, reseltCode: 2)

    }
    
    
   /* @IBAction func loginasdemouser_click(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let next: CreateDemoDriverViewController = storyboard.instantiateViewController(withIdentifier: "CreateDemoDriverViewController") as! CreateDemoDriverViewController
        next.modalPresentationStyle = .overCurrentContext
        self.present(next, animated: true, completion: nil)
        
    }*/
    
    @IBAction func onGoogle(_ sender: Any) {
        self.buttonPressed = "google"
        GIDSignIn.sharedInstance().signIn()
    }
   
    @IBAction func onFacebook(_ sender: Any) {
        self.buttonPressed = "facebook"
        self.loginButtonClicked()

    }
    
    @IBAction func forgetpassaction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let verifyViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyPhoneViewController") as! VerifyPhoneViewController
        verifyViewController.matchString = "forgot"
        self.present(verifyViewController, animated:true, completion:nil)
      
    }
    
   /* func signoutTwiterDegit()
    {
        Digits.sharedInstance().logOut()
        
    }*/
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                debugPrint(error)
            case .cancelled:
                debugPrint("User cancelled login.")
            case .success( _, _, _):
                //debugPrint(grantedPermissions)
                //debugPrint(declinedPermissions)
                // debugPrint(accessToken)
                //debugPrint(loginResult)
                self.getuaerinfofromfacebook()
            }
        }
    }

    func getuaerinfofromfacebook() {
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, gender , name, first_name, last_name, picture.type(large), email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                debugPrint("Error: \(error)")
            } else {
                debugPrint(result!)
                // let userdat = result as
                let data:[String:Any] = result as! [String : Any]
                let  name  =   (data as AnyObject).object(forKey:"name") as! String
                let  id  =   (data as AnyObject).object(forKey:"id") as! String
                let email  = id + "@facebook.com"
                self.firstName = name
                self.fbOrGoogleId = id
                self.fbOrGoogleMail = email
                let imgURLString = "https://graph.facebook.com/\(id)/picture?width=640&height=640"
                self.fborGoogleImageUrl = imgURLString
                let dic=[ facebookLoginUrl2: "\(id)"]
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.postData(dictonary: dic as NSDictionary, url: facebookLoginUrl)
                
            }  
        })
    }
    
    //MARK: Google Sign In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
      /*  if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            // let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            let email = user.profile.email
            Lclsocialname = fullName!
            LclsocialID = userId!
            LclsocialEmail = email!
            self.SocialLoginapi(socialid: userId!, SocialParam: "google_id", Socialurl: "Account/google_login", resultcode: 3)
            // ...
        } */
        if (error == nil) {    
            let userId = user.userID
            //  let idToken = user.authentication.idToken
            let fullName = user.profile.name    
            // let image = user.profile.imageURL(withDimension: 400)    
            let profilePicture = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 400)
            // let profilePicture = String(describing: GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 400))
            let email = user.profile.email
            //  self.signOutGoogle()
            self.firstName = fullName!
            self.fbOrGoogleId = userId!
            self.fborGoogleImageUrl = String(describing: profilePicture!)
            debugPrint(fborGoogleImageUrl)
            self.fbOrGoogleMail = email!
            let dic=[ googleLoginUrl2: "\(userId!)"]
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.postData(dictonary: dic as NSDictionary, url: googleLoginUrl)
            //   ApiController.sharedInstance.parsPostData(dic, url: googleLoginUrl, reseltCode: 9)
            
        } else {
            debugPrint("\(error.localizedDescription)")
        }
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }

    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showalert(message:String)  {        
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title:   "Alert".localized, message:message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) { }
            
        })
    }

    func onProgressStatus(value: Int) {
        if(value == 0 ){
            MBProgressHUD.hide(for: self.view, animated: true)

        }else if (value == 1){
            let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
            spinnerActivity.label.text = "Loading".localized
            spinnerActivity.detailsLabel.text = "Please Wait!!".localized
            spinnerActivity.isUserInteractionEnabled = false
            
        }
    }
    
    func onSuccessExecution(msg: String) {
        debugPrint("\(msg)")
    }
    
    
    func onerror(msg : String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.showalert(message: msg)

    }
    
    func onSuccessParse(data: AnyObject) {    
        logindata = data as! SignupLoginResponse
        if buttonPressed == "login" {
            if logindata.result == 1 {
                let userid = logindata.details!.userId
                let UserDeviceKey = UserDefaults.standard.string(forKey: "device_key")
                debugPrint(UserDeviceKey!)
                let uniqueid =  UserDefaults.standard.string(forKey: "unique_number")
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.UserDeviceId(USERID: userid!, USERDEVICEID: UserDeviceKey! , FLAG: "1",UNIQUEID: uniqueid!)
                NsUserDekfaultManager.SingeltionInstance.loginuser(user_id: self.logindata.details!.userId!,name: self.logindata.details!.userName!, image: (self.logindata.details?.userImage)!, email: self.logindata.details!.userEmail!, phonenumber: (self.logindata.details?.userPhone!)!, status: self.logindata.details!.status!,password: self.logindata.details!.userPassword!,facbookimage: (self.logindata.details?.facebookImage!)!, googleimage: (self.logindata.details?.googleImage)!)
               /* let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let revealViewController:MapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                self.present(revealViewController, animated:true, completion:nil)*/
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextController: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                if let window = self.view.window { 
                    window.rootViewController = nextController

                }
            } else {
                self.showalert(message: logindata.message!)
                
            }
        }

        if buttonPressed == "facebook"{   
            if logindata.result == 0 // 0 means user Does not exis mens us fb or google id se koi user register nhi ha 
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "SignupViewControllerWithFacebookGoogle") as! SignupViewControllerWithFacebookGoogle
                vc.facebookFirstName = self.firstName
                vc.facebookLastName = self.lastName
                vc.facebookId = self.fbOrGoogleId
                vc.facebookMail = fbOrGoogleMail
                vc.facebookImage = fborGoogleImageUrl
                vc.movedFrom = "facebook"
                self.present(vc, animated: true, completion: nil)

            }

            if logindata.result == 1 {
                let userid = logindata.details!.userId
                let UserDeviceKey = UserDefaults.standard.string(forKey: "device_key")
                debugPrint(UserDeviceKey!)
                let uniqueid =  UserDefaults.standard.string(forKey: "unique_number")
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.UserDeviceId(USERID: userid!, USERDEVICEID: UserDeviceKey! , FLAG: "1",UNIQUEID: uniqueid!)
                NsUserDekfaultManager.SingeltionInstance.loginuser(user_id: self.logindata.details!.userId!,name: self.logindata.details!.userName!, image: (self.logindata.details?.userImage)!, email: self.logindata.details!.userEmail!, phonenumber: (self.logindata.details?.userPhone!)!, status: self.logindata.details!.status!,password: self.logindata.details!.userPassword!,facbookimage: (self.logindata.details?.facebookImage!)!, googleimage: (self.logindata.details?.googleImage)!)
              /*  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let revealViewController:MapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                self.present(revealViewController, animated:true, completion:nil)*/
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextController: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                if let window = self.view.window{
                    window.rootViewController = nextController
                    
                }
                debugPrint("user Exist verifyed plz save detail and move to home Screen")

            }
        }

        if buttonPressed == "google"{   
            if logindata.result == 0 // 0 means user Does not exis mens us fb or google id se koi user register nhi ha
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "SignupViewControllerWithFacebookGoogle") as! SignupViewControllerWithFacebookGoogle
                vc.googleFirstName = self.firstName
                vc.googleLastName = self.lastName
                vc.googleId = self.fbOrGoogleId
                vc.movedFrom = "google"
                vc.googleMail = fbOrGoogleMail
                vc.googleImage = fborGoogleImageUrl
                self.present(vc, animated: true, completion: nil)
            }
            
            if logindata.result == 1 {
                let userid = logindata.details!.userId
                let UserDeviceKey = UserDefaults.standard.string(forKey: "device_key")
                debugPrint(UserDeviceKey!)
                let uniqueid =  UserDefaults.standard.string(forKey: "unique_number")                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.UserDeviceId(USERID: userid!, USERDEVICEID: UserDeviceKey! , FLAG: "1",UNIQUEID: uniqueid!)
                NsUserDekfaultManager.SingeltionInstance.loginuser(user_id: self.logindata.details!.userId!,name: self.logindata.details!.userName!, image: (self.logindata.details?.userImage)!, email: self.logindata.details!.userEmail!, phonenumber: (self.logindata.details?.userPhone!)!, status: self.logindata.details!.status!,password: self.logindata.details!.userPassword!,facbookimage: (self.logindata.details?.facebookImage!)!, googleimage: (self.logindata.details?.googleImage)!)
               /* let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let revealViewController:MapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                self.present(revealViewController, animated:true, completion:nil)*/
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextController: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                if let window = self.view.window{
                    window.rootViewController = nextController
                }
                debugPrint("user Exist verifyed plz save detail and move to home Screen")
            }
        }
        
        if buttonPressed == "forgot"{    
            if logindata.result == 1 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
                vc.oldPassword =   logindata.details!.userPassword!
                vc.userId = logindata.details!.userId!
                self.present(vc, animated: true, completion: nil)

            } else {
                self.showalert(message: logindata.message!)

            }
        }
    }

}
