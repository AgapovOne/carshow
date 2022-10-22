//
//  CarResponse.swift
//  Carshow
//
//  Created by Alexey Agapov on 22.10.2022.
//

import Foundation

struct CarResponse: Decodable, Hashable, Identifiable {
    struct Seller: Decodable, Hashable {
        let type: String
        let phone: String
        let city: String
    }
    struct ImageURL: Decodable, Hashable {
        let url: String
    }

    let id: Int
    let make: String
    let model: String
    let colour: String?
    let price: Int
    let mileage: Int
    let firstRegistration: String?
    let fuel: String
    let seller: Seller?
    let images: [ImageURL]?
    let description: String

    static func example(id: Int) -> Self {
        .init(
            id: id,
            make: "Ford",
            model: "Mondeo",
            colour: nil,
            price: 30000,
            mileage: 15000,
            firstRegistration: nil,
            fuel: "Diesel",
            seller: .init(type: "Private", phone: "+79992223344", city: "Yekaterinburg"),
            images: [],
            description: "Desc"
        )
    }
}
