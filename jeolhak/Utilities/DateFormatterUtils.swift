//
//  DateFormatterUtils.swift
//  jeolhak
//
//  Created by 윤대현 on 5/29/25.
//

import Foundation

// MARK: - 날짜 형식 변환 유틸리티

enum DateFormatterUtils {
    
    // "YYYY.MM.DD~YYYY.MM.DD" 형식의 문자열을 "YYYY년 M월 D일 ~ YYYY년 M월 D일"로 변환
    // 형식이 맞지 않으면 그대로 반환 (예시: "상시" -> 그대로 반환)
    static func formatSaleDate(_ raw: String) -> String {
        let components = raw.split(separator: "~")
        guard components.count == 2 else { return raw }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd"

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "yyyy년 M월 d일"

        guard let startDate = formatter.date(from: components[0].trimmingCharacters(in: .whitespaces)),
              let endDate = formatter.date(from: components[1].trimmingCharacters(in: .whitespaces)) else {
            return raw
        }

        return "\(outputFormatter.string(from: startDate)) ~ \(outputFormatter.string(from: endDate))"
    }
}
