//
//  YPImagePickerView.swift
//  KlockApp
//
//  Created by 성찬우 on 12/27/23.
//

import SwiftUI
import YPImagePicker

struct YPImagePickerView: UIViewControllerRepresentable {
    @Binding var showingImagePicker: Bool
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library, .photo]

        let picker = YPImagePicker(configuration: config)
        // Configure your picker here
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.selectedImage = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }

        return picker
    }

    func updateUIViewController(_ uiViewController: YPImagePicker, context: Context) {}

    class Coordinator: NSObject, YPImagePickerDelegate {
        var parent: YPImagePickerView

        init(parent: YPImagePickerView) {
            self.parent = parent
        }

        func imagePickerHasNoItemsInLibrary(_ picker: YPImagePicker) {
            
        }
        
        func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
            return false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

//#Preview {
//    YPImagePickerView()
//}
