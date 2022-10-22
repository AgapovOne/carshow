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
                id: 0,
                make: "Suzuki",
                model: "Vitara",
                colour: "White",
                price: 10000,
                mileage: 10000,
                firstRegistration: "01-2001",
                fuel: "Diesel",
                seller: .init(type: "Private", phone: "+79998887766", city: "Munich"),
                images: [.init(url: "http://placekitten.com/200/300")],
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
}
