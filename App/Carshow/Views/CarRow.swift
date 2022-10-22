//
//  CarRow.swift
//  Carshow
//
//  Created by Alexey Agapov on 22.10.2022.
//

import SwiftUI
import Nuke
import NukeUI

struct CarRow: View {
    let car: CarResponse

    var body: some View {
        HStack {
            Group {
                if
                    let image = car.images?.first?.url,
                    let url = URL(string: image)
                {
                    LazyImage(url: url) { state in
                        if let image = state.image {
                            image.resizingMode(.aspectFill)
                        } else if state.error != nil {
                            Color.red
                        } else {
                            ProgressView()
                        }
                    }
                } else {
                    Text("📷")
                }
            }
            .frame(width: 60)
            VStack(alignment: .leading) {
                HStack {
                    Text(car.emojiColour + (car.colour ?? ""))
                        .font(.callout)
                        .lineLimit(1)
                        .layoutPriority(0)
                    Text(car.make)
                        .lineLimit(1)
                        .layoutPriority(1)
                    Text(car.model)
                        .lineLimit(1)
                        .layoutPriority(2)
                }
                Text(car.price.formatted(.currency(code: "EUR")))
                    .monospacedDigit()
                    .lineLimit(1)
            }

            Spacer()
            if let phone = car.seller?.phone {
                Button {
                    call(phone)
                } label: {
                    Image(systemName: "phone")
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

extension CarResponse {
    var emojiColour: String {
        switch colour {
            case "White":
                return "🚐"
            case "Brown":
                return "🚚"
            default:
                return "🚗"
        }
    }
}

struct CarRow_Previews: PreviewProvider {
    static var previews: some View {
        CarRow(car: .example(id: 0))
    }
}
