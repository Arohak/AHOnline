//
//  TabBarViewController.swift
//  AHOnline
//
//  Created by Ara Hakobyan on 7/9/16.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class TabBarViewController -
class TabBarViewController: UITabBarController {
        
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseConfig()
    }
    
    //MARK: -  Private Methods -
    private func baseConfig() {
        addViewControllers()
        styleTab()
    }
    
    private func addViewControllers() {
        var tempViewControllers: [UIViewController] = []
        
        let homeVC = HomeViewController()
        _ = HomeModuleInitializer(viewController: homeVC)
        tempViewControllers.append(homeVC)
        
        let categoriesVC = CategoriesViewController()
        _ = CategoriesModuleInitializer(viewController: categoriesVC)
        tempViewControllers.append(categoriesVC)
        
        let cartVC = CartViewController()
        _ = CartModuleInitializer(viewController: cartVC)
        tempViewControllers.append(UINavigationController(rootViewController: cartVC))
        
        let mapVC = MapViewController()
        _ = MapModuleInitializer(viewController: mapVC)
        tempViewControllers.append(UINavigationController(rootViewController: mapVC))
        
        let accountVC = AccountViewController()
        _ = AccountModuleInitializer(viewController: accountVC)
        tempViewControllers.append(UINavigationController(rootViewController: accountVC))
        
        viewControllers = tempViewControllers
    }
    
    private func styleTab() {
        let titles = ["Home", "Categories", "Cart", "Map", "Account"]

        for (index, viewController) in viewControllers!.enumerate() {
            let title           = titles[index]
            let image           = UIImage(named: title)
            let selectedImage   = UIImage(named: "selected" + title)
            let item = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
            viewController.tabBarItem = item
        }
    }
}

//MARK: - extension for UITabBarControllerDelegate -
extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
    }
    
    func tabBarController(tabBarController: UITabBarController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
     
        return nil
    }
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return nil
    }
}