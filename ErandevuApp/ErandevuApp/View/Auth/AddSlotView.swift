//
//  AddSlotView.swift
//  ErandevuApp
//
//  Created by BÜŞRA ŞENER BOLAT on 29.06.2025.
//

import SwiftUI
struct AddSlotView: View {
    @Environment(\.dismiss) var dismiss

    @State private var selectedDate = Date()
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600)

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Tarih")) {
                    DatePicker("Randevu Günü", selection: $selectedDate, displayedComponents: .date)
                }

                Section(header: Text("Saat Aralığı")) {
                    DatePicker("Başlangıç", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("Bitiş", selection: $endTime, displayedComponents: .hourAndMinute)
                }

                Section {
                    Button("Kaydet") {
                        // API’ye gönderilecek veri buraya
                        dismiss()
                    }
                }
            }
            .navigationTitle("Yeni Zaman Ekle")
        }
    }
}
