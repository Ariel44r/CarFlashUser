//
//  CustomerSupportViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 26/08/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit

class CustomerSupportViewController: UIViewController,MainCategoryProtocol {

    @IBOutlet weak var entername: UITextField!
    
    @IBOutlet weak var enteremail: UITextField!
    
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    var data: CustomerSupportModel!
    
    @IBOutlet weak var nameview: UIView!
    
    @IBOutlet weak var emailview: UIView!
    
    @IBOutlet weak var enterphone: UITextField!
    
    @IBOutlet weak var queryview: UIView!
    
    @IBOutlet weak var enterquerytext: UITextView!
    @IBOutlet weak var phoneview: UIView!
    
     var  Userid =  NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)!
    
    
    
    @IBOutlet var lblSend: UILabel!
    @IBOutlet var lblHaveQuery: UILabel!
    @IBOutlet var lblQueryInstruction: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var lblYourQuery: UILabel!
    
    func viewSetup(){
        
        lblSend.text = "SEND".localized
        lblHaveQuery.text = "DO YOU HAVE A QUERY".localized
        lblQueryInstruction.text = "Please let us know about your query,our support team will get back to you".localized
        lblName.text = "Name ".localized
        lblEmail.text = "Email".localized
        lblPhone.text = "Phone".localized
        lblYourQuery.text = "your Query".localized
        
        
    }
    

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewSetup()
        
        self.nameview.layer.borderWidth = 1.0
        self.nameview.layer.cornerRadius = 4
        self.emailview.layer.borderWidth = 1.0
        self.emailview.layer.cornerRadius = 4
        self.phoneview.layer.borderWidth = 1.0
        self.phoneview.layer.cornerRadius = 4
        self.queryview.layer.borderWidth = 1.0
        self.queryview.layer.cornerRadius = 4
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.scrollview.frame = self.scrollview.bounds
        self.scrollview.contentSize.height =  500
        self.scrollview.contentSize.width = 0
    }
    
    
    @IBAction func backbtn(_ sender: AnyObject) {
        
       self.dismiss(animated: true, completion: nil)
        //self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func sendbtn(_ sender: AnyObject) {
        
        if entername.text!.characters.count < 2
        {
           
            
            self.showalert(message: "Please Check Your Name".localized)
            
        }
        else if enteremail.text!.characters.count < 2{
            
           
            self.showalert(message: "Please Check Your Email".localized)
            
        }
        else if (!enteremail.text!.contains("@"))
        {
            let alert = UIAlertController(title: NSLocalizedString("", comment: ""), message:" Wrong Email format ".localized, preferredStyle: .alert)
            let action = UIAlertAction(title:  "OK".localized, style: .default) { _ in
                
            }
            alert.addAction(action)
            self.present(alert, animated: true){}
        }
            
        else if (enteremail.text!.contains(" "))
        {
            let alert = UIAlertController(title: "", message:" Email id must not contain space ".localized, preferredStyle: .alert)
            let action = UIAlertAction(title:  "OK".localized, style: .default) { _ in
                
            }
            alert.addAction(action)
            self.present(alert, animated: true){}
        }else if enterquerytext.text!.characters.count < 1{
            
              self.showalert(message: "Please Check Your Query is blank".localized)
            
         
            
        }
         else{
            
            ApiManager.sharedInstance.protocolmain_Catagory = self
            
            ApiManager.sharedInstance.CustomerSupportApi(UserId: self.Userid, Name: self.entername.text!, Email: self.enteremail.text!, Phone: self.enterphone.text!, Query: self.enterquerytext.text!)
        }
        
        
        
    }
    
    func showalert(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:   NSLocalizedString("Alert", comment: ""), message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                
            }
            
            
        })
        
    }
    
    
    func showalert1(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:   NSLocalizedString("Alert", comment: ""), message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
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
        
        self.data = data as! CustomerSupportModel
        
        if(self.data.result == 1){
            
            
            self.showalert1(message: (self.data.msg!))
            
            
        }else{
             self.showalert(message: (self.data.msg!))
            
          
            
            
        }

        

    }
    


   

}
