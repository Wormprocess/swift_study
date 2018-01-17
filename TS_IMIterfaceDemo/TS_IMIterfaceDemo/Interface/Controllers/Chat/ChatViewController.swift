//
//  ChatViewController.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/9.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit
import PINCache
import PINRemoteImage
import TZImagePickerController
import UITableView_FDTemplateLayoutCell
import SnapKit

class ChatViewController: UIViewController {

    private let textCellIdentifier = "cell_identifier_text"
    private let textMeCellIdentifier = "cell_identifier_text_me"
    private let photoCellIdentifier = "cell_identifier_photo"
    private let photoMeCellIdentifier = "cell_identifier_photo_me"
    private var currentUserId = AccountAPI.shared.account?.id ?? ""
    private var groupInfo: [String : [MessageItem]] = [:]
    private var groupSort: [String] = []
    private var selectedMessage: MessageItem?
    
    private var conversationId : String?
    private var conversation: ConversationItem?
    private var user: User?
    
    private var isDidAppear = false
    private var isShowedKeyboard = false
    private var currentContentOffsetY: CGFloat = 0.0
    
    private var heightConstraint: Constraint?
    private var bottomConstraint: Constraint?
    private var textViewHeight: CGFloat = 34.0

    private var tableview: UITableView!
    
    private var chatKeyView: ChatKeyView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDidAppear = true
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        isDidAppear = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createUI()
        prepareTableview()
        fetchData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboradWillChangFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(messageDidChange(_:)), name: Notification.Name.MessageDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func fetchData() {
        if let conversation = self.conversation {
            conversationId = conversation.id
            renderInfo(avatarUrl: conversation.iconUrl, identityNumber: conversation.userIdentityNumber, name: conversation.name)
            
            DispatchQueue.global().async {
                [weak self] in
                let messages = MessageDAO.shared.getMessages(conversationId: conversation.id)
                self?.timeGroupingHandle(messages)
                DispatchQueue.main.async {
                    self?.tableview.reloadData()
                    self?.scrollToBottom(false)
                }
                
            }
        } else if let user = self.user {
            renderInfo(avatarUrl: user.avatar_url, identityNumber: user.identity_number, name: user.full_name)
            DispatchQueue.global().async { [weak self] in
                if let conversationId = ConversationDAO.shared.getConversationIdIfExists(userId: user.id) {
                    self?.conversationId = conversationId
                    let messages = MessageDAO.shared.getMessages(conversationId: conversationId)
                    self?.timeGroupingHandle(messages)
                    DispatchQueue.main.async {
                        self?.tableview.reloadData()
                        self?.scrollToBottom(false)
                    }
                } else {
                    self?.conversationId = ConversationDAO.shared.addContactCoversation(name: user.full_name, iconUrl: user.avatar_url, userId: user.id)
                }
            }
        }
    }
    
    private func renderInfo(avatarUrl: String, identityNumber: String, name: String){
        title = name
    }
    
    private func scrollToBottom(_ animated: Bool){
        guard let lastKey = groupSort.last, let array = groupInfo[lastKey] else {
            return
        }
        
        let indexPath = IndexPath(row: array.count - 1, section: groupSort.count - 1)
        tableview.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
    }
    
    func timeGroupingHandle(_ messages: [MessageItem]) {
        let formatter = DateFormatter(dateFormat: "yyyyMMdd")
        formatter.locale = Locale.current
        
        for item in messages {
            var array = groupInfo[formatter.string(from: item.createdAt)] ?? []
            array.append(item)
            groupInfo[formatter.string(from: item.createdAt)] = array
        }
        groupSort = groupInfo.keys.sorted(by: <)
    }
    
