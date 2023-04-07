//
//  UINavigationController+UIGestureRecognizerDelegate.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/07.
//

import UIKit

// UINavigationController를 확장하여 UIGestureRecognizerDelegate를 구현합니다.
extension UINavigationController: UIGestureRecognizerDelegate {
    
    // viewDidLoad()에서 호출되어 interactivePopGestureRecognizer의 delegate를 설정합니다.
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    // 제스처 인식자가 시작되어야 하는지 결정하는 메소드를 구현합니다.
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // AppState에서 swipeEnabled를 확인하여 스와이프 백 제스처를 활성화할지 결정합니다.
        if AppState.shared.swipeEnabled {
            return viewControllers.count > 1 // 뷰 컨트롤러 스택에 두 개 이상의 뷰 컨트롤러가 있는 경우에만 스와이프 백을 활성화합니다.
        }
        return false // 그렇지 않으면 스와이프 백을 비활성화합니다.
    }
}
