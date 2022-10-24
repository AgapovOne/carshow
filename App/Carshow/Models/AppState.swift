//
//  AppState.swift
//  Carshow
//
//  Created by Alexey Agapov on 23.10.2022.
//

import Foundation

struct AppState {

    struct Filter {
        var price: Range<Int>?
        var searchText: String?

        func apply(to car: Car) -> Bool {
            (price?.contains(car.price) ?? true)
            && (searchText?.nonEmpty.map {
                car.make.localizedCaseInsensitiveContains($0) || car.model.localizedCaseInsensitiveContains($0)
            } ?? true)
        }
    }

    enum Sort {
        case `default`
        case makeAlphabetically(ascending: Bool)
        case price(ascending: Bool)

        func apply(to cars: [Car]) -> [Car] {
            switch self {
                case .default:
                    return cars
                case let .makeAlphabetically(ascending):
                    return cars.sorted(by: { ascending ? $0.make < $1.make : $0.make > $1.make })
                case let .price(ascending):
                    return cars.sorted(by: { ascending ? $0.price < $1.price : $0.price > $1.price })
            }
        }
    }

    struct LoadedState {
        var filter: Filter?
        var sort: Sort
        var cars: [Car] = []

        var displayedCars: [Car] {
            let filteredCars = filter.map { filters in cars.filter { filters.apply(to: $0) } } ?? cars
            return sort.apply(to: filteredCars)
        }
    }
    enum LoadingState {
        case loading
        case loaded(LoadedState)
        case failed(String)

        var loadedState: LoadedState? {
            get {
                if case .loaded(let state) = self {
                    return state
                }
                return nil
            }
            set {
                if let loadedState = newValue {
                    self = .loaded(loadedState)
                } else {
                    self = .loading
                }
            }
        }
    }
    var loadingState: LoadingState

    static var initial: Self = .init(loadingState: .loading)
}
