//
//  UIView+Extension.swift
//  jeolhak
//
//  Created by 윤대현 on 5/24/25.
//

import UIKit

// MARK: - 어떤 UIView가 자신을 포함하는 컨트롤러를 찾을 떄 활용
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            parentResponder = responder.next
            if let vc = responder as? UIViewController {
                return vc
            }
        }
        return nil
    }
}
