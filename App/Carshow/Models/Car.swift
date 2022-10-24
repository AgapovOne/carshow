//
//  Car.swift
//  Carshow
//
//  Created by Alexey Agapov on 23.10.2022.
//

import Foundation

struct Car: Hashable, Identifiable {
    struct ID: Hashable {
        let rawValue: Int
    }

    struct Seller: Hashable {
        let type: String
        let phone: String
        let city: String
    }
    struct ImageURL: Hashable {
        let url: String
    }

    enum Fuel: String, Hashable {
        case gasoline
        case diesel
        case unknown
    }

    let id: ID
    let make: String
    let model: String
    let colour: String?
    let price: Int
    let mileage: Int
    let firstRegistration: String?
    let fuel: Fuel
    let seller: Seller?
    let images: [URL]
    let description: String

    static func example(
        id: Int,
        make: String = "Ford",
        price: Int = 30_000
    ) -> Self {
        .init(
            id: .init(rawValue: id),
            make: make,
            model: "Mondeo",
            colour: nil,
            price: price,
            mileage: 15_000,
            firstRegistration: nil,
            fuel: .diesel,
            seller: .init(type: "Private", phone: "+79992223344", city: "Yekaterinburg"),
            images: [],
            description: "Desc"
        )
    }
}

extension Car {
    init(_ response: CarResponse) {
        id = .init(rawValue: response.id)
        make = response.make
        model = response.model
        colour = response.colour
        price = response.price
        mileage = response.mileage
        firstRegistration = response.firstRegistration
        fuel = {
            switch response.fuel {
                case "Gasoline":
                    return .gasoline
                case "Diesel":
                    return .diesel
                default:
                    // logError("unknown type \(response.fuel)")
                    return .unknown
            }
        }()
        seller = nil
        images = response.images?.compactMap {
            if let url = URL(string: $0.url) {
                return url
            } else {
                // logError("incorrect image url \($0.url)")
                return nil
            }
        } ?? []
        description = response.description
    }
}
