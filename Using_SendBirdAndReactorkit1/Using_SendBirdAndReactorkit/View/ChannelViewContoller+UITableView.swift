//
//  ChannelViewContoller+UITableView.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/15.
//

import UIKit

extension ChannelViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        typealias ChatType = ChatData.ChatType
        
        let row = indexPath.row
        print(#fileID, #function, #line, "✅✅✅ \(self.tempList) / indexPath: \(indexPath)" )
        let element = tempList[row] // 테이블 요소

        // 현재 들어오는 item 에 type 확인
        let chatType : ChatType = element.chatType
        let showChatCell : Bool = element.shouldAddingMsgChat //추가 메세지 인지 판별
        let indexPath = IndexPath(row: row, section: 0)

        //true: 나 false: 다른애
        switch chatType {
        case .me:
            let cell = tableView.dequeueReusableCell(withIdentifier: chatType.reuserId, for: indexPath) as? MyChatTableCell
            
//            if showChatCell{
//                let addingCell = tableView.dequeueReusableCell(withIdentifier: "MyMessageTableViewCell", for: indexPath) as? MyMessageTableViewCell
//                 addingCell?.configure(element)
//                 return addingCell ?? UITableViewCell()
//            }
            
            cell?.configure(element)
            return cell ?? UITableViewCell()

        default:

            var cell : UITableViewCell?
            // 상대방이 보내지만 fileType 이 "image/jpeg" 라면  이미지 타입 셀을 준다.
            // 이전 아이디 와 같아서 연속돼서 이미지 셀을 또 보내야 한다면
            if element.fileType == "image/jpeg" { //  첫 메세지 이면서, 이미지 파일 셀 인경우
                cell = tableView.dequeueReusableCell(withIdentifier: "AnotherIFirstmgTypeCell", for: indexPath) as? AnotherIFirstmgTypeCell
                if let imgCell = cell as? AnotherIFirstmgTypeCell {
                        imgCell.configure(element)
                    }
            }else { // 첫 메세지 이면서, 이미지 파일 셀이 아닐 경우
                cell = tableView.dequeueReusableCell(withIdentifier: chatType.reuserId, for: indexPath) as? AnotherUserChatTableViewCell
                if let chatCell = cell as? AnotherUserChatTableViewCell {
                        chatCell.configure(element)
                    }
            }
            // 연속 챗
            if showChatCell {
                var addingCell : UITableViewCell?
                if element.fileType == "image/jpeg" { // 연속으로 챗을 보내는 중에 이미지 를 보낼 경우
                    addingCell = tableView.dequeueReusableCell(withIdentifier: "AnotherImgTypeCell", for: indexPath) as? AnotherImgTypeCell
                    if let imgCell = addingCell as? AnotherImgTypeCell {
                            imgCell.configure(element)
                        }
                }else{ // 연속으로 보내는 경우 메세지 일 때
                    addingCell = tableView.dequeueReusableCell(withIdentifier: "AnotherUserMessageTableViewCell", for: indexPath) as? AnotherUserMessageTableViewCell
                    if let chatCell = addingCell as? AnotherUserMessageTableViewCell {
                        chatCell.configure(element)
                    }
                }
                 return addingCell ?? UITableViewCell()
            }
//
//            cell?.configure(element)
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempList.count
    }
}
