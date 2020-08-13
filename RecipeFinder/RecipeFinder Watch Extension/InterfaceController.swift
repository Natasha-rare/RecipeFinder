//
//  InterfaceController.swift
//  RecipeFinder Watch Extension
//
//  Created by I on 06.08.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import WatchKit
import Foundation
import CryptoKit
import Alamofire
import WatchConnectivity
class InterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet weak var notificationLabel: WKInterfaceLabel!
    @IBOutlet weak var GroceryTable: WKInterfaceTable!
    
    var colors: Dictionary = [0 : ""]
    var wcSession : WCSession!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let groceryIngredients = UserDefaults.standard.stringArray(forKey: "ingredients") ?? []
        loadGroceryTable(groceryIngredients: groceryIngredients, GroceryTable: GroceryTable)
        if groceryIngredients != [] {
            notificationLabel.setText("You need to buy " + String(groceryIngredients.count) + " products")
            notificationLabel.setHidden(false)
        }
        else {
            notificationLabel.setText("You have nothing to buy")
            notificationLabel.setHidden(false)
        }
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        wcSession = WCSession.default
        wcSession.delegate = self
        wcSession.activate()
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
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("into")
        let groceryIngredients = message["message"] as! [String]
        print(groceryIngredients)
        print("GROCERY:", groceryIngredients)
        loadGroceryTable(groceryIngredients: groceryIngredients, GroceryTable: GroceryTable)
        notificationLabel.setText("You need to buy " + String(groceryIngredients.count) + " products")
        notificationLabel.setHidden(false)
        
    }
    func loadGroceryTable(groceryIngredients: [String], GroceryTable: WKInterfaceTable){
        var i : Int = 0
        GroceryTable.setNumberOfRows(groceryIngredients.count, withRowType: "Row")
        for item in groceryIngredients {
            
            guard let row = self.GroceryTable.rowController(at: i) as? GroceryRow else
            {
                colors[i] = "white"
                continue
            }
            row.label.setText(item)
            colors[i] = "white"
            print("ROWS:", GroceryTable.numberOfRows)
            i += 1
        }
        UserDefaults.standard.set(groceryIngredients, forKey: "ingredients")
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}

