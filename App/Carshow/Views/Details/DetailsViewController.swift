//
//  DetailsViewController.swift
//  Carshow
//
//  Created by Alexey Agapov on 22.10.2022.
//

import Align
import NukeUI
import UIKit

final class DetailsViewController: UIViewController {

    struct ViewState: Hashable {
        let images: [URL]
        let title: String
        let price: String
        let mileage: String
        let date: String?
        let seller: String

        static var initial: Self {
            .init(
                images: [],
                title: "",
                price: "",
                mileage: "",
                date: "",
                seller: ""
            )
        }
    }

    var viewState: ViewState = .initial {
        didSet {
            titleLabel.text = [
                viewState.title,
                viewState.price,
                viewState.mileage,
                viewState.date,
                viewState.seller
            ].compactMap { $0 }.joined(separator: "\n")

            imagesContainerStackView.isHidden = viewState.images.isEmpty

            if !viewState.images.isEmpty {
                imagesContainerStackView.arrangedSubviews.forEach {
                    $0.removeFromSuperview()
                }
                func imageView(url: URL) -> UIView {
                    let imageView = LazyImageView()
                    imageView.placeholderView = UIActivityIndicatorView()
                    imageView.url = url
                    return imageView
                }

                if let firstImageURL = viewState.images.first {
                    let imageURLsWithoutFirst = viewState.images.dropFirst()
                    let firstImageView = imageView(url: firstImageURL)
                    firstImageView.anchors.height.equal(firstImageView.anchors.width.multiplied(by: 9 / 16))
                    imagesContainerStackView.addArrangedSubview(firstImageView)

                    if !imageURLsWithoutFirst.isEmpty {
                        let stack = update(UIStackView()) {
                            $0.axis = .horizontal
                            $0.spacing = 0
                            $0.distribution = .fillEqually
                        }
                        imagesContainerStackView.addArrangedSubview(stack)
                        stack.anchors.height.equal(firstImageView.anchors.height.multiplied(by: 1 / 3))
                        imageURLsWithoutFirst.forEach {
                            stack.addArrangedSubview(imageView(url: $0))
                        }
                    }
                }
            }
        }
    }

    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var imagesContainerStackView = update(UIStackView()) {
        $0.axis = .vertical
        $0.spacing = 8
    }
    private var stackView = update(UIStackView()) {
        $0.axis = .vertical
        $0.spacing = 8
    }
    private var titleLabel = update(UILabel()) {
        $0.font = .preferredFont(forTextStyle: .title1)
        $0.numberOfLines = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        viewState = .initial
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        scrollView.anchors.edges.pin(insets: .zero)
        contentView.anchors.edges.pin(insets: .zero)
        contentView.anchors.width.equal(view.anchors.width)
        stackView.anchors.edges.pin(insets: .zero)

        stackView.addArrangedSubview(imagesContainerStackView)
        stackView.addArrangedSubview(titleLabel)
    }
}

extension DetailsViewController.ViewState {
    init(_ car: Car) {
        images = car.images
        title = [car.make, car.model, car.colour.map { ($0 + car.emojiColour) }].compactMap { $0 }.joined(separator: " ")
        price = car.price.formatted(.currency(code: "EUR"))

        let km = Measurement(value: Double(car.mileage), unit: UnitLength.kilometers)
        mileage = km.formatted(.measurement(width: .abbreviated, usage: .asProvided))

        if let registration = car.firstRegistration {
            let fields = registration.split(separator: "-").prefix(upTo: 1)
            if
                let month = fields.first.map(String.init).flatMap(Int.init),
                let year = fields.last.map(String.init).flatMap(Int.init),
                let dateRegistration = Calendar.current.date(from: .init(year: year, month: month))
            {
                date = dateRegistration.formatted(.dateTime.month(.abbreviated).year(.twoDigits))
            } else {
                date = nil
            }
        } else {
            date = nil
        }
        seller = "someone"
    }
}

// MARK: - SwiftUI

import SwiftUI

struct DetailsView: UIViewControllerRepresentable {
    let car: Car

    func makeUIViewController(context: Context) -> DetailsViewController {
        DetailsViewController()
    }
    func updateUIViewController(_ uiViewController: DetailsViewController, context: Context) {
        uiViewController.viewState = .init(car)
    }

}
