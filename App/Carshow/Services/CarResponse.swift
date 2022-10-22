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
}
