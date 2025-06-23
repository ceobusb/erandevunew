import SwiftUI
struct Endpoints {
    //static let baseURL = "http://192.168.0.179:8080/api"
    static let baseURL = "http://10.10.34.210:8080/api"

    struct Slider {
        static let list = "\(baseURL)/info_slider"
    }

    struct Customer {
        static let list = "\(baseURL)/customers"
        static let detail = "\(baseURL)/customer/detail"
    }

    // Diğer modüller eklenir...
}

