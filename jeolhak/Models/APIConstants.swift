//
//  APIConstants.swift
//  jeolhak
//
//  Created by 윤대현 on 5/15/25.
//

import Foundation

enum APIConstants {
    static let baseURL = "http://ec2-43-201-94-46.ap-northeast-2.compute.amazonaws.com:8080"
    
    // GET /stores
    static let getStores = baseURL + "/stores"
    
    // POST /token/save
    static let postToken = baseURL + "/token/save"
}
