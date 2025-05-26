//
//  TransparentPassThroughView.swift
//  jeolhak
//
//  Created by 윤대현 on 5/26/25.
//

import UIKit

/// 터치 이벤트를 하위 뷰에만 전달하고 자신은 무시하는 UIView
///
/// 지도 등 터치가 필요한 뷰 위에 투명하게 올려놓고
/// 탭 제스처만 따로 감지할 때 사용
// HomeViewController에서 BottomCardView와 backgroundView가 함께 올라갈때 HomeViewVC에 탭과 제스처 감지
class TransparentPassThroughView: UIView {
    
    // 배경 터치 허용 여부 판단
    var shouldReceiveTouch: Bool = false
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard shouldReceiveTouch else {
            return nil // 터치 무시하고 통과시킴
        }
        
        return self
    }
}
