//
//  GroceryController.swift
//  RecipeFinder Watch Extension
//
//  Created by I on 06.08.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire

public struct User: Codable {
    var name: String?
    var email: String?
    var password: String?
    var savedRecipeURLs: String?
    var savedRecipeImages: String?
    var savedRecipeNames: String?
    var productList: String?
}

class GroceryController: WKInterfaceController {
    @IBOutlet weak var GroceryTable: WKInterfaceTable!
    var ingredients: String = ""
    var ingr: [String] = []
    var groceryIngr: [Substring] = []
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
//        fetchIngredients()
        if UserDefaults.standard.bool(forKey: "logged") == true{
            ingredients = UserDefaults.standard.string(forKey: "productList")!
            groceryIngr = ingredients.split(separator: "|")
            for item in groceryIngr {
                ingr.append(String(item))
            }
            GroceryTable.setNumberOfRows(self.ingr.count, withRowType: "Row")
            var string: [String] = []
            for item in self.ingr {
                string.append(String(item))
            }
            for (index, product) in string.enumerated(){
                guard let row = self.GroceryTable.rowController(at: index) as? GroceryRow else {continue}
                row.label.setText(product)
            }
            print(ingredients)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
//    func fetchIngredients(){
//        print("into")
//        var email = UserDefaults.standard.string(forKey: "email") ?? "Nope"
//        print(email)
//        var password = UserDefaults.standard.string(forKey: "password") ?? "Nope"
//        print(password)
//        email = "irene@gmail.com"
//        password = "9823010176adff1ed75beb313e8fdd61a66b526355df05fc90d7f683af8ec024"
//        let url =  "https://recipe-finder-api-nodejs.herokuapp.com/?email=janelake2017@gmail.com&password=ff551d515feb96cef76a2d2a9b98f4ee1895bca58a7c86c00a6249827442f13c"
//        print(url)
//        AF.request(url, method: .get).response {
//        response in
//        if let data = response.value{
//            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
//
//            if let dict = json as? [String: Any]{
//                print("into")
//                print("DICTIONARY:", dict)
//                let grocery = dict["productList"] as! String
//                print("GROCERY:", grocery)
//                self.ingredients = grocery
//                self.ingr = self.ingredients.split(separator: "|")
//                print("ingr:",self.ingr)
//                self.ingr = ["banana", "apple", "raspberry"]
//                print("INGR:", self.ingr)
//                print("INGR:", self.ingr.count)
//                self.GroceryTable.setNumberOfRows(self.ingr.count, withRowType: "Row")
//                var string: [String] = []
//                for item in self.ingr {
//                    string.append(String(item))
//                }
//                for (index, product) in string.enumerated(){
//                    guard let row = self.GroceryTable.rowController(at: index) as? GroceryRow else {continue}
//                    row.label.setText(product)
//                }
//            }
//        }
//        }
//    }
}
