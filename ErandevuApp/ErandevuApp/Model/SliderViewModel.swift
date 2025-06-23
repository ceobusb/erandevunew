import Foundation

struct InfoCard: Identifiable, Codable {
    let id = UUID()
    let image: String
    let text: String
    enum CodingKeys: String, CodingKey {
        case image, text
    }

}

struct SliderInfo: Identifiable, Codable {
    let id = UUID()
    let image: String
    let text: String

    enum CodingKeys: String, CodingKey {
        case image, text
    }
}


class SliderViewModel: ObservableObject {
    @Published var infoCards: [InfoCard] = []

    func loadSliders() {
        SliderService.fetchSliders { [weak self] sliders in
            let converted = sliders.map { slider in
                InfoCard(image: slider.image, text: slider.text)
            }
            self?.infoCards = converted
        }
    }

}



