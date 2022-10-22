//
//  AppState.swift
//  Carshow
//
//  Created by Alexey Agapov on 23.10.2022.
//

import Foundation

struct AppState {
    struct LoadedState {
        var searchText: String?
        var cars: [Car] = []

        var filteredCars: [Car] {
            switch searchText {
                case nil:
                    return cars
                case let .some(search):
                    return cars
                        .filter {
                            $0.make.localizedCaseInsensitiveContains(search)
                        }
            }
        }
    }
    enum LoadingState {
        case loading
        case loaded(LoadedState)
        case failed(String)

        var loadedState: LoadedState? {
            if case .loaded(let state) = self {
                return state
            }
            return nil
        }
    }
    var loadingState: LoadingState

    static var initial: Self = .init(loadingState: .loading)
}
