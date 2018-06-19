//
//  AddMoneyViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 15/07/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit
import Stripe

class AddMoneyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MainCategoryProtocol,CardIOPaymentViewControllerDelegate {
    
    @IBOutlet weak var mainview: UIView!
    
    var savedata : SaveCardModel!
    var carddata : CardDetailsModel!
    var addmoneydata : AddMoneyModel!
    
    var SIZE = 0
    
    var toastLabel : UILabel!

    var enteramountvalue = ""
    
    
    
    @IBOutlet var lblAddMoney: UILabel!
    @IBOutlet var lblAddMoneyToWallet: UILabel!
    @IBOutlet var lblItQuickAndSafe: UILabel!
    
    @IBOutlet var lblCardDetails: UILabel!
    
       @IBOutlet var btnAddMoney: UIButton!
    
    @IBOutlet weak var carddetailstableview: UITableView!
    
    
    @IBOutlet weak var currencylabeltext: UILabel!
    
    
    @IBOutlet weak var firstbtn: UIButton!
    
    @IBOutlet weak var secondbtn: UIButton!
    
    @IBOutlet weak var thirdbtn: UIButton!
    @IBOutlet weak var enteramounttext: UITextField!
    
    let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
    
    var newGeneratedCardName = ""
    var newGeneratedCardNumber = ""
    var newGeneratedCardExpiryMonth = ""
    var newGeneratedCardExpiryYear = ""
    var newGeneratedCardCv = ""
    
    func viewSetupForLang(){
        
        lblAddMoney.text = "Add Money To Wallet".localized
        lblAddMoneyToWallet.text = "Add Money To Wallet".localized
        lblItQuickAndSafe.text = "It's quick,safe and secure".localized
        btnAddMoney.setTitle("Add Money".localized, for: UIControlState.normal)
        
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewSetupForLang()
        
        
        carddetailstableview.isHidden = true
        
        
        currencylabeltext.text = GlobalVarible.currencysymbol
        
        self.firstbtn.setTitle(GlobalVarible.currencysymbol + " 100", for: .normal)
        
         self.secondbtn.setTitle(GlobalVarible.currencysymbol + " 200", for: .normal)
        
         self.thirdbtn.setTitle(GlobalVarible.currencysymbol + " 300", for: .normal)
        
       
        
                
        
        toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-300, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.white
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = NSTextAlignment.center;
        self.view.addSubview(toastLabel)
        toastLabel.text =  "No Card Added!!".localized
        
        toastLabel.isHidden = true
        

        
        mainview.layer.shadowColor = UIColor.gray.cgColor
        mainview.layer.shadowOpacity = 1
        mainview.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainview.layer.shadowRadius = 2
        
        
        self.firstbtn.layer.borderWidth = 1.0
        self.firstbtn.layer.cornerRadius = 4
        
        self.secondbtn.layer.borderWidth = 1.0
        self.secondbtn.layer.cornerRadius = 4
        self.thirdbtn.layer.borderWidth = 1.0
        self.thirdbtn.layer.cornerRadius = 4
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if GlobalVarible.Walletcheck == 3{
            
            GlobalVarible.Walletcheck = 0
            
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.AddMoneyMethod(UserId: Userid!, Amount: enteramountvalue, CardId: GlobalVarible.CardId)
            
            
            
        }else{
            
            
        }
        
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func firstbtn_click(_ sender: Any) {
        
        firstbtn.backgroundColor = UIColor(red:147.0/255.0, green:165.0/255.0, blue:165.0/255.0, alpha:1.0)
        
      secondbtn.backgroundColor = UIColor.clear
        thirdbtn.backgroundColor = UIColor.clear
        
       
        enteramounttext.text = "100"
    }
    
    @IBAction func secondbtn_click(_ sender: Any) {
        
        
        secondbtn.backgroundColor = UIColor(red:147.0/255.0, green:165.0/255.0, blue:165.0/255.0, alpha:1.0)
        firstbtn.backgroundColor = UIColor.clear
        thirdbtn.backgroundColor = UIColor.clear
     
        

        
         enteramounttext.text = "200"
    }
    
    @IBAction func thirdbtn_click(_ sender: Any) {
        
        
        thirdbtn.backgroundColor = UIColor(red:147.0/255.0, green:165.0/255.0, blue:165.0/255.0, alpha:1.0)
        
        secondbtn.backgroundColor = UIColor.clear
        firstbtn.backgroundColor = UIColor.clear
        

                 enteramounttext.text = "300"
        
        
    }
    
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        debugPrint("caneceld")
        paymentViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            
            //create Stripe card
            let card: STPCardParams = STPCardParams()
            card.number = info.cardNumber
            card.expMonth = info.expiryMonth
            card.expYear = info.expiryYear
            card.name = info.cardholderName
            card.cvc = info.cvv
            
            
            newGeneratedCardName = info.cardholderName
            newGeneratedCardNumber = info.cardNumber
            newGeneratedCardExpiryMonth = String(info.expiryMonth)
            newGeneratedCardExpiryYear = String(info.expiryYear)
            newGeneratedCardCv = info.cvv
            
            
            //Send to Stripe
            getStripeToken(card: card , resultCode: 0)
            
            
        }
        
        paymentViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    func getStripeToken(card:STPCardParams ,  resultCode: Int ) {
        
        if resultCode == 1
        {
            
            
            // get stripe token for current card
            STPAPIClient.shared().createToken(withCard: card) { token, error in
                if let token = token {
                    debugPrint(token)
                    // SVProgressHUD.showSuccessWithStatus("Stripe token successfully received: \(token)")
                    //  self.placeOrder(token)
                } else {
                    debugPrint(error!)
                    // SVProgressHUD.showErrorWithStatus(error?.localizedDescription)
                }
            }
            
            
            
        }
            
        else
        {
            // get stripe token for current card
            STPAPIClient.shared().createToken(withCard: card) { token, error in
                if let token = token {
                    debugPrint(token)
                    // SVProgressHUD.showSuccessWithStatus("Stripe token successfully received: \(token)")
                    self.saveCard(token: token)
                } else {
                    debugPrint(error!)
                    //  SVProgressHUD.showErrorWithStatus(error?.localizedDescription)
                }
            }
        }
        
        // KVNProgress.dismiss()
        
    }
    
    
    
    // charge money from backend
    func saveCard(token: STPToken) {
        
        debugPrint(token)
        debugPrint(newGeneratedCardName)
        
        let fullExpiry =  self.newGeneratedCardExpiryMonth + "/"  +  self.newGeneratedCardExpiryYear
        debugPrint(fullExpiry)
        let email = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyemail)
        
        let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
        
        
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.SaveCardDetails(UserId: Userid!, UserEmail: email!, StripeToken: String(describing: token))
        
        
            
        
    }
    
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return SIZE
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = carddetailstableview.dequeueReusableCell(withIdentifier: "walletcell", for: indexPath)
        
        
         let cardNumber : UILabel = (cell.contentView.viewWithTag(1) as? UILabel)!
         let expiryDate : UILabel = (cell.contentView.viewWithTag(2) as? UILabel)!
        
        cardNumber.text = "XXXXXXXXXXXX" + carddata.details![indexPath.row].cardNumber!
        expiryDate.text = carddata.details![indexPath.row].cardType
        
        
        return cell
        
    }
    
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        GlobalVarible.CardId = carddata.details![indexPath.row].cardId!
        
              
        enteramountvalue = enteramounttext.text!
        
        if enteramountvalue == "" {
        
            self.showalert(message: "Please enter Amount First".localized)
        
        }else{
        
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.AddMoneyMethod(UserId: Userid!, Amount: enteramountvalue, CardId: GlobalVarible.CardId)
        
        }
        
        
    }
    

    @IBAction func AddMoney_btn(_ sender: Any) {
        
        enteramountvalue = enteramounttext.text!
        
        if enteramountvalue == "" {
            
            self.showalert(message: "Please enter Amount First".localized)
            
        }else{
            
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let walletpaymentoptionviewcontroller = storyBoard.instantiateViewController(withIdentifier: "ACViewController") as! ACViewController
            // walletpaymentoptionviewcontroller.viewcontrollerself = self
            // walletpaymentoptionviewcontroller.modalPresentationStyle = .overCurrentContext
            
            self.present( walletpaymentoptionviewcontroller, animated:true, completion:nil)
            
        }

        
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
        
        
        if(GlobalVarible.Api == "viewcard"){
            
            
            carddata = data as! CardDetailsModel
            
            
            if(carddata.result == 0){
                
                toastLabel.isHidden = false
                SIZE = 0
                self.carddetailstableview.isHidden = true
                
                
            }else{
                
                toastLabel.isHidden = true
                
                SIZE = (carddata.details?.count)!
                self.carddetailstableview.isHidden = false
                carddetailstableview.reloadData()
            }
            
            
        }
        
        if(GlobalVarible.Api == "Savecard"){
            
            savedata = data as! SaveCardModel
            
            if(savedata.result == 0){
                
                self.showalert(message: savedata.msg!)
            }else{
                
                //self.showalert1(message: "Card Details Saved Succesfully")
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.viewcarddetails(UserId: Userid!)
            }
            
            
            
            
        }
        
          if(GlobalVarible.Api == "addmoneymodel"){
            
            addmoneydata = data as! AddMoneyModel
            
            if addmoneydata.result == 1{
                GlobalVarible.addmoneyvalue = 1
            self.dismiss(animated: true, completion: nil)
                
            }else{
                
             self.showalert(message: addmoneydata.msg!)
            }
            
            
            
        }

    }
 
}
