//
//  BaseViewController.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/09/02.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setupLayout()
        setupConstraints()
        setData()
    }
    
    func setupLayout() {
        // Override Layout
    }
    
    func setupConstraints() {
        // Override Constraints
    }
    
    func setData() {
        // Override Set Data
    }
}

// MARK: - function

extension BaseViewController {
    // 네비게이션 바에 이미지 추가
    func addNavBarImage() {
        let navController = navigationController!
        let image = UIImage(named: "title")
        let imageView = UIImageView(image: image)
//        let bannerWidth = navController.navigationBar.frame.size.width
//        let bannerHeight = navController.navigationBar.frame.size.height
//        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
//        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
//        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}
