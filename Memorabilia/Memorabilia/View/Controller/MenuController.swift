//
//  MenuController.swift
//  Memorabilia
//
//  Created by André Mello Alves on 06/04/20.
//  Copyright © 2020 André Mello Alves. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
    
    // MARK: Properties
    
    let navigation: NavigationBarView = {
        let view = NavigationBarView()
        view.leftButton.setImage(UIImage(systemName: "person.fill"), for: .normal)
        view.titleButton.setTitle(MenuPageType.create.name, for: .normal)
        view.rightButton.setImage(UIImage(systemName: "info"), for: .normal)
        return view
    }()
    
    lazy var page: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        controller.delegate = self
//        controller.dataSource = self
        controller.view.backgroundColor = .systemBackground
        controller.view.layer.cornerRadius = 20
        controller.view.clipsToBounds = true
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    lazy var createButton: OptionsBarButton = {
        let button = OptionsBarButton()
        button.addAction(optionButtonAction(option: .create))
        button.setImage(UIImage(systemName: MenuPageType.create.symbol), for: .normal)
        return button
    }()
    
    lazy var memoriesButton: OptionsBarButton = {
        let button = OptionsBarButton()
        button.addAction(optionButtonAction(option: .memories))
        button.setImage(UIImage(systemName: MenuPageType.memories.symbol), for: .normal)
        return button
    }()
    
    lazy var settingsButton: OptionsBarButton = {
        let button = OptionsBarButton()
        button.addAction(optionButtonAction(option: .settings))
        button.setImage(UIImage(systemName: MenuPageType.settings.symbol), for: .normal)
        return button
    }()
    
    lazy var optionsBar: OptionsBarView = {
        let view = OptionsBarView()
        view.addButton(createButton)
        view.addButton(memoriesButton)
        view.addButton(settingsButton)
        return view
    }()
    
    // MARK: Control properties
    
    var selectedPage: MenuPageType = .create
    
    // MARK: View model
    
    // MARK: Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        // Background
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(named: "Memo1")!.cgColor, UIColor(named: "Memo2")!.cgColor]
        gradient.startPoint = .init(x: 0, y: 0.3)
        gradient.endPoint = .init(x: 0, y: 1)
        view.backgroundColor = .systemBackground
        view.layer.insertSublayer(gradient, at: 0)
        
        // Navigation bar
        view.addSubview(navigation)
//        navigation.leftButton.addTarget(self, action: #selector(backButtonAction), for: .primaryActionTriggered)
//        navigation.rightButton.addTarget(self, action: #selector(optionsButtonAction), for: .primaryActionTriggered)
        
        // PageView
        view.addSubview(page.view)
        
        // Options bar
        view.addSubview(optionsBar)
        
        // Constraints
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Navigation bar
            navigation.leftButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            navigation.topAnchor.constraint(equalTo: view.topAnchor),
            navigation.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigation.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            // PageView
            page.view.topAnchor.constraint(equalTo: navigation.rightButton.bottomAnchor, constant: 16),
            page.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            page.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            page.view.bottomAnchor.constraint(equalTo: optionsBar.topAnchor, constant: -16),
            
            // Options bar
            optionsBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            optionsBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            optionsBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: View life cycle
    
    // MARK: Actions
    
    func optionButtonAction(option: MenuPageType) -> () -> () {
        let action = { [weak self] in
            guard let self = self else { return }
            self.changePage(from: self.selectedPage.rawValue, to: option.rawValue)
            self.navigation.titleButton.setTitle(option.name, for: .normal)
            self.selectedPage = option
        }
        return action
    }
    
    // MARK: Navigation
    
    func changePage(from: Int, to: Int) {
        if from > to {
            page.setViewControllers([pages[to]], direction: .reverse, animated: true, completion: nil)
        } else if from < to {
            page.setViewControllers([pages[to]], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: Delegate
    
    var pages: [UIViewController] = []
    
    public func addPage(_ controller: UIViewController) {
        pages.append(controller)
        page.addChild(controller)
    }
    
}

//extension MenuController: UIPageViewControllerDelegate {
//
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        guard completed else { return }
//        guard let controller = pageViewController.viewControllers?.first else { return }
//        guard let index = pages.firstIndex(of: controller) else { return }
//
//        switch index {
//        case MenuPageType.create.rawValue:
//            createButton.sendActions(for: .primaryActionTriggered)
//        case MenuPageType.memories.rawValue:
//            memoriesButton.sendActions(for: .primaryActionTriggered)
//        case MenuPageType.settings.rawValue:
//            settingsButton.sendActions(for: .primaryActionTriggered)
//        default:
//            break
//        }
//    }
//
//}
//
//extension MenuController: UIPageViewControllerDataSource {
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let index = pages.firstIndex(of: viewController) else { return nil }
//
//        if index > 0 {
//            return pages[index - 1]
//        } else {
//            return nil
//        }
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let index = pages.firstIndex(of: viewController) else { return nil }
//
//        if index < pages.count - 1 {
//            return pages[index + 1]
//        } else {
//            return nil
//        }
//    }
//
//}

class a1: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .white
    }
    
}

class a2: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .black
    }
    
}

class a3: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .red
    }
    
}
