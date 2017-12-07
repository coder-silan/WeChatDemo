//
//  Const.swift
//  Clue_Global
//
//  Created by maomao on 2017/11/24.
//  Copyright © 2017年 王璇. All rights reserved.
//

import Foundation
import UIKit
/* 屏幕的宽 */
public let kSCREEN_WIDTH  = UIScreen.main.bounds.size.width
/* 屏幕的高 */
public let kSCREEN_HEIGHT  = UIScreen.main.bounds.size.height
/* 屏幕的宽 */
public let kMAIN_BOUNDS: CGRect = UIScreen.main.bounds

/* 是否为iPhone X */
let isIphoneX = kSCREEN_HEIGHT == 812 ? true : false
/* 导航栏高度 */
let kNavigationH:CGFloat =  isIphoneX ? 88.0 : 64.0
/* 工具栏高度 */
let kTabBarHeight:CGFloat = isIphoneX ? 49.0 + 34.0 : 49.0

//设备信息
/// Swift获取唯一标识
var uniqueString = ProcessInfo.processInfo.globallyUniqueString

