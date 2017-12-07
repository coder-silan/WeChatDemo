//
//  CWChatToolBar.swift
//  CWWeChat
//
//  Created by chenwei on 2017/4/1.
//  Copyright © 2017年 cwcoder. All rights reserved.
//

import UIKit
import YYText

/// toolBar代理事件
public protocol CWChatToolBarDelegate: NSObjectProtocol {

    func chatToolBar(_ chatToolBar: CWChatToolBar, voiceButtonPressed select: Bool, keyBoardState change:Bool)
    func chatToolBar(_ chatToolBar: CWChatToolBar, emoticonButtonPressed select: Bool, keyBoardState change:Bool)
    func chatToolBar(_ chatToolBar: CWChatToolBar, moreButtonPressed select: Bool, keyBoardState change:Bool)

    ///发送文字
    func chatToolBar(_ chatToolBar: CWChatToolBar, sendText text: String)
}

public class CWChatToolBar: UIView {

    weak var delegate: CWChatToolBarDelegate?
    /// 临时记录输入的textView
    var currentText: String?
    var previousTextViewHeight: CGFloat = 36
    
    // MARK: 属性
    /// 输入框
    lazy var inputTextView: CWInputTextView = {
        let inputTextView = CWInputTextView(frame:CGRect.zero)
        inputTextView.delegate = self
        return inputTextView
    }()

