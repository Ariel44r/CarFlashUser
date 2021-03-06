//
//  RideEstimate.swift
//
//  Created by AppOrio on 20/12/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class RideEstimate: NSObject {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kRideEstimateResultKey: String = "result"
	internal let kRideEstimateMsgKey: String = "msg"
    internal let kEstimateTimeKey: String = "estimatetime"


    // MARK: Properties
	public var result: Int?
	public var msg: String?
    public var estimatetime: String?


    // MARK: SwiftyJSON Initalizers
    /**
    Initates the class based on the object
    - parameter object: The object of either Dictionary or Array kind that was passed.
    - returns: An initalized instance of the class.
    */
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }

    /**
    Initates the class based on the JSON that was passed.
    - parameter json: JSON object from SwiftyJSON.
    - returns: An initalized instance of the class.
    */
    public init(json: JSON) {
		result = json[kRideEstimateResultKey].int
		msg = json[kRideEstimateMsgKey].string
        estimatetime = json[kEstimateTimeKey].string

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if result != nil {
			dictionary.updateValue(result! as AnyObject, forKey: kRideEstimateResultKey)
		}
		if msg != nil {
			dictionary.updateValue(msg! as AnyObject, forKey: kRideEstimateMsgKey)
		}
        if estimatetime != nil {
            dictionary.updateValue(estimatetime! as AnyObject, forKey: kEstimateTimeKey)
        }

        return dictionary
    }

}
