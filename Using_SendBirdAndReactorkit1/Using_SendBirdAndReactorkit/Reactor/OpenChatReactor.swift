//
//  OpenChatReactor.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/12.
//

import Foundation
import ReactorKit
import RxSwift
import RxRelay
// 뷰 -> 액션(1,2,3) -> 리액터 -> mutate -> reduce -> state
final class OpenChatReactor: Reactor {
    let userIdentifier = BehaviorRelay(value: "")
    let userNickName = BehaviorRelay(value: "")
    
    // 사용자로 부터 들어오는 액션
    // Action is an user interaction
    enum Action {
        case userInputIdentifier(text: String)
        case userInputNickName(text: String)
        case connectSendBirdChannelButtonTapped // 센드버드 채널 입장 버튼
        case receivedChat
        case userInputText(text: String) // 사용자 글 입력
        case sendButtonTapped // 사용자 글 보내기
    }
    
    // 사용자로 부터 들어오는 액션을 토대로
    // 상태를 바꾸는 로직처리
    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        case userInputIdentifierText(text: String) // 아이디 입력 업데이트
        case userInputNickNameText(text: String) // 이름 입력 업데이트
        case connetToChannel(isOk: Bool) // 채널 접속 확인
        case userInputText(text: String) //  유저가 입력한 채팅
        case receivedChat(chat: (ChatData, IndexPath))
        case msgSent
        // 챗 데이터 리스트를 여기에 저장 해서 받아오기 도 가능
    }
    
    // 화면에 보여주는 최종결과
    // State is a current view state
    struct State {
        var userIdentifier : String // 입력된 id
        var userNickName : String
        var connectToServer : Bool // 접속 여부 확인
        var buttonEnable : Bool
        var userInputChatText : String // 사용자 채팅 입력 글
        var updateChatData : (ChatData, IndexPath) // 업데이트 된 챗
    }
    
    var initialState: State
    
    init(userNickname: String = "",
         userIdentifier: String = "") {
        print(#fileID, #function, #line, "- OpenChatReactor init")
        self.initialState = State(
            userIdentifier: userIdentifier,
            userNickName: userNickname,
            connectToServer: false,
            buttonEnable: false,
            userInputChatText: "", // 사용자가 직접 입력한 채팅
            //  들어오는 챗 업데이트
            updateChatData: ( ChatData(id: UUID().uuidString,
                                       userId: "",
                                       nickName: "",
                                       profileImage: "",
                                       message: "",
                                       created: "",
                                       showtime: "",
                                       fileName: "",
                                       fileURL: "",
                                       fileType: ""
                                      ),
                              IndexPath(row: 0, section: 0))
            
        )
    }
    
    // 비즈니스 로직처리
    // 액션 -> 비즈니스 로직처리 + (사이드 이펙트, API, 서비스 레벨)
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        // 아이디 입력
        case .userInputIdentifier(let text):
            return Observable
                .just(text)
                .map {
                    return Mutation.userInputIdentifierText(text: $0)
                }
            
        // 닉네임 입력
        case .userInputNickName(let text):
            return Observable
                .just(text)
                .map { Mutation.userInputNickNameText(text: $0) }
            
        // 접속 버튼 로직
        case .connectSendBirdChannelButtonTapped:
            //채널 + 채팅 방 접속
            OpenChatService.shared.connetToSendbirdChannel(userID: currentState.userIdentifier)
                .subscribe()

           return Observable.concat([
                //닉네임 변경
                OpenChatService.shared.updaterUserNN(nickname: currentState.userNickName)
                .map { ok in Mutation.connetToChannel(isOk: ok) }
                ])
 // -> Down here is ChannelViewController

            //유저가 입력한 채팅 저장
        case .userInputText(let text):
            return Observable
                .just(text)
                .map { Mutation.userInputText(text: $0) }
            
            // 사용자가 입력한 챗 보내기
        case .sendButtonTapped:
            // 서버에 챗 정보 보내기 : rx 로 연결되어 있기 때문에 rx에 변동 사항이 있다면 receivedChat 에서 값을 계속 받아오는 듯
            OpenChatService.shared.sendToMsg(currentState.userInputChatText,
                                             currentState.userIdentifier,
                                             currentState.userNickName)
            return Observable.just(()).map{ Mutation.msgSent } // 서버에 만 보내고 끝
            
        case .receivedChat:
            // 받아 오는 챗
            return OpenChatService.shared.showChatData
                .map { return Mutation.receivedChat(chat: $0) }
        }// switch
    

    }// mutate
    
    // 프리젠테이션 로직 - 화면에 보여주기 위한 데이터 가공 단계
    // 상태값 변경
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .msgSent:
            print(#fileID, #function, #line, "- msgSent")
            
        case .userInputIdentifierText(let text):
            newState.userIdentifier = text
            newState.buttonEnable = currentState.userNickName.count > 0 && text.count > 0
            
        case .userInputNickNameText(let text):
            newState.userNickName = text
            
            newState.buttonEnable = text.count > 0 && currentState.userIdentifier.count > 0
            
        case .connetToChannel(let isOk): // 채널 접속 상태 확인
            newState.connectToServer = isOk
            
        case .receivedChat(chat: let chat): // 전달 받은 채팅
            
            
            
            newState.updateChatData = chat
            
        case .userInputText(text: let text): // 입력한 챗
            newState.userInputChatText = text
        }// switch
        return newState
    } // reduce
    
}