    /// 表情按钮
    lazy var emoticonButton: UIButton = {
        let emoticonButton = UIButton(type: .custom)
        emoticonButton.autoresizingMask = [.flexibleTopMargin]

        emoticonButton.setNormalImage(self.kEmojiImage, highlighted:self.kEmojiImageHL)
        emoticonButton.addTarget(self, action: #selector(handelEmotionClick(_:)), for: .touchDown)
        return emoticonButton
    }()
    
    ///更多按钮
    lazy var moreButton: UIButton = {
        let moreButton = UIButton(type: .custom)
        moreButton.autoresizingMask = [.flexibleTopMargin]
        moreButton.setNormalImage(self.kMoreImage, highlighted:self.kMoreImageHL)
        moreButton.addTarget(self, action: #selector(handelMoreClick(_:)), for: .touchDown)
        return moreButton
    }()
    
    var allowFaceView: Bool = true
    var allowMoreView: Bool = true

    var faceSelected: Bool {
        return self.emoticonButton.isSelected
    }
    
    var moreSelected: Bool {
        return self.moreButton.isSelected
    }

 
    var kEmojiImage:UIImage = CWAsset.Chat_toolbar_emotion.image
    var kEmojiImageHL:UIImage = CWAsset.Chat_toolbar_emotion_HL.image
    
    //图片名称待修改
    var kMoreImage:UIImage = CWAsset.Chat_toolbar_more.image
    var kMoreImageHL:UIImage = CWAsset.Chat_toolbar_more_HL.image
    
    var kKeyboardImage:UIImage = CWAsset.Chat_toolbar_keyboard.image
    var kKeyboardImageHL:UIImage = CWAsset.Chat_toolbar_keyboard_HL.image
    
    //MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        self.autoresizingMask = [UIViewAutoresizing.flexibleWidth,UIViewAutoresizing.flexibleTopMargin]
        self.backgroundColor = UIColor.white
        
        addSubview(self.emoticonButton)
        addSubview(self.moreButton)
        addSubview(self.inputTextView)
        
        setupFrame()
        self.kvoController.observe(self.inputTextView, keyPath: "contentSize", options: .new, action: #selector(layoutAndAnimateTextView))
        setupTopLine()
    }
    
    func setupFrame() {
        let toolBarHeight = self.height
        
        let kItem: CGFloat = 42
        let buttonSize = CGSize(width: kItem, height: kTabBarHeight)
        
        if self.allowMoreView {
            let origin = CGPoint(x: kSCREEN_WIDTH-buttonSize.width, y: toolBarHeight-buttonSize.height)
            moreButton.frame = CGRect(origin: origin, size: buttonSize)
        } else {
            moreButton.frame = CGRect.zero
        }
        
        if self.allowFaceView {
            let origin = CGPoint(x: kSCREEN_WIDTH-buttonSize.width*2, y: toolBarHeight-buttonSize.height)
            emoticonButton.frame = CGRect(origin: origin, size: buttonSize)
        } else {
            emoticonButton.frame = CGRect.zero
        }
        
        let textViewX = 10.0
        let textViewWidth = emoticonButton.left - 15
        
        let height = self.textViewLineHeight()
        inputTextView.frame = CGRect(x: CGFloat(textViewX), y: (kTabBarHeight - height)/2.0,
                                     width: textViewWidth, height: height)
    }
    
    
    func setupTopLine() {
        let line = UIView()
        line.width = self.width
        line.height = YYTextCGFloatFromPixel(1)
        line.backgroundColor = UIColor(hex: "#e9e9e9")
        line.autoresizingMask = .flexibleWidth
        self.addSubview(line)
    }

    public func setTextViewContent(_ content: String) {
        self.currentText = content
        self.inputTextView.text = content
    }
    
    public func clearTextViewContent() {
        self.currentText = ""
        self.inputTextView.text = ""
    }
    
    func beginInputing() {
        self.inputTextView.becomeFirstResponder()
    }
    
    func endInputing() {

        emoticonButton.isSelected = false
        moreButton.isSelected = false

    }
    
    func prepareForBeginComment() {
        
    }
    
    func prepareForEndComment() {
        
    }

    @objc func handelVoiceClick(_ sender: UIButton) {
        self.emoticonButton.isSelected = false
        self.moreButton.isSelected = false

        var keyBoardChanged = true
        if sender.isSelected {
            if inputTextView.isFirstResponder == false {
                keyBoardChanged = false
            }
            self.adjustTextViewContentSize()
            self.inputTextView.resignFirstResponder()
        } else {
            self.resumeTextViewContentSize()
            self.inputTextView.becomeFirstResponder()
        }
        
        UIView.animate(withDuration: 0.2) { 
            self.inputTextView.isHidden = sender.isSelected
        }
        self.delegate?.chatToolBar(self, voiceButtonPressed: sender.isSelected, keyBoardState: keyBoardChanged)
    }
    
    @objc func handelEmotionClick(_ sender: UIButton) {
        self.emoticonButton.isSelected = !self.emoticonButton.isSelected
        self.moreButton.isSelected = false
        
        var keyBoardChanged = true
        if sender.isSelected {
            if inputTextView.isFirstResponder == false {
                keyBoardChanged = false
            }
            self.inputTextView.resignFirstResponder()
        } else {
            self.inputTextView.becomeFirstResponder()
        }
        
        self.resumeTextViewContentSize()

        UIView.animate(withDuration: 0.2) {
            self.inputTextView.isHidden = false
        }
        self.delegate?.chatToolBar(self, emoticonButtonPressed: sender.isSelected, keyBoardState: keyBoardChanged)
        
    }
    
    @objc func handelMoreClick(_ sender: UIButton) {
        self.moreButton.isSelected = !self.moreButton.isSelected
        self.emoticonButton.isSelected = false
        
        var keyBoardChanged = true
        if sender.isSelected {
            if inputTextView.isFirstResponder == false {
                keyBoardChanged = false
            }
            self.inputTextView.resignFirstResponder()
        } else {
            self.inputTextView.becomeFirstResponder()
        }
        
        self.resumeTextViewContentSize()
        
        UIView.animate(withDuration: 0.2) {
            self.inputTextView.isHidden = false
        }
        self.delegate?.chatToolBar(self, moreButtonPressed: sender.isSelected, keyBoardState: keyBoardChanged)
    }
    
    // MARK: 功能
    func resumeTextViewContentSize() {
        self.inputTextView.text = self.currentText
    }
    
    func adjustTextViewContentSize() {
        self.currentText = self.inputTextView.text
        self.inputTextView.text = ""
        
        inputTextView.contentSize = CGSize(width: inputTextView.width,
                                           height: self.textViewLineHeight())
    }
    
    // MARK: 高度变化
    @objc func layoutAndAnimateTextView() {
        
        let maxHeight = self.textViewLineHeight() * 4
        let contentHeight = ceil(inputTextView.sizeThatFits(inputTextView.size).height)
    
        let isShrinking = contentHeight < self.previousTextViewHeight
        var changeInHeight = contentHeight - self.previousTextViewHeight
        
        let result = self.previousTextViewHeight == maxHeight || inputTextView.text.count == 0
        if !isShrinking && result {
            changeInHeight = 0
        } else {
            changeInHeight = min(changeInHeight, maxHeight-self.previousTextViewHeight)
        }
        if changeInHeight != 0 {
            
            UIView.animate(withDuration: 0.25, animations: { 
                
                if !isShrinking {
                    self.adjustTextViewHeightBy(changeInHeight)
                }
                
                let inputViewFrame = self.frame
                self.frame = CGRect(x: 0, 
                                    y: inputViewFrame.minY - changeInHeight,
                                    width: inputViewFrame.width,
                                    height: inputViewFrame.height + changeInHeight)
                
                if isShrinking {
                    self.adjustTextViewHeightBy(changeInHeight)
                }
            })
            self.previousTextViewHeight = min(contentHeight, maxHeight)
        }
        
        if self.previousTextViewHeight == maxHeight {

            DispatchQueueDelay(0.01, task: { 
                let bottomOffset = CGPoint(x: 0.0, y: contentHeight - self.inputTextView.bounds.height)
                self.inputTextView.setContentOffset(bottomOffset, animated: true)
            
            })
            
        }
        
    }
    
    func adjustTextViewHeightBy(_ changeInHeight: CGFloat) {
        
        let prevFrame = self.inputTextView.frame
        let numLines = self.inputTextView.numberOfLinesOfText()
        
        self.inputTextView.frame = CGRect(x: prevFrame.minX,
                                          y: prevFrame.minY,
                                          width: prevFrame.width, 
                                          height: prevFrame.height + changeInHeight)
       
        if numLines > 6 {
            self.inputTextView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0)
        } else {
            self.inputTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        if numLines > 6 {
            
        }
    }
    
    //MARK: 计算高度
    func textViewLineHeight() -> CGFloat {
        return 36.0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK: - UITextViewDelegate
extension CWChatToolBar: UITextViewDelegate {
    // 开始编辑的时候
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        emoticonButton.isSelected = false
        moreButton.isSelected = false
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            sendCurrentTextViewText()
            return false
        }
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        self.currentText = textView.text
        
    }
    
    ///发送文字
    func sendCurrentTextViewText() {
        delegate?.chatToolBar(self, sendText: self.inputTextView.text)
        self.currentText = ""
    }
    
}
