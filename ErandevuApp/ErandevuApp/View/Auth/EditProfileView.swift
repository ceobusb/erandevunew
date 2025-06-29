//
//  EditProfileView.swift
//  ErandevuApp
//
//  Created by BÜŞRA ŞENER BOLAT on 29.06.2025.
//

import SwiftUI
struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    @State private var companyName = ""
    @State private var description = ""
    @State private var address = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Firma Bilgileri")) {
                    TextField("Firma Adı", text: $companyName)
                    TextField("Açıklama", text: $description)
                    TextField("Adres", text: $address)
                }

                Section {
                    Button("Kaydet") {
                        appState.FirmaAdi = companyName
                        dismiss()
                    }
                }
            }
            .navigationTitle("Profili Güncelle")
            .onAppear {
                companyName = appState.FirmaAdi
                // description ve address veritabanı varsa çekilir
            }
        }
    }
}
