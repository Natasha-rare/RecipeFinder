//
//  ContentView.swift
//  RecipeFinder
//
//  Created by Наталья Автухович on 08.07.2020.
//  Copyright © 2020 Наталья Автухович. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    init(){
        UITableView.appearance().backgroundColor = .yellow
    }
    
    var body: some View {
        ZStack
            {
            Color.yellow
                .edgesIgnoringSafeArea(.all)
            Text("Recipe Finder")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .foregroundColor(.black) //можно заменить когда придумаем фон
                
        }
        
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
