//
//  SignupViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 22/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit


class SignupViewController: UIViewController,MainCategoryProtocol,MICountryPickerDelegate {
    
    var logindata: SignupLoginResponse!
    
    
   @IBOutlet weak var enterphonetext: UITextField!
    
     @IBOutlet weak var countrycodetext: UILabel!
    
    
    
    @IBOutlet weak var attachdetailslabel: UILabel!
    @IBOutlet weak var topregisterlabel: UILabel!
    
    
    @IBOutlet weak var registerbtntext: UIButton!
    
    
    @IBOutlet var container: UIView!
    
    @IBOutlet var phoneButton: UIButton!
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    
    var selcetcountrycode = "+52"
    
    var emailValid=false
    
    var phonetext = ""

    
    @IBOutlet var password: UITextField!
    //  @IBOutlet var confirmPassword: UITextField!
    
    var facebookFirstName = ""
    var facebookLastName = ""
    var googleFirstName = ""
    var googleLastName = ""
    var facebookId = ""
    var googleId = ""
    
    
    func setupView(){
        
        topregisterlabel.text = "Register".localized
        attachdetailslabel.text = "Attach Your Phone number if you want to remember your account easily.".localized
        firstName.placeholder = "Enter Name".localized
        lastName.placeholder = "Enter Email".localized
        // phoneButton.setTitle("Enter Phone".localized, for: UIControlState.normal)
        
        enterphonetext.placeholder = "Enter Phone".localized
        password.placeholder = "Enter Password".localized
        registerbtntext.setTitle("Register".localized, for: UIControlState.normal)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        self.container.edgeWithShadow()
        
        if facebookFirstName.characters.count > 0
        {
            self.firstName.text = facebookFirstName
        }
        if facebookLastName.characters.count > 0
        {
            self.lastName.text = facebookLastName
        }
        if googleFirstName.characters.count > 0
        {
            self.firstName.text = googleFirstName
        }
        if facebookFirstName.characters.count > 0
        {
            self.lastName.text = googleLastName
        }
        
       // self.signOutGoogle()
      //  self.signOutFacebok()
      //  self.signoutTwiterDegit()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if GlobalVarible.checkphonenumber == 1{
            
            self.phoneButton.setTitle(GlobalVarible.enteruserphonenumber, for: .normal)
            self.phoneButton.setTitleColor(UIColor.black, for: .normal)
            GlobalVarible.checkphonenumber = 0
            
        }else{
            
        }
        
    }

    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        
    }
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String)
    {
        selcetcountrycode = dialCode
        countrycodetext.text = dialCode
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func backbtn(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onRegister(_ sender: Any) {
        
        self.view.endEditing(true)
        
        self.lastName.text=self.lastName.text!
        
      //  phonetext = self.enterphonetext.text!
        
        let enteredEmail=self.lastName.text!
        
        if enteredEmail.isEmail{
            
            self.emailValid=true
            
            
        }else{
            
            self.emailValid=false
            
            
        }
        

        
        if (self.firstName.text?.characters.count)! < 2 {
            self.showalert(message: "Please Enter  Name".localized)
            // self.showBannerError("Message", subTitle: "Please Enter Valid Name", imageName: "")
            return
        }
        
        /* if self.lastName.text?.characters.count < 2 {
         self.showalert("Please check Last Name")
         // self.showBannerError("Message", subTitle: "Please check Last Name", imageName: "")
         return
         }*/
        
        if (((enterphonetext.text?.characters.count)! < 9) || ((enterphonetext.text?.characters.count)! > 11)){
            
            //if phonetext == ""{
            
            self.showalert(message: "Mobile number must be 9 to 11 digits.".localized)
            
            
            
            //  self.showBannerError("Message", subTitle: "Please Enter Valid Mobile Number", imageName: "")
            return
        }
        
        
        if (self.password.text?.characters.count)! < 5 {
            self.showalert(message: "Password  length should not be less then 5".localized)
            //   self.showBannerError("Message", subTitle: "Password  length should not be less then 5", imageName: "")
            return
        }
        
        
        
        
        /*if self.password.text! != self.confirmPassword.text! {
         self.showBannerError("Message", subTitle: "Password Does Not Match", imageName: "")
         return
         }*/
          if self.emailValid {
        
        
        let dic=[ signUpUrl2:"\(self.firstName.text!)",
            signUpUrl3:"\(".")",
            signUpUrl4:"\(selcetcountrycode + self.enterphonetext.text!)",
            signUpUrl5:"\(self.password.text!)",
            signUpUrl6:"\(self.lastName.text!)",
            signUpUrl7:"\(GlobalVarible.languagecode)"
        ]
        debugPrint(dic)
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.postData(dictonary: dic as NSDictionary, url: signUpUrl)
            
          }else{
            
            self.showalert(message: "Please fill email properly.".localized)
        }
        //  ApiController.sharedInstance.parsPostData(dic, url: signUpUrl, reseltCode: 3)
        
    }
    
    @IBAction func onPhone(_ sender: Any) {
        
       /* let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let verifyViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyPhoneViewController") as! VerifyPhoneViewController
        verifyViewController.matchString = ""
        self.present(verifyViewController, animated:true, completion:nil)*/
        
        

        
        let picker = MICountryPicker { (name, code) -> () in
            debugPrint(code)
        }
        
        picker.delegate = self
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped))
        picker.navigationItem.leftBarButtonItem = backButton
        // Display calling codes
        picker.showCallingCodes = true
        
        // or closure
        picker.didSelectCountryClosure = { name, code in
        }
        
        // self.present(picker, animated: true, completion: nil)
        let navcontroller = UINavigationController(rootViewController: picker)
        
        self.present(navcontroller,animated: true,completion: nil)
        
        

        

    }
    
    func backButtonTapped() {
        
        self.dismiss(animated: true, completion: nil)
    }

    
    
      
    
   /* func signOutGoogle()
    {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() == true {
            GIDSignIn.sharedInstance().signOut()
        }
        
    }
    
    func signOutFacebok()
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
    }
    
    func signoutTwiterDegit()
    {
        Digits.sharedInstance().logOut()
        
    }*/
    
    
    func showalert(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:  "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                
            }
            
            
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
        
        if logindata.result == 1{
            
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

            
            
        }else{
            
            self.showalert(message: logindata.message!)
        }
        
        
    }
    

    

  

}
