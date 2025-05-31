//
//  APIConstants.swift
//  jeolhak
//
//  Created by 윤대현 on 5/15/25.
//

import Foundation

// MARK: - API 경로 관리
enum APIConstants {
    private static let baseURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "SERVER_URI") as? String else {
            fatalError("❌ SERVER_URI 불러오기 실패 ❌")
        }
        return url
    }()
    
    static let getStores = baseURL + "/stores"
    static let postToken = baseURL + "/notify"
}
