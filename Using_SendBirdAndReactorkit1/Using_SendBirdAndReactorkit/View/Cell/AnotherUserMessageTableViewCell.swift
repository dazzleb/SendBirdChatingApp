//
//  AnotherUserMessageTableViewCell.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/14.
//

import Foundation
import UIKit

//MARK: - 사용자 메세지 쎌
class AnotherUserMessageTableViewCell : UITableViewCell {
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
        msgLabel.textColor = UIColor.purple.withAlphaComponent(0.5)
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
        self.contentView.addSubview(msgBubbleView)
        self.msgBubbleView.addSubview(msgLabel)
        self.contentView.addSubview(msgLabel)
        NSLayoutConstraint.activate([
            self.msgLabel.topAnchor.constraint(equalTo: self.msgBubbleView.topAnchor, constant: 10),
            self.msgLabel.leadingAnchor.constraint(equalTo: self.msgBubbleView.leadingAnchor, constant: 10),
            self.msgLabel.centerXAnchor.constraint(equalTo: self.msgBubbleView.centerXAnchor),
            self.msgLabel.centerYAnchor.constraint(equalTo: self.msgBubbleView.centerYAnchor),
            
            self.msgBubbleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.msgBubbleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 75),
            self.msgBubbleView.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -150),
//            self.msgBubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
            msgBubbleView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        let selectedBgView = UIView(frame: self.contentView.bounds)
        selectedBgView.backgroundColor = .systemPink.withAlphaComponent(0.2)
        self.selectedBackgroundView = selectedBgView
    }
    func configure(_ data: ChatData ){
        self.msgLabel.text = data.message
        // 이전 아이디 확인 값 이 true 일때 시간 표시 그런데 맨마지막 값에만 나오게 하는걸 어떻게하지..?
    }
}
