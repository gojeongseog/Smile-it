//
//  PostCustomCollectionViewCell.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/08/31.
//

import Foundation
import UIKit

class PostCustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var isAnimate: Bool! = false
    
    // 애니메이션 시작
    func startAnimate() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 9999
        
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        
        shakeAnimation.fromValue = NSNumber(value: startAngle)
        shakeAnimation.toValue = NSNumber(value: stopAngle)
        shakeAnimation.autoreverses = true
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey: "animate")
//        self.myRemoveBtn.isHidden = false
        isAnimate = true
    }
    
    // 애니메이션 종료
    func stopAnimate() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "animte")
//        self.myRemoveBtn.isHidden = true
        isAnimate = true
    }
}
