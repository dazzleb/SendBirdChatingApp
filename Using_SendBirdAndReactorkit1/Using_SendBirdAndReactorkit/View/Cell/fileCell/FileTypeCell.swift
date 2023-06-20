//
//  fileTypeCell.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/20.
//

import Foundation
import UIKit
import Kingfisher
//상대가 보낸 파일
class FileTypeCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 파일 이름
    private func configureUI() {
        let selectedBgView = UIView(frame: self.contentView.bounds)
        selectedBgView.backgroundColor = .systemPink.withAlphaComponent(0.2)
        self.selectedBackgroundView = selectedBgView
        
//        self.contentView.selectAll(<#T##sender: Any?##Any?#>)
    }
    func configure(_ data: ChatData) {

    }
}