    func createUI() {
        self.title = conversation?.name
        
        let bg = UIImageView(image: #imageLiteral(resourceName: "ic_chat_bg"))
        view.addSubview(bg)
        
        bg.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableview = UITableView(frame: CGRect.zero, style: .plain)
        tableview.backgroundColor = UIColor.clear
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 100;
        tableview.estimatedSectionHeaderHeight = 20;
        tableview.sectionHeaderHeight = 30
        tableview.sectionFooterHeight = 10
        
        tableview.estimatedSectionFooterHeight = 0;
        if #available(iOS 11.0, *) {
            tableview.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(tableview)
        
        chatKeyView = ChatKeyView(frame: CGRect.zero)
        chatKeyView.delegate = self
        
        view.addSubview(chatKeyView)
        chatKeyView.addLayout()
        tableview.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(chatKeyView.snp.top).offset(0)
        }

        chatKeyView.snp.makeConstraints { (make) in
           
            self.bottomConstraint = make.bottom.equalTo(view.snp.bottom).offset(0).constraint
            self.heightConstraint = make.height.equalTo(49.0).constraint
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    class func instance(conversation: ConversationItem? = nil, user: User? = nil) -> UIViewController {
        let chat: ChatViewController = ChatViewController();
        chat.conversation = conversation
        chat.user = user
        return chat;
    }
    
    override func viewDidLayoutSubviews() {
        if #available(iOS 11.0, *) {
            self.heightConstraint?.update(offset: textViewHeight + 15 + view.safeAreaInsets.bottom)
        }
    }
    
    @objc func messageDidChange(_ sender: Notification){
        
    }
    
}

extension ChatViewController {
    @objc func keyboradWillChangFrame(_ sender: NSNotification){
        guard let info = sender.userInfo else {
            return
        }
        
        guard let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        
        guard let beginKeyBoardRect = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        guard let endKeyboardRect =  (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        guard isDidAppear else {
            return
        }
        print("contentOffset-\(tableview.contentOffset.y)")
        UIView.animate(withDuration: duration, animations: {
            self.showOrHideKeyboard(beginKeyBoardRect, endKeyboardRect)
        })
    }
    
    func showOrHideKeyboard(_ beginKeyboardRect: CGRect, _ endKeyboardRect: CGRect) {
        let bounds = UIScreen.main.bounds
        
        print("开始\(beginKeyboardRect)--结束\(endKeyboardRect)")
        let safeBottom: CGFloat = getChatKeyBotom()
        
        if endKeyboardRect.origin.y == bounds.height || endKeyboardRect.origin.y == bounds.width {
            self.bottomConstraint?.update(offset: 0)
            
            isShowedKeyboard = false
            let tableViewHeight = view.bounds.height - beginKeyboardRect.height - chatKeyView.frame.height
            if (tableview.contentSize.height > tableViewHeight) {
                if (tableview.contentSize.height < tableViewHeight) {
                    tableview.contentOffset = CGPoint.zero
                } else {
                    
                    tableview.contentOffset = CGPoint(x: 0, y: currentContentOffsetY - beginKeyboardRect.height + safeBottom)
                }
            }
        } else {
            if #available(iOS 11.0, *) {
                self.bottomConstraint?.update(offset: view.safeAreaInsets.bottom - endKeyboardRect.height)
            } else {
                self.bottomConstraint?.update(offset: -endKeyboardRect.height)
            }
            if !isShowedKeyboard {
                currentContentOffsetY = tableview.contentOffset.y
                isShowedKeyboard = true
            }
            let tableViewHeight = view.bounds.height - endKeyboardRect.height - chatKeyView.frame.height
            if (tableview.contentSize.height > tableViewHeight) {
                if (tableview.contentSize.height < tableViewHeight) {
                    tableview.contentOffset = CGPoint.zero
                } else {
                    tableview.contentOffset = CGPoint(x: 0, y: currentContentOffsetY + endKeyboardRect.height - safeBottom)
                }
            }
            UIMenuController.shared.menuItems = nil
        }
        self.view.layoutIfNeeded()
    }
    
    
    func updateTextViewHeight(height: CGFloat, animated: Bool) {
        let dvalue = height - textViewHeight;
        textViewHeight = height;
        self.heightConstraint?.update(offset: height + 15 + getChatKeyBotom())
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.currentContentOffsetY = self.currentContentOffsetY + dvalue
                self.tableview.contentOffset = CGPoint(x: 0, y: self.currentContentOffsetY)
            })
        }
    }
    
    func getChatKeyBotom() -> CGFloat {
        let safeBottom: CGFloat
        
        if #available(iOS 11.0, *){
            safeBottom = view.safeAreaInsets.bottom
        }else{
            safeBottom = 0;
        }
        return safeBottom
    }
}

