//
//  LeafMarkerUpdater.swift
//  jeolhak
//
//  Created by 윤대현 on 5/19/25.
//

import NMapsMap

// MARK: - 개별 마커 세팅

class LeafMarkerUpdater: NMCDefaultLeafMarkerUpdater {
    var stores: [Store] = []
    
    // BottomCardView 참조
    weak var bottomCardView: BottomCardView?
    
    // 선택된 마커 임시 저장
    private var selectedMarker: NMFMarker?
    
    // 마커 클릭 호출 클로저
    var onMarkerTapped: ((Store) -> Void)?
    
    override init() {
        super.init()
        // 카드 뷰 닫힐 때 마커 크기 복원
        NotificationCenter.default.addObserver(self, selector: #selector(handleCardViewClosed), name: .didCloseCardView, object: nil)
    }
    
    override func updateLeafMarker(_ info: NMCLeafMarkerInfo, _ marker: NMFMarker) {
        super.updateLeafMarker(info, marker)
        guard let key = info.key as? StoreKey else { return }
        
        let categoryName = stores[key.identifier].category ?? "기타" // 옵셔널 바인딩 대체
        let markerType = MarkerCategory.from(categoryName: categoryName)
        
        marker.iconImage = NMFOverlayImage(image: UIImage(named: markerType.imageName)!)
        marker.width = 28
        marker.height = 29
        
        marker.captionText = ""
        
        // 식별자 기준으로 Store 찾기
        if key.identifier < stores.count {
            let store = stores[key.identifier]
            marker.captionText = stores[key.identifier].name
            marker.captionAligns = [NMFAlignType.top]
            
            // 마커 터치 핸들러 (클로저 연결)
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self else { return false }
                
                // 기존 마커 크기 복원
                self.selectedMarker?.width = 28
                self.selectedMarker?.height = 29
                
                // 터치된 마커 확대 (강조)
                marker.width = 48
                marker.height = 50
                
                // 현재 마커 상태 저장
                self.selectedMarker = marker
                
                // 가게 데이터 콜백
                self.bottomCardView?.showSelectedStore(store, targetTop: 480)
                
                //                marker.width = 38
                //                marker.height = 41
                
                // 개별 마커 위치로 지도 카메라 이동
                let latLng = NMGLatLng(lat: store.lat, lng: store.lng)
                let cameraUpdate = NMFCameraUpdate(scrollTo: latLng, zoomTo: 16)
                cameraUpdate.animation = .easeIn
                // 콘텐츠 패딩 지정
                //MapManager.shared.mapView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
                MapManager.shared.mapView?.moveCamera(cameraUpdate)
                
                return true
            }
        }
    }
    
    @objc private func handleCardViewClosed() {
        // 선택된 마커 크기 원상복구
        selectedMarker?.width = 28
        selectedMarker?.height = 29
        selectedMarker = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
