//
//  CategoryTabViewController.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

class CategoriesViewController: UIViewController {

    var output: CategoriesViewOutput!
    
    var tabNavigation: CarbonTabSwipeNavigation!
    var viewControllers: [UIViewController] = []
    var selectedViewController: UIViewController!
    var categories: [Category] = []

    // MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = WHITE
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        output.viewIsReady()
    }
    
    //MARK: -  Private Methods -
    private func baseConfig() {
        var items: [String] = []
        for category in categories { items.append(category.name)  }
        
        if !items.isEmpty {
            tabNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
            tabNavigation.insertIntoRootViewController(self)
            styleTab()
        }
    }
    
    private func styleTab() {
        if let tabNavigation = tabNavigation {
            tabNavigation.setIndicatorColor(RED)
            tabNavigation.toolbar.translucent = false
            tabNavigation.setTabExtraWidth(50)
            tabNavigation.setNormalColor(BLACK.colorWithAlphaComponent(0.6))
            tabNavigation.setSelectedColor(RED, font: UIFont.boldSystemFontOfSize(14))
        }
    }
}

//MARK: - extension for CategoriesViewInput -
extension CategoriesViewController: CategoriesViewInput {
    
    func setupInitialState(viewControllers: [UIViewController], categories: [Category]) {
        self.viewControllers = viewControllers
        self.categories = categories
        
        baseConfig()
    }
}

//MARK: - extension for CarbonTabSwipeNavigationDelegate -
extension CategoriesViewController: CarbonTabSwipeNavigationDelegate {
    
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAtIndex index: UInt) -> UIViewController {
        return viewControllers[Int(index)]
    }
    
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAtIndex index: UInt) {
        selectedViewController = viewControllers[Int(index)]
        output.didSelectCategory(categories[Int(index)])
    }
}