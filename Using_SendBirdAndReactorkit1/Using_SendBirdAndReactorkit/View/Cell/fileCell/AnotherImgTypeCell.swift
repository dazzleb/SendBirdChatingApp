//
//  ImgCell.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/20.
//

import Foundation
import UIKit
import Kingfisher
// 상대가 보낸 이미지 셀 : 이미지 셀은 연속 보내기 상관 안할거다.
class AnotherImgTypeCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 말풍선
    var msgBubbleView : UIView = {
        let msgBubbleView = UIView()
        msgBubbleView.translatesAutoresizingMaskIntoConstraints = false
        msgBubbleView.backgroundColor = UIColor.purple.withAlphaComponent(0.1)
        msgBubbleView.layer.cornerRadius = 8
        msgBubbleView.clipsToBounds = true
        
//        msgBubbleView.layer.shadowColor = UIColor.blue.cgColor
//        msgBubbleView.layer.shadowOpacity = 0.3
//        msgBubbleView.layer.shadowOffset = CGSize(width: 9, height: 10)
//        msgBubbleView.layer.shadowRadius = 4
        msgBubbleView.layer.masksToBounds = false
        
        return msgBubbleView
    }()
    //보낸 이미지
    var userSenderImg : UIImageView = {
        let userSenderImg = UIImageView()
        userSenderImg.translatesAutoresizingMaskIntoConstraints = false
        userSenderImg.layer.cornerRadius = 13
        userSenderImg.clipsToBounds = true
        return userSenderImg
    }()
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

    private func configureUI() {
        self.contentView.addSubview(userSenderImg)
        NSLayoutConstraint.activate([
            userSenderImg.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            userSenderImg.leadingAnchor.constraint(equalTo:  self.contentView.leadingAnchor, constant: 70),
            userSenderImg.trailingAnchor.constraint(lessThanOrEqualTo:  self.contentView.trailingAnchor, constant: -50),
            userSenderImg.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            userSenderImg.heightAnchor.constraint(equalToConstant: 300)
        ])
        let selectedBgView = UIView(frame: self.contentView.bounds)
        selectedBgView.backgroundColor = .systemPink.withAlphaComponent(0.2)
        self.selectedBackgroundView = selectedBgView
    }
    func configure(_ data: ChatData) {
        userName.text = data.nickName
        createdTime.text = showTime(inputTime: data.created)
        if let profileURL = URL(string: data.profileImage){
            userProfile.kf.setImage(with: profileURL)
        }
        if let senderImgURL = URL(string: data.fileURL){
            userSenderImg.kf.setImage(with: senderImgURL)
         
        }
        print("✅파일URL:\(data.fileURL)")
    }
}
