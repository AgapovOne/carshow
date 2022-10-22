//
//  DetailView.swift
//  Carshow
//
//  Created by Alexey Agapov on 22.10.2022.
//

import SwiftUI
import CustomDump

struct DetailView: View {

    let car: CarResponse

    var body: some View {
        DetailsView(car: car)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            car: .example(id: 0)
        )
    }
}
