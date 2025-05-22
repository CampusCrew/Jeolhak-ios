//
//  LeafMarkerUpdater.swift
//  jeolhak
//
//  Created by 윤대현 on 5/19/25.
//

import NMapsMap

class LeafMarkerUpdater: NMCDefaultLeafMarkerUpdater {
    var stores: [Store] = []
    
    override func updateLeafMarker(_ info: NMCLeafMarkerInfo, _ marker: NMFMarker) {
        super.updateLeafMarker(info, marker)
        guard let key = info.key as? StoreKey else { return }
        
        let categoryName = stores[key.identifier].name
        let markerType = MarkerCategory.from(categoryName: categoryName)
        
        marker.iconImage = NMFOverlayImage(image: UIImage(named: markerType.imageName)!)
        marker.width = 28
        marker.height = 31
        
        marker.captionText = ""
        
        // 식별자 기준으로 Store 찾기
        if key.identifier < stores.count {
            marker.captionText = stores[key.identifier].name
            marker.captionAligns = [NMFAlignType.top]
        }
    }
}
