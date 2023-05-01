//
//  CurrencyConversionRepo.swift
//  CurrencyConversion
//
//  Created by Vaibhav Sadana on 29/04/23.
//

import Foundation


class CurrencyConversionRepo {
    
    //MARK: get currency data
    func getDataCurrency(app_id:String,baseCurrency: String,completion:@escaping([String:Any]?)->Void){
        let url = URL(string: String(format: BASE_URL,baseCurrency))!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(app_id, forHTTPHeaderField: "apikey")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                do {
                     let response =  try JSONSerialization.jsonObject(with: data) as? [String:Any]
                    if response?["base"] != nil {
                        completion(response)
                    } else {
                        completion(nil)

                    }
                } catch(_) {
                    completion(nil)
                }
            } else if error != nil {
                completion(nil)
            }
        }
        task.resume()
    }
}
