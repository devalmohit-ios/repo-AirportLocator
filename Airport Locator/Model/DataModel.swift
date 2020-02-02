//
//  DataModel.swift
//  Airport Locator
//
//  Created by Mohit Deval on 30/01/20.
//  Copyright © 2020 Mohit Deval. All rights reserved.
//

import Foundation
struct Airport : Codable {
    
    var results : [AirportData]
    let status : String?
    enum CodingKeys: String, CodingKey {
        case results
        case status
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try values.decode([AirportData].self, forKey: .results)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
    
}
struct AirportData : Codable {
    let name: String?
    let geometry : GeometryData?
    enum CodingKeys: String, CodingKey {
        case name
        case geometry
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        geometry = try values.decodeIfPresent(GeometryData.self, forKey: .geometry)
    }
}

struct GeometryData : Codable {
    let location : LocationData
    enum CodingKeys: String, CodingKey {
        case location
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decodeIfPresent(LocationData.self, forKey: .location)!
    }
}
struct LocationData : Codable {
    let lat : Double?
    let lng : Double?
    enum CodingKeys: String, CodingKey {
           case lat
           case lng
       }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lng = try values.decodeIfPresent(Double.self, forKey: .lng)
    }
    
}
