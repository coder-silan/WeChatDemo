//
//  UIImage+Extension.swift
//  CWWeChat
//
//  Created by chenwei on 16/6/22.
//  Copyright © 2016年 chenwei. All rights reserved.
//

/*
 https://github.com/AliSoftware/SwiftGen 在电脑上安装这个工具，自动生成 Asset 的 image enum 的 Extension
 切换到xcassets所在的文件夹
 命令：swiftgen images path
 */

typealias CWAsset = Asset

#if os(iOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

enum Asset: String {
  //case Applogo = "Applogo"
  case Button_disable = "button_disable"
  case Button_normal = "button_normal"
  case Button_select = "button_select"
  case Chat_toolbar_emotion = "chat_toolbar_emotion"
  case Chat_toolbar_emotion_HL = "chat_toolbar_emotion_HL"
  case Chat_toolbar_keyboard = "chat_toolbar_keyboard"
  case Chat_toolbar_keyboard_HL = "chat_toolbar_keyboard_HL"
  case Chat_toolbar_more = "chat_toolbar_more"
  case Chat_toolbar_more_HL = "chat_toolbar_more_HL"
  case Default_head = "default_head"
  case Receiver_background_highlight = "receiver_background_highlight"
  case Receiver_background_normal = "receiver_background_normal"
  case Sender_background_highlight = "sender_background_highlight"
  case Sender_background_normal = "sender_background_normal"


  var image: Image {
    return Image(asset: self)
  }
}

extension Image {
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}
