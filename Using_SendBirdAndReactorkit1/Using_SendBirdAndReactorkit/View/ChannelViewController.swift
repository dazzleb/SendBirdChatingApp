//
//  ChannelViewController.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/12.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import ReactorKit

class ChannelViewController : UIViewController, StoryboardView {
    var disposeBag :DisposeBag = DisposeBag()
    typealias Reactor = OpenChatReactor
    
    // 테이블 리스트 스토어
    var tempList : [ChatData] = [] {
        didSet{
            print(#fileID, #function, #line, "- tempList.count: \(tempList.count)")
        }
    }
    // 테이블 뷰  스크롤 제어기
    var shouldScrollToBottom : Bool = false
    
    init(userNickname: String,
         userIdentifier: String) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = OpenChatReactor(userNickname: userNickname, userIdentifier: userIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: OpenChatReactor) {
        // Action
    
        // 채팅 룸 입장액션
        rx.sentMessage(#selector(viewWillAppear(_:)))
            .map{_ in Reactor.Action.receivedChat }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 텍스트 입력 액션
        inputTextField.rx.text.orEmpty
            .map { Reactor.Action.userInputText(text: $0 ) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 텍스트 전송 버튼
        sendBtn.rx.tap
            .map { _ in
                self.inputTextField.text = ""
               return Reactor.Action.sendButtonTapped
            }.bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map({
                $0.updateChatData
            })
            .distinctUntilChanged({ previous , current in
                let c = current.0.id
                let p = previous.0.id
                if c == p {
                    return true
                }else {
                    return false
                }
            })
            .filter{ $0.0.userId.count > 0}
            .observe(on: MainScheduler.instance)
//            .debug("⭐️ updateChatData")
            .subscribe(onNext: { [weak self] chatData in
                guard let self = self else { return }
                let chat = chatData.0 // 챗
                let indexPath = chatData.1 // 인덱스

                let appendingIndexPath = IndexPath(row: self.tempList.count, section: 0)

                self.tempList.append(chat)
                // 이전 셀 업데이트
                self.updatePreviousMsgNextTimestamp(chat.created, indexPath)
                
                print(#fileID, #function, #line, "✅ 이번에 들어온 인덱스 \(indexPath)✅ appendingIndexPath: \(appendingIndexPath)" )
                
//                self.tableView.reloadData()
                
                self.tableView.insertRows(at: [appendingIndexPath], with: .fade) // 행이 먼저 있어야 한다
                
                print(#fileID, #function, #line, "✅ 최신 테이블 데이터 \(self.tempList)✅" )
                
                if self.shouldScrollToBottom {
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }).disposed(by: disposeBag)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        self.tableView.register(MyChatTableCell.self, forCellReuseIdentifier: "MyChatTableCell")
        self.tableView.register(MyMessageTableViewCell.self, forCellReuseIdentifier: "MyMessageTableViewCell")
        self.tableView.register(AnotherUserMessageTableViewCell.self, forCellReuseIdentifier: "AnotherUserMessageTableViewCell")
        self.tableView.register(AnotherUserChatTableViewCell.self, forCellReuseIdentifier: "AnotherUserChatTableViewCell")
        self.tableView.register(AnotherImgTypeCell.self, forCellReuseIdentifier: "AnotherImgTypeCell")
        self.tableView.register(AnotherIFirstmgTypeCell.self, forCellReuseIdentifier: "AnotherIFirstmgTypeCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.inputTextField.delegate = self
        
        /// 테이블 뷰 300 이상 부터는 아래로 x
        tableView.rx.bottomOffset
            .map{ !($0 > 300.0) }
            .bind(to: self.rx.shouldScrollToBottom)
            .disposed(by: disposeBag)
        
        /// 데이터 셀 클릭
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { vc, indexPath in
                vc.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: UI
     lazy var logOutItem : UIBarButtonItem = {
        let logOutItem = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(logoutButtonDidTap))
        logOutItem.tintColor = UIColor.purple.withAlphaComponent(0.7)
        return logOutItem
    }()
    
     lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

     lazy var inputTextField : UITextView = {
        let inputTextField = UITextView()
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.font = .systemFont(ofSize: 17, weight: .regular)
        inputTextField.textAlignment = .left
        inputTextField.layer.borderWidth = 2
        inputTextField.layer.borderColor = UIColor.purple.withAlphaComponent(0.2).cgColor
        inputTextField.clipsToBounds = true
        inputTextField.layer.cornerRadius = 10
        return inputTextField
    }()
    
     lazy var sendBtn : UIButton = {
        let sendBtn = UIButton(type: .system)
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.setTitle("💬 입력 전송", for: .normal )
        sendBtn.setTitleColor(UIColor.white, for: .normal)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        sendBtn.layer.borderColor = UIColor.purple.withAlphaComponent(0.2).cgColor
        sendBtn.backgroundColor = UIColor.purple.withAlphaComponent(0.2)
        sendBtn.clipsToBounds = true
        sendBtn.layer.cornerRadius = 8
        sendBtn.layer.shadowColor = UIColor.purple.cgColor // 그림자 색상
        sendBtn.layer.shadowOffset = CGSize(width: 3, height: 5) // 그림자 위치
        sendBtn.layer.shadowOpacity = 0.2 // 그림자 투명도
        sendBtn.layer.shadowRadius = 4 // 그림자 반경
        
        sendBtn.contentEdgeInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        return sendBtn
    }()
     lazy var bottomStackView : UIStackView = {
        let bottomStackView = UIStackView()
        bottomStackView.translatesAutoresizingMaskIntoConstraints  = false
        bottomStackView.spacing = 10
        bottomStackView.axis = .horizontal
        return bottomStackView
    }()

    func configureUI(){
        view.backgroundColor = .white
        self.tableView.separatorColor = .white
        
        self.navigationItem.rightBarButtonItems = [logOutItem]
        bottomStackView.addArrangedSubview(inputTextField)
        bottomStackView.addArrangedSubview(sendBtn)
        
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendBtn.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        self.view.addSubview(tableView)
        self.view.addSubview(bottomStackView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            bottomStackView.heightAnchor.constraint(equalToConstant: 50),
            bottomStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bottomStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    // 화면 이전으로
    @objc
    func logoutButtonDidTap() {
        let beforeVC = RootViewController()
        self.navigationController?.viewControllers = [beforeVC]
    }
    
}
/// 테이블 뷰 바닥과 현재 위치의 차이
extension Reactive where Base: UITableView {
    
    var bottomOffset : Observable<CGFloat> {
        return self.contentOffset
            .map { cgPoint -> CGFloat in
                
                let bottomEdge = self.base.contentSize.height + self.base.contentInset.bottom - self.base.bounds.height
                
                let bottomOffset = bottomEdge - cgPoint.y
                return bottomOffset
            }
    }
}


//MARK: - Helpers
extension ChannelViewController {
    
//    private func getPreviousMsg(_ indexPath: IndexPath) -> ChatData? {
//        guard tempList.count > 0 else { return nil }
//        return self.tempList[indexPath.row - 1]
//    }
    
    private func updatePreviousMsgNextTimestamp(_ currentMsgTimestamp: String,
                                                _ indexPath: IndexPath) {
        guard tempList.count > 0,
              indexPath.row > 0
        else { return }
        

        let previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        
        self.tempList[previousIndexPath.row].nextMsgTimestamp = currentMsgTimestamp
        
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [previousIndexPath], with: .fade)
        }
        
    }

}
