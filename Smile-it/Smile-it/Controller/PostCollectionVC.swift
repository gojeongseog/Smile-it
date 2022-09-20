//
//  ViewController.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/08/30.
//

import UIKit
import AVFoundation

class PostCollectionVC: BaseViewController {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    private var longPressedEnabled: Bool = false
    
    // 추가 / 완료 버튼 이미지뷰
    let addbuttonImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "addButton")
        return image
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        for fontFamily in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                print(fontName)
            }
        }
        
        CoreDataManager.shared.getItem()
        self.postCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
    }
    
    override func setupLayout() {
        
        // 추가/완료 버튼 설정
        view.addSubview(addbuttonImage)
        addbuttonImage.isUserInteractionEnabled = true
        addbuttonImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressedAddbutton(_:))))
        
        // 콜렉션 뷰에 대한 설정
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_ :)))
        postCollectionView.addGestureRecognizer(longPressGesture)
        postCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        
        // 닙파일 가져오기
        let postCustomCollectionViewCell = UINib(nibName: String(describing: PostCustomCollectionViewCell.self), bundle: nil)
        
        // 가져온 닙파일로 컬렉션뷰 셀로 등록
        postCollectionView.register(postCustomCollectionViewCell, forCellWithReuseIdentifier: String(describing: PostCustomCollectionViewCell.self))
        
        // 컬렉션뷰의 레이아웃 설정
        self.postCollectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
        addbuttonImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        addbuttonImage.widthAnchor.constraint(equalToConstant: view.bounds.width / 5),
        addbuttonImage.heightAnchor.constraint(equalToConstant: view.bounds.width / 5),
        addbuttonImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    @objc func pressedAddbutton(_ sender: UIGestureRecognizer) {
        if longPressedEnabled {
            // 롱프레스 활성상태 -> 비활성화 상태 버튼
            AudioServicesPlaySystemSound(1520)
            addbuttonImage.image = UIImage(named: "addButton")
            longPressedEnabled = false
            postCollectionView.reloadData()
        } else {
            // 롱프레스 비활성상태 -> 포스트잇 추가하기 버튼
            AudioServicesPlaySystemSound(1520)
            let writeDiaryVC = WriteDiaryVC()
            self.navigationController?.pushViewController(writeDiaryVC, animated: true)
        }
    }
    
    // 롱탭 제스쳐 했을때 함수
    @objc func longTap(_ gesture: UIGestureRecognizer) {
        addbuttonImage.image = UIImage(named: "doneButton")
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = postCollectionView.indexPathForItem(at: gesture.location(in: postCollectionView)) else { return }
            AudioServicesPlaySystemSound(1520)
            postCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            postCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            postCollectionView.endInteractiveMovement()
            longPressedEnabled = true
            self.postCollectionView.reloadData()
        default:
            postCollectionView.cancelInteractiveMovement()
        }
    }
}

extension PostCollectionVC {
    
    // 컴포지셔널 레이아웃 설정
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        print("createCompositionalLayoutForFirst() called")
        // 컴포지셔널 레이아웃 생성
        let layout = UICollectionViewCompositionalLayout {
            // 만들게 되면 튜플 (키: 값, 키: 값) 의 묶음으로 들어옴 변환하는 것은 NSCollectionLayoutSection 컬렉션 레이아웃 섹션을 변환해야함
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            // 아이템에 대한 사이즈 - absolute 는 고정값, estimeted sms cncmr, frection 퍼센트
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            // 위에서 만든 아이템 사이즈로 아이템 만들기
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            // 아이템 간의 간격 설정
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            // 그룹사이즈 설정
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/4))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            // 그룹으로 섹션 만들기
            let section = NSCollectionLayoutSection(group: group)
            // 섹션에 대한 간격 설정
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }
}

// 콜렉션뷰 데이터 소스
extension PostCollectionVC: UICollectionViewDataSource {
    // 각 섹션에 들어가는 아이템 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = CoreDataManager.shared.postitems?.count else {
            return 0
        }
        return count
    }
    // 각 콜렉션뷰 셀에 대한 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PostCustomCollectionViewCell.self), for: indexPath) as! PostCustomCollectionViewCell
        
        guard let item = CoreDataManager.shared.postitems?.reversed()[indexPath.item] else { return UICollectionViewCell() }

        cell.removeBtn.tag = indexPath.item
        cell.removeBtn.addTarget(self, action: #selector(pressedRemoveBtn(_:)), for: .touchUpInside)
        
        cell.profileLabel.text = item.value(forKey: "content") as? String
        cell.profileLabel.font = UIFont(name: "godoMaum", size: 30)
        cell.profileImage.image = UIImage(named: (item.value(forKey: "color") as? String)!)
        
        // 셀 애니메이션 시작 / 종료
        if longPressedEnabled {
            cell.startAnimate()
        } else {
            cell.stopAnimate()
        }
        return cell
    }
    
    // 셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = CoreDataManager.shared.postitems?.reversed()[indexPath.item] else { fatalError("error") }
        
        print("셀 눌림")
        let writeDiaryVC = WriteDiaryVC()
        writeDiaryVC.color = item.value(forKey: "color") as! String
        writeDiaryVC.postitEditorMode = .edit(indexPath)
        self.navigationController?.pushViewController(writeDiaryVC, animated: true)
    }
    
    @objc func pressedRemoveBtn(_ sender: UIButton) {
        if let item =
            CoreDataManager.shared.postitems?.reversed()[sender.tag] {
            AudioServicesPlaySystemSound(1520)
            CoreDataManager.shared.deleteItem(object: item)
            CoreDataManager.shared.getItem()
        }
        self.postCollectionView.reloadData()
    }
}

extension PostCollectionVC: UICollectionViewDelegate {
    
}
