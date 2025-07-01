import SwiftUI
struct Endpoints {
   // static let baseURL = "http://192.168.0.179:8083/api"
    //static let baseURL = "http://10.10.34.210:8080/api"
    static let baseURL = "https://api.kurumsaleticaretsitesi.com/api"
    static let logobaseurl = "https://api.kurumsaleticaretsitesi.com"
    static let apikey = "174ce253-a7bb-4ea7-96dc-923824a9937a"

    struct Slider {
        static let list = "\(baseURL)/info_slider"
    }
    
    struct Sektor {
        static let list = "\(baseURL)/sektorler_get"
        static let create = "\(baseURL)/create_sektor"
    }
    
    struct Firma {
        static let register = "\(baseURL)/create_firma"
        static let sendCode = "\(baseURL)/create_firma_kod"
        static let verifyCode = "\(baseURL)/confirm_firma_kod"
        static let resend_firma_kod = "\(baseURL)/resend_firma_kod"
        static let login = "\(baseURL)/firma_login"
        
        static let featuredCompanies = "\(baseURL)/get_featured_companies"
        static let nearbyCompanies = "\(baseURL)/nearby_companies_get"
        static let detail = "\(baseURL)/firmadetails"
        
        
        static let services = "\(baseURL)/get_firma_services"
        static let personeller = "\(baseURL)/get_firma_personeller"
        static let yorumlar = "\(baseURL)/get_firma_comments"
    }


    struct Customer {
        static let list = "\(baseURL)/customers"
        static let detail = "\(baseURL)/customer/detail"
        static let register = "\(baseURL)/create_customer"
        static let login = "\(baseURL)/customer_login"
    }
    

    // Diğer modüller eklenir...
}

