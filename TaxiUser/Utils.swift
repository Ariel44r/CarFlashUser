import Foundation

public class Utils {
    
    func dictionaryRepresentation(properties: [String], keys; [String]) -> [String: AnyObject] {
        var dictionary: [String: AnyObject ] = [:]
        if properties.count == keys.count {
            for index in 0...properties.count {
                if properties[index] != nil {
                    dictionary.updateValue(properties[index] as AnyObject, forKey: keys[index])

                }
            }
        }
    }
}