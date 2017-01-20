//
//  PageViewController.swift
//  SieveOfEratosthenes
//
//  Created by Kelly Alonso-Palt on 1/19/17.
//  Copyright © 2017 Kelly Alonso. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.getViewControllerNamed(identifier: "Unit"),
                self.getViewControllerNamed(identifier: "CompositeNumbers"),
                self.getViewControllerNamed(identifier: "Composite2"),
                self.getViewControllerNamed(identifier: "PrimeNumbers"),
                self.getViewControllerNamed(identifier: "Transition")]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        delegate = self
        //stylePageControl()
    }

    func getViewControllerNamed(identifier: String) -> UIViewController {
        let thisNextViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: identifier)
        return thisNextViewController
    }

    //MARK: - UIPageViewController DataSource
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return orderedViewControllers[nextIndex]




    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

//    private func stylePageControl() {
//
//        //let pageControl = UIPageControl.appearanceWhenContainedInInstancesOfClasses([type(of: self)])
//        let pageControl = UIPageControl()
//        self.view.bringSubview(toFront: pageControl)
//        pageControl.currentPageIndicatorTintColor = UIColor.blue
//        pageControl.pageIndicatorTintColor = UIColor.green
//        pageControl.backgroundColor = UIColor.orange
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
