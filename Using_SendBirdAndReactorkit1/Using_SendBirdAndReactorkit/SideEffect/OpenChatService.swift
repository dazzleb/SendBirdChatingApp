//
//  OpenChatService.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/13.
//

import Foundation
import SendbirdChatSDK
import RxSwift
import RxCocoa
import RxRelay

final class OpenChatService : NSObject, OpenChannelDelegate {
    static let shared = OpenChatService()
    var disposeBag : DisposeBag = DisposeBag()
    let nickNameUpdateParam = UserUpdateParams()
    // BehaviorRelay는 현재 값을 유지하면서 새로운 값을 방출하고,
    // PublishRelay는 현재 값을 유지하지 않고 새로운 값을 즉시 방출합니다.
    let showTimeUpdateRelay = BehaviorRelay(value: "")
//    let fileManager = FileManager.default // 싱글톤 인스터스
    /// 전달될 쳇
    var showChatData : PublishRelay<(ChatData, IndexPath)> = PublishRelay()
//    var showChatData : BehaviorRelay<(ChatData, IndexPath)> = BehaviorRelay(value: (ChatData.init(id: "", nickName: "", profileImage: "", message: "", created: 0), IndexPath(row: 0, section: 0)) )
    ///  쳇 리스트
    var receivedChatList : BehaviorRelay<[ChatData]> = BehaviorRelay(value: [])
    
    override init(){
        super.init()
        SendbirdChat.addChannelDelegate(self, identifier: "OpenChanneService")
        
    }// init
    
    //MARK: 접속
    func connetToSendbirdChannel(userID: String) ->Observable<Bool>  {
        
        let connectToChannel = Observable.create { observer -> Disposable in
                SendbirdChat.connect(userId: userID) { user, error in
                    if let user = user, error == nil {
                        print("✅ 채널 접속 완료 \(user.userId)")
                        observer.onNext(true)
                    } else {
                        observer.onNext(false)
                    }
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        
        let connectToChatRoom = Observable.create { observer -> Disposable in
            OpenChannel.getChannel(url: "sendbird_open_channel_10800_ea35f4af7a2a365d8a3ce5f3788d51414482b521") { channel, error in
                guard let channel = channel, error == nil else { return }
                channel.enter { error in
                    guard error == nil else { return }
                    print("✅ 채팅방 접속 완료")
                    observer.onNext(true)
                    observer.onCompleted()
                }
                
            }
            return Disposables.create()
        }
            
        return connectToChannel.flatMap { _ in connectToChatRoom }

    }
    
    //MARK: 닉네임 변경
    func updaterUserNN(nickname: String) -> Observable<Bool> {
        self.nickNameUpdateParam.nickname = nickname
        print("✅ 닉네임 변경 완료\(nickname)")
        return Observable.create { observer -> Disposable in
            
            SendbirdChat.updateCurrentUserInfo(params: self.nickNameUpdateParam, completionHandler: { err in
               
                if err != nil {
                    observer.onNext(false)
                } else {
                    observer.onNext(true)
                }
                observer.onNext(true)
            })
            return Disposables.create()
        }
        
        }//updaterUserNN
    /// 입력 메세지 sendbird 로 보내기
    func sendToMsg(_  chat: String, _ userId: String, _ userName: String) {
        
        OpenChannel.getChannel(url: "sendbird_open_channel_10800_ea35f4af7a2a365d8a3ce5f3788d51414482b521") { channel, error in
            guard let channel = channel, error == nil else {
                // Handle error.
                return
            }
            channel.sendUserMessage(chat) { message, error in
                guard let message = message, error == nil else {
                    // Handle error.
                    return
                }
            }// channel
            
//            channel.sendFileMessage(params: <#T##FileMessageCreateParams#>, completionHandler: <#T##FileMessageHandler?##FileMessageHandler?##(_ message: FileMessage?, _ error: SBError?) -> Void#>)
        }// openChanel
    // 입력된 챗
    var receiveNewChats = self.receivedChatList.value
    let priviousUserId = receiveNewChats.last?.userId ?? "" // 이전 아이디
    let currentTime = currentTime()
    // 챗 자체로 보내면 chat 이 let 이여서 수정 불가
        let newChat = ChatData(id: UUID().uuidString, userId: userId,
                           nickName: userName,
                           profileImage: "",
                           message: chat,
                           created: currentTime,
                           showtime: "방금",
                           fileName: "",
                           fileURL: "",
                           fileType: "",
                           previousMsgUserId: priviousUserId,
                           isMyChat: true)
    // 입력된 챗
    receiveNewChats.append(newChat)

    let row = receiveNewChats.count - 1
    let indexPath = IndexPath(row: row, section: 0)
        
    self.receivedChatList.accept(receiveNewChats) // 서버 와 내가 입력한 모든 테이블 의 요소 저장소  업데이트
    self.showChatData.accept((newChat,indexPath)) // 테이블 에 보여줄 한줄의 쳇 업데이트
    }// sendToMsg
}
/// 현재 시간 : 현재 시간 을 연도 시간 분 초 로 스트링 형태로 변환 해서 반환
private func currentTime() -> String {

    let dateFormatter = DateFormatter()
    let now = Date()
    
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // created: "2023-06-18 19:47:44"
    return dateFormatter.string(from: now)
}

/// 서버에서 들어 오는 시간 형태 변환기
private func timeTransform(time: Int64) -> String { // 1687085458604
    // 서버에서 들어오는 시간 Int64 를 연도 시간 분 초 로 스트링 형태로 변환
    let date = Date(timeIntervalSince1970: TimeInterval(time / 1000))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: date)
}
/// 폴더 만들기
//private func makeFolder() {
//    let documenetURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    let directoryURL = documenetURL.appendingPathComponent("DownLoadFile")
//    do {
//        try self.fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: false, attributes: nil)
//    } catch let err {
//        print(#fileID, #function, #line, "\(err.localizedDescription )")
//    }
//}
extension OpenChatService {
   
