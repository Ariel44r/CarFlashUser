//
//  BookYourRentalViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 28/06/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit

class BookYourRentalViewController: UIViewController {
    
    //MARK: Instances
    var  rentaldata : RentalModel!
    let imageUrl = API_URL.imagedomain
    
    //MARK: Outlets
    @IBOutlet weak var rentalstextlabel: UILabel!
    @IBOutlet weak var textviewdescription: UITextView!
    //@IBOutlet weak var carmodelcitytextlabel: UILabel!
    //@IBOutlet weak var nowrentcabtextlabel: UILabel!
    //@IBOutlet weak var miniprimetextlabel: UILabel!
    @IBOutlet weak var bookyourrentalbtntext: UIButton!
    @IBOutlet weak var carimage: UIImageView!
    @IBOutlet weak var innerview: UIView!
    @IBOutlet weak var mainview: UIView!

    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rentalstextlabel.text = "RENTALS".localized
      //  miniprimetextlabel.text = "Mini, Prime, Sedan,Luxury and other categories".localized
      //  nowrentcabtextlabel.text = "Now Rent cab from your app for local tours. Choose an hourly package and travel all day!".localized
      //  carmodelcitytextlabel.text = "Car models are city specific.".localized
        bookyourrentalbtntext.setTitle("Book YOUR RENTAL".localized, for: UIControlState.normal)
        innerview.layer.cornerRadius = 5
        innerview.clipsToBounds = true
        textviewdescription.text = rentaldata.description1
        let newString =  GlobalVarible.cartypeimage
        let url = imageUrl + newString
        let url1 = NSURL(string: url)
        carimage!.af_setImage(withURL: url1! as URL,
            placeholderImage: UIImage(named: "dress"),
            filter: nil,
            imageTransition: .crossDissolve(1.0)
        
        )
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
      //  let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        
       // let tapGestureRecognizer = UITapGestureRecognizer(target(forAction: self.onTap(), withSender: <#T##Any?#>))
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(BookYourRentalViewController.viewTapped(_:)))
      //  mainview.addGestureRecognizer(gesture)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   /* func onTap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }*/
    
    //MARK: Actions & Methods
    @IBAction func viewclickbackbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func bookyourrentalbtn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let selectpackageviewcontroller = storyBoard.instantiateViewController(withIdentifier: "SelectPackageViewController") as! SelectPackageViewController
        // bookrentalviewcontroller.viewcontrollerself = self
        selectpackageviewcontroller.rentaldata = self.rentaldata
        selectpackageviewcontroller.modalPresentationStyle = .overCurrentContext
        self.present(selectpackageviewcontroller, animated:true, completion:nil)
       
    }
}