extension ChatViewController: UITableViewDataSource,UITableViewDelegate
{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentContentOffsetY = scrollView.contentOffset.y
        UIMenuController.shared.setMenuVisible(false, animated: false)
    }
    // 1659
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupSort.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array =  groupInfo[groupSort[section]] else {
            return 0
        }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = getIdentifier(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ChatCell
        cell.delegate = self
        renderCell(cell, indexpath: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: ChatTimeHeaderView = tableview.dequeueReusableHeaderFooterView(withIdentifier: "header") as! ChatTimeHeaderView
        view.render(time: groupSort[section])
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableview.dequeueReusableHeaderFooterView(withIdentifier: "footer")
        if let back = view?.backgroundView {
            back.backgroundColor = UIColor.clear
        }else{
            view?.backgroundView = UIView()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    private func prepareTableview() {
        tableview.register(ChatTimeHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "header")
        tableview.register(UITableViewHeaderFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: "footer")
        tableview.register(ChatTextCell.classForCoder(), forCellReuseIdentifier: textCellIdentifier)
        tableview.register(ChatTextCell.classForCoder(), forCellReuseIdentifier: textMeCellIdentifier)
        
        tableview.register(ChatPhotoCell.classForCoder(), forCellReuseIdentifier: photoCellIdentifier)
        tableview.register(ChatPhotoCell.classForCoder(), forCellReuseIdentifier: photoMeCellIdentifier)
    }
    
    func getIdentifier(_ index: IndexPath) -> String {
        let array = groupInfo[groupSort[index.section]] ?? []
        let message: MessageItem = array[index.row]
        let isMe = message.userId == currentUserId
        return textCellIdentifier
        switch message.type {
        case .text:
            return isMe ? textMeCellIdentifier : textCellIdentifier
        case .photo:
            return isMe ? photoMeCellIdentifier : photoCellIdentifier
        case .audio:
            return ""
        case .video:
            return ""
        default:
            return textCellIdentifier;
        }
    }
    
    func renderCell(_ cell: ChatCell, indexpath: IndexPath)  {
        UIView.setAnimationsEnabled(false)
        let array = groupInfo[groupSort[indexpath.section]] ?? []
        
        let message: MessageItem = array[indexpath.row]
        cell.render(item: message)
        
//        if indexpath.row < array.count - 1 {
//            let nextMessage = array[indexpath.row + 1]
//            let isEqual = message.userId == nextMessage.userId
//
//        }
        
        UIView.setAnimationsEnabled(true)
    }
}

extension ChatViewController: ChatCellDelegate {
    func longPressMenu(cell: ChatCell, item: MessageItem, rect: CGRect) {
        
    }
    
}

extension ChatViewController: ChatKeyViewDelegate {
    func presentPickImageVC() {
        let alc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alc.addAction(UIAlertAction(title: Localized.CHAT_ACTION_TITLE_CAMERA, style: .default, handler: { [weak self] (action) in
            self?.openCamera()
        }))
        
        alc.addAction(UIAlertAction(title: Localized.CHAT_ACTION_TITLE_ALBUM, style: .default, handler: { [weak self](action) in
            self?.openAlbum()
        }))
        
        alc.addAction(UIAlertAction(title: Localized.DIALOG_BUTTON_CANCEL, style: .cancel, handler: nil))
        
        self.present(alc, animated: true, completion: nil)
    }
    
    func sendInfomation(_ text: String) {
        
    }
    
    func upLayout(_ height: CGFloat, animated: Bool) {
        updateTextViewHeight(height: height, animated: animated)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ChatViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate{
    
    func openCamera()  {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func openAlbum()  {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        
        if let picker = TZImagePickerController.init(maxImagesCount: 9, columnNumber: 4, delegate: self) {
            picker.allowPickingGif = true
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            sendPhoto(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func sendPhoto(_ image: UIImage) {
        
    }
    
    func sendGIf(_ data: Data, size: CGSize) {
        
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: Any!) {
        
    }
    

    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingGifImage animatedImage: UIImage!, sourceAssets asset: Any!) {
        
        guard let manager = TZImageManager.default() else {
            return
        }
        
        manager.getOriginalPhotoData(withAsset: asset) { (imageData, info, isDegraded) in
            guard let data = imageData else {
                return
            }
            self.sendGIf(data, size: CGSize(width: animatedImage.size.width, height: animatedImage.size.height))
        }
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        guard photos.count > 0 else {
            return
        }
        
        for image in photos {
            sendPhoto(image)
        }
    }
    
    
}
