//
//  MarkerCategory.swift
//  jeolhak
//
//  Created by 윤대현 on 5/21/25.

// MARK: - 마커 타입 열거형
enum MarkerCategory: String{
    case restaurant
    case cafe
    case bakery
    case meat
    case alcohol
    
    // 카테고리에 맞는 이미지 매핑
    var imageName: String{
        switch self{
        case .restaurant: return "marker_restaurant"
        case .cafe: return "marker_cafe"
        case .bakery: return "marker_bakery"
        case .meat: return "marker_meat"
        case .alcohol: return "marker_alcohol"
        }
    }
}

// MARK: - 가게 카테고리(키워드) 기반 자동 매핑
extension MarkerCategory {
    static func from(categoryName: String) -> MarkerCategory {
        let lowercased = categoryName.lowercased()
        
        let mapping: [MarkerCategory: [String]] = [
            .restaurant: [
                "식당", "음식점", "한식", "중식", "일식", "분식", "패밀리레스토랑",
                "냉면", "국밥", "비빔밥", "백반", "순대국", "칼국수", "돼지국밥", "면요리"
            ],
            .cafe: [
                "카페", "커피", "다방", "찻집", "디저트", "음료전문점", "티하우스",
                "브런치카페", "베이커리카페", "라운지카페", "디카페인", "밀크티", "스무디", "주스바"
            ],
            .bakery: [
                "빵", "베이커리", "제과점", "제빵소", "브래드", "크로와상", "케이크전문점",
                "도넛", "파이", "마카롱샵", "슈크림", "바게트", "페이스트리", "쿠키샵"
            ],
            .meat: [
                "고기", "육류", "삼겹살", "갈비", "소고기", "한우", "양고기",
                "곱창", "막창", "닭갈비", "돼지갈비", "바비큐", "숯불구이", "육회", "양꼬치", "스테이크"
            ],
            .alcohol: [
                "술집", "주점", "호프", "맥주집", "와인바", "이자카야", "막걸리집",
                "요리주점", "선술집", "바", "펍", "하이볼", "위스키바", "칵테일바"
            ]
        ]
        
        for (type, keywords) in mapping {
            if keywords.contains(where: {
                lowercased.contains($0)
            }){
                return type
            }
        }
        
        // 기본값 설정 (음식점)
        return .restaurant
    }
}
