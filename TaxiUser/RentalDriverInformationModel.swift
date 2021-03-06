//
//  RentalDriverInformationModel.swift
//
//  Created by AppOrio on 18/07/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class RentalDriverInformationModel: NSObject {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kRentalDriverInformationModelStatusKey: String = "status"
	internal let kRentalDriverInformationModelMessageKey: String = "message"
	internal let kRentalDriverInformationModelDetailsKey: String = "details"


    // MARK: Properties
	public var status: Int?
	public var message: String?
	public var details: RentalDriverInformationDetails?


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
		status = json[kRentalDriverInformationModelStatusKey].int
		message = json[kRentalDriverInformationModelMessageKey].string
		details = RentalDriverInformationDetails(json: json[kRentalDriverInformationModelDetailsKey])

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if status != nil {
			dictionary.updateValue(status! as AnyObject, forKey: kRentalDriverInformationModelStatusKey)
		}
		if message != nil {
			dictionary.updateValue(message! as AnyObject, forKey: kRentalDriverInformationModelMessageKey)
		}
		if details != nil {
			dictionary.updateValue(details!.dictionaryRepresentation() as AnyObject, forKey: kRentalDriverInformationModelDetailsKey)
		}

        return dictionary
    }

}
