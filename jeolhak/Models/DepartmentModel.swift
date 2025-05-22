//
//  DepartmentModel.swift
//  jeolhak
//
//  Created by 윤대현 on 5/22/25.
//

import Foundation

// MARK: - 단과대학 <-> 학과 매핑 모델
struct Department {
    let departmentName: String
    let majors: [String]
}

let allDepartments: [Department] = [
    Department(departmentName: "경영대학", majors: [
        "경영대학 전체", 
        "경영학과", "경제금융학과", "회계세무학과"
    ]),
    Department(departmentName: "교학대학", majors: [
        "교학대학 전체",
        "원불교학과"
    ]),
    Department(departmentName: "농생명/바이오계열", majors: [
        "계열 전체", 
        "산림조경전공", "생명과학전공", "생명환경전공", "원예산업전공", "푸드테크전공"
    ]),
    Department(departmentName: "독립학과", majors: [
        "국방기술학과", "자율전공학부"
    ]),
    Department(departmentName: "디자인융합계열", majors: [
        "계열 전체",
        "공예문화/주얼리디자인전공", "시각정보디자인전공", "실내/산업디자인전공",
        "파인아트전공", "패션디자인전공"
    ]),
    Department(departmentName: "보건과학대학", majors: [
        "보건과학대학 전체",
        "동물보건학과", "반려동물산업학과", "뷰티디자인학부",
        "스포츠과학부", "식품영양학과", "안전보건학과", "의료상담학과"
    ]),
    Department(departmentName: "사범대학", majors: [
        "사범대학 전체",
        "가정교육과", "교육학과", "국어교육과", "수학교육과", "역사교육과",
        "영어교육과", "유아교육과", "일어교육과", "중등특수교육과", "체육교육과", "한문교육과"
    ]),
    Department(departmentName: "사회과학대학", majors: [
        "사회과학대학 전체",
        "가족아동복지학과", "경찰행정학과", "군사학과",
        "복지/보건학부/사회복지학 및 보건행정학 전공", "소방행정학과", "행정공공기관학과"
    ]),
    Department(departmentName: "생명교양교육원", majors: [
        "생명교약교육원 전체",
        "교양교육과", "비교과통합센터"
    ]),
    Department(departmentName: "약학대학", majors: [
        "약학대학 전체",
        "약학과", "한약학과"
    ]),
    Department(departmentName: "의과대학", majors: [
        "의과대학 전체",
        "간호학과", "응급구조학과", "의예과/의학과", "작업치료학과"
    ]),
    Department(departmentName: "창의공과대학", majors: [
        "창의공과대학 전체",
        "건설환경공학과", "건축공학과", "게임콘텐츠학과",
        "기계공학부(기계공학/모빌리티)", "도시공학과", "전기공학과", "전자공학과",
        "철도시스템공학부", "컴퓨터소프트웨어공학과", "화학공학과"
    ]),
    Department(departmentName: "창의문화융합계열(인문대학)", majors: [
        "인문대학 전체",
        "국어국문학전공", "글로벌문화예술융합전공", "글로컬역사전공", "문예창작전공",
        "미디어커뮤니케이션광고PR전공", "영어영문학전공", "중국어통번역전공"
    ]),
    Department(departmentName: "치과대학", majors: [
        "치과대학 전체",
        "치의예과/치의학과"
    ]),
    Department(departmentName: "한의과대학", majors: [
        "한의과대학 전체",
        "한의예과/한의학과"
    ])
]
