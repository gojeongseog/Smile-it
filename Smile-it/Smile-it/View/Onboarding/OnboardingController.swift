//
//  OnboardingControllerViewController.swift
//  Smile-it
//
//  Created by KoJeongseok on 2022/09/26.
//

import UIKit

class OnboardingController: UIPageViewController {
    
    var pages = [UIViewController]()
    
    // external controls
    let pageControl = UIPageControl()
    let initialPage = 0
    
    let startButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.setTitle("시작 하기", for: .normal)
//        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
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

extension OnboardingController {
    // 온보딩 페이지 설정
    func setup() {
        dataSource = self
        delegate = self
        view.backgroundColor = .systemBackground
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        let page1 = OnboardingViewController(imageName: "첫번째이미지", titleText: "첫번째텍스트", subtitleText: "첫번째서브텍스트")
        
        let page2 = OnboardingViewController(imageName: "두번째이미지", titleText: "두번째텍스트", subtitleText: "두번째텍스트")
        
        let page3 = OnboardingViewController(imageName: "두번째이미지", titleText: "세번째텍스트", subtitleText: "세번째텍스트")
        
        let page4 = OnboardingViewController(imageName: "두번째이미지", titleText: "네번째텍스트", subtitleText: "네번째텍스트")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true)
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

extension OnboardingController: UIPageViewControllerDataSource {
    
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

extension OnboardingController: UIPageViewControllerDelegate {
    
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

extension OnboardingController {

    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func startButtonTapped() {
//        UserDefaults.standard.set(true, forKey: "oldUser")
        let smileVC = SmileVC()
        dismiss(animated: false)
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
