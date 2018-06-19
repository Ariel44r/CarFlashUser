//
//  TemsConditionsViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 24/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit

class TemsConditionsViewController: UIViewController,MainCategoryProtocol {
    
    var mydata: TermsModel!
    
    @IBOutlet weak var textview: UITextView!
    
@IBOutlet var lblTermAndCond: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTermAndCond.text = "Terms & Conditions".localized
        
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.TermsConditions()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        mydata = data as! TermsModel
        
        if(UserDefaults.standard.object(forKey: "PreferredLanguage") as! String == "en"){
            
            
            do {
                let str = try NSAttributedString(data: (self.mydata.details!.descriptionValue)!.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
                
                textview.attributedText =  str
            } catch {
                debugPrint(error)
            }
            

            
           //textview.text = mydata.details!.descriptionValue!.html2String
        }else{
            
            do {
                let str = try NSAttributedString(data: (self.mydata.details!.descriptionValue)!.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
                
                textview.attributedText =  str
            } catch {
                debugPrint(error)
            }
            

            
            //textview.text = mydata.details!.descriptionFrench!.html2String
        }
        
        
        
        
    }
    

    

  

}
