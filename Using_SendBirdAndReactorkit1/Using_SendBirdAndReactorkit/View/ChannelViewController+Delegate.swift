//
//  ChannelViewController+Delegate.swift
//  Using_SendBirdAndReactorkit
//
//  Created by 시혁 on 2023/06/20.
//


import UIKit

extension ChannelViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tempList[indexPath.row].fileURL.count > 1 {
            print("✅앗 클릭당해버림 꺟")
            fileDonwLoad(tempList[indexPath.row].fileURL, tempList[indexPath.row].fileName)
        }
    }
    private func fileDonwLoad(_ fileURL : String,_ fileName : String){
        // 다운로드 받을 파일의 URL을 생성합니다.
        guard let url = URL(string: fileURL) else {
            print("유효하지 않은 파일 URL입니다.")
            return
        }

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        let downloadTask = session.downloadTask(with: url) { (temporaryURL, response, error) in
            if let error = error {
                print("파일 다운로드 실패: \(error)")
                return
            }

            // 임시 다운로드된 파일의 URL을 확인합니다.
            guard let temporaryURL = temporaryURL else {
                print("임시 다운로드된 파일 URL을 찾을 수 없습니다.")
                return
            }

            do {
                let fileManager = FileManager.default
                let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

                // 저장할 파일의 최종 URL을 생성합니다.
                let destinationURL = documentsURL.appendingPathComponent(fileName)

                // 동일한 이름의 파일이 이미 존재하는지 확인합니다.
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }

                // 파일을 저장합니다.
                try fileManager.moveItem(at: temporaryURL, to: destinationURL)
                print("파일 다운로드 및 저장 성공. 저장된 경로: \(destinationURL.path)")
            } catch {
                print("파일 저장 실패: \(error)")
            }
        }

        downloadTask.resume()
        
    }
}
