//
//  ViewController.swift
//  WeChatDemo
//
//  Created by maomao on 2017/12/6.
//  Copyright © 2017年 maomao. All rights reserved.
//

import UIKit

class ViewController: CWBaseMessageController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        //背景图
        if let path = Bundle.main.path(forResource: "chat_background", ofType: "png") {
            let imageView = UIImageView(frame: self.view.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(contentsOfFile: path)
            self.collectionView.backgroundView = imageView
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

