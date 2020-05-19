//
//  ViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit
import TwitterProfile

class ViewController : UIViewController, UIScrollViewDelegate, TPDataSource, TPProgressDelegate {
    
    var headerVC: HeaderViewController?
    
    let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //implement data source to configure tp controller with header and bottom child viewControllers
        //observe header scroll progress with TPProgressDelegate
        self.tp_configure(with: self, delegate: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func handleRefreshControl() {
        print("refreshing")
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.refresh.endRefreshing()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //MARK: TPDataSource
    func headerViewController() -> UIViewController {
        headerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HeaderViewController") as? HeaderViewController
        return headerVC!
    }
    
    func bottomViewController() -> UIViewController & PagerAwareProtocol {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XLPagerTabStripExampleViewController") as! XLPagerTabStripExampleViewController
        //        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomPageContainerViewController") as! BottomPageContainerViewController
        return vc
    }
    
    //headerHeight in the closed range [minValue, maxValue], i.e. minValue...maxValue
    func headerHeight() -> ClosedRange<CGFloat> {
        return (topInset + 44)...300
    }
    
    //MARK: TPProgressDelegate
    func tp_scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat) {
        headerVC?.update(with: progress, headerHeight: headerHeight())
    }
    
    func tp_scrollViewDidLoad(_ scrollView: UIScrollView) {
        
        refresh.tintColor = .white
        refresh.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        let refreshView = UIView(frame: CGRect(x: 0, y: 44, width: 0, height: 0))
        scrollView.addSubview(refreshView)
        refreshView.addSubview(refresh)

    }
}


extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
