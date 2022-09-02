//
//  BaseViewController.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/09/02.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
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
