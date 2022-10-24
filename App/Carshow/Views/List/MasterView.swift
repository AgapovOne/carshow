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
                    ScrollView {
                        Text(message)
                            .foregroundColor(.red)
                    }
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
        .searchable(text: Binding {
            loadedState.filter?.searchText ?? ""
        } set: {
            let loadedState = state.loadingState.loadedState
            if loadedState?.filter == nil {
                state.loadingState.loadedState?.filter = .init()
            }
            state.loadingState.loadedState?.filter?.searchText = $0
        })
        .navigationBarItems(trailing: {
            loadedState.sort.view
                .foregroundColor(.accentColor)
                .onTapGesture {
                    state.loadingState.loadedState?.sort = loadedState.sort.next
                }
        }())
    }

    @Sendable private func load() async {
        do {
            let carsResponse = try await Networking.cars()
            let cars = carsResponse.map(Car.init)
            self.state.loadingState = .loaded(
                .init(
                    filter: nil,
                    sort: .default,
                    cars: cars
                )
            )
        } catch {
            self.state.loadingState = .failed(dumped(error))
        }
    }
}

extension AppState.Sort {
    var next: Self {
        switch self {
            case .default:
                return .makeAlphabetically(ascending: true)
            case .makeAlphabetically(let ascending):
                return ascending ? .makeAlphabetically(ascending: false) : .price(ascending: true)
            case .price(let ascending):
                return ascending ? .price(ascending: false) : .default
        }
    }

    @MainActor
    var view: some View {
        HStack {
            switch self {
                case .default:
                    Text("SORT")
                case .makeAlphabetically(let ascending):
                    Image(systemName: "textformat.abc")
                    Image(systemName: ascending ? "arrow.up.forward" : "arrow.down.forward")
                        .imageScale(.small)
                case .price(let ascending):
                    Image(systemName: "eurosign")
                    Image(systemName: ascending ? "arrow.up.forward" : "arrow.down.forward")
                        .imageScale(.small)
            }
        }
    }
}


struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView(state: .initial)
    }
}
