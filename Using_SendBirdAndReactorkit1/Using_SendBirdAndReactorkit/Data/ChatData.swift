//
//  ChatData.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/14.
//

import Foundation
/// 채팅 데이터 모델
struct ChatData {
    let id : String
    let userId: String
    let nickName : String
    let profileImage : String
    var message : String
//    let created : Int64
    let created : String // 생성 시간
    let showtime : String // 셀에 보여질 시간
    let fileName : String // 파일 이름
    let fileURL : String // 파일 URL
    let fileType : String // 파일 타입
    
    var nextMsgTimestamp : String? = nil
    
    enum ChatType {
        case me
        case another

        var reuserId : String {
            switch self{
            case .me: return "MyChatTableCell"
            case .another: return "AnotherUserChatTableViewCell"
            }
        }// reuserId
    }
    //이전 chatData 아이디
    var previousMsgUserId : String? = nil
    
    var isMyChat : Bool? = nil
    var chatType : ChatType {
        //true: 나 false: 다른애
        let isMyChatMessage = isMyChat ?? false
        return isMyChatMessage ? .me : .another
    }
    // 메세지를 이어서 보여줘야 하는 셀 인지 판단
    // 반환 값이 true 는 전체 보여주기 false는 메세지만
    var shouldAddingMsgChat : Bool {
        
//        guard let previousMsgUserId = previousMsgUserId else { return true } // 첫 값은 nill 이므로 true 반환
        
        // 현재 아이디 와 이전 아이디 와 같지 않다면 -> true 로 프로필 사진 보여주는 셀
        return previousMsgUserId ?? "" == self.userId // 둘이 같지 않다면 true
    }
}
