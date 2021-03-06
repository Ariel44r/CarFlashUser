//
//  NotificationModel.swift
//
//  Created by AppOrio on 04/09/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class NotificationModel: NSObject {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kNotificationModelStatusKey: String = "status"
	internal let kNotificationModelMessageKey: String = "message"
	internal let kNotificationModelDetailsKey: String = "details"


    // MARK: Properties
	public var status: Int?
	public var message: String?
	public var details: [NotificationDetails]?


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
		status = json[kNotificationModelStatusKey].int
		message = json[kNotificationModelMessageKey].string
		details = []
		if let items = json[kNotificationModelDetailsKey].array {
			for item in items {
				details?.append(NotificationDetails(json: item))
			}
		} else {
			details = nil
		}

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if status != nil {
			dictionary.updateValue(status! as AnyObject, forKey: kNotificationModelStatusKey)
		}
		if message != nil {
			dictionary.updateValue(message! as AnyObject, forKey: kNotificationModelMessageKey)
		}
		if (details?.count)! > 0 {
			var temp: [AnyObject] = []
			for item in details! {
				temp.append(item.dictionaryRepresentation() as AnyObject)
			}
			dictionary.updateValue(temp as AnyObject, forKey: kNotificationModelDetailsKey)
		}

        return dictionary
    }

}
