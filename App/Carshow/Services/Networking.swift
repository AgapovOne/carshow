//
//  Networking.swift
//  Carshow
//
//  Created by Alexey Agapov on 22.10.2022.
//

import Foundation
import Get

private let url = {
    fatalError("Provide your url :)")
}()
private let client = APIClient(baseURL: url)

enum Networking {
    static func cars() async throws -> [CarResponse] {
        try await client
            .send(.init(path: ""))
            .value
    }
}
