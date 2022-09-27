//
//  OnboardingControllerViewController.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/09/26.
//

import UIKit

class OnboardingView: UIPageViewController {
    var pages = [UIViewController]()
    
    // external controls
    let pageControl = UIPageControl()
    let initialPage = 0
    
    let startButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "tintColor")
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.setTitle("시작 하기", for: .normal)
        // 버튼 타이틀 폰트 바꾸기 추가해야 함
        return button
    }()
    
    // animations
    var pageControlBottomAnchor: NSLayoutConstraint?
    var buttonWidth: NSLayoutConstraint?
    var buttonHeight: NSLayoutConstraint?
    var buttonBottom: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 다시 실행 되지 않도록 UserDefaults 설정 하기
    }
}

extension OnboardingView {
    // 온보딩 페이지 설정
    func setup() {
        dataSource = self
        delegate = self
        view.backgroundColor = .systemBackground
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        let page0 = OnboardingViewController(imageName: "on0",
                                             titleText: "사용 설명!",
                                             subtitleText: "Smile-it사용법 알아보기.\n사용자가 웃으면 잠금 화면이 풀립니다.\n간단한 사용 방법 확인 후 이용해 보세요.")
        
        let page1 = OnboardingViewController(imageName: "on1",
                                             titleText: "첫번째!",
                                             subtitleText: "카메라의 정면 응시하기.\n표정을 확인하기 위해\n카메라 권한이 필요합니다.\n")
        
        let page2 = OnboardingViewController(imageName: "on2",
                                             titleText: "두번째!",
                                             subtitleText: "눈을 깜빡여 보기.\n사용자를 따라 눈을 깜빡입니다.")
        
        let page3 = OnboardingViewController(imageName: "on3",
                                             titleText: "세번째!",
                                             subtitleText: "미소 지어보기.\n사용자를 따라 미소를 짓습니다.")
        
        let page4 = OnboardingViewController(imageName: "on4",
                                             titleText: "네번째!",
                                             subtitleText: "좀 더 활짝 웃어보기.\n환하게 웃었다면 잠금화면이 풀립니다.")
        pages.append(page0)
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .systemGray2
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        startButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        view.addSubview(pageControl)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // for animations
        pageControlBottomAnchor = pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        pageControlBottomAnchor?.isActive = true
        buttonWidth = startButton.widthAnchor.constraint(equalToConstant: 340)
        buttonWidth?.isActive = true
        buttonHeight = startButton.heightAnchor.constraint(equalToConstant: 54)
        buttonHeight?.isActive = true
        buttonBottom = startButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 80)
        buttonBottom?.isActive = true
    }
}

// MARK: - DataSource

extension OnboardingView: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1] // 이전 페이지
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil}
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1] // 다음 페이지
        } else {
            return nil
        }
    }
}

// MARK: - Delegates

extension OnboardingView: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else {return }
        
        pageControl.currentPage = currentIndex
        
        if currentIndex == pages.count - 1 {
            buttonBottom?.constant = -120
        }
        
        // 최신 애니메이션 적용
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
}

// MARK: - Actions

extension OnboardingView {

    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func startButtonTapped() {
        let defaults = UserDefaults.standard
        defaults.set("No", forKey:"isFirstTime")
        let smileVC = SmileVC()
        smileVC.modalPresentationStyle = .fullScreen
        guard let pvc = self.presentingViewController else { return }
        dismiss(animated: false)
        pvc.present(smileVC, animated: true)
    }
}

// MARK: - Extensions

extension UIPageViewController {

    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
        
        
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
    }
}
