//
//  ContentView.swift
//  Carshow
//
//  Created by Alexey Agapov on 22.10.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            MasterView(state: .initial)
        }
        .navigationViewStyle(.columns)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
