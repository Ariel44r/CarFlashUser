//
//  Northeast.swift
//
//  Created by AppOrio on 31/05/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Northeast: NSObject {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kNortheastLatKey: String = "lat"
	internal let kNortheastLngKey: String = "lng"


    // MARK: Properties
	public var lat: Float?
	public var lng: Float?


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
		lat = json[kNortheastLatKey].float
		lng = json[kNortheastLngKey].float

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if lat != nil {
			dictionary.updateValue(lat!, forKey: kNortheastLatKey)
		}
		if lng != nil {
			dictionary.updateValue(lng!, forKey: kNortheastLngKey)
		}

        return dictionary
    }

}
