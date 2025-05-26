//
//  LeafMarkerUpdater.swift
//  jeolhak
//
//  Created by 윤대현 on 5/19/25.
//

import NMapsMap

class LeafMarkerUpdater: NMCDefaultLeafMarkerUpdater {
    var stores: [Store] = []
    
    // BottomCardView 참조
    weak var bottomCardView: BottomCardView?
    
    // 마커 클릭 호출 클로저
    var onMarkerTapped: ((Store) -> Void)?
    
    override func updateLeafMarker(_ info: NMCLeafMarkerInfo, _ marker: NMFMarker) {
        super.updateLeafMarker(info, marker)
        guard let key = info.key as? StoreKey else { return }
        
        let categoryName = stores[key.identifier].category ?? "기타" // 옵셔널 바인딩 대체
        let markerType = MarkerCategory.from(categoryName: categoryName)
        
        marker.iconImage = NMFOverlayImage(image: UIImage(named: markerType.imageName)!)
        marker.width = 28
        marker.height = 31
        
        marker.captionText = ""
        
        // 식별자 기준으로 Store 찾기
        if key.identifier < stores.count {
            let store = stores[key.identifier]
            marker.captionText = stores[key.identifier].name
            marker.captionAligns = [NMFAlignType.top]
            
            // 마커 터치 핸들러 (클로저 연결)
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self else { return false }
                
                // 가게 데이터 콜백
                self.bottomCardView?.showSelectedStore(store, targetTop: 480)
                
                // 개별 마커 위치로 지도 카메라 이동
                let latLng = NMGLatLng(lat: store.lat, lng: store.lng)
                let cameraUpdate = NMFCameraUpdate(scrollTo: latLng, zoomTo: 16)
                cameraUpdate.animation = .easeIn
                MapManager.shared.mapView?.moveCamera(cameraUpdate)
                
                return true
            }
        }
    }
}
