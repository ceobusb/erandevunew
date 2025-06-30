// Optional+Extensions.swift

import Foundation

extension Optional where Wrapped == String {
    var bound: String {
        get { self ?? "" }
        set { self = newValue }
    }
}
