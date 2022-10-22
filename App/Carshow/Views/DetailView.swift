//
//  DetailView.swift
//  Carshow
//
//  Created by Alexey Agapov on 22.10.2022.
//

import SwiftUI
import CustomDump

struct DetailView: View {

    @State var cars: [CarResponse] = []

    var body: some View {
        VStack {
            Text("Detail")
            List {
                ForEach(cars) { car in
                    Text(dumped(car))
                }
            }
        }
        .task {
            do {
                let cars = try await Networking.cars()
                self.cars = cars
            } catch {
                fatalError(dumped(error))
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(cars: [])
    }
}
