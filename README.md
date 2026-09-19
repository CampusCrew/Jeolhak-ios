# 🏫 절약학개론 (Jeolhak) — iOS

<div align="center">
  <img src="https://github.com/user-attachments/assets/812e80de-5bb4-4993-86c7-004c56ea0434" width="800" alt="절약학개론 소개 배너"/>
  
  <b> 대학가 할인 정보, 흩어져 있지 말고 지도 위에서 한눈에. </b>

  <p> 원광대학교 학생들을 위한 <b>위치 기반 대학가 할인 정보 제공 플랫폼</b></p>
</div>

---

## 📌 프로젝트 개요

> 🏫 대학가 상권에는 학생 대상 할인 혜택이 정말 많지만, 정작 학생들은 이를 **한눈에 확인할 방법이 없습니다.**

- 할인 정보는 대부분 **SNS 게시물, 입소문, 오프라인 전단지** 등 흩어진 매체에 의존하고 있어, 학생들이 실시간으로 확인하거나 체계적으로 접근하기 어렵습니다.
- 이로 인해 학생은 실질적인 혜택을 놓치고, 상점은 애써 마련한 프로모션이 있어도 효과적으로 홍보할 방법이 없는 문제가 반복되었습니다.
- 기존 지역 기반 할인 앱(쿠폰모아 등)을 조사해본 결과, 대부분 프랜차이즈 중심으로 구성되어 있어 **대학가의 소규모 매장 할인 정보**를 반영하지 못하는 한계가 있었습니다.

**절약학개론**은 이렇게 흩어진 대학가 할인 정보를 **지도 위 하나의 서비스**로 통합해, 학생이 위치·학과·단과대 기준으로 근처 할인 매장을 실시간으로 찾고, 직접 새로운 할인 정보를 등록할 수 있는 **참여형 할인 정보 플랫폼**을 목표로 합니다.

---

## 📱 스크린샷

<table align="center">
  <tr>
    <td align="center" width="20%"><img src="https://github.com/user-attachments/assets/9446dfa4-3ca2-49ff-9366-ae5e568f7d6f" alt="지도 탐색"/></td>
    <td align="center" width="20%"><img src="https://github.com/user-attachments/assets/db81eca8-71d6-4cae-b353-cba2a134fe6f" alt="매장 카드"/></td>
    <td align="center" width="20%"><img src="https://github.com/user-attachments/assets/c9652028-b71d-471c-adb2-6c51c797eb12" alt="매장 목록"/></td>
    <td align="center" width="20%"><img src="https://github.com/user-attachments/assets/2d9cd58f-0fe2-4a7a-a552-ceb89576803d" alt="할인 상세"/></td>
    <td align="center" width="20%"><img src="https://github.com/user-attachments/assets/fa130925-5b81-4f2f-823b-d8da32a83588" alt="매장 등록"/></td>
  </tr>
  <tr>
    <td align="center"><b>① 지도 탐색</b><br/><sub>마커로 할인 매장 확인<br/>단과대·학과 필터</sub></td>
    <td align="center"><b>② 매장 카드</b><br/><sub>마커 선택 시<br/>바텀 카드로 요약</sub></td>
    <td align="center"><b>③ 매장 목록</b><br/><sub>카드를 위로 올려<br/>주변 매장 스크롤</sub></td>
    <td align="center"><b>④ 할인 상세</b><br/><sub>할인 내용·기간·대상<br/>네이버 지도 연동</sub></td>
    <td align="center"><b>⑤ 매장 등록</b><br/><sub>지도에서 위치 선택<br/>주소 자동 반영</sub></td>
  </tr>
</table>

<p align="center">
  <sub>왼쪽부터 — 홈(지도 기반 할인 매장 탐색) · 할인 상세 정보 · 매장 등록(주소 확인)</sub>
</p>

<p align="center">실제 원광대학교 인근 상권(창의공과대학·컴퓨터소프트웨어공학과 제휴 매장 등)을 대상으로 iPhone/Android 실기기 테스트를 거쳤습니다.</p>

---

## ✨ 주요 기능

