//
//  ViewController.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/08/30.
//

import UIKit

class PostCollectionVC: UIViewController {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    fileprivate let postits = ["postit1", "postit2", "postit3", "postit4"]
    
    fileprivate let systemImageNameArray = [
        "moon", "zzz", "sparkles", "cloud", "tornado", "smoke.fill", "tv.fill", "gamecontroller", "headphones", "flame", "bolt.fill", "timer", "tortoise", "moon", "zzz", "sparkles", "cloud", "tornado", "smoke.fill", "tv.fill", "gamecontroller", "headphones", "flame", "bolt.fill", "here", "tortoise", "moon", "zzz", "sparkles", "cloud", "staroflife", "smoke.fill", "bag", "cart", "creditcard", "clock", "alarm", "stopwatch.fill", "timer",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 콜렉션 뷰에 대한 설정
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
//            section.orthogonalScrollingBehavior = .groupPaging
            
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
        return systemImageNameArray.count
    }
    
    // 각 콜렉션뷰 셀에 대한 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PostCustomCollectionViewCell.self), for: indexPath) as! PostCustomCollectionViewCell
        let item = systemImageNameArray[indexPath.item]
        cell.profileLabel.text = item
        cell.profileImage.image = UIImage(named: postits.randomElement()!)
        return cell
    }
}

extension PostCollectionVC: UICollectionViewDelegate {
    
}


