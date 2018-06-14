//
//  PaymentWebViewController.swift
//  Apporio Taxi
//
//  Created by Atul Jain on 19/12/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit

class PaymentWebViewController: UIViewController,UIWebViewDelegate {
    
    
    
    @IBOutlet weak var webview: UIWebView!
    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    
    var currentrideid = ""
    
     var ProductLink = ""
    
    var urlString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProductLink = API_URL.commondomain + "Application/View_Ride_info/\(currentrideid)"
        
        print(ProductLink)
        
        let url = NSURL(string: ProductLink)
        let request = URLRequest(url: url! as URL)
        webview.delegate = self
        
        
        activityindicator.hidesWhenStopped = true
        activityindicator.startAnimating()
        webview.loadRequest(request)
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        activityindicator.stopAnimating()
        
        if let yourTargetUrl = webview.request?.url
        {
            urlString = yourTargetUrl.absoluteString
            
            print(yourTargetUrl)
            
        }
        
        if urlString.contains("FinishActivity"){
            
            GlobalVarible.UserDropLocationText = "No drop off point".localized
            GlobalVarible.UserDropLat = 0.0
            GlobalVarible.UserDropLng = 0.0
            GlobalVarible.PaymentOptionId = "1"
            GlobalVarible.CouponCode = ""
            GlobalVarible.paymentmethod = "Cash"
            
            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                GlobalVarible.viewcontrollerself.viewDidLoad()
            })
            
            
        }else{
        
        }
        

        
    }
    

   
}
