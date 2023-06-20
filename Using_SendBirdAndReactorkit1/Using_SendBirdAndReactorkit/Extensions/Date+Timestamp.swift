//
//  Date+.swift
//  Using_SendBirdAndReactorkit
//
//  Created by Jeff Jeong on 2023/06/19.
//

import Foundation

extension Date {
    
    ///  1분 이내 시간차 여부
    /// from 현재 데이터의 생성 시간 , to 다음 데이터의 시간
    static func checkTimeGapInAMinute(from fromTime : String, to inputTime: String)  -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // 비교 를 위해 Date 형태로 변환
        guard let inputDate = dateFormatter.date(from: inputTime),
              let now = dateFormatter.date(from: fromTime) else { return false }
        
        //  시간 격차
        let gap = now.timeIntervalSince(inputDate)
        
        
        let plusGap = -gap
        
        print(#fileID, #function, #line, "- gap: \(gap) / plusGap: \(plusGap)")
        
        let seconds = Int(plusGap)
        
        let minutes = Int(plusGap) / 60 // 시간 단위로 변환
        
//        return minutes < 1
        return seconds < 5
    }

}

