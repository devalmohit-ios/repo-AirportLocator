//
//  APIManager.swift
//  Airport Locator
//
//  Created by Mohit Deval on 30/01/20.
//  Copyright © 2020 Mohit Deval. All rights reserved.
//

import Foundation
import UIKit

public typealias HTTPHeaders = [String: String]

public enum RequestMethod: String {
    case get = "GET"
}

typealias Parameters = [String: Any]

enum commonError : Error{
    case noDataAvailabel
    case canNotProcessData
}

class APIManager {
    
    // MARK: - Singleton -
    class var sharedInstance:APIManager {
        struct Static{
            static let _instance = APIManager()
        }
        return Static._instance
    }
    
    // Mark :-  For GetRequest
    func getRequestAPI(url:String,completion: @escaping(_ news : Airport?, _ error: Error?) -> Void){
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = RequestMethod.get.rawValue
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let responseData = data else {
                print("Data is nil")
                completion(nil, error)
                return
            }
            self.createAirportDataObjectWith(json: responseData, completion: { (news, error) in
                if let error = error {
                    print("Failed to convert data")
                    return completion(nil, error)
                }
                return completion(news, nil)
            })
        }.resume()
    }
    
    func createAirportDataObjectWith(json: Data, completion: @escaping (_ data: Airport?, _ error: Error?) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let news = try decoder.decode(Airport.self, from: json)
            return completion(news, nil)
        } catch let error {
            print("Error creating current weather from JSON because: \(error.localizedDescription)")
            return completion(nil, error)
        }
    }
    
}

