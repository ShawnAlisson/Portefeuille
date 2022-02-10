////
////  SekkeDataService.swift
////  Walletam
////
////  Created by Shayan Alizadeh on 2/2/22.
////
//
//import Foundation
//import SWXMLHash
//import SwiftUI
//
//class ParseController: NSObject, XMLParserDelegate{
//var items: [Item] = []
//@Published var itemStore: [Item]?
//
//func loadData() {
//    let url = URL(string: "website")!
//    let request=URLRequest(url: url)
//
//    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//      if data == nil {
//        print("dataTaskWithRequest error: \(String(describing: error?.localizedDescription))")
//        return
//      }
//
//      let parser = XMLParser(data: data!)
//      parser.delegate=self
//      parser.parse()
//
//      self.itemStore=self.items
//      print(self.itemStore)
//    }
//    task.resume()
//}
//}
