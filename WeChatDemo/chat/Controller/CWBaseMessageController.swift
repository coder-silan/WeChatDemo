//
//  CWBaseMessageController.swift
//  CWWeChat
//
//  Created by wei chen on 2017/7/15.
//  Copyright © 2017年 cwcoder. All rights reserved.
//

import UIKit
import CWActionSheet
import PGImagePicker
import PGImagePickerKingfisher
import Kingfisher

public class CWBaseMessageController: UIViewController {
    
    // 显示时间
    var messageList: [CWMessageModel] = [CWMessageModel]()
    
    var keyboard: CWChatKeyboard = CWChatKeyboard()

    lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0,
                           width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-kTabBarHeight)
        let layout = CWMessageViewLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.register(CWMessageCell.self, forCellWithReuseIdentifier: CWMessageType.none.identifier)
        collectionView.register(CWMessageCell.self, forCellWithReuseIdentifier: CWMessageType.text.identifier)
        collectionView.register(CWMessageCell.self, forCellWithReuseIdentifier: CWMessageType.image.identifier)
        
        collectionView.register(CWMessageCell.self, forCellWithReuseIdentifier: CWMessageType.emoticon.identifier)
        collectionView.register(CWMessageCell.self, forCellWithReuseIdentifier: CWMessageType.location.identifier)
        collectionView.register(CWMessageCell.self, forCellWithReuseIdentifier: CWMessageType.voice.identifier)

        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadMessageData()
    }
    
    func setupUI() {
        self.view.addSubview(collectionView)
        
        var groupList = [EmoticonGroup]()
        if let qqemoticon = EmoticonGroup(identifier: "com.apple.emoji") {
            qqemoticon.type = .normal
            groupList.append(qqemoticon)
        }
        
        keyboard.delegate = self
        keyboard.emoticonInputView.loadData(groupList)
        keyboard.moreInputView.delegate = self
        keyboard.associateTableView = collectionView
        self.view.addSubview(keyboard)
    }
    
    func loadMessageData() {
//        self.conversation.fetchMessagesStart { (list, error) in
//            if error == nil {
//                let messageList = self.formatMessages(list)
//                self.messageList.append(contentsOf: messageList)
//                self.collectionView.reloadData()
//                self.updateMessageAndScrollBottom(false)
//            }
//        }
    }
    
    func formatMessages(_ messages: [CWMessage]) -> [CWMessageModel] {
        
        var messageModelList = [CWMessageModel]()
        for message in messages {
            // TODO: 添加时间分割显示
            
            let messageModel = CWMessageModel(message: message)
            messageModelList.append(messageModel)
        }
        return messageModelList
    }

    deinit {
      
        NotificationCenter.default.removeObserver(self)
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension CWBaseMessageController {
    /// 滚动到底部
    public func updateMessageAndScrollBottom(_ animated:Bool = true) {
        if messageList.count == 0 {
            return
        }
        let indexPath = IndexPath(row: messageList.count-1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }
    
}

extension CWBaseMessageController: CWMessageViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, itemAt indexPath: IndexPath) -> CWMessageModel {
        return messageList[indexPath.row]
    }
}

extension CWBaseMessageController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message = messageList[indexPath.row]
        let identifier = message.messageType.identifier
        let messageCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CWMessageCell
        messageCell.delegate = self
        messageCell.refresh(message: message)
        return messageCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        keyboard.keyboardDown()
    }
}

extension CWBaseMessageController: CWMessageCellDelegate {
    
    func messageCellDidTap(_ cell: CWMessageCell) {
        
        guard let message = cell.message else {
            return
        }
        
        switch message.messageType{
        case .image:
            
            chatImageClick(message: message)
            
        default:
           // log.debug("其他类型")
            print("其他类型")
        }
    }
    
    func messageCellResendButtonClick(_ cell: CWMessageCell) {
        
    }
    
    /// 头像点击的回调方法
    func messageCellUserAvatarDidClick(_ userId: String) {
        //log.debug("cell头像 点击...\(userId)")

    }
    
    /// 大图点击的回调方法
    func chatImageClick(message: CWMessageModel) {
        
        let imagebody:CWImageMessageBody = message.messageBody as! CWImageMessageBody
        
        if message.isSend{
            
            let imageView = UIImageView()
            imageView.kf.setImage(with:URL(fileURLWithPath: imagebody.originalLocalPath as Any as! String))
            
            let imagePicker = PGImagePicker(currentImageView: imageView)
            present(imagePicker, animated: false, completion: nil)
            
        }else{
            
           // print(imagebody.originalURL as Any)
            let url:String = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1512733184643&di=fb91a68edf106fddd03c16a6ef8da2b3&imgtype=0&src=http%3A%2F%2Fattachments.gfan.com%2Fforum%2Fattachments2%2Fday_111124%2F11112420337ad0f91dbfd042d3.jpg"
            
            imagebody.originalURL = URL(string: url)
            let imageView = UIImageView()
            //必须得有image 且image有size  不然会报错
            imageView.kf.setImage(with:imagebody.originalURL, placeholder: UIImage(named: "default_head"))
            
            let imagePicker = PGImagePickerKingfisher(currentImageView: imageView, imageViews: [imageView])
            imagePicker.imageUrls = [url]
            imagePicker.indicatorType = .activity
            // imagePicker.placeholder = UIImage(named: "projectlist_06")
            present(imagePicker, animated: false, completion: nil)
        }
    }
    
    func messageCellDidTap(_ cell: CWMessageCell, link: URL) {
        
        let viewController = ChatWebViewController(URLString: link)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func messageCellDidTap(_ cell: CWMessageCell, phone: String) {
        let title = "\(phone)可能是一个电话号码，你可以"
        let otherButtonTitle = ["呼叫","复制号码","添加到手机通讯录"]
        
        let clickedHandler = { (actionSheet: ActionSheetView, index: Int) in
            
            if index == 0 {
                let phoneString = "telprompt://\(phone)"
                guard let URL = URL(string: phoneString) else {
                    return
                }
                UIApplication.shared.openURL(URL)
            } else if index == 1 {
                UIPasteboard.general.string = phone
            }
        }
        
        let actionSheet = ActionSheetView(title: title, 
                                          cancelButtonTitle: "取消", 
                                          otherButtonTitles: otherButtonTitle,
                                          clickedHandler: clickedHandler)
        
        
        actionSheet.show()
    }
    
}