    /// 다른 유저로 부터 들어오는 메세지
    func channel(_ sender: BaseChannel, didReceive message: BaseMessage) {

        if message is UserMessage {

            if let userMsg = message as? UserMessage {
                
                let senderProfileImage = userMsg.sender?.profileURL ?? ""
                let senderIdentifier = userMsg.sender?.id ?? ""
                let senderNickName = userMsg.sender?.nickname ?? ""
                let priviousMsgUserIdentifier = self.receivedChatList.value.last?.userId ?? ""
                let senderMsgCreatedAt : Int64 = userMsg.createdAt // 1687085458604
                let createdAt = timeTransform(time: senderMsgCreatedAt)
                var showTimecreated : String = "방금"
//                let aaa = showTime(inputTime: "2023-06-18 19:47:44")
//                print(#fileID, #function, #line, "✅반환값 체크  : \(aaa)" )
//                print(#fileID, #function, #line, "✅시간 체크 : \(senderMsgCreatedAt)" )
                // userMsg.createdAt 를 포메터에 넣고 created 에 주기
                let anotherChatData = ChatData(id: userMsg.messageId.description, userId: senderIdentifier,
                                               nickName: senderNickName,
                                               profileImage: senderProfileImage,
                                               message: userMsg.message,
                                               created: createdAt,
                                               showtime: showTimecreated,
                                               fileName: "",
                                               fileURL: "",
                                               fileType: "",
                                               previousMsgUserId: priviousMsgUserIdentifier,
                                               isMyChat: false)
               
                var receiveNewChatList = receivedChatList.value
                receiveNewChatList.append(anotherChatData)

                let row = receiveNewChatList.count - 1
                let indexPath = IndexPath(row: row, section: 0)
                
                self.receivedChatList.accept(receiveNewChatList)
                self.showChatData.accept((anotherChatData,indexPath))
                
            }
            
        }
        else if message is FileMessage {
            if let userFiled = message as? FileMessage {
                // 서버에서 들어오는 파일
                // 테이블 에 표현될 이미지 URL 과 이름  chatData 에 담아 저장
               
//                let fileManager = FileManager.default // 싱글톤 인스터스
               
//                let sender = userFiled.sender?.id ?? ""
//                print(#fileID, #function, #line, "✅ 파일이름: \(fileName)" ) // msk_6099e16b4078f.JPG
//                print(#fileID, #function, #line, "✅ 파일주소: \(fileURL)" ) // https://file-ap-2.sendbird.com/dc4c5eb3ab414f2aad7fd3299daf246b.jpg?auth=cBkBzIY4aTv2jCyV-z9XiIK3r_uQb4qi9WqVMJpVwMnECPIDEhL71KAobmRF5SsRo1Y0wLqhsagvUwdC1pn4-A
               
                let senderProfileImage = userFiled.sender?.profileURL ?? ""
                let senderIdentifier = userFiled.sender?.id ?? ""
                let senderNickName = userFiled.sender?.nickname ?? ""
                let priviousMsgUserIdentifier = self.receivedChatList.value.last?.userId ?? "" // 또  셀 두개 만들어야 하나..?
                let senderMsgCreatedAt : Int64 = userFiled.createdAt // 1687085458604
                let createdAt = timeTransform(time: senderMsgCreatedAt)
                var showTimecreated : String = "방금"
                
                let fileName = userFiled.name
                let fileType = userFiled.type
                let fileURL = userFiled.url
                print(#fileID, #function, #line, "✅ 파일타입: \(fileURL)" ) // image/jpeg
                
                // userMsg.createdAt 를 포메터에 넣고 created 에 주기
                let anotherChatData = ChatData(id: userFiled.messageId.description, userId: senderIdentifier,
                                               nickName: senderNickName,
                                               profileImage: senderProfileImage,
                                               message: "",
                                               created: createdAt,
                                               showtime: showTimecreated,
                                               fileName: fileName,
                                               fileURL: fileURL,
                                               fileType: fileType,
                                               previousMsgUserId: priviousMsgUserIdentifier,
                                               isMyChat: false)
               
                var receiveNewChatList = receivedChatList.value
                receiveNewChatList.append(anotherChatData)

                let row = receiveNewChatList.count - 1
                let indexPath = IndexPath(row: row, section: 0)
                
                self.receivedChatList.accept(receiveNewChatList)
                self.showChatData.accept((anotherChatData,indexPath))
                
                
//                let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                documentsURL.appendingPathComponent(fileName)
//                let fileLocalURL = URL(string: fileURL)
                
                // 어차피 테이블 데이터 는 ChatData 만 받으니까 ChatData 에 추가로 정보 더만들어서 거기다가 저장하면 되겠네
                
                
            }
        }
//        else if message is AdminMessage {
//            print(#fileID, #function, #line, "⭐️⭐️⭐️⭐️" )

//        }
    }
}
