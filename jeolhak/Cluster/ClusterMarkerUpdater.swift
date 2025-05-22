//
//  LeafMarkerUpdater.swift
//  jeolhak
//
//  Created by 윤대현 on 5/19/25.
//

import NMapsMap

class ClusterMarkerUpdater: NMCDefaultClusterMarkerUpdater {
    override func updateClusterMarker(_ info: NMCClusterMarkerInfo, _ marker: NMFMarker) {
        super.updateClusterMarker(info, marker)
        print("클러스터마커 업데이터 실행")
        if info.size < 3 {
            marker.iconImage = NMF_MARKER_IMAGE_CLUSTER_LOW_DENSITY
        } else {
            marker.iconImage = NMF_MARKER_IMAGE_CLUSTER_MEDIUM_DENSITY
        }
    }
}
