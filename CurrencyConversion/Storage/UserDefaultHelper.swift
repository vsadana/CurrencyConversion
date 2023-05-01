//
//  UserDefaultHelper.swift
//  CurrencyConversion
//
//  Created by Vaibhav Sadana on 30/04/23.
//

import Foundation

enum UserDefaultsKeys : String,CaseIterable {
    case CurrencyData = "currencyDataLatest"
}


extension UserDefaults {
    
    var currencyData : [String:Any]? {
        get {
            if UserDefaults.standard.value(forKey: UserDefaultsKeys.CurrencyData.rawValue) == nil {
                return [String:Any]()
            }
            return  UserDefaults.standard.object(forKey: UserDefaultsKeys.CurrencyData.rawValue) as? [String:Any]
        }
        
        set(newValue) {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.CurrencyData.rawValue)
            } else {
                UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKeys.CurrencyData.rawValue)
            }
        }
    }
}
