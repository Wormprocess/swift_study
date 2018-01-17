//
//  ChatKeyView.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/11.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit
import SnapKit

class ChatKeyView: UIView {

    private var leftBtn: UIButton!
    private var rightBtn: UIButton!
    private var sendBtn: UIButton!
    private var text: UITextView!
    private var line: UIView!
    
    private var leftBottom: Constraint?
    private var rightBottom: Constraint?
    private var sendBottom: Constraint?
    private var textBottom: Constraint?
    private var textHeight: Constraint?

    weak var delegate: ChatKeyViewDelegate?
    
    func addLayout() {
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            self.leftBottom =  make.bottom.equalTo(self).offset(0).constraint
            make.size.equalTo(CGSize(width: 49.0, height: 49.0))
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            self.rightBottom = make.bottom.equalTo(self).offset(0).constraint
            make.size.equalTo(CGSize(width: 49.0, height: 49.0))
        }
        
        sendBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            self.sendBottom = make.bottom.equalTo(self).offset(0).constraint
            make.size.equalTo(CGSize(width: 49.0, height: 49.0))
        }
        
        text.snp.makeConstraints { (make) in
            make.left.equalTo(leftBtn.snp.right).offset(0)
            make.top.equalTo(self).offset(7.5)
            make.right.equalTo(rightBtn.snp.left).offset(0)
            make.top.equalTo(self).offset(7.5)
            self.textHeight = make.height.equalTo(34.0).constraint
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(rgbValue: 0xEFEFF4)
        
        line = UIView()
        line.backgroundColor = UIColor(rgbValue: 0xCFCFCF)
        self.addSubview(line)
        
        leftBtn = UIButton()
        leftBtn.setImage(#imageLiteral(resourceName: "ic_chat_more"), for: .normal)
        leftBtn.setImage(#imageLiteral(resourceName: "ic_chat_more"), for: .highlighted)
        leftBtn.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        self.addSubview(leftBtn)
        
        rightBtn = UIButton()
        rightBtn.setImage(#imageLiteral(resourceName: "ic_chat_photo"), for: .normal)
        rightBtn.setImage(#imageLiteral(resourceName: "ic_chat_photo"), for: .highlighted)
        rightBtn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        self.addSubview(rightBtn)
        
        sendBtn = UIButton()
        sendBtn.setImage(#imageLiteral(resourceName: "ic_chat_send"), for: .normal)
        sendBtn.setImage(#imageLiteral(resourceName: "ic_chat_send"), for: .highlighted)
        sendBtn.addTarget(self, action: #selector(sendBtnAction), for: .touchUpInside)
        sendBtn.isHidden = true
        self.addSubview(sendBtn)
       
        text = UITextView()
        prepareTextView()
        self.addSubview(text)
    }
    
    func prepareTextView() {
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 1 / UIScreen.main.scale
        text.delegate = self
        text.layer.masksToBounds = true
        text.layer.cornerRadius = 34.0 / 2
        text.isScrollEnabled = false
        text.font = UIFont.systemFont(ofSize: 16.0)
        text.textContainerInset = UIEdgeInsetsMake(7, 8, 7, 8)
    }
    @available(iOS 11.0, *)
    override func safeAreaInsetsDidChange() {
        if safeAreaInsets.bottom > 0 {
            self.leftBottom?.update(offset:  -self.safeAreaInsets.bottom)
            self.rightBottom?.update(offset: -self.safeAreaInsets.bottom)
            self.sendBottom?.update(offset: -self.safeAreaInsets.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func leftBtnAction()  {
        text.resignFirstResponder()
        delegate?.presentPickImageVC()
    }
    
    @objc
    func rightBtnAction()  {
        text.resignFirstResponder()
        delegate?.presentPickImageVC()
    }
    
    
    @objc
    func sendBtnAction()  {
        text.resignFirstResponder()
        text.text = ""
        if let delegate = self.delegate {
            delegate.sendInfomation(text.text)
            
            self.textHeight?.update(offset: 34.0)
            delegate.upLayout(34.0, animated: true)
            
        }
        rightBtn.isHidden = false
        sendBtn.isHidden = true
    }
}

extension ChatKeyView: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
     
        guard let lineHeight = text.font?.lineHeight else {
            return
        }
        
        let maxRow = 6
        let maxHeight = ceilf(Float(lineHeight * CGFloat(maxRow) + text.textContainerInset.top + text.textContainerInset.bottom))
        let size = text.sizeThatFits(CGSize(width: text.bounds.size.width, height: CGFloat(MAXFLOAT)))
        let height = ceilf(Float(size.height))
        
        let currentHeight = ceilf(Float(text.bounds.height))
        
        text.isScrollEnabled = height > maxHeight && maxHeight > 0
        
        let targetHeight = text.isScrollEnabled ? maxHeight : height
        
        if currentHeight != targetHeight {
            
            if let delegate = self.delegate {
                self.textHeight?.update(offset: targetHeight)
                delegate.upLayout(CGFloat(targetHeight), animated: true)
            }
        }
        
        if text.text.count == 0 {
            rightBtn.isHidden = false
            sendBtn.isHidden = true
        }else{
            sendBtn.isHidden = false
            rightBtn.isHidden = true
        }
        
    }
}

protocol  ChatKeyViewDelegate: class{
    
    func presentPickImageVC() -> Void
    func sendInfomation(_ text: String) -> Void
    func upLayout(_ height: CGFloat, animated: Bool) -> Void
}
