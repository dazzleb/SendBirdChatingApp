//
//  MyMessageTableViewCell.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/14.
//

import Foundation
import UIKit
class MyMessageTableViewCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 메세지 텍스트
    var msgLabel : UILabel = {
        let msgLabel = UILabel()
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        msgLabel.textColor = UIColor.blue.withAlphaComponent(0.5)
        msgLabel.numberOfLines = 0
        return msgLabel
    }()
    /// 말풍선
    var msgBubbleView : UIView = {
        let msgBubbleView = UIView()
        msgBubbleView.translatesAutoresizingMaskIntoConstraints = false
        msgBubbleView.backgroundColor = UIColor.purple.withAlphaComponent(0.1)
        msgBubbleView.layer.cornerRadius = 8
        msgBubbleView.clipsToBounds = true
        
        msgBubbleView.layer.shadowColor = UIColor.blue.cgColor
        msgBubbleView.layer.shadowOpacity = 0.3
        msgBubbleView.layer.shadowOffset = CGSize(width: 9, height: 10)
        msgBubbleView.layer.shadowRadius = 4
        msgBubbleView.layer.masksToBounds = false
        
        return msgBubbleView
    }()
    private func configureUI(){
        self.msgBubbleView.addSubview(msgLabel)
        self.contentView.addSubview(msgBubbleView)
        NSLayoutConstraint.activate([
            self.msgLabel.topAnchor.constraint(equalTo: self.msgBubbleView.topAnchor, constant: 10),
            self.msgLabel.leadingAnchor.constraint(equalTo: self.msgBubbleView.leadingAnchor, constant: 10),
            self.msgLabel.centerXAnchor.constraint(equalTo: self.msgBubbleView.centerXAnchor),
            self.msgLabel.centerYAnchor.constraint(equalTo: self.msgBubbleView.centerYAnchor),
            
            self.msgBubbleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 55),
            self.msgBubbleView.leadingAnchor.constraint(greaterThanOrEqualTo:  self.contentView.leadingAnchor, constant: 100),
            // 최대 커질 수 있는 크기 제한
            msgBubbleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            msgBubbleView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    func configure(_ data: ChatData ) {
        self.msgLabel.text = data.message
    }
}
