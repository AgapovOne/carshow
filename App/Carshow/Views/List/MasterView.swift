//
//  MasterView.swift
//  Carshow
//
//  Created by Alexey Agapov on 22.10.2022.
//

import SwiftUI

struct MasterView: View {

    @State var state: AppState = .initial

    var body: some View {
        Group {
            switch state.loadingState {
                case .loading:
                    ProgressView()
                case let .failed(message):
                    Text(message)
                        .foregroundColor(.red)
                case let .loaded(loadedState):
                    list(loadedState)
            }
        }
        .navigationTitle("Master")
        .task(load)
        .refreshable(action: load)
    }

    @MainActor
    func list(_ loadedState: AppState.LoadedState) -> some View {
        List {
            ForEach(loadedState.displayedCars, id: \.id.rawValue) { car in
                NavigationLink {
                    DetailView(car: car)
                } label: { CarRow(car: car) }
            }
        }
    }

    @Sendable private func load() async {
        do {
            self.state.loadingState = .loading
            let carsResponse = try await Networking.cars()
            let cars = carsResponse.map(Car.init)
            self.state.loadingState = .loaded(
                .init(
                    filter: nil,
                    sort: nil,
                    cars: cars
                )
            )
        } catch {
            self.state.loadingState = .failed(dumped(error))
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView(state: .initial)
    }
}
