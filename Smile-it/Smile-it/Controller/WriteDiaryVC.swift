//
//  WriteDiaryViewController.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/09/01.
//

import UIKit

class WriteDiaryVC: UIViewController {
    
    let postitImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "postit4")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let contentTextView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .clear
        text.textColor = .black
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupPostitImageView()
    }
    

    private func setupPostitImageView() {
        view.addSubview(postitImage)
        view.addSubview(contentTextView)
        
        
        NSLayoutConstraint.activate([
            
            contentTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100),
            contentTextView.heightAnchor.constraint(equalTo: view.widthAnchor, constant: -100),
        
            postitImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            postitImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            postitImage.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            postitImage.heightAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
