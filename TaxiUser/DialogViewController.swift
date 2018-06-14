//
//  DialogViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 13/06/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


//let kMaxRadius: CGFloat = 200
//let kMaxDuration: TimeInterval = 10

class DialogViewController: UIViewController,NVActivityIndicatorViewable {
    
  //  @IBOutlet weak var pulseview: UIView!
    
   // @IBOutlet weak var slideview: UIImageView!
    
    
    @IBOutlet var lblGettingNearest: UILabel!
    @IBOutlet var lblLoading: UILabel!
    @IBOutlet var lblPleaseWait: UILabel!
    
    @IBOutlet weak var slideview: NVActivityIndicatorView!
    
     var viewcontrollerself : UIViewController!
    
    func viewSetup(){
        
        lblGettingNearest.text = "GETTING NEAREST DRIVER".localized
        lblLoading.text = "Loading...".localized
        lblPleaseWait.text = "Please wait your driver reach you soon in while".localized
        
        
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewSetup()
   
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
             let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .ballScaleMultiple, color: .init(colorLiteralRed: 149/256, green: 165/256, blue: 166/256, alpha: 0.8) , padding: 10)
        
            self.slideview.addSubview(activityIndicatorView)
          
            activityIndicatorView.startAnimating()
            
            

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelbtn_click(_ sender: Any) {
        
        GlobalVarible.checkdialogcancelbtn = 1
        self.dismiss(animated: true, completion: nil)
        self.viewcontrollerself.viewWillAppear(true)
        
    }
    
  
   
    
      private func setupInitialValues() {
        
       // pulsator.position = slideview.center
     
             
    }

}
