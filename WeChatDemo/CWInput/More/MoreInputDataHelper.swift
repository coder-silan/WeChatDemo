//
//  MoreInputDataHelper.swift
//  CWWeChat
//
//  Created by wei chen on 2017/8/30.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit

class MoreInputDataHelper: NSObject {

    /// 更多键盘item的数组
    var chatMoreKeyboardData: [MoreItem] = [MoreItem]()
    
    override init() {
        
        super.init()
        //创建数据
        let titleArray = ["照片", "相机"]
        let imageArray = ["moreKB_image", "moreKB_video"]
        
        for i in 0..<titleArray.count {
            let type = MoreItemType(rawValue: i)!
            let item = MoreItem(title: titleArray[i], imagename: imageArray[i], type: type)
            chatMoreKeyboardData.append(item)
        }
        
    }
    
}
