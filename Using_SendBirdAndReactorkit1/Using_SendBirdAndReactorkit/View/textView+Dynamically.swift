//
//  textView+height.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/20.
//
import UIKit
extension ChannelViewController : UITextViewDelegate {
    // 텍스트가 변경될 때마다 호출되는 델리게이트 메서드입니다.
    func textViewDidChange(_ textView: UITextView) {
            // UITextView의 높이를 조정하고 글의 줄 수를 제한합니다.
            adjustTextViewHeight()
            limitTextViewLineCount()
        }
        
        func adjustTextViewHeight() {
            let maxHeight: CGFloat = 100 // 최대 높이
            // inputTextField  : 내가 사용중인 textView
            let newSize = inputTextField.sizeThatFits(CGSize(width: inputTextField.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
//            sizeThatFits(_:) 메서드는 UIView의 콘텐츠에 적합한 크기를 계산
//            CGFloat.greatestFiniteMagnitude는 가능한 가장 큰 값
            // 최대 높이를 넘지 않도록 둘중 더 작은거 newSize.height는 이전 단계에서 계산된 inputTextField의 높이
            let newHeight = min(newSize.height, maxHeight)
            
            // UITextView의 높이를 조정합니다. //  $0.firstAttribute == .height  높이 인 요소 만
            inputTextField.constraints.filter { $0.firstAttribute == .height }.forEach { $0.constant = newHeight }
            
            // bottomStackView의 높이도 조정합니다.
            bottomStackView.constraints.filter { $0.firstAttribute == .height }.forEach { $0.constant = newHeight }
        }
        
    func limitTextViewLineCount() {
            let maxLineCount = 4 // 최대 줄 수 (원하는 값으로 조정)
            
            let text = inputTextField.text ?? ""
            // 줄 바꿈 문자 를 기준으로  분할한 배열
            let lines = text.components(separatedBy: "\n")
            
            // 최대 줄 수를 넘지 않도록 조정합니다.
            if lines.count > maxLineCount {
                // 앞서만든 줄 바꿈 기준으로 쪼개서 만든 배열을 앞에서 부터 4개 를 "\n" 붙여서 하나의 문자열로 만든다.
                let truncatedText = lines.prefix(maxLineCount).joined(separator: "\n")
                inputTextField.text = truncatedText
                // 그래서 4줄 이후부터는 다음줄 안댐 ㅋㅋㅋ 
            }
        }
}

