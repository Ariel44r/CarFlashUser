//
//  ApiManager.swift
//  TaxiApp
//
//  Created by AppOrio on 22/08/16.
//  Copyright © 2016 apporio. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


protocol MainCategoryProtocol {
    func onProgressStatus(value : Int)
    func onerror(msg : String)
    func onSuccessExecution (msg : String)
    func onSuccessParse(data : AnyObject)
     //func SendingBugFinderLog(url: String, response: Any, requestparam: Any)

}


class ApiManager{
      
    var protocolmain_Catagory : MainCategoryProtocol! = nil
    static let sharedInstance = ApiManager()

    func getcoupons(CouponCode: String,USERID: String) {
        let url = (API_URL.getcoupon + "\(CouponCode)&user_id=\(USERID)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        debugPrint(url)
        Alamofire.request(url, method: .get, parameters: nil)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                       // self.protocolmain_Catagory.SendingBugFinderLog(url: url, response: responsedata, requestparam: "No Parameter")
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = Coupons(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                   // self.protocolmain_Catagory.SendingBugFinderLog(url: url, response: error, requestparam: "No Parameter")
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }   
    }
   // http://apporio.co.uk/apporiotaxi/api/car_type.php?city_id=1

    func viewcars(UserCityName: String) {
        let url = (API_URL.Viewcars + "\(UserCityName)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "getcartype"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = CarType(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }              
    }
    
    func viewwalletmoney(UserId: String) {
        let url = (API_URL.showwalletmoney + "\(UserId)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        debugPrint(url)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "walletmoneyresponse"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = ShowWalletMoneyModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }    
    }
    
    func changeDrop(droplat: String , droplong: String , droplocation : String,  rideid : String){           
        let dic: [String: Any] = [
            "drop_lat":droplat,
            "drop_long":droplong,
            "drop_location":droplocation,
            "app_id":"1",
            "ride_id":rideid,
            "language_code":GlobalVarible.languagecode
                   
        ]
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.changedropLoc, method: .post, parameters: dic)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
                
            }
            .validate { request, response, data in
                return .success

            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "Dropchange"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = DropChange(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func ViewCarsWithTime(UserCityName: String, USERLAT: String, USERLNG: String){    
        let dic = [
            "city_name":UserCityName,
            "latitude":USERLAT,
            "longitude":USERLNG,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        Alamofire.request(API_URL.viewcarswithtime, method: .post, parameters: dic)    
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")

            }
            .validate { request, response, data in
                return .success

            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    //self.protocolmain_Catagory.onProgressStatus(value: 0)
                    //self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "CarsTimeModel"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = CarsTImeModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }
    }
    
    func CityList(){
        let url = (API_URL.ViewCity + "\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "cityname"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = CityName(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }    
    }
    
    

    
    

    

    

    
    func AboutUs(){
        let url = (API_URL.Aboutus + "\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = TermsModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):                  
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }

    func CustomerSupportApi(UserId: String,Name: String,Email: String,Phone: String,Query: String){   
        let dic = [
            "name":Name,
            "driver_id":"",
            "user_id":UserId,
            "email":Email,
            "phone":Phone,
            "query":Query,
            "application":"1",
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.customersupport, method: .post, parameters: dic)
            .responseJSON { response in
            switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = CustomerSupportModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):                    
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

            }
        }
    }
    

    
    
    func TermsConditions(){   
        let url = (API_URL.TermsAndConditions + "\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)    
        Alamofire.request(url, method: .get, parameters: nil)
           /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = TermsModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }
    }
    
    
    func RateCard(City: String , CarTypeId: String) {
        let url = (API_URL.ratecard + "\(City)&car_type_id=\(CarTypeId)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        debugPrint(url)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "ratecard"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = RateCardModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }
    }
    
    func RideEstimatedScreen(Distance: String,CITYID: String,CARTYPEId: String,RideTime: String){    
        let dic: [String: Any] = [
            "distance":Distance,
            "city_id":CITYID,
            "car_type_id":CARTYPEId,
            "pickup_lat":GlobalVarible.PickUpLat,
            "pickup_long":GlobalVarible.PickUpLng,
            "ride_time":RideTime,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode

        ]
        debugPrint(dic)
        Alamofire.request(API_URL.rideestimate, method: .get, parameters: dic)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
                
            }
            .validate { request, response, data in
                return .success

            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                   //  self.protocolmain_Catagory.onProgressStatus(value: 0)
                       self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "rideestimateresponse"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = RideEstimate(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func ConfirmRide(USERID: String,COUPONCODE: String,USERCURRENTLAT: String,USERCURRENTLONG: String,CURRENTADDRESS: String,DROPLAT: String,DROPLNG: String,DropLOCATION: String,RIDETYPE: String,RIDESTATUS: String,CARTYPEID: String,PaymentOPtionId: String,CardId: String){    
      //  let url = (API_URL.RideNow + "\(USERID)&coupons_code=\(COUPONCODE)&pickup_lat=\(USERCURRENTLAT)&pickup_long=\(USERCURRENTLONG)&pickup_location=\(CURRENTADDRESS)&drop_lat=\(DROPLAT)&drop_long=\(DROPLNG)&drop_location=\(DropLOCATION)&ride_type=\(RIDETYPE)&ride_status=\(RIDESTATUS)&car_type_id=\(CARTYPEID)&payment_option_id=\(PaymentOPtionId)&card_id=\(CardId)&language_id=\(GlobalVarible.languageid)")
        debugPrint(GlobalVarible.CouponCode)
        let dic: [String: Any] = [
            "user_id":USERID,
            "coupon_code":COUPONCODE,
            "pickup_lat":USERCURRENTLAT,
            "pickup_long":USERCURRENTLONG,
            "pickup_location":CURRENTADDRESS,
            "drop_lat":DROPLAT,
            "drop_long":DROPLNG,
            "drop_location":DropLOCATION,
            "ride_type":RIDETYPE,
            "ride_status":RIDESTATUS,
            "car_type_id":CARTYPEID,
            "payment_option_id":PaymentOPtionId,
            "card_id":CardId,
            "pem_file":GlobalVarible.pemfilevaule,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode       
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1
             Alamofire.request(API_URL.RideNow, method: .get, parameters: dic)
               .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "confirmridebook"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = ConfirmRideModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func RideLaterConfirm(USERID: String,COUPONCODE: String,USERCURRENTLAT: String,USERCURRENTLONG: String,CURRENTADDRESS: String,DROPLAT: String,DROPLNG: String,DropLOCATION: String,SELECTTIME: String,SELECTDATE: String,RIDETYPE: String,RIDESTATUS: String,CARTYPEID: String,PaymentOPtionId: String,CardId: String) {
        let dic: [String: Any] = [
            "user_id":USERID,
            "coupons_code":COUPONCODE,
            "pickup_lat":USERCURRENTLAT,
            "pickup_long":USERCURRENTLONG,
            "pickup_location":CURRENTADDRESS,
            "drop_lat":DROPLAT,
            "drop_long":DROPLNG,
            "drop_location":DropLOCATION,
            "later_date":SELECTDATE,
            "later_time":SELECTTIME,
            "ride_type":RIDETYPE,
            "ride_status":RIDESTATUS,
            "car_type_id":CARTYPEID,
            "payment_option_id":PaymentOPtionId,
            "card_id":CardId,
            "pem_file":GlobalVarible.pemfilevaule,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.RideLater, method: .get, parameters: dic)
            //  Alamofire.request(API_URL.RideLater, method: .get, parameters: dic)
                .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "RideLaterBook"
                        debugPrint(responsedata)
                        //  let dataToParse = JSON(responsedata)
                        // let  ParsedData = ConfirmRideModel(json: dataToParse)    
                        self.protocolmain_Catagory.onSuccessParse(data: responsedata as AnyObject)

                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func RentalUserCancel(RentalBookindId: String,UserId: String){    
        let dic: [String: Any] = [
            "rental_booking_id":RentalBookindId,
            "user_id":UserId,
            "cancel_reason_id":GlobalVarible.cancelId,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.rentalusercancel, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value{
                        GlobalVarible.Api = "rentalCancelbyuser"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = RentalRideCancelModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func CancelRide(RIDEID: String,RIDESTATUS: String){    
        let url = (API_URL.Cancelbyuser + "\(RIDEID)&ride_status=\(RIDESTATUS)&reason_id=\(GlobalVarible.cancelId)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "Cancelbyuser"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = BookingCancelled(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func uploadRequest(parameters: [String: String] , driverImage: UIImage) {
        let URL = API_URL.EditProfile
        //  let  URL = API_URL.EditProfile + "&language_id=\(GlobalVarible.languageid)"
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if  let imageData = UIImageJPEGRepresentation(driverImage, 0.5) {
                multipartFormData.append(imageData, withName: "user_image", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                
            }
            for (key, value) in parameters {   
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                
            }
        }, to: URL) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    debugPrint("Upload Progress: \(Progress.fractionCompleted)")

                })
                upload.responseJSON { response in  
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    debugPrint(response.result)
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "editprofile"
                        let dataToParse = JSON(responsedata)
                        debugPrint(responsedata)
                        let  ParsedData = SignupLoginResponse(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                }
            case.failure(let error):
                self.protocolmain_Catagory.onProgressStatus(value: 0)
                self.protocolmain_Catagory.onerror(msg: error.localizedDescription)            }
        }
    }
    
    func UserDeviceId(USERID: String,USERDEVICEID: String,FLAG: String,UNIQUEID: String){    
        let dic: [String: Any] = [
            "user_id":USERID,
            "device_id":USERDEVICEID,
            "flag":FLAG,
            "unique_id":UNIQUEID,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
        
        ]
        debugPrint(dic)
        Alamofire.request(API_URL.DeviceId, method: .get, parameters: dic)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")

            }
            .validate { request, response, data in
                return .success

            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func EmergencyContactUrl() {
        let url = (API_URL.emergencycontacturl + "?language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        debugPrint(url)
        Alamofire.request(url, method: .get, parameters: nil)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    //  self.delegate.onProgressState(1)
                    
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = EmergencyResponseModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }

    func EmergencyContactMessageUrl(RideId: String,DriverId: String,UserId: String,SOSNUMBER: String,Latitude: String,Longitude: String) {
        let dic: [String: Any] = [
            "ride_id":RideId,
            "driver_id":DriverId,
            "user_id":UserId,
            "sos_number":SOSNUMBER,
            "latitude":Latitude,
            "longitude":Longitude,
            "application":"1",
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        Alamofire.request(API_URL.emergencycontactmessage, method: .post, parameters: dic)   
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    //  self.delegate.onProgressState(1)
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                       // self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                   // self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }

    func DriverInformation(RIDEID: String) {
        let url = (API_URL.driverdetails + "\(RIDEID)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        // self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                 //   self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "DriverInformation"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = DriverInfo(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                 //   self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func ViewDoneRide(RIDEID: String){    
        let url = (API_URL.viewdonerideinfo + "\(RIDEID)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        debugPrint(url)
        Alamofire.request(url, method: .get, parameters: nil)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "DoneRideInformation"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = DoneRideModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func RatingSubmitbtn(UserId: String , DriverId: String , RatingStar: String , RideId: String,Comment: String){    
        
        let url = (API_URL.userrating + "\(UserId)&driver_id=\(DriverId)&rating_star=\(RatingStar)&comment=\(Comment)&ride_id=\(RideId)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        let escapedString = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(escapedString!, method: .get, parameters: nil)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "NormalRating"
                        debugPrint(responsedata)
                        //let dataToParse = JSON(responsedata)
                        //let  ParsedData = CompletePayment(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: responsedata as AnyObject)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }    
    }
    
    func ConfirmPayment(OrderId: String, UserId: String, PaymentId: String,PaymentMethod: String,PaymentPlatform: String, PaymentAmount: String, PaymentDate: String, PaymentStatus: String){
        let dic: [String: Any] = [
            "order_id":OrderId,
            "user_id":UserId,
            "payment_id":PaymentId,
            "payment_method":PaymentMethod,
            "payment_platform":PaymentPlatform,
            "payment_amount":PaymentAmount,
            "payment_date_time":PaymentDate,
            "payment_status":PaymentStatus,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        //let url = (API_URL.confirmpayment + "\(OrderId)&user_id=\(UserId)&payment_id=\(PaymentId)&payment_method=\(PaymentMethod)&payment_platform=\(PaymentPlatform)&payment_amount=\(PaymentAmount)&payment_date_time=\(PaymentDate)&payment_status=\(PaymentStatus)&language_id=\(GlobalVarible.languageid)")
        //let escapedString = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        //debugPrint(escapedString!)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.confirmpayment, method: .get, parameters: dic)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "CONFIRMPAYMENT"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = CompletePayment(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }

    func FindDistance(){    
   // key=&origins=28.4101574783944,77.0476813986897&destinations=28.4121763232743,77.0432902872562&language=en-EN
        let pickuplng = Double(GlobalVarible.PickUpLng)!
        let pickuplat = Double(GlobalVarible.PickUpLat)!
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?key=\("AIzaSyDdN4fqXPnnGWuCs2d5ncpDBnGgKfDo1fM")&origins=\(pickuplat),\(pickuplng)&destinations=\(GlobalVarible.UserDropLat),\(GlobalVarible.UserDropLng)&language=\("en-EN")"
        Alamofire.request(url, method: .post, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                  //  self.protocolmain_Catagory.onProgressStatus(value: 0)
                   // self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "distancetype"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = DistanceModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):                   
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func FindDirectionlatlng(pickLat: Double,pickLng: Double, DropLat : Double,DropLng: Double){    
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(pickLat),\(pickLng)&destination=\(DropLat),\(DropLng)"
        debugPrint(url)
        Alamofire.request(url, method: .post, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                  //  self.protocolmain_Catagory.onProgressStatus(value: 0)
                   // self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "directionapiresult"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = NewGoogleDistanceModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }
    }

    func logoutUser(dictonary: NSDictionary , url: String) {
        protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .post, parameters: dictonary as? [String : AnyObject])
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "userlogout"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = LogOutModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }

    func reasonCancel(){        
        let url = (API_URL.cancelreasonuser + "\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "cancelreason"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = ReasonModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }        
    }
    
    func Mailinvoice(DoneRideId: String,UserEmail: String){    
        let url = (API_URL.sendinvoice + "\(DoneRideId)&user_email=\(UserEmail)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        let escapedString = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(escapedString!, method: .get, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "mailinvoice"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = MailInvoiceModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }    
    }
    
    func SaveCardDetails(UserId: String , UserEmail: String , StripeToken : String){    
        let url = (API_URL.savecard + "\(UserId)&user_email=\(UserEmail)&stripe_token=\(StripeToken)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "Savecard"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = SaveCardModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func viewcarddetails(UserId: String){    
        let url = (API_URL.viewcard + "\(UserId)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "viewcard"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = CardDetailsModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func AddMoneyMethod(UserId: String,Amount: String,CardId: String){    
        let url = (API_URL.addmoneyurl + "\(Amount)&user_id=\(UserId)&card_id=\(CardId)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        debugPrint(url)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "addmoneymodel"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = AddMoneyModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }
    }

    func DeleteCard(CardId : String){        
        let url = (API_URL.deletecard + "\(CardId)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "deletecard"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = DeleteCardModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):                   
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }    
    }
    
    func PayPaymentCard(RideId: String,Amount: String){    
        let url = (API_URL.paycard + "\(RideId)&amount=\(Amount)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                         GlobalVarible.Api = "paycard"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = PayCardModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }    
    }
    
    func ViewPaymentOption(UserId: String){
        let url = (API_URL.viewpaymentoption + "\(UserId)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = ViewPaymentModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }    
    }
    
    func CancelRide60Sec(RideID: String,Auto: String,RideMode: String){    
        let url = (API_URL.cancelride60sec + "\(RideID)&auto=\(Auto)&ride_mode=\(RideMode)&language_code=\(GlobalVarible.languagecode)")
        debugPrint(url)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "usersyncwhenappterminate"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = CustomerSyncModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):                  
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }

  //  http://apporioinfolabs.com/apporiotaxi/api/user_sync.php?user_id=

    func UserSyncWhenAppTerminate(UserId: String){        
        let url = (API_URL.usersyncwhenappterminate + "\(UserId)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        debugPrint(url)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "usersyncwhenappterminate"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = CustomerSyncModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func customerSync1(RideId: String,UserId: String){        
        let url = (API_URL.customersync + "\(RideId)&user_id=\(UserId)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "customersync" 
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = CustomerSyncModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                
                }
            }
    }
    
    func customerSyncEnd(RideId: String,UserId: String){    
        let url = (API_URL.customersyncend + "\(RideId)&user_id=\(UserId)&language_id=\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .get, parameters: nil)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                       GlobalVarible.Api = "customersyncend" 
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = CustomerSyncModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):                   
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func postData(dictonary: NSDictionary , url: String) {
        protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .post, parameters: dictonary as? [String : AnyObject])
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = SignupLoginResponse(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                   
                }
            }
    }
    
    func postData1(dictonary: NSDictionary , url: String) {
        protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(url, method: .post, parameters: dictonary as? [String : AnyObject])
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = NewChangePassword(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func SelectRentalCar(CityID: String){    
        let dic: [String: Any] = [
            "city_id":CityID,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
        ]
        debugPrint(dic)
        Alamofire.request(API_URL.viewrentaldata, method: .post, parameters: dic)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    // self.protocolmain_Catagory.onProgressStatus(value: 0)
                    //   self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "RentalModel"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = RentalModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func RentalBookRide(USERID: String,USERCURRENTLAT: String,USERCURRENTLONG: String,CURRENTADDRESS: String,CARTYPEID: String,RentCardId: String,COUPONCODE: String,PaymentOPtionId: String){    
        let dic: [String: Any] = [
            "user_id":USERID,
            "booking_type":"1",
            "pickup_lat":USERCURRENTLAT,
            "pickup_long":USERCURRENTLONG,
            "pickup_location":CURRENTADDRESS,
            "car_type_id":CARTYPEID,
            "rentcard_id":RentCardId,
            "coupan_code":COUPONCODE,
            "payment_option_id":PaymentOPtionId,
            "pem_file":GlobalVarible.pemfilevaule,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
                
        ] 
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.bookriderental, method: .post, parameters: dic)
            //    Alamofire.request(url, method: .post, parameters: nil)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "rentalconfirmridebook"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = RentalBookModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func RentalBookRideLater(USERID: String,USERCURRENTLAT: String,USERCURRENTLONG: String,CURRENTADDRESS: String,CARTYPEID: String,RentCardId: String,SELECTTIME: String,SELECTDATE: String,COUPONCODE: String,PaymentOPtionId: String){    
        let dic: [String: Any] = [
            "user_id":USERID,
            "booking_type":"2",
            "pickup_lat":USERCURRENTLAT,
            "pickup_long":USERCURRENTLONG,
            "pickup_location":CURRENTADDRESS,
            "car_type_id":CARTYPEID,
            "rentcard_id":RentCardId,
            "booking_date":SELECTDATE,
            "booking_time":SELECTTIME,
            "coupan_code":COUPONCODE,
            "payment_option_id":PaymentOPtionId,
            "pem_file":GlobalVarible.pemfilevaule,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.bookriderental, method: .post, parameters: dic)
            //    Alamofire.request(url, method: .post, parameters: nil)
            /* .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
             //debugPrint("Progress: \(progress.fractionCompleted)")
             }
             .validate { request, response, data in
             return .success
             }*/
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "rentalconfirmridebooklater"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = RentalBookLaterModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }    
    }
    
    func RentalUserSync(BookindId: String){    
        let dic: [String: Any] = [
            "rental_booking_id":BookindId,
            "app_id":"1",
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.rentalridesync, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "rentalridesync"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        debugPrint(dataToParse)
                        let  ParsedData = RentalRideSyncModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func RentalCancelReason(){    
        let dic: [String: Any] = [
            "app_id":"1",
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.rentalcancelreason, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "rentalcancelreason"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        debugPrint(dataToParse)
                        let  ParsedData = RentalCancelReasonModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):                    
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func ShowAllRides(UserId: String){
        let dic: [String: Any] = [
            "user_id":UserId,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.viewrides, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = AllRides(json: dataToParse)
                        GlobalVarible.RideResult = ParsedData.status!
                        debugPrint(GlobalVarible.RideResult)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func ShowAllRidesLater(UserId: String){    
        let dic: [String: Any] = [
            "user_id":UserId,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.viewrideslater, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = AllRides(json: dataToParse)
                        GlobalVarible.RideResult = ParsedData.status!
                        debugPrint(GlobalVarible.RideResult)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }

    func ShowAllNotification(UserId: String){        
        let dic: [String: Any] = [
            "application":"1",
            "id":UserId,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.NotificationUrl, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = NotificationModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }

    func RentalviewRideInfo(BookingId: String,RideMode: String) {
        let dic: [String: Any] = [
            "ride_mode":RideMode,
            "booking_id":BookingId,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.RentalViewRideInfo, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "rentalviewrideinfo"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = RentalViewRideInfoModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):                    
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func RideShareDetails(RideId: String) {
        let dic: [String: Any] = [
            "ride_id":RideId,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.RideShareUrl, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value { 
                        GlobalVarible.Api = "rentalshareurl"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = RideShareModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func NormalviewRideInfo(BookingId: String,RideMode: String) {
        let dic: [String: Any] = [
            "ride_mode":RideMode,
            "booking_id":BookingId,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.RentalViewRideInfo, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "normalviewrideinfo"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = NormalViewRideInfoModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func RentalPaymentUrl(RentalBookindId: String,TotalAmount: String,PaymentStatus: String){    
        let dic: [String: Any] = [
            "rental_booking_id":RentalBookindId,
            "amount_paid":TotalAmount,
            "payment_status":PaymentStatus,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.rentalpayment, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "rentalpayment" 
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        debugPrint(dataToParse)
                        let  ParsedData = RentalPaymentmodel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }    
    }

    func RentalRideFare(RentalBookindId: String){        
        let dic: [String: Any] = [
            "rental_booking_id":RentalBookindId,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.Rentalridefareinfo, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "rentalridefare"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        debugPrint(dataToParse)
                        let  ParsedData = RentalRideFareModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):                   
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }     
    }
    
    func RentalDriverInformation(RentalBookindId: String){    
        let dic: [String: Any] = [
            "rental_booking_id":RentalBookindId,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.Rentaltrackridefareinfo, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "rentaldriverinfomation"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        debugPrint(dataToParse)
                        let  ParsedData = RentalDriverInformationModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):                    
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func RentalRatingApi(RentalBookindId: String,RatingValue: String,DriverId: String,UserId: String,Comment: String){    
        let dic: [String: Any] = [
            "rental_booking_id":RentalBookindId,
            "rating_star":RatingValue,
            "comment":Comment,
            "user_id":UserId,
            "driver_id":DriverId,
            "app_id":"1",
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.Rentalratinginfo, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "rentalratecustomer"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        debugPrint(dataToParse)
                        let  ParsedData = RentalRateCustomerModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func GetOtpMethod(Phone: String) {
        let dic: [String: Any] = [
            "phone":Phone,
            "flag":"1",
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.getotpurl, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "CheckOtpModel"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = CheckOtpModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                        
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                }
            }
    }

    func ForgotGetOtpMethod(Phone: String) {
        // http://apporio.org/YoTaxi/api/otp_sent.php
        let dic: [String: Any] = [
            "phone":Phone,
            "flag":"1",
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.forgetotpurl, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "ForgotCheckOtpModel"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = ForgotCheckOtpModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):                    
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }    
    }
    
    func ChangeUserPassword(Phone: String,Password: String) {
        let dic: [String: Any] = [
            "user_phone":Phone,
            "password":Password,
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.forgotuserpassword, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = NewChangePassword(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)

                    }
                case.failure(let error):                    
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                    
                }
            }
    }
    
    func AppUdateMethod(ApplicationVersion: String) {
        let dic: [String: Any] = [
            "application_version":ApplicationVersion,
            "flag":"1",
            "application":"1",
            "language_id":GlobalVarible.languageid,
            "language_code":GlobalVarible.languagecode
            
        ]
        debugPrint(dic)
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        Alamofire.request(API_URL.appupdate, method: .post, parameters: dic)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "appupdateData"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = AppUpdateModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                    }
                case.failure(let error):
                    
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)

                }
            }
    }
    
    func ReportIssueMethod() {
        let url = (API_URL.reportissueurl + "\(GlobalVarible.languageid)&language_code=\(GlobalVarible.languagecode)")
        self.protocolmain_Catagory.onProgressStatus(value: 1)
        debugPrint(url)
        Alamofire.request(url, method: .get, parameters: nil)
            .responseJSON { response in
                switch response.result {
                case.success( _):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onSuccessExecution(msg: "API is succesfully Executed")
                    if let responsedata = response.result.value {
                        GlobalVarible.Api = "reportissue"
                        debugPrint(responsedata)
                        let dataToParse = JSON(responsedata)
                        let  ParsedData = ReportIssueModel(json: dataToParse)
                        self.protocolmain_Catagory.onSuccessParse(data: ParsedData)
                    }
                case.failure(let error):
                    self.protocolmain_Catagory.onProgressStatus(value: 0)
                    self.protocolmain_Catagory.onerror(msg: error.localizedDescription)
                }
            }
    }
}
