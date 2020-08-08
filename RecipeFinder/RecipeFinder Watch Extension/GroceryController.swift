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
    @IBOutlet weak var labelNothing: WKInterfaceLabel!
    @IBOutlet weak var buttonReset: WKInterfaceButton!
    
    @IBOutlet weak var GroceryTable: WKInterfaceTable!
    var ingredients: String = ""
    var ingr: [String] = []
    var groceryIngr: [Substring] = []
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if GroceryTable.numberOfRows == 0{
            buttonReset.setHidden(true)
            labelNothing.setHidden(false)
        }
        // Configure interface objects here.
//        fetchIngredients()
        print("DEFAULTS:", UserDefaults.standard.bool(forKey: "logged"))
        if UserDefaults.standard.bool(forKey: "logged") == true{
            print("loading")
            ingredients = UserDefaults.standard.string(forKey: "productList")!
            print("INDR:", ingredients)
            groceryIngr = ingredients.split(separator: "|")
            for item in groceryIngr{
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
        if GroceryTable.numberOfRows != 0 {
            buttonReset.setHidden(false)
            labelNothing.setHidden(true)
        }
    }
    @IBAction func buttonResetPressed() {
        print("reset loading")
        SendIngredients(ingredientList: [])
        GroceryTable.setNumberOfRows(0, withRowType: "Row")
        print("done")
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    func SendIngredients(ingredientList: [String]){
        let url =  "https://recipe-finder-api-nodejs.herokuapp.com/"
        
        let email = UserDefaults.standard.string(forKey: "email") ?? "Nope"
        let password = UserDefaults.standard.string(forKey: "password") ?? "Nope"
        
        let preparedString = ingredientList.joined(separator: "|")
        let params = [
            "email": "\(email)",
            "password": "\(password)",
            "productList": "\(preparedString)"
        ]
        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default).response{
            response in
            if let string = response.value{
                print("Ingredient send response: \(string!)")
            }
            
        }
        UserDefaults.standard.set("", forKey: "productList")
    }
}
