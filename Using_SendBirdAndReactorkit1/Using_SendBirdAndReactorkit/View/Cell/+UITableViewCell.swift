//
//  +UITableCell.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/18.
//

import Foundation
import UIKit
extension UITableViewCell {
    /// 격차 보내주기
    func showTime( inputTime : String )  -> String {
        let now = Date() // UI 나타나는 지금 시간
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // 비교 를 위해 Date 형태로 변환
        guard let inputDate = dateFormatter.date(from: inputTime) else { return "" }
//        print("✅\(inputDate)")
        
        //  격차
        let gap = now.timeIntervalSince(inputDate)
        let minutes = Int(gap) / 60 // 시간 단위로 변환
//        print("✅\(minutes)")
        let hours = minutes / 60
        let days = hours / 24
        let months = days / 30
        let years = months / 12
//        print("✅시간:\(hours)")
//        print("✅몇일:\(days)")
//        print("✅달:\(months)")
//        print("✅년:\(years)")
        
        if minutes < 1 {  // 1분 이내 : 방금
            return "방금"
        } else if hours < 1 {  // 1시간 이내 : ~십분전
            return "\(minutes)분 전"
        } else if days < 1 { // 24시간 이내 : ~시간전
            return "\(hours)시간 전"
        } else if months < 1 { // 한달 이내: ~ 몇일 전
            return "\(days)일 전"
        } else if years < 1 {  // 1년 이내 : ~월 ~일
            let month = months % 12
            return "\(month)개월 \(days % 30)일 전"
        } else { // 1년 이상
            return "\(years)년 전"
        }
//        return "방금"
    }
}

//
//extension AnotherUserChatTableViewCell {
//    /// 격차 보내주기
//    func showTime( inputTime : String )  -> String {
//        let now = Date() // UI 나타나는 지금 시간
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        // 비교 를 위해 Date 형태로 변환
//        guard let inputDate = dateFormatter.date(from: inputTime) else { return "" }
////        print("✅\(inputDate)")
//
//        //  격차
//        let gap = now.timeIntervalSince(inputDate)
//        let minutes = Int(gap) / 60 // 시간 단위로 변환
////        print("✅\(minutes)")
//        let hours = minutes / 60
//        let days = hours / 24
//        let months = days / 30
//        let years = months / 12
////        print("✅시간:\(hours)")
////        print("✅몇일:\(days)")
////        print("✅달:\(months)")
////        print("✅년:\(years)")
//
//        if minutes < 1 {  // 1분 이내 : 방금
//            return "방금"
//        } else if hours < 1 {  // 1시간 이내 : ~십분전
//            return "\(minutes)분 전"
//        } else if days < 1 { // 24시간 이내 : ~시간전
//            return "\(hours)시간 전"
//        } else if months < 1 { // 한달 이내: ~ 몇일 전
//            return "\(days)일 전"
//        } else if years < 1 {  // 1년 이내 : ~월 ~일
//            let month = months % 12
//            return "\(month)개월 \(days % 30)일 전"
//        } else { // 1년 이상
//            return "\(years)년 전"
//        }
////        return "방금"
//    }
//}
//extension MyChatTableCell {
//    /// 격차 보내주기
//    func showTime( inputTime : String )  -> String {
//        let now = Date() // UI 나타나는 지금 시간
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        // 비교 를 위해 Date 형태로 변환
//        guard let inputDate = dateFormatter.date(from: inputTime) else { return "" }
////        print("✅\(inputDate)")
//
//        //  시간 격차
//        let gap = now.timeIntervalSince(inputDate)
//        let minutes = Int(gap) / 60 // 시간 단위로 변환
////        print("✅\(minutes)")
//        let hours = minutes / 60
//        let days = hours / 24
//        let months = days / 30
//        let years = months / 12
////        print("✅시간:\(hours)")
////        print("✅몇일:\(days)")
////        print("✅달:\(months)")
////        print("✅년:\(years)")
//
//        if minutes < 1 {  // 1분 이내 : 방금
//            return "방금"
//        } else if hours < 1 {  // 1시간 이내 : ~십분전
//            return "\(minutes)분 전"
//        } else if days < 1 { // 24시간 이내 : ~시간전
//            return "\(hours)시간 전"
//        } else if months < 1 { // 한달 이내: ~ 몇일 전
//            return "\(days)일 전"
//        } else if years < 1 {  // 1년 이내 : ~월 ~일
//            let month = months % 12
//            return "\(month)개월 \(days % 30)일 전"
//        } else { // 1년 이상
//            return "\(years)년 전"
//        }
////        return "방금"
//    }
//}
