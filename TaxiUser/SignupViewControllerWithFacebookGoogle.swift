//
//  SignupViewControllerWithFacebookGoogle.swift
//  TaxiUser
//
//  Created by AppOrio on 22/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit


class SignupViewControllerWithFacebookGoogle: UIViewController,MainCategoryProtocol,MICountryPickerDelegate {
    
    var logindata : SignupLoginResponse!
    
    @IBOutlet weak var userimageview: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var useremail: UILabel!
    
    
    @IBOutlet var container: UIView!
    
   // @IBOutlet var phoneButton: UIButton!
    
    @IBOutlet weak var countrycodetext: UILabel!
    
    @IBOutlet weak var enterphonetext: UITextField!
    
    @IBOutlet weak var registerbtntext: UIButton!
    
    @IBOutlet weak var topregistertextlabel: UILabel!
    
    @IBOutlet weak var attachdetailstextlabel: UILabel!
    
   // @IBOutlet var firstName: UITextField!
   // @IBOutlet var lastName: UITextField!
    
    var selcetcountrycode = "+52"
    
    var phonetext = ""
    
    var movedFrom = ""
    
    var facebookFirstName = ""
    var facebookLastName = ""
    var googleFirstName = ""
    var googleLastName = ""
    var facebookId = ""
    var googleId = ""
    var googleMail = ""
    var googleImage = ""
    var facebookMail = ""
    var facebookImage = ""
    
    func setupView(){
        
        attachdetailstextlabel.text = "Attach Your Phone number if you want to remember your account easily.".localized
        
        topregistertextlabel.text = "Register".localized
       // phoneButton.setTitle("Enter Phone".localized, for: UIControlState.normal)
        enterphonetext.placeholder = "Enter Phone".localized
        registerbtntext.setTitle("Register".localized, for: UIControlState.normal)
        
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupView()
        
        userimageview.layer.cornerRadius =  userimageview.frame.width/2
        userimageview.clipsToBounds = true
        userimageview.layer.borderWidth = 1
        userimageview.layer.borderColor = UIColor.white.cgColor
        


        self.container.edgeWithShadow()
        
        if movedFrom == "google"{
            
            if(googleImage == ""){
                userimageview.image = UIImage(named: "profileeee") as UIImage?
               
                debugPrint("No Image")
            }else{
                let newUrl = googleImage
                // let url = "http://apporio.co.uk/apporiotaxi/\(drivertypeimage!)"
                debugPrint(newUrl)
                
                let url1 = NSURL(string: newUrl)
                
                
                userimageview!.af_setImage(withURL:
                    url1! as URL,
                                                 placeholderImage: UIImage(named: "dress"),
                                                 filter: nil,
                                                 imageTransition: .crossDissolve(1.0))
                
            }
            
            
            self.username.text = googleFirstName
             self.useremail.text = googleMail
        }
        else
        {
            
            
            if(facebookImage == ""){
                userimageview.image = UIImage(named: "profileeee") as UIImage?
                
                debugPrint("No Image")
            }else{
                let newUrl = facebookImage
                // let url = "http://apporio.co.uk/apporiotaxi/\(drivertypeimage!)"
                debugPrint(newUrl)
                
                let url1 = NSURL(string: newUrl)
                
                
                userimageview!.af_setImage(withURL:
                    url1! as URL,
                                           placeholderImage: UIImage(named: "dress"),
                                           filter: nil,
                                           imageTransition: .crossDissolve(1.0))
                
            }

            
            self.username.text = facebookFirstName
            self.useremail.text = facebookMail
        }
        
        
       // self.signoutTwiterDegit()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       /* if GlobalVarible.checkphonenumber == 1{
            
            self.phoneButton.setTitle(GlobalVarible.enteruserphonenumber, for: .normal)
            self.phoneButton.setTitleColor(UIColor.black, for: .normal)
            GlobalVarible.checkphonenumber = 0
            
        }else{
            
        }
        */
    }

    
    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        
    }
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String)
    {
        selcetcountrycode = dialCode
        countrycodetext.text = dialCode
        self.dismiss(animated: true, completion: nil)
        
        
    }

    
    @IBAction func onRegister(_ sender: Any) {
        
        self.view.endEditing(true)
        
        
      //  phonetext = self.enterphonetext.text!
        
       /* if (self.firstName.text?.characters.count)! < 2 {
            self.showalert(message: "Please Enter Valid Name")
            // self.showBannerError("Message", subTitle: "Please Enter Valid Name", imageName: "")
            return
        }
        
        if movedFrom != "google"{
            
            if (self.lastName.text?.characters.count)! < 2 {
                self.showalert(message: "Please check Last Name")
                //  self.showBannerError("Message", subTitle: "Please check Last Name", imageName: "")
                return
            }
        }*/
        
        
        if (((enterphonetext.text?.characters.count)! < 9) || ((enterphonetext.text?.characters.count)! > 11)){
            
           
            
            self.showalert(message: "Mobile number must be 9 to 11 digits.".localized)
            
            
            
          
            return
        }
        
        
        
        if movedFrom == "facebook" {
            
            let dic=[ facebookSignupUrl2:"\(self.facebookId)",
                facebookSignupUrl3:"\(self.facebookMail)",
                facebookSignupUrl4:"\(self.facebookImage)",
                facebookSignupUrl5:"\(facebookFirstName)",
                facebookSignupUrl6:"\(facebookLastName)",
                facebookSignupUrl7:"\(selcetcountrycode + self.enterphonetext.text!)",
                facebookSignupUrl8:"\(facebookFirstName)",
                facebookSignupUrl9:"\(facebookLastName)",
                facebookSignupUrl10:"\(GlobalVarible.languagecode)"
            ]
            
            for items in dic{
                debugPrint(items.1)
            }
            
            debugPrint(dic)
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.postData(dictonary: dic as NSDictionary, url: facebookSignupUrl)
            
            //  ApiController.sharedInstance.parsPostData(dic, url:facebookSignupUrl, reseltCode: 10)
            
        }
        
        
        if movedFrom == "google"{
            
            let dic=[ googleSignupUrl2:"\(self.googleId)",
                googleSignupUrl3:"\(googleFirstName)",
                googleSignupUrl4:"\(self.googleMail)",
                googleSignupUrl5:"\(self.googleImage)",
                googleSignupUrl6:"\(selcetcountrycode + self.enterphonetext.text!)",
                googleSignupUrl7:"\(googleFirstName)",
                googleSignupUrl8:"\(googleLastName)",
                googleSignupUrl9:"\(GlobalVarible.languagecode)",
                googleSignupUrl10:"\(self.googleMail)"
                
            ]
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.postData(dictonary: dic as NSDictionary, url: googleSignupUrl)
            
            //  ApiController.sharedInstance.parsPostData(dic, url:googleSignupUrl, reseltCode: 10)
            
        }
        
        
        

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
    
    
    
      
    
   /* func signoutTwiterDegit()
    {
        Digits.sharedInstance().logOut()
        
    }*/
    
    
    func showalert(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:   "Alert".localized, message:message, preferredStyle: .alert)
            
            
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
            
            
        }
        
        
    }
    
    



   

}
