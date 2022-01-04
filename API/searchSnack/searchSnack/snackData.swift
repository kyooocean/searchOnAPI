//
//  snackData.swift
//  searchSnack
//
//  Created by Kyohei Morinaka on 2022/01/05.
//

import Foundation
import UIKit
import SwiftUI

//snack info
struct snackItem: Identifiable {
    let id = UUID()
    let name: String
    let link: URL
    let image: URL
}

class snackData: ObservableObject {
    struct ResultJson: Codable {
        struct Item: Codable {
            let name: String?
            let url: URL?
            let image: URL?
        }
        let item: [Item]?
    }
    @Published var snackList: [snackItem] = []
    func searchSnack(keyword: String) async {
        print(keyword)
        //encode URL
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        //set rewuestURL
        guard let req_url = URL(string:
                                    "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r")
            else {
            return
        }
        print(req_url)
        
        do {
            //download from req_url
            let (data , _) = try await URLSession.shared.data(from: req_url)
            //get decode instance
            let decoder = JSONDecoder()
            let json = try decoder.decode(ResultJson.self, from: data)
               // print(json)
            //check info
            guard let items = json.item else { return }
            DispatchQueue.main.async {
                self.snackList.removeAll()
            }
            for item in items {
                if let name = item.name,
                   let link = item.url,
                   let image = item.image {
                    let snack = snackItem(name: name, link: link, image: image)
                    DispatchQueue.main.async {
                        self.snackList.append(snack)
                    }
                }
            }
            print(self.snackList)
        } catch {
            print("ERROR")
        }
    }
}
