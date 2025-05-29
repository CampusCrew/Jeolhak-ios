//
//  FCMRegisterRequest.swift
//  jeolhak
//
//  Created by 윤대현 on 5/29/25.
//

import Foundation

// MARK: - 서버로 FCM 토큰 POST 할 때 모델
// 사용 API : POST /notify

// 요청 모델
struct FCMRegisterRequest: Encodable {
    let token: String
    let os: String
}

// 응답 모델
struct FCMRegisterResponse: Decodable {
    let message: String
}
