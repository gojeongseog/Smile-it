//
//  WriteDiaryViewController.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/09/01.
//

import UIKit

enum PostitEditorMode {
    case new
    case edit(IndexPath)
}

class WriteDiaryVC: BaseViewController {
    
    var content: String = ""
    var color: String = "postitYellow1"
    var postitEditorMode: PostitEditorMode = .new
    
    
    // 컬러 스택뷰
    let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    // 포스트잇 이미지뷰
    let postitImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "postitYellow1")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    // 컨텐트 텍스트뷰
    let contentTextView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .clear
        text.textColor = .black
        text.font = UIFont(name: "godoMaum", size: 30)
        //        text.font = .systemFont(ofSize: 30)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    // 컬러 버튼
    lazy var yellowColorButton = setupColorButton(color: color == "postitYellow1" ? "CCyellow" : "Cyellow", tag: 0)
    lazy var greenColorButton = setupColorButton(color: color == "PostItGreen1" ? "CCgreen" : "Cgreen", tag: 1)
    lazy var redColorButton = setupColorButton(color: color == "PostItRed1" ? "CCred" : "Cred", tag: 2)
    lazy var blueColorButton = setupColorButton(color: color == "PostItBlue1" ? "CCblue" : "Cblue", tag: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 네비게이션 바에 타이틀 추가
        addNavBarImage()
        
        // 등록 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ok"), style: .plain, target: self, action: #selector(postSave))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 취소 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(postCancle))
        
        // 네비게이션바 버튼 컬러
        navigationController?.navigationBar.tintColor = UIColor(named: "tintColor")
    }
    
    override func setupLayout() {
        
        view.addSubview(hStackView)
        view.addSubview(postitImage)
        view.addSubview(contentTextView)
        hStackView.addArrangedSubview(yellowColorButton)
        hStackView.addArrangedSubview(greenColorButton)
        hStackView.addArrangedSubview(redColorButton)
        hStackView.addArrangedSubview(blueColorButton)
        
        contentTextView.delegate = self
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            hStackView.bottomAnchor.constraint(equalTo: postitImage.topAnchor, constant: -10),
            hStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            hStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            hStackView.heightAnchor.constraint(equalTo: yellowColorButton.widthAnchor),
            
            yellowColorButton.heightAnchor.constraint(equalTo: yellowColorButton.widthAnchor),
            
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
    
    override func setData() {
        switch postitEditorMode {
        case .new:
            return
        case .edit(let indexPath):
            guard let item = CoreDataManager.shared.postitems?.reversed()[indexPath.item] else { fatalError("error") }
            contentTextView.text = item.value(forKey: "content") as? String
            postitImage.image = UIImage(named: (item.value(forKey: "color") as? String)!)
        }
    }
    
    // 컬러버튼 셋업
    func setupColorButton(color: String, tag: Int) -> UIButton {
        let button = UIButton()
        let image = UIImage(named: color)
        button.setImage(image, for: .normal)
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(presedColorButton(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func presedColorButton(_ sender: UIButton) {
        // 편집모드에 컬러 변경시 수정 가능
        switch postitEditorMode {
        case .new:
            if contentTextView.text == "" {
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        case .edit:
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        // 컬러 선택시 컬러 변경
        yellowColorButton.setImage(UIImage(named: sender.tag == 0 ? "CCyellow" : "Cyellow") , for: .normal)
        greenColorButton.setImage(UIImage(named: sender.tag == 1 ? "CCgreen" : "Cgreen") , for: .normal)
        redColorButton.setImage(UIImage(named: sender.tag == 2 ? "CCred" : "Cred") , for: .normal)
        blueColorButton.setImage(UIImage(named: sender.tag == 3 ? "CCblue" : "Cblue") , for: .normal)
        
        // 컬러 선택시 포스트잇 컬러 변경
        switch sender.tag {
        case 0:
            self.postitImage.image = UIImage(named: "postitYellow1")
            self.color = "postitYellow1"
        case 1:
            self.postitImage.image = UIImage(named: "PostItGreen1")
            self.color = "PostItGreen1"
        case 2:
            self.postitImage.image = UIImage(named: "PostItRed1")
            self.color = "PostItRed1"
        case 3:
            self.postitImage.image = UIImage(named: "PostItBlue1")
            self.color = "PostItBlue1"
        default:
            return
        }
    }
    
    // 포스트잇 저장
    @objc private func postSave() {
        
        switch postitEditorMode {
        case .new:
            content = self.contentTextView.text
            CoreDataManager.shared.createItem(content: content, color: color)
            self.navigationController?.popViewController(animated: true)
        case .edit(let indexPath):
            guard let item = CoreDataManager.shared.postitems?.reversed()[indexPath.item] else { fatalError("error") }
            let id = item.value(forKey: "id") as! UUID
            content = self.contentTextView.text
            CoreDataManager.shared.updateitem(id: id, content: content, color: color)
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    // 포스트잇 작성 취소
    @objc private func postCancle() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension WriteDiaryVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print("textView text is change")
        if textView.text == "" {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}
