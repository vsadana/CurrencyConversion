//
//  CurrencyViewModel.swift
//  CurrencyConversion
//
//  Created by Vaibhav Sadana on 29/04/23.
//

import Foundation
 
class CurrencyViewModel {
    let repoObj = CurrencyConversionRepo()
    
    //MARK: get currency app
    func getCurrencyData(app_id:String,baseCurrency: String,completion:@escaping([String:Any]?)->Void){
        repoObj.getDataCurrency(app_id: app_id, baseCurrency: baseCurrency,completion: completion)
    }
}
