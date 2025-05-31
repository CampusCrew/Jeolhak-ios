//
//  NaverReverseGeocodeResponse.swift
//  jeolhak
//
//  Created by 윤대현 on 5/31/25.
//

import Foundation

// MARK: - 위,경도를 도로명,지번 주소로 변환할 때 사용하는 응답 모델

struct NaverReverseGeocodeResponse: Decodable {
    let results: [GeoResult]
    
    struct GeoResult: Decodable {
        let name: String                    // "roadaddr", "addr" 등
        let region: Region
        let land: Land?
        
        struct Region: Decodable {
            let area1: Area
            let area2: Area
            let area3: Area
            let area4: Area?                // 선택적으로 추가
        }
        
        struct Area: Decodable {
            let name: String
        }
        
        struct Land: Decodable {
            let type: String?
            let name: String?               // 도로명 ("서동로")
            let number1: String?
            let number2: String?
            let addition0: Addition?
            let addition1: Addition?
            let addition2: Addition?
            let addition3: Addition?
            let addition4: Addition?
        }
        
        struct Addition: Decodable {
            let type: String
            let value: String
        }
    }
}
