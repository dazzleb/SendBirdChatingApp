//
//  RootVIewController.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/12.
//


// 사용자가 입력한 아이디 담아두기
//        reactor
//            .state
//            .bind(onNext: { self.openChatReact.currentUserIdentifier.accept($0.userIdentifier)})
//            .disposed(by: disposeBag)

// 사용자가 입력한 닉네임 담아두기
//        reactor
//            .state
//            .bind(onNext: { self.openChatReact.currentUserNickName.accept($0.userNickName)})
//            .disposed(by: disposeBag)


import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import ReactorKit
class RootViewController : UIViewController, StoryboardView {
    
    var disposeBag :DisposeBag = DisposeBag()
//    let openChatReact = OpenChatReactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.reactor = OpenChatReactor()
    }
    
    func bind(reactor: OpenChatReactor) {
        // Action
        
        // 아이디 입력 액션
        inputToUserIDTextFiled.rx.text.orEmpty
            .map { Reactor.Action.userInputIdentifier(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 닉네임 입력 액션
        inputToUserNameTextFiled.rx.text.orEmpty
            .map { Reactor.Action.userInputNickName(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 로그인 버튼 클릭 액션
        connetToChannelBtn.rx.tap
            .map { _ in Reactor.Action.connectSendBirdChannelButtonTapped }
            .debug("🎉")
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        
        // 버튼 활성화
        reactor
            .state
            .map { $0.buttonEnable }
            .bind(to: self.connetToChannelBtn.rx.isEnabled)
            .disposed(by: disposeBag)
    
        // 접속l + 닉네임 변경이 잘 됐다면 다음 뷰로 이동
        reactor
            .state
            .bind(onNext: { ok in
                if ok.connectToServer{
                    
                    let currentUserName = self.reactor?.currentState.userNickName ?? ""
                    let userIdentifier = self.reactor?.currentState.userIdentifier ?? ""
    
                    let nextVC = ChannelViewController(userNickname: currentUserName, userIdentifier: userIdentifier)
                    self.navigationController?.viewControllers = [nextVC]
                }else{
                    print(#fileID, #function, #line, "아직 이동 하지 못합니다." )
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: UI
    
    private lazy var titleTextLabel : UILabel = {
        let titleTextLabel = UILabel()
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextLabel.text = "Connet to Chating Room.\n 🦄"
        titleTextLabel.textAlignment = .center
        titleTextLabel.numberOfLines = 0
        titleTextLabel.font = .systemFont(ofSize: 58, weight: .heavy)
        titleTextLabel.textColor = .purple.withAlphaComponent(0.3)
        return titleTextLabel
    }()
    private lazy var inputToUserIDTextFiled : UITextField = {
        let inputToUserIDTextFiled = UITextField()
        inputToUserIDTextFiled.translatesAutoresizingMaskIntoConstraints = false
        inputToUserIDTextFiled.placeholder = "존재하지 않는 아이디라면 자동생성 됩니다."
        inputToUserIDTextFiled.textAlignment = .center
        inputToUserIDTextFiled.layer.borderWidth = 2
        inputToUserIDTextFiled.clipsToBounds = true
        inputToUserIDTextFiled.layer.cornerRadius = 10
        inputToUserIDTextFiled.layer.borderColor = UIColor.purple.withAlphaComponent(0.2).cgColor
        return inputToUserIDTextFiled
    }()
    private lazy var inputToUserNameTextFiled : UITextField = {
        let inputToUserNameTextFiled = UITextField()
        inputToUserNameTextFiled.translatesAutoresizingMaskIntoConstraints = false
        inputToUserNameTextFiled.placeholder = "참여 이름은 한글자 이상이여야 합니다."
        inputToUserNameTextFiled.textAlignment = .center
        inputToUserNameTextFiled.layer.borderWidth = 2
        inputToUserNameTextFiled.layer.borderColor = UIColor.purple.withAlphaComponent(0.2).cgColor
        inputToUserNameTextFiled.clipsToBounds = true
        inputToUserNameTextFiled.layer.cornerRadius = 10
        return inputToUserNameTextFiled
    }()
    private lazy var veticalJoinBoxStackView : UIStackView = {
        let veticalJoinBoxStackView = UIStackView()
        veticalJoinBoxStackView.translatesAutoresizingMaskIntoConstraints = false
        veticalJoinBoxStackView.axis = .vertical
        veticalJoinBoxStackView.alignment = .fill
        veticalJoinBoxStackView.distribution = .fillEqually
        veticalJoinBoxStackView.spacing = 10
        
        //        veticalJoinBoxStackView.layer.shadowColor = UIColor.purple.cgColor // 그림자 색상
        //        veticalJoinBoxStackView.layer.shadowOffset = CGSize(width: 3, height: 5) // 그림자 위치
        //        veticalJoinBoxStackView.layer.shadowOpacity = 0.2 // 그림자 투명도
        //        veticalJoinBoxStackView.layer.shadowRadius = 4 // 그림자 반경
        //        veticalJoinBoxStackView.layer.shadowColor = UIColor.black.cgColor
        veticalJoinBoxStackView.layer.shadowOpacity = 0.5
        veticalJoinBoxStackView.layer.shadowOffset = CGSize(width: 10, height: 15)
        veticalJoinBoxStackView.layer.shadowRadius = 4
        veticalJoinBoxStackView.layer.masksToBounds = false
        
        return veticalJoinBoxStackView
    }()
    private lazy var connetToChannelBtn : UIButton = {
        let connetToChannelBtn = UIButton()
        connetToChannelBtn.translatesAutoresizingMaskIntoConstraints = false
        //활성화 모습
        connetToChannelBtn.setTitle("🚀 It's time to chating", for: .normal )
        connetToChannelBtn.setTitleColor(UIColor.purple, for: .normal)
        connetToChannelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        connetToChannelBtn.layer.borderColor = UIColor.purple.withAlphaComponent(0.2).cgColor
        connetToChannelBtn.backgroundColor = .white
        
        connetToChannelBtn.layer.shadowColor = UIColor.purple.cgColor // 그림자 색상
        connetToChannelBtn.layer.shadowOffset = CGSize(width: 3, height: 5) // 그림자 위치
        connetToChannelBtn.layer.shadowOpacity = 0.2 // 그림자 투명도
        connetToChannelBtn.layer.shadowRadius = 4 // 그림자 반경
        
        connetToChannelBtn.layer.borderWidth = 2
        connetToChannelBtn.layer.cornerRadius = 10
        //        connetToChannelBtn.clipsToBounds = true
        connetToChannelBtn.isEnabled = false
        //비활성화 모습
        connetToChannelBtn.setTitle("🚀 It's time to chating", for: .disabled )
        connetToChannelBtn.setTitleColor(UIColor.gray, for: .disabled)
        return connetToChannelBtn
    }()
    func configureUI(){
        
        view.backgroundColor = .white
        
        veticalJoinBoxStackView.addArrangedSubview(inputToUserIDTextFiled)
        veticalJoinBoxStackView.addArrangedSubview(inputToUserNameTextFiled)
        view.addSubview(titleTextLabel)
        view.addSubview(veticalJoinBoxStackView)
        view.addSubview(connetToChannelBtn)
        NSLayoutConstraint.activate([
            titleTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextLabel.bottomAnchor.constraint(equalTo: veticalJoinBoxStackView.topAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            inputToUserIDTextFiled.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            veticalJoinBoxStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            veticalJoinBoxStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            veticalJoinBoxStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
        NSLayoutConstraint.activate([
            connetToChannelBtn.topAnchor.constraint(equalTo: veticalJoinBoxStackView.bottomAnchor, constant: 25),
            connetToChannelBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            connetToChannelBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            connetToChannelBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
