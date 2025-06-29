//
//  SectionBox.swift
//  ErandevuApp
//
//  Created by BÜŞRA ŞENER BOLAT on 30.06.2025.
//

import SwiftUI
struct SectionBox<Content: View>: View {
    let title: String
    let content: () -> Content

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
