//
//  ViewController.swift
//  corkbored
//
//  Created by Jackson Meyer on 11/29/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollViewTexts: [String] = ["see the funniest posts and pictures by fellow students", "get involved with college campus and make friends", "crowd source information anf find people who are down to do anything with you"]
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var contentWidth:CGFloat = 300.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        loadScrollView()
        checkIfUserIsLoggedIn()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(view.frame.width))
    }

    func loadScrollView() {
        for i in 0...2 {
            let textToShow = scrollViewTexts[i]
            print(textToShow)
            
            let xcoordinate = view.frame.midX + view.frame.width * CGFloat(i)
            
            let label = UILabel()
            
            label.text = textToShow
            label.numberOfLines = 2
            label.textColor = UIColor.white
            label.textAlignment = .center
           
            scrollView.addSubview(label)
            print(scrollView.subviews)
            label.frame = CGRect(x: xcoordinate - 175, y: (view.frame.height / 2) - 50, width: view.frame.width - 16, height: view.frame.height / 2)
          
        }
        let offset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        scrollView.contentSize = CGSize(width: 1500, height: scrollView.frame.height)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid != nil {
            
             print("user logged in")
            
            perform(#selector(login), with: nil, afterDelay: 0)
            
        } else {
            
            print("user not logged in")
            
        }
}

    @objc func login() {
        performSegue(withIdentifier: "toTabViewControllerFromInitialVC", sender: self)
    }
}

