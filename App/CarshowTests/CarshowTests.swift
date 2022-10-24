//
//  CarshowTests.swift
//  CarshowTests
//
//  Created by Alexey Agapov on 22.10.2022.
//

import XCTest
import CustomDump
@testable import Carshow

final class CarshowTests: XCTestCase {

    func test_viewStateBuilder() {
        // Tests are fixed to Germany, English
        let viewState = DetailsViewController.ViewState(
            .init(
                id: .init(rawValue: 0),
                make: "Suzuki",
                model: "Vitara",
                colour: "White",
                price: 10000,
                mileage: 10000,
                firstRegistration: "01-2001",
                fuel: .diesel,
                seller: .init(type: "Private", phone: "+79998887766", city: "Munich"),
                images: [URL(string: "http://placekitten.com/200/300")!],
                description: "Some description"
            )
        )

        XCTAssertNoDifference(
            viewState,
            .init(
                images: [URL(string: "http://placekitten.com/200/300")! ],
                title: "Suzuki Vitara White🚐",
                price: "10.000,00 €",
                mileage: "10.000 km",
                date: "Jan 01",
                seller: "someone"
            )
        )
    }

    func test_filtering() {
        measureFiltering(count: 500)
    }

    func test_filteringMore() {
        measureFiltering(count: 50_000)
    }

    func test_filteringMoooore() {
        measureFiltering(count: 5_000_000)
    }

    private func measureFiltering(count: Int) {
        let loadedState = AppState.LoadedState.init(
            filter: .init(price: 5000..<15000, searchText: "Ford"),
            sort: .price(ascending: true),
            cars: (0..<count).map {
                Car.example(id: $0, make: $0.isMultiple(of: 2) ? "Ford" : "Aston Martin", price: $0 * 100)
            }
        )

        let options = XCTMeasureOptions()
        options.iterationCount = 10

        measure(options: options) {
            let cars = loadedState.displayedCars

            XCTAssertEqual(cars.count, 50)
        }
    }
}
