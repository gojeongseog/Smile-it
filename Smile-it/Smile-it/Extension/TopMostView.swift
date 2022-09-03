//
//  TopMostView.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/08/31.
//

// 최상위 뷰를 불러오기

import UIKit

class TopMostView: UIViewController {
    
}

// MARK: -topMostView

// 최상단 뷰를 불러오기 위한 코드 1
extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

// 최상단 뷰를 불러오기 위한 코드 2
extension UIApplication {
    func topMostViewController() -> BaseViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return keyWindow?.rootViewController?.topMostViewController() as? BaseViewController
    }
}
