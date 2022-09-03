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
    
    // setup image
//    func setupImage(imageName: String) -> UIImageView {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.image = UIImage(named: imageName)
//        return image
//    }
}
