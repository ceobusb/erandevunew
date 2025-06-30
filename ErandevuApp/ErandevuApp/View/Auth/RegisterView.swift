import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State private var showMenu = false
    
    var body: some View {
        MainLayout(showMenu: $showMenu) {
            ZStack(alignment: .leading) {
                VStack(spacing: 0) {
                    ScrollView {
                        Text("Kayıt Türünü Seçin")
                            .font(.title)
                            .bold()
                        
                        NavigationLink(destination: RegisterFirmaView()) {
                            Text("Firma Kaydı")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        
                        NavigationLink(destination: RegisterMusteriView()) {
                            Text("Müşteri Kaydı")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
          
            .navigationBarBackButtonHidden(true)
            .navigationTitle("")
        
        }
     
    }
}

