//
//  ProfileViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 26/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,MainCategoryProtocol,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
     var logindata : SignupLoginResponse!
    
    
    var logoutdata : LogOutModel!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var ueremail: UITextField!
    
    @IBOutlet weak var userimage: UIImageView!
    
    
    
    
    @IBOutlet var lblAccountInfo: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblEmailDesc: UILabel!
    @IBOutlet var lblVerified: UILabel!
  //  @IBOutlet var lblSignOut: UILabel!
    @IBOutlet var btnDone: UIButton!
    @IBOutlet var lblYourAccount: UILabel!

    
    var editname = ""
    
    var editemail = ""
    
    var edituserimage = ""
    
    
   // @IBOutlet weak var username: UILabel!
    
   // @IBOutlet weak var useremail: UILabel!
    
    @IBOutlet weak var usermobile: UILabel!
    
    let imageUrl = API_URL.imagedomain
    
    let Name = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyname)
    
    
    
    let email = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyemail)
    
    let mobile = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyphonenumber)
    let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
    
     let image = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyimage)

     let facebookimage = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.keyfacbookimage)
    
     let googleimage = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.keygoogleimage)

    
    
    func viewSetup(){
        
        lblAccountInfo.text = "Name".localized
        lblUserName.text = "User Email".localized
        lblEmailDesc.text = "This email can be used in future for getting your proper order tracking and invocing of your order".localized
        lblVerified.text = "Verified".localized
       // lblSignOut.text = "SignOut".localized
        lblYourAccount.text = "YOUR ACCOUNT".localized
        btnDone.setTitle("DONE".localized, for: UIControlState.normal)
        
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewSetup()
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ProfileViewController.imageTapped(_:)))
        userimage.isUserInteractionEnabled = true
        userimage.addGestureRecognizer(tapGestureRecognizer)
        
        userimage.layer.cornerRadius =  userimage.frame.width/2
        userimage.clipsToBounds = true
        userimage.layer.borderWidth = 1
        userimage.layer.borderColor = UIColor.black.cgColor
        

        
        
        if image != ""{
            
            
            
            edituserimage = image!
            
            
            
            let newUrl =  image!
            let url = URL(string: newUrl)
            userimage.af_setImage(withURL:
                url! as URL,
                                  placeholderImage: UIImage(named: "dress"),
                                  filter: nil,
                                  imageTransition: .crossDissolve(1.0))
            

            

        
        
        }else if googleimage != ""{
            
            let newUrl = googleimage
           
           edituserimage = googleimage!
            
            let url1 = NSURL(string: newUrl!)
            
            
            userimage!.af_setImage(withURL:
                url1! as URL,
                                       placeholderImage: UIImage(named: "dress"),
                                       filter: nil,
                                       imageTransition: .crossDissolve(1.0))
            

        
        
        }else if facebookimage != ""{
            
            
            let newUrl = facebookimage
            
            edituserimage = facebookimage!
            
            let url1 = NSURL(string: newUrl!)
            
            
            userimage!.af_setImage(withURL:
                url1! as URL,
                                   placeholderImage: UIImage(named: "dress"),
                                   filter: nil,
                                   imageTransition: .crossDissolve(1.0))
        
        }else{
            
           
            
        
            userimage.image = UIImage(named: "profileeee") as UIImage?

        }
        
        editname = Name!
        
        editemail = email!
        
        self.ueremail.text! = email!
        self.username.text! = Name!
        
        self.usermobile.text! = mobile!


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if GlobalVarible.checkphonenumber == 1{
            
             self.usermobile.text! = GlobalVarible.enteruserphonenumber
           
            GlobalVarible.checkphonenumber = 0
            
        }else{
            
        }
        
    }
    

    
    
    func imageTapped(_ img: AnyObject)
    {
        let alertView = UIAlertController(title: "Select Option".localized, message: "", preferredStyle: .alert)
        let Camerabutton = UIAlertAction(title: "Camera".localized, style: .default, handler: { (alert) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            
            
            
        })
        let Gallerybutton = UIAlertAction(title: "Gallery".localized, style: .default, handler: { (alert) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
                print("Button capture")
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel".localized,
                                         style: .cancel, handler: nil)
        alertView.addAction(Camerabutton)
        alertView.addAction(Gallerybutton)
        alertView.addAction(cancelAction)
        self.present(alertView, animated: true, completion: nil)
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            userimage.image = pickedImage
            
           
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func editphonebtn_click(_ sender: Any) {
        
        
      /*  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let verifyViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyPhoneViewController") as! VerifyPhoneViewController
        verifyViewController.matchString = ""
        self.present(verifyViewController, animated:true, completion:nil)*/
        

    }
    
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donebtn_click(_ sender: Any) {
        
        editname = username.text!
        
        editemail = ueremail.text!
        
               
        if editemail == ""{
        
            self.showalert(message: "Please enter email first.".localized)
        
        }else{
        
        
        
        let parameters = [
            "user_name": editname,
            "user_email": editemail,
            "user_id": self.Userid,
            "phone": self.usermobile.text!,
            "language_code":GlobalVarible.languagecode
           
            
        ]
        
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.uploadRequest(parameters: parameters as! [String : String], driverImage: userimage.image!)
        
        }
        
       
        
    }
    
    
    
    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
  /*  @IBAction func logoutbtn(_ sender: Any) {
        
        let refreshAlert = UIAlertController(title:  "Log Out".localized, message: "Are You Sure to Log Out ?".localized, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Confirm".localized , style: .default, handler: { (action: UIAlertAction!) in
            
          
            
             let uniqueid =  UserDefaults.standard.string(forKey: "unique_number")
            
            let dic=[ LogoutUrl1:"\(self.Userid!)",
                LogoutUrl2:"\(uniqueid!)",
                LogoutUrl3:"\(GlobalVarible.languagecode)"
            
            ]
            
            print(dic)
            
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.logoutUser(dictonary: dic as NSDictionary, url: LogoutUrl)
            
            
            
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: { (action: UIAlertAction!) in
            
            refreshAlert .dismiss(animated: true, completion: nil)
            
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)

        
        
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
    
    func showalert2(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:   "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
                NsUserDekfaultManager.SingeltionInstance.logOut()
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let splashViewController = storyBoard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
                
                self.present(splashViewController, animated:true, completion:nil)
                
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
        print("\(msg)")
    }
    
    
    func onerror(msg : String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        
        self.showalert(message: msg)
        
    }
    
    
    
    func onSuccessParse(data: AnyObject) {
        
        
        if(GlobalVarible.Api == "editprofile"){
        
        logindata = data as! SignupLoginResponse
            
              if logindata.result == 1{
                
                
                NsUserDekfaultManager.SingeltionInstance.loginuser(user_id: self.logindata.details!.userId!,name: self.logindata.details!.userName!, image: (self.logindata.details?.userImage)!, email: self.logindata.details!.userEmail!, phonenumber: (self.logindata.details?.userPhone!)!, status: self.logindata.details!.status!,password: self.logindata.details!.userPassword!,facbookimage: (self.logindata.details?.facebookImage!)!, googleimage: (self.logindata.details?.googleImage)!)
                

        
            let alert = UIAlertController(title: "Profile Updated".localized, message:"", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok".localized, style: .default) { _ in
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextController: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                
                if let window = self.view.window{
                    window.rootViewController = nextController
                }
                
                
            }
            alert.addAction(action)
            self.present(alert, animated: true){}
                
              }else{
            
            self.showalert(message: "Please try again.".localized)
            
            
            }
        
        
        
        }
        
        
        if(GlobalVarible.Api == "userlogout"){
            
            logoutdata = data as! LogOutModel
            
            if(logoutdata.result == 1){
                
                NsUserDekfaultManager.SingeltionInstance.logOut()
                
                self.showalert2(message: logoutdata.msg!)
                
            }else{
                
                self.showalert(message: logoutdata.msg!)
            }
            
            
        }

    }
    

   
}
