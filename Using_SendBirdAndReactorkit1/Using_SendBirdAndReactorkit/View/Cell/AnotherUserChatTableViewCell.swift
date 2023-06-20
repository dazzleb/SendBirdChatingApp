//
//  AnotherUserChatTableViewCell.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/14.
//

import Foundation
import UIKit
import Kingfisher
//MARK: - 사용자 프로필이 있는 메세지 쎌
class AnotherUserChatTableViewCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //메세지, 닉네임, 발신 날짜, 프로필 이미지
    var userProfile : UIImageView = {
        let userProfile = UIImageView()
        userProfile.translatesAutoresizingMaskIntoConstraints = false
        userProfile.layer.cornerRadius = 30
        userProfile.clipsToBounds = true
        return userProfile
    }()
    /// 닉네임
    var userName : UILabel = {
        let userName = UILabel()
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.font = .systemFont(ofSize: 15, weight: .black)
        userName.text = "화이팅"
        return userName
    }()
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
    
    
    /// profile img
    
    private func configureUI(){
        
        self.userInfoStack.addArrangedSubview(userName)
        self.userInfoStack.addArrangedSubview(createdTime)
        
        self.contentView.addSubview(userProfile)
        self.contentView.addSubview(userInfoStack)
        self.contentView.addSubview(msgBubbleView)
        
        NSLayoutConstraint.activate([
            userProfile.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            userProfile.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            userProfile.heightAnchor.constraint(equalToConstant: 60),
            userProfile.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            userInfoStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            userInfoStack.leadingAnchor.constraint(equalTo: self.userProfile.trailingAnchor, constant: 10)
        ])
        
        self.msgBubbleView.addSubview(msgLabel)
        NSLayoutConstraint.activate([
            msgLabel.topAnchor.constraint(equalTo: self.msgBubbleView.topAnchor, constant: 10),
            msgLabel.leadingAnchor.constraint(equalTo: self.msgBubbleView.leadingAnchor, constant: 10),
            msgLabel.centerXAnchor.constraint(equalTo: self.msgBubbleView.centerXAnchor),
            msgLabel.centerYAnchor.constraint(equalTo: self.msgBubbleView.centerYAnchor),
            
            msgBubbleView.topAnchor.constraint(equalTo: self.userInfoStack.bottomAnchor, constant: 5),
            msgBubbleView.leadingAnchor.constraint(equalTo: self.userProfile.trailingAnchor, constant: 10),
            // 최대 커질 수 있는 크기 제한
            msgBubbleView.trailingAnchor.constraint(lessThanOrEqualTo:  self.contentView.trailingAnchor, constant: -150),
//            msgBubbleView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
            msgBubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
//        createdTime.isHidden = false
        let selectedBgView = UIView(frame: self.contentView.bounds)
        selectedBgView.backgroundColor = .systemPink.withAlphaComponent(0.2)
        self.selectedBackgroundView = selectedBgView
    }
    func configure(_ data: ChatData ) {
        userName.text = data.nickName
        createdTime.text = showTime(inputTime: data.created)
        msgLabel.text = data.message
        if let imageURL = URL(string: data.profileImage){
//            print(#fileID, #function, #line, "\(imageURL)" )
            userProfile.kf.setImage(with: imageURL)
        }
        // 이전 아이디 확인 값 이 false 일때 시간 표시
//        let inputTime = data.nextMsgTimestamp ?? ""
//        let now = data.created
//        /// 이전 쳇 과 현재 쳇의 시간의 차이가 나면 쇼타임 히든
//        createdTime.isHidden = Date.checkTimeGapInAMinute(from: now, to: inputTime)
    }

}
