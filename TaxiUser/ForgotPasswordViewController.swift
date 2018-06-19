//
//  ForgotPasswordViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 22/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,MainCategoryProtocol {
    
    var changepasswordresponse : NewChangePassword!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var confrimPassword: UITextField!
    
    @IBOutlet var changePasswordButton: UIButton!
    
    
    @IBOutlet weak var topresetyourpasswordtext: UILabel!
    
    @IBOutlet weak var newpasswordtext: UILabel!
    
    @IBOutlet weak var confirmpasswordtext: UILabel!
    
    
    @IBOutlet weak var changepasswordbtntext: UIButton!
    
    var oldPassword = ""
    var userId = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
        topresetyourpasswordtext.text = "RESET YOUR PASSWORD".localized
        newpasswordtext.text = "New Password".localized
        confirmpasswordtext.text = "Confirm Password".localized
        changepasswordbtntext.setTitle("Change Password".localized, for: UIControlState.normal)
        password.placeholder = "Enter Password".localized
        confrimPassword.placeholder = "Confirm Password".localized
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backbtn(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onChangePassword(_ sender: Any) {
        
        if self.password.text!.characters.count < 6
        {
            self.showalert(message: "Password Shoud Not Be Less Then 6".localized)
            // self.showBannerError("Error", subTitle: "Password Shoud Not Be Less Then 6", imageName: "")
            return
        }
        
        
        if self.password.text!  != self.confrimPassword.text {
            self.showalert(message: "Password Does Not Match".localized)
            //  self.showBannerError("Error", subTitle: "Password Does Not Match", imageName: "")
            return
        }
        
        
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.ChangeUserPassword(Phone: GlobalVarible.enteruserphonenumber, Password: self.password.text!)
        
        
    }
    
    
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
        
        changepasswordresponse = data as! NewChangePassword
        
        
        if(changepasswordresponse.result == 1){
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let revealViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            self.present(revealViewController, animated:true, completion:nil)
            
            
        }else{
            
            self.showalert(message: changepasswordresponse.message!)
            
        }
        
        
        
        
    }


    


  
}
