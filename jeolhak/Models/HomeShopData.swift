//
//  HomeShopData.swift
//  jeolhak
//
//  Created by 윤대현 on 4/14/25.
//

import Foundation

// MARK: - Home View Controller의 TableView Cell 데이터 정의 (미사용)
struct HomeShopData {
    let imageName: String
    let title: String
    let category: String
    let content: String
    let isFavorite: Bool
}

let sampleHomeShops: [HomeShopData] = [
    HomeShopData(imageName: "testImage", title: "GT커피 모현점", category: "디저트", content: "분위기 좋은 공간", isFavorite: true),
    HomeShopData(imageName: "testImage", title: "홍콩반점", category: "중식", content: "푸짐한 양과 저렴한 가격", isFavorite: false),
    HomeShopData(imageName: "testImage", title: "마라공방", category: "마라탕", content: "얼얼한 마라맛이 끝내줘요!", isFavorite: false),
    HomeShopData(imageName: "testImage", title: "버거킹", category: "패스트푸드", content: "빠르고 맛있는 와퍼!", isFavorite: true),
    HomeShopData(imageName: "testImage", title: "할리스커피", category: "카페", content: "스터디와 대화에 좋은 분위기", isFavorite: false)
]