### 🗺️ 지도 기반 할인 매장 탐색
- 네이버 지도(Naver Map) 위에 제휴 할인 매장을 마커로 표시
- 할인 대상(전체 대학생 / 단과대 / 학과)에 따라 마커 색상을 다르게 구분
- 마커 클릭 시 가게 이름, 할인 내용, 이미지 등 상세 정보를 카드/상세 화면으로 확인

### 🔍 검색 및 필터
- 가게명, 지역, 할인 대상 기준으로 검색
- 학과 / 단과대 / 전체 대학생 단위로 지도에 표시할 매장 범위를 필터링

### ✍️ 할인 매장 직접 등록
- 학생이 직접 상호명, 주소, 할인 내용, 사진 등을 입력해 새로운 할인 매장 등록
- 지도에서 위치를 직접 선택하면 해당 주소가 자동으로 등록 폼에 반영
- 등록된 주소는 서버에서 좌표로 변환되어 즉시 지도에 반영

### 🔔 신규 매장 등록 알림
- 새로운 할인 매장이 등록되면 APNs를 통해 사용자에게 실시간 알림 전송
- 알림 수신 시 현재 보고 있던 필터 기준으로 목록을 다시 조회해 최신 상태 유지

### ⭐ 관심 매장 관리 (북마크) · 🚨 신고 기능
- 자주 찾는 할인 매장을 북마크로 저장해 별도 관리
- 잘못된 할인 정보에 대한 신고 접수 -> 검토 -> 반영 프로세스

---

## 🛠 기술 스택

| 구분 | 스택 |
| --- | --- |
| **Language** | Swift (UIKit, SnapKit) |
| **Architecture** | MVC 기반 컴포넌트 재사용 설계 |
| **Networking** | URLSession, REST API (Spring Boot 서버 연동) |
| **위치/지도** | Naver Maps SDK, Naver Geocoding / 검색 API |
| **알림** | APNs (Apple Push Notification service) · FCM 경유 |
| **협업 도구** | GitHub, Notion, Figma |
| **백엔드(연동)** | Spring Boot, MySQL, AWS EC2, AWS S3 |

> iOS는 Swift(UIKit), Android는 React Native로 개발되었으며, 두 클라이언트는 동일한 Spring Boot 백엔드 API를 공유합니다.

---

## 🏛 시스템 아키텍처

<div align="center">
  <img src="https://github.com/user-attachments/assets/e1ca6506-3c73-47cd-a358-0dd2fa6f9111" width="800" alt="절약학개론 기술스택 아키텍처"/>
</div>

- **Client** : iOS(Swift) · Android(React Native)
- **External API** : Naver Maps, Naver Reverse Geocoding, Naver Search API
- **Notification** : FCM(Firebase Cloud Messaging) → APNs 경유 푸시 알림
- **Back End** : Spring Boot 기반 Main Server + FCM 기반 Notification Server (JPA/Hibernate)
- **Infrastructure** : AWS EC2(서버 호스팅) · AWS S3(파일 스토리지) · MySQL(데이터베이스)

---

## 💡 핵심 경험 (트러블슈팅)

개발 과정에서 마주친 문제와 해결 과정을 Wiki에 정리했습니다.

<div align="center">
  <img src="https://github.com/user-attachments/assets/ec7832ff-653a-4433-a3bd-3290b60a6653" width="800" alt="개발 트러블슈팅 경험"/>
</div>

| 경험 | 설명 |
| --- | --- |
| **주소 → 좌표 변환 최적화** | 매장 데이터에 좌표가 없는 문제를, 최초 1회 전처리 + 신규 등록 시 자동 변환 구조로 해결한 과정 |
| **썸네일 이미지 API 호출 최적화** | 매장마다 매번 이미지 API를 호출하던 구조를 DB 캐싱 방식으로 개선해 호출 횟수 **88.75% 절감**, 응답 속도 35% 개선 |
| **바텀 카드뷰 공통 컴포넌트 설계** | 홈/관심 화면에서 서로 다른 데이터·레이아웃을 공유 컴포넌트 하나로 유연하게 처리한 설계 경험 |
| **Android 지도-바텀시트 동기화** | 위치 권한, 학과 필터링, 지도 마커까지 여러 데이터 흐름을 `useEffect`로 동기화한 경험 (React Native) |
| **Spring Boot MVC 구조화** | 처음엔 흐름이 잡히지 않던 백엔드를 MVC 구조로 역할을 나눠 개발·협업 효율을 높인 경험 |
| **APNs 알림 연동** | Sandbox / Production 키 분리 및 FCM-APNs 연동 과정에서의 삽질기 |

