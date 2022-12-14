//
//  SmileViewController.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/08/30.
//

import UIKit
import ARKit

class SmileVC: BaseViewController {
    let trackingView = ARSCNView()
    lazy var backgroundImageView = setupImage(imageName: "smileBackground")
    lazy var mouthImageView = setupImage(imageName: "LsmileMouth")
    lazy var leftEyeImageView = setupImage(imageName: "Lclose")
    lazy var rightEyeImageView = setupImage(imageName: "Rclose")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AR face tracking 지원하는지 확인
        guard ARFaceTrackingConfiguration.isSupported else {
            // AR face tracking 지원 불가시 에러 / 종료
            fatalError("이 기기에서는 AR face tracking 지원 불가")
        }
        
        
        // 카메라 권한 요청
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if (granted) {
                // 접근이 허용된 경우 뷰 설정
                DispatchQueue.main.async {
                    self.setupSmile()
                }
            } else {
                // 접근 거부된 경우
//                fatalError("카메라 접근 거부")
                let alert = UIAlertController(title: "Smile-it을 사용하기 위해서는 카메라의 권한이 필요합니다.", message: "표정을 확인하기 위해 권한이 필요합니다. 카메라를 통한 정보는 전송되거나 저장되지 않습니다.", preferredStyle: .alert)
//                let cancle = UIAlertAction(title: "취소", style: .cancel)
                let setting = UIAlertAction(title: "설정", style: .default, handler: {_ in
                    print("설정")
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
//                alert.addAction(cancle)
                alert.addAction(setting)
                self.present(alert, animated: true)
                
                
                
            }
        }
    }
    
    override func setupLayout() {
        view.addSubview(trackingView)
        view.addSubview(backgroundImageView)
        view.addSubview(mouthImageView)
        view.addSubview(leftEyeImageView)
        view.addSubview(rightEyeImageView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            backgroundImageView.heightAnchor.constraint(equalToConstant: view.bounds.height),
            mouthImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            mouthImageView.heightAnchor.constraint(equalToConstant:  view.bounds.width / 2),
            mouthImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mouthImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftEyeImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            leftEyeImageView.heightAnchor.constraint(equalToConstant:  view.bounds.width / 2),
            leftEyeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leftEyeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rightEyeImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            rightEyeImageView.heightAnchor.constraint(equalToConstant:  view.bounds.width / 2),
            rightEyeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rightEyeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupImage(imageName: String) -> UIImageView {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: imageName)
        return image
    }
    
    func setupSmile() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        trackingView.session.run(configuration)
        trackingView.delegate = self
    }
    
    func handleSmile(smileValue: CGFloat) {
        switch smileValue {
            
            // 활짝 웃음
        case _ where smileValue > 0.5:
            // dismiss 될때 애니메이션 실행
                        mouthImageView.image = UIImage(named: "HsmileMouth")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.modalTransitionStyle = .crossDissolve
                            self.dismiss(animated: true)
            }
            
            // 웃음
        case _ where smileValue > 0.2:
            mouthImageView.image = UIImage(named: "MsmileMouth")
            
            // 안웃음
        default:
            mouthImageView.image = UIImage(named: "LsmileMouth")
        }
    }
    
    func handleEyeBlink(leftValue: CGFloat, rightValue: CGFloat) {
        switch leftValue {
            // 왼쪽 눈 뜸
        case _ where leftValue < 0.5:
            leftEyeImageView.image = UIImage(named: "Lopen")
            
            // 왼쪽 눈 감음
        case _ where leftValue > 0.5:
            leftEyeImageView.image = UIImage(named: "Lclose")
            
            // 왼쪽눈 기본
        default:
            leftEyeImageView.image = UIImage(named: "Lclose")
        }
        
        switch rightValue {
            // 오른쪽 눈 뜸
        case _ where rightValue < 0.5:
            rightEyeImageView.image = UIImage(named: "Ropen")
            
            // 오른쪽 눈 감음
        case _ where rightValue > 0.5:
            rightEyeImageView.image = UIImage(named: "Rclose")
            
            // 오른쪽 눈 기본
        default:
            rightEyeImageView.image = UIImage(named: "Rclose")
        }
    }
}

// MARK: -Smile tracking

extension SmileVC: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        // 왼쪽 오른쪽 웃는 입 수치 가져오기
        let leftMouthSmileValue = faceAnchor.blendShapes[.mouthSmileLeft] as! CGFloat
        let rightMouthSmileValue = faceAnchor.blendShapes[.mouthSmileRight] as! CGFloat
        
        let leftEyeBlinkValue = faceAnchor.blendShapes[.eyeBlinkLeft] as! CGFloat
        let rightEyeBlinkValue = faceAnchor.blendShapes[.eyeBlinkRight] as! CGFloat
        
        // 트래킹 중인지 확인
        if faceAnchor.isTracked {
            DispatchQueue.main.async {
                self.handleSmile(smileValue: (leftMouthSmileValue + rightMouthSmileValue) / 2.0)
                
                self.handleEyeBlink(leftValue: rightEyeBlinkValue, rightValue: leftEyeBlinkValue)
            }
        } else {
            DispatchQueue.main.async {
                self.leftEyeImageView.image = UIImage(named: "Lclose")
                self.rightEyeImageView.image = UIImage(named: "Rclose")
                self.mouthImageView.image = UIImage(named: "LsmileMouth")
            }
        }
    }
}
