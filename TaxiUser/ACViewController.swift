//
//  ACViewController.swift
//  CabShe
//
//  Created by Piyush Kumar on 1/9/18.
//  Copyright © 2018 apporio. All rights reserved.
//

import UIKit

class ACViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var Webview: UIWebView!
    
    var ProductLink = ""
    
    var urlString = ""
    
    @IBOutlet weak var addcardtextlbl: UILabel!
    
    let Userid =  NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProductLink = GlobalVarible.UserBaseUrl + "view_card.php?user_id=\(Userid)"
        
        print(ProductLink)
        
        let url = NSURL(string: ProductLink)
        let request = URLRequest(url: url! as URL)
        Webview.delegate = self
        
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.startAnimating()
        Webview.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func Back_Btn(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        ActivityIndicator.stopAnimating()
        
        if let yourTargetUrl = Webview.request?.url
        {
            urlString = yourTargetUrl.absoluteString
            
            if urlString.contains("select_card.php") {
                let cardurl = (urlString.components(separatedBy: "="))
                
                let cardid = (cardurl[1])
                print (cardid)
                GlobalVarible.CardId = cardid
                GlobalVarible.MatchCardSelect = 1
                GlobalVarible.Walletcheck = 3
                self.dismiss(animated: true, completion: nil)   
            }
            
            print(yourTargetUrl)
            
        }

    }

}
