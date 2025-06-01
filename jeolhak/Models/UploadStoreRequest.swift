//
//  UploadStoreRequestDTO.swift
//  jeolhak
//
//  Created by 윤대현 on 6/1/25.
//

import Foundation

// MARK: - 할인 매장 등록
// 사용 API : POST /stores

// 요청 모델
struct UploadStoreRequestDTO: Encodable {
    let name: String                   // 가게 이름
    let address: String                // 가게 주소
    let partDivision: String           // "학과" 또는 "단과"
    let partName: String               // 학과 명 또는 단과대학 명
    let saleTarget: String             // 할인 대상 ("컴공 재학생" 등)
    let saleInfo: String               // 할인 조건 설명
    let saleDate: String               // "상시" 또는 "YYYY.MM.dd~YYYY.MM.dd"
    let etc: String                    // 기타 설명
    let requester: String              // 요청자
}

// 응답 모델
struct UploadStoreResponseDTO: Decodable {
    let message: String
}
