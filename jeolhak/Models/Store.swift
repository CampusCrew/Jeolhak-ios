//
//  Store.swift
//  jeolhak
//
//  Created by 윤대현 on 5/15/25.
//

import Foundation

/// 개별 가게 정보를 나타내는 모델
///
/// 사용 API: `GET /stores`
///
/// - Note: 위도(lat), 경도(lng)는 WGS84 기준
struct Store: Decodable {
    
    /// 가게 이름
    let name: String
    
    /// 가게 위도 (latitude)
    let lat: Double
    
    /// 가게 경도 (longitude)
    let lng: Double
}

/// 가게 목록 조회 API의 전체 응답 모델
///
/// 서버에서 응답으로 내려주는 최상위 JSON 구조에 대응
///
/// 사용 API: `GET /stores`
struct StoreResponse: Decodable {
    
    /// 응답 상태 (예: `"success"`, `"error"`)
    let status: String
    
    /// 실제 가게 목록 데이터
    let data: [Store]
    
    /// 응답 생성 시각 (서버 기준, 한국 표준시)
    let timestamp: String
}
