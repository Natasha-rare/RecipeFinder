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
    @IBOutlet weak var notificationLabel: WKInterfaceLabel!
    
    @IBOutlet weak var logoutButton: WKInterfaceButton!
    @IBOutlet weak var labelNothing: WKInterfaceLabel!
    @IBOutlet weak var buttonReset: WKInterfaceButton!
    
    @IBOutlet weak var GroceryTable: WKInterfaceTable!
    var ingredients: String = ""
    var ingr: [String] = []
    var groceryIngr: [Substring] = []
    var colors: Dictionary = [0 : ""]
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if GroceryTable.numberOfRows == 0{
            buttonReset.setHidden(true)
            labelNothing.setHidden(false)
        }
        if UserDefaults.standard.bool(forKey: "logged"){
            logoutButton.setHidden(false)
            notificationLabel.setHidden(true)
        }
        else{
            logoutButton.setHidden(true)
            notificationLabel.setHidden(false)
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
                guard let row = self.GroceryTable.rowController(at: index) as? GroceryRow else
                {
                    colors[index] = "white"
                    continue
                    
                }
                
                row.label.setText(product)
                colors[index] = "white"
            }
            print("COLORS", colors)
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
        buttonReset.setHidden(true)
        labelNothing.setHidden(false)
    }
    @IBAction func logoutButtonPressed() {
        let defaults = UserDefaults.standard
        UserDefaults.resetStandardUserDefaults()
        defaults.set(false, forKey: "logged")
        logoutButton.setHidden(true)
        notificationLabel.setHidden(false)
        GroceryTable.setNumberOfRows(0, withRowType: "Row")
        buttonReset.setHidden(true)
        labelNothing.setHidden(true)
    }
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        print("got it")
        print("ROW INDEX:", rowIndex)
            if let row = table.rowController(at: rowIndex) as? GroceryRow {
                print("intooo")
                if colors[rowIndex] == "white"{
             row.label.setTextColor(UIColor(red: 0.39, green: 0.39, blue: 0.39, alpha: 1))
                    colors[rowIndex] = "grey"
                }
                else {
                    row.label.setTextColor(UIColor.white)
                    colors[rowIndex] = "white"
                }
            }
        }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if GroceryTable.numberOfRows == 0{
                    buttonReset.setHidden(true)
                    labelNothing.setHidden(false)
                }
                if UserDefaults.standard.bool(forKey: "logged"){
                    logoutButton.setHidden(false)
                    notificationLabel.setHidden(true)
                }
                else{
                    logoutButton.setHidden(true)
                    notificationLabel.setHidden(false)
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
