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
    let car: Car

    var body: some View {
        HStack {
            carImage()
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
        .padding(.vertical, 8)
    }

    @MainActor
    func carImage() -> some View {
        Group {
            if
                let url = car.images.first
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
                .frame(maxHeight: .infinity)
            } else {
                Text("📷")
            }
        }
        .frame(width: 60)
        .cornerRadius(8)
    }
}

extension Car {
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
        List {
            CarRow(car: .example(id: 0))
                .padding(5)
                .background(Color.blue)
        }
            .background(Color.red)
    }
}
