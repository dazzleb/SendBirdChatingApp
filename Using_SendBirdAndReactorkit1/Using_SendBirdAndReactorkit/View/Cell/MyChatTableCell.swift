//
//  MyChatTableCell.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/14.
//

import Foundation
import UIKit

/// 내가 보낸 채팅
class MyChatTableCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 메세지, 닉네임, 발신 날짜
    /// 닉네임
    
    /// 보낸 시간
    var createdTime : UILabel = {
        let createdTime = UILabel()
        createdTime.translatesAutoresizingMaskIntoConstraints = false
        createdTime.font = .systemFont(ofSize: 14, weight: .light)
        createdTime.textColor = UIColor.black.withAlphaComponent(0.7)
        createdTime.text = "1234123124"
        return createdTime
    }()
    /// 유저 스택
    var userInfoStack : UIStackView = {
        let userInfoStack = UIStackView()
        userInfoStack.translatesAutoresizingMaskIntoConstraints = false
        userInfoStack.axis = .horizontal
        userInfoStack.spacing = 5
        return userInfoStack
    }()
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

    private func configureUI() {
        self.contentView.addSubview(msgBubbleView)
        self.contentView.addSubview(userInfoStack)
        self.userInfoStack.addArrangedSubview(createdTime)
        self.msgBubbleView.addSubview(msgLabel)
        NSLayoutConstraint.activate([
//            userInfoStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            userInfoStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            userInfoStack.trailingAnchor.constraint(equalTo: self.msgBubbleView.leadingAnchor, constant: -15),
//            userInfoStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
//            userInfoStack.heightAnchor.constraint(equalToConstant: 100)
//            userInfoStack.leadingAnchor.constraint(equalTo: self.msgBubbleView.leadingAnchor, constant: 5)
        ])
        NSLayoutConstraint.activate([
            msgLabel.topAnchor.constraint(equalTo: self.msgBubbleView.topAnchor, constant: 10),
            msgLabel.leadingAnchor.constraint(equalTo: self.msgBubbleView.leadingAnchor, constant: 10),
            msgLabel.centerXAnchor.constraint(equalTo: self.msgBubbleView.centerXAnchor),
            msgLabel.centerYAnchor.constraint(equalTo: self.msgBubbleView.centerYAnchor),
            
//            msgBubbleView.topAnchor.constraint(equalTo: self.userInfoStack.bottomAnchor, constant: 5),
            msgBubbleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            msgBubbleView.leadingAnchor.constraint(greaterThanOrEqualTo:  self.contentView.leadingAnchor, constant: 100),
            // 최대 커질 수 있는 크기 제한
            msgBubbleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            //            msgBubbleView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
            self.msgBubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
        
        let selectedBgView = UIView(frame: self.contentView.bounds)
        selectedBgView.backgroundColor = .systemPink.withAlphaComponent(0.2)
        self.selectedBackgroundView = selectedBgView

        createdTime.isHidden = false
    }

    func configure(_ data: ChatData) {
        msgLabel.text = data.message
        createdTime.text = showTime(inputTime: data.created)
        
        // 다음 메세지의 시간 차가 1분이라면
        // 시간표시를 숨긴다
//        guard let inputTime = data.nextMsgTimestamp else { return }
//
        let inputTime = data.nextMsgTimestamp ?? ""
        let now = data.created
        /// 이전 쳇 과 현재 쳇의 시간의 차이가 나면 쇼타임 히든
        createdTime.isHidden = Date.checkTimeGapInAMinute(from: now, to: inputTime)
    }

}
