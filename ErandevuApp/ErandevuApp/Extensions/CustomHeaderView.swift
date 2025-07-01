import SwiftUI

struct CustomHeaderView: View {
    var title: String
    var onBack: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .leading) {
            Color.white
                .ignoresSafeArea(edges: .top)

            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        onBack?()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .medium))
                            Text("")
                        }
                        .foregroundColor(Color.black.opacity(0.8))
                    }
                    Spacer()
                }
                .padding()
            
            }
        }
        .frame(height: 40) // toplam yükseklik
    }
}
