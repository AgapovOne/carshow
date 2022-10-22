//
//  MasterView.swift
//  Carshow
//
//  Created by Alexey Agapov on 22.10.2022.
//

import SwiftUI

struct MasterView: View {
    var body: some View {
        Text("Master")

        NavigationLink {
            DetailView()
        } label: {
            Label("Details", systemImage: "folder")
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
