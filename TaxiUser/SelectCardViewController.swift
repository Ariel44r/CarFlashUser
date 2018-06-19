//
//  SelectCardViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 24/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit
import Stripe

class SelectCardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CardIOPaymentViewControllerDelegate,MainCategoryProtocol {
    /// This method will be called if the user cancels the scan. You MUST dismiss paymentViewController.
    /// @param paymentViewController The active CardIOPaymentViewController.
   
    
    
    var savedata : SaveCardModel!
    var carddata : CardDetailsModel!
    var deletedata : DeleteCardModel!
    
    var senderTag = 0
    
    var newGeneratedCardName = ""
    var newGeneratedCardNumber = ""
    var newGeneratedCardExpiryMonth = ""
    var newGeneratedCardExpiryYear = ""
    var newGeneratedCardCv = ""
    
    
    @IBOutlet var lblSelectCreditCard: UILabel!
    
       @IBOutlet var lblManageYourCard: UILabel!
    
    @IBOutlet var btnAddNewCard: UIButton!
    
    
    var Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
    
        
    @IBOutlet weak var tableView: UITableView!
    
    var SIZE = 0
    
    var toastLabel : UILabel!
    
    
    func viewSetup(){
        
        lblManageYourCard.text = "Manage Your Cards".localized
        btnAddNewCard.setTitle("Add New Card".localized, for: UIControlState.normal)
        lblSelectCreditCard.text = "Select Credit Card".localized
        
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        
        self.viewSetup()
        
        toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-300, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.white
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = NSTextAlignment.center;
        self.view.addSubview(toastLabel)
        toastLabel.text =  "No Card Added!!".localized
        
        toastLabel.isHidden = true
        
        
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.viewcarddetails(UserId: Userid!)
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onAddCard(_ sender: Any) {
        
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        cardIOVC?.collectCardholderName = true
        
        present(cardIOVC!, animated: true, completion: nil)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
       return  SIZE
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCardCell") as! SelectCardCell
        
        cell.deleteButton.tag = indexPath.row
        //  cell.payButton.tag = indexPath.row
        
        cell.deleteButton.addTarget(self, action: #selector(onDeleteCard), for: UIControlEvents.touchUpInside)
        // cell.payButton.addTarget(self, action: #selector(onPay(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        cell.cardNumber.text = "XXXXXXXXXXXX" + carddata.details![indexPath.row].cardNumber!
        cell.expiryDate.text = carddata.details![indexPath.row].cardType

        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        debugPrint(indexPath.row)
        
        GlobalVarible.MatchCardSelect = 1
        
        GlobalVarible.CardId = carddata.details![indexPath.row].cardId!
        
        self.dismiss(animated: true, completion: nil)
        
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
        
        
        /*  let userId =  parsedData.loginData!.userDetails!.userId!
         let userEmail =  parsedData.loginData!.userDetails!.email!
         
         
         
         
         let parameters = [saveCardsUrlUserId: userId , saveCardsUrlName: self.newGeneratedCardName , saveCardsUrlCardNo: self.newGeneratedCardNumber , saveCardsUrlExpiry: fullExpiry, saveCardsUrlEmail: userEmail ,  saveCardsUrlToken: String(token) ]
         
         ApiController.sharedInstance.parsDataMultipart(saveCardsUrl, parameters: parameters, reseltCode: 18)*/
        
        
        
    }
    
    
    
    
    
    
    func onDeleteCard(sender: UIButton ) {
        
        debugPrint("delete")
        
        self.senderTag = sender.tag
        
        
        
        let alert = UIAlertController(title: "Delete Card".localized, message: "Are you sure want to delete this card ?".localized, preferredStyle: UIAlertControllerStyle.alert)
        
        self.present(alert, animated: true, completion: nil)
        
        
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: { (action: UIAlertAction!) in
            
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.DeleteCard(CardId: self.carddata.details![sender.tag].cardId!)
            
            //  ApiController.sharedInstance.parsDataSimple(deleteCardUrl + parsedData.viewCards!.response!.message![sender.tag].cardId!, reseltCode: 19)
            
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: { (action: UIAlertAction!) in
            
            
        }))
        
        
        
        
        
    }
    
    func onPay(sender: UIButton ) {
        
        
        self.senderTag = sender.tag
        
        debugPrint("pay")
        
       // let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        
      //  let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! SelectCardCell
        
        
        
        
        
    }
    
    
    func showalert(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:  "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                
            }
            
            
        })
        
    }
    
    
    func showalert1(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:  "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.viewcarddetails(UserId: self.Userid!)
                
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
                self.tableView.isHidden = true
                
                
            }else{
                
                toastLabel.isHidden = true
                
                SIZE = (carddata.details?.count)!
                self.tableView.isHidden = false
                tableView.reloadData()
            }
            
            
        }
        
        if(GlobalVarible.Api == "Savecard"){
            
            savedata = data as! SaveCardModel
            
            if(savedata.result == 0){
                
                self.showalert(message: savedata.msg!)
            }else{
                
                self.showalert1(message: savedata.msg!)
                
            }
            
            
            
            
        }
        
        
        if(GlobalVarible.Api == "deletecard")
        {
            
            deletedata = data as! DeleteCardModel
            
            if(deletedata.result == 0){
                
                self.showalert(message: deletedata.msg!)
            }else{
                
                self.showalert1(message: deletedata.msg!)
                
            }
            
            
            
            
            
        }
        
        

    }


   

}
