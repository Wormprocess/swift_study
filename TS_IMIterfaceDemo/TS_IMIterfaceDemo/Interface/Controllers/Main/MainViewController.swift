//
//  ViewController.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/5.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController{
    
    private lazy var tableview: UITableView = {
        
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate   = self;
        table.dataSource = self;
        table.rowHeight  = 78;
        table.register(ConversationCells.self, forCellReuseIdentifier: "ConversationCells")
        table.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageDidChange(_:)), name: NSNotification.Name.MessageDidChange, object: nil)
        return table
    }()
    
    private lazy var conversations = ConversationDAO.shared.conversationList()
    
    var leftBaritem : UIBarButtonItem!

    @objc func leftBaritmAction() {
        print("哈哈")
    }
    
    @objc func messageDidChange(_ sender: Notification){
        
        conversations = ConversationDAO.shared.conversationList()
        tableview.reloadData()
    }
    
    func cofiigureNavItem()  {
        self.title = "信息"
        leftBaritem = UIBarButtonItem(title: "left", style: .plain, target: self, action:#selector(leftBaritmAction))
        self.navigationItem.leftBarButtonItem = leftBaritem
        
        for view in (self.navigationController?.navigationBar.subviews)! {
            view.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cofiigureNavItem()
        view.addSubview(tableview)
        tableview.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        if #available(iOS 11.0, *) {
            tableview.contentInsetAdjustmentBehavior = .never
        }else{
            automaticallyAdjustsScrollViewInsets = false
        }
        
//        let shapelayer: CAShapeLayer = CAShapeLayer()
//        shapelayer.frame = CGRect(x: 0, y: 160, width: 320, height: 320);
//        shapelayer.backgroundColor = UIColor.cyan.cgColor
//        view.layer.addSublayer(shapelayer)
//
//        let bzi = UIBezierPath()
//        bzi.move(to: CGPoint(x: 160, y: 160))
//        for i in 1..<10000 {
//
//            bzi.addLine(to: CGPoint(x: 160 + 140 * sin(CGFloat(13.0 * Float(i) / 10 * Float.pi / 180)), y: 160 + 140 * sin(CGFloat(18.0 * Float(i) / 10 * Float.pi / 180))))
//
//        }
//        shapelayer.lineWidth = 0.5
//        shapelayer.strokeColor = UIColor.red.cgColor
//        shapelayer.fillColor = UIColor.clear.cgColor
//        shapelayer.path = bzi.cgPath
//        shapelayer.strokeEnd = 0
//
//        let anmation = CABasicAnimation(keyPath: "strokeEnd")
//        anmation.duration = 30
//        anmation.toValue = 1.0
//
//        shapelayer.add(anmation, forKey: nil)
    }

}

extension MainViewController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCells") as! ConversationCells
        cell.sender(item: conversations[indexPath.row])
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mess: ConversationItem = conversations[indexPath.row]
            self.navigationController?.pushViewController(ChatViewController.instance(conversation: mess), animated: true)
    }
}

