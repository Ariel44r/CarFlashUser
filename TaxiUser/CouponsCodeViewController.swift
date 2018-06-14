//
//  CouponsCodeViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 29/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit

class CouponsCodeViewController: UIViewController,MainCategoryProtocol {
    
    var mydata : Coupons!
    
     var viewcontrollerself : UIViewController!
    
    @IBOutlet var mainview: UIView!
    
    @IBOutlet weak var innerview: UIView!
    
    @IBOutlet weak var entercouponcode: UITextField!
    
    @IBOutlet weak var simpleview: UIView!
    
    @IBOutlet weak var invalidtextshowview: UIView!
    
    
    @IBOutlet weak var youdontseemtextlabel: UILabel!
    @IBOutlet weak var applybtntextlabel: UILabel!
    @IBOutlet weak var cancelbtntextlabel: UILabel!
    @IBOutlet weak var pleaseentervalidcodetextlabel: UILabel!
    @IBOutlet weak var applycoupontextlabel: UILabel!
    
    @IBOutlet weak var invalidcodetextlabel: UILabel!
    
     var Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
    
     func viewSetup(){
        
        applybtntextlabel.text = "APPLY COUPON".localized
        applybtntextlabel.text = "APPLY".localized
        cancelbtntextlabel.text = "Cancel".localized
        invalidcodetextlabel.text = "INVALID CODE!!".localized
        pleaseentervalidcodetextlabel.text = "Please enter a valid coupon and try again.".localized
        youdontseemtextlabel.text = "You dont seem to have any valid coupons".localized
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewSetup()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func applycouponbtn(_ sender: Any) {
        
        if(entercouponcode.text!.characters.count == 0)
            
        {
            invalidtextshowview.isHidden = false
            simpleview.isHidden = true
        }
        else{
        
            
        ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.getcoupons(CouponCode: self.entercouponcode.text!,USERID: Userid!)

        }
        
    }
    
    @IBAction func cancelbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
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
    
    
    func showalert1(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:   "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
                 GlobalVarible.CouponCode = self.entercouponcode.text!
               
                GlobalVarible.couponcodevalue = 1
                self.dismiss(animated: true, completion: nil)
                 self.viewcontrollerself.viewWillAppear(true)
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
        
        mydata = data as! Coupons
        
        if(mydata.result == 0){
            
          invalidtextshowview.isHidden = false
            simpleview.isHidden = true
            
        }else{
            
            GlobalVarible.CouponCode = self.entercouponcode.text!

            self.showalert1( message: mydata.msg!)
            
        }

        
    }
    

    
}
