//
//  StoreKey.swift
//  jeolhak
//
//  Created by 윤대현 on 5/19/25.
//

import NMapsMap

class StoreKey: NSObject, NMCClusteringKey {
    let identifier: Int
    let position: NMGLatLng

    init(identifier: Int, position: NMGLatLng) {
        self.identifier = identifier
        self.position = position
    }

    static func markerKey(withIdentifier identifier: Int, position: NMGLatLng) -> StoreKey {
        return StoreKey(identifier: identifier, position: position)
    }

    override func isEqual(_ o: Any?) -> Bool {
        guard let o = o as? StoreKey else {
            return false
        }
        if self === o {
            return true
        }

        return o.identifier == self.identifier
    }

    override var hash: Int {
        return self.identifier
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return StoreKey(identifier: self.identifier, position: self.position)
    }
}
