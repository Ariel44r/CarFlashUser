//
//  Details.swift
//
//  Created by Atul Jain on 21/12/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class AppUpdateDetails {

  // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let androidUserMaintenanceMode = "android_user_maintenance_mode"
        static let androidDriverMandantoryUpdate = "android_driver_mandantory_update"
        static let iosUserMaintenanceMode = "ios_user_maintenance_mode"
        static let androidDriverCurrentVersion = "android_driver_current_version"
        static let iosDriverMandantoryUpdate = "ios_driver_mandantory_update"
        static let iosUserCurrentVersion = "ios_user_current_version"
        static let androidUserCurrentVersion = "android_user_current_version"
        static let iosUserMandantoryUpdate = "ios_user_mandantory_update"
        static let androidUserMandantoryUpdate = "android_user_mandantory_update"
        static let androidDriverMaintenanceMode = "android_driver_maintenance_mode"
        static let iosDriverCurrentVersion = "ios_driver_current_version"
        static let applicationVersionId = "application_version_id"
        static let iosDriverMaintenanceMode = "ios_driver_maintenance_mode"
    }
    
    // MARK: Properties
    public var androidUserMaintenanceMode: String?
    public var androidDriverMandantoryUpdate: String?
    public var iosUserMaintenanceMode: String?
    public var androidDriverCurrentVersion: String?
    public var iosDriverMandantoryUpdate: String?
    public var iosUserCurrentVersion: String?
    public var androidUserCurrentVersion: String?
    public var iosUserMandantoryUpdate: String?
    public var androidUserMandantoryUpdate: String?
    public var androidDriverMaintenanceMode: String?
    public var iosDriverCurrentVersion: String?
    public var applicationVersionId: String?
    public var iosDriverMaintenanceMode: String?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        androidUserMaintenanceMode = json[SerializationKeys.androidUserMaintenanceMode].string
        androidDriverMandantoryUpdate = json[SerializationKeys.androidDriverMandantoryUpdate].string
        iosUserMaintenanceMode = json[SerializationKeys.iosUserMaintenanceMode].string
        androidDriverCurrentVersion = json[SerializationKeys.androidDriverCurrentVersion].string
        iosDriverMandantoryUpdate = json[SerializationKeys.iosDriverMandantoryUpdate].string
        iosUserCurrentVersion = json[SerializationKeys.iosUserCurrentVersion].string
        androidUserCurrentVersion = json[SerializationKeys.androidUserCurrentVersion].string
        iosUserMandantoryUpdate = json[SerializationKeys.iosUserMandantoryUpdate].string
        androidUserMandantoryUpdate = json[SerializationKeys.androidUserMandantoryUpdate].string
        androidDriverMaintenanceMode = json[SerializationKeys.androidDriverMaintenanceMode].string
        iosDriverCurrentVersion = json[SerializationKeys.iosDriverCurrentVersion].string
        applicationVersionId = json[SerializationKeys.applicationVersionId].string
        iosDriverMaintenanceMode = json[SerializationKeys.iosDriverMaintenanceMode].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = androidUserMaintenanceMode { dictionary[SerializationKeys.androidUserMaintenanceMode] = value }
        if let value = androidDriverMandantoryUpdate { dictionary[SerializationKeys.androidDriverMandantoryUpdate] = value }
        if let value = iosUserMaintenanceMode { dictionary[SerializationKeys.iosUserMaintenanceMode] = value }
        if let value = androidDriverCurrentVersion { dictionary[SerializationKeys.androidDriverCurrentVersion] = value }
        if let value = iosDriverMandantoryUpdate { dictionary[SerializationKeys.iosDriverMandantoryUpdate] = value }
        if let value = iosUserCurrentVersion { dictionary[SerializationKeys.iosUserCurrentVersion] = value }
        if let value = androidUserCurrentVersion { dictionary[SerializationKeys.androidUserCurrentVersion] = value }
        if let value = iosUserMandantoryUpdate { dictionary[SerializationKeys.iosUserMandantoryUpdate] = value }
        if let value = androidUserMandantoryUpdate { dictionary[SerializationKeys.androidUserMandantoryUpdate] = value }
        if let value = androidDriverMaintenanceMode { dictionary[SerializationKeys.androidDriverMaintenanceMode] = value }
        if let value = iosDriverCurrentVersion { dictionary[SerializationKeys.iosDriverCurrentVersion] = value }
        if let value = applicationVersionId { dictionary[SerializationKeys.applicationVersionId] = value }
        if let value = iosDriverMaintenanceMode { dictionary[SerializationKeys.iosDriverMaintenanceMode] = value }
        return dictionary
    }

}
