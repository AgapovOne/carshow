//
//  MasterView.swift
//  Carshow
//
//  Created by Alexey Agapov on 22.10.2022.
//

import SwiftUI

struct AppState {
    struct LoadedState {
        var cars: [CarResponse] = []
    }
    enum LoadingState {
        case loading
        case loaded(LoadedState)
        case failed(String)
    }
    var loadingState: LoadingState

    static var initial: Self = .init(loadingState: .loading)
}

struct MasterView: View {

    @State var state: AppState

    var body: some View {
        Group {
            switch state.loadingState {
                case .loading:
                    ProgressView()
                case let .failed(message):
                    Text(message)
                        .foregroundColor(.red)
                case let .loaded(loadedState):
                    List {
                        ForEach(loadedState.cars) { car in
                            NavigationLink {
                                DetailView(car: car)
                            } label: { CarRow(car: car) }
                        }
                    }
            }
        }
        .navigationTitle("Master")
        .task(load)
        .refreshable(action: load)
    }

    @Sendable private func load() async {
        do {
            self.state.loadingState = .loading
            let cars = try await Networking.cars()
            self.state.loadingState = .loaded(.init(cars: cars))
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