👉 더 자세한 내용은 **[Wiki 홈](../../wiki)** 에서 확인하실 수 있습니다.

---

## 🤝 협업 방식

- **스크럼 운영** : 매주 목표 설정과 회고를 반복하며 점진적 개선 진행
- **주간 루틴** : 주간 스프린트 + 정기 회의 기반 운영
- **Notion** : 회의록 · 문서화 · 할 일 정리
- **GitHub** : 코드 리뷰 · 커밋 컨벤션 · PR 관리
- **Figma** : UI 시안 공유 및 피드백

---

## 📂 프로젝트 구조

```
jeolhak/
├── jeolhak.xcodeproj
├── jeolhak.xcworkspace
├── jeolhak/                # 앱 메인 소스
├── jeolhakTests/           # 유닛 테스트
├── jeolhakUITests/         # UI 테스트
└── Podfile                 # CocoaPods 의존성 관리
```

---

## 📚 관련 문서

프로젝트를 진행하며 쌓인 기획, 회의록, 트러블슈팅 기록은 모두 **[Wiki](../../wiki)** 에 정리되어 있습니다.

| 문서 | 내용 |
| --- | --- |
| [🧭 프로젝트 설명서](../../wiki/프로젝트-설명서) | 문제 정의, 목표, 기술 스택, 협업 방식 |
| [🗺️ 프로젝트 구상도](../../wiki/프로젝트-구상도) | 초기 기능 리스트 및 기획 아이디어 |
| [🗃️ 회의록](../../wiki#️-회의록) | 킥오프부터 스프린트 회의까지 전체 회의 기록 |
| [💀 문제 해결 과정](../../wiki/문제해결과정-좌표변환) | 좌표 변환 / 이미지 캐싱 트러블슈팅 |
| [🧢 개발 회고](../../wiki/개발-회고) | 컴포넌트 설계 회고 |
| [🧻 API 명세서](../../wiki/API-명세서) | 서버 API 요청/응답 스펙 |
| [✅ APNs 설정 가이드](../../wiki/APNs-설정-가이드) | 실제 키 값 없이 정리한 APNs 발급·연동 방법 |

---

## 👥 팀원 소개

<table align="center">
  <tr>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/u/62231651?v=4" width="150" height="150"/>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/u/89891115?v=4" width="150" height="150"/>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/u/82390197?v=4" width="150" height="150"/>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/u/103913165?v=4" width="150" height="150"/>
    </td>
  </tr>

  <tr>
    <td align="center">
      Daehyeon Yun<br/>
      <a href="https://github.com/YunDaeHyeon">@YunDaeHyeon</a>
    </td>
    <td align="center">
      YoungJae01<br/>
      <a href="https://github.com/YoungJae01">@YoungJae01</a>
    </td>
    <td align="center">
      봉가은<br/>
      <a href="https://github.com/pongaun">@pongaun</a>
    </td>
    <td align="center">
      김혜진<br/>
      <a href="https://github.com/hyejin27">@hyejin27</a>
    </td>
  </tr>

  <tr>
    <td align="center">
      <b>팀장 / PM</b><br/>
      <b>iOS 개발</b><br/>
      <b>서버(API)</b><br/>
      <b>CI/CD</b>
    </td>
    <td align="center">
      <b>팀원</b><br/>
      <b>Android 개발</b><br/>
      <b>UI/UX</b>
    </td>
    <td align="center">
      <b>팀원</b><br/>
      <b>백엔드</b><br/>
      <b>API 구축</b>
    </td>
    <td align="center">
      <b>팀원</b><br/>
      <b>백엔드</b><br/>
      <b>API 구축</b><br/>
      <b>데이터베이스</b>
    </td>
  </tr>
</table>
