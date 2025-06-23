import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else {
                return
            }

            provider.loadObject(ofClass: UIImage.self) { image, error in
                if let uiImage = image as? UIImage {
                    // 500x500 boyut kontrolü
                    
                    DispatchQueue.main.async {
                        self.parent.image = uiImage
                    }
                    
                 //   if Int(uiImage.size.width) == 500 && Int(uiImage.size.height) == 500 {
                       
                  //  } else {
                    //    print("Hatalı boyut: \(uiImage.size.width)x\(uiImage.size.height)")
                   // }
                }
            }
        }
    }
}
