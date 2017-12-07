//
//  ToolView.swift
//  Keyboard
//
//  Created by chenwei on 2017/7/20.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit

enum ToolViewStatus {
    case none
    case text
    case audio
    case emoticon
    case more
}

private let kItemSpacing: CGFloat = 3
private let kTextViewPadding: CGFloat = 6

protocol ToolViewDelegate: class {
    
    func textViewShouldBeginEditing()
    
}

/// 输入框按钮
class ToolView: UIView {

    weak var delegate: ToolViewDelegate?
    // MARK: 属性
    var contentText: String? {
        didSet {
            inputTextView.text = contentText
        }
    }
    
    var showsKeyboard: Bool {
        get {
            return inputTextView.isFirstResponder
        }
        set {
            if newValue {
                inputTextView.becomeFirstResponder()
            } else {
                inputTextView.resignFirstResponder()
            }
        }
    }
    
    var status: ToolViewStatus = .none
    
    /// 输入框
    lazy var inputTextView: InputTextView = {
        let inputTextView = InputTextView(frame:CGRect.zero)
        inputTextView.delegate = self
        return inputTextView
    }()
    
    /// 表情按钮
    lazy var emoticonButton: UIButton = {
        let emoticonButton = UIButton(type: .custom)
        emoticonButton.autoresizingMask = [.flexibleTopMargin]
        emoticonButton.setNormalImage(self.kEmojiImage, highlighted:self.kEmojiImageHL)
        
        return emoticonButton
    }()
    
    ///更多按钮
    lazy var moreButton: UIButton = {
        let moreButton = UIButton(type: .custom)
        moreButton.autoresizingMask = [.flexibleTopMargin]
        moreButton.setNormalImage(self.kMoreImage, highlighted:self.kMoreImageHL)
        return moreButton
    }()
    

    //按钮的图片
    var kEmojiImage:UIImage = UIImage(named: "chat_toolbar_emotion")!
    var kEmojiImageHL:UIImage = UIImage(named: "chat_toolbar_emotion_HL")!
    
    //图片名称待修改
    var kMoreImage:UIImage = UIImage(named: "chat_toolbar_more")!
    var kMoreImageHL:UIImage = UIImage(named: "chat_toolbar_more_HL")!
    
    var kKeyboardImage:UIImage = UIImage(named: "chat_toolbar_keyboard")!
    var kKeyboardImageHL:UIImage = UIImage(named: "chat_toolbar_keyboard_HL")!
    
    var allowFaceView: Bool = true
    var allowMoreView: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        
        self.autoresizingMask = [UIViewAutoresizing.flexibleWidth,UIViewAutoresizing.flexibleTopMargin]
        self.backgroundColor = UIColor(hex: "#E4EBF0")
        
        addSubview(self.emoticonButton)
        addSubview(self.moreButton)
        addSubview(self.inputTextView)
        
        // 分割线
        let line = UIView()
        line.backgroundColor = UIColor(hex: "#e9e9e9")
        line.frame = CGRect(x: 0, y: self.frame.height-1, width: self.frame.width, height: 1.0/UIScreen.main.scale)
        addSubview(line)
        
        let toolBarHeight = self.height
        
        let kItem: CGFloat = 42
        let buttonSize = CGSize(width: kItem, height: kTabBarHeight)
        
        if self.allowMoreView {
            let origin = CGPoint(x: self.bounds.width-buttonSize.width, y: toolBarHeight-buttonSize.height)
            moreButton.frame = CGRect(origin: origin, size: buttonSize)
        } else {
            moreButton.frame = CGRect.zero
        }
        
        if self.allowFaceView {
            let origin = CGPoint(x: self.bounds.width-buttonSize.width*2, y: toolBarHeight-buttonSize.height)
            emoticonButton.frame = CGRect(origin: origin, size: buttonSize)
        } else {
            emoticonButton.frame = CGRect.zero
        }
        
        let textViewWidth = emoticonButton.left
        
        let height: CGFloat = 36
        inputTextView.frame = CGRect(x: 10, y: (kTabBarHeight - height)/2.0,
                                     width: textViewWidth, height: height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateStatus(_ status: ToolViewStatus) {
        
        if status == .text || status == .more {
            
            self.inputTextView.isHidden = false
            updateEmoticonButtonImage(true)

        } else if (status == .audio) {
            self.inputTextView.isHidden = true
            updateEmoticonButtonImage(true)
        } else if (status == .emoticon) {
            
            self.inputTextView.isHidden = false
            updateEmoticonButtonImage(true)
        }
        
        
    }
    
    func updateEmoticonButtonImage(_ selected: Bool) {
        self.emoticonButton.setImage(selected ? kEmojiImage:kKeyboardImage, for: .normal)
        self.emoticonButton.setImage(selected ? kEmojiImageHL:kKeyboardImageHL, for: .highlighted)
    }

}

extension ToolView : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.delegate?.textViewShouldBeginEditing()
        return true
    }
    
}




