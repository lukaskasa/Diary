//
//  PhotoPickerManager.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 26.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

protocol PhotoPickerManagerDelegate: class {
    func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage)
}

/// Manager to handle the photo selection
class PhotoPickerManager: NSObject {
    
    // MARK: - Properties
    private let imagePickerController = UIImagePickerController()
    private let presentingController: UIViewController
    weak var delegate: PhotoPickerManagerDelegate?
    
    /// Initializer
    init(presentingViewController: UIViewController) {
        self.presentingController = presentingViewController
        super.init()
        configure()
    }
    
    /// Presents the image picker while handling authorization
    func presentPhotoPicker(animated: Bool) {
        
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied, .restricted:
            presentingController.showSettingsAlert(with: "No Camera Access", and: "Please enable camera access in your settings.")
        case .authorized:
            presentingController.present(self.imagePickerController, animated: animated, completion: nil)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                     self.presentingController.present(self.imagePickerController, animated: animated, completion: nil)
                }
            }
        @unknown default:
            fatalError()
        }
        
    }
    
    /// Dismisses the image picker
    func dismissPhotoPicker(animated: Bool, completion: (() -> Void)?) {
        imagePickerController.dismiss(animated: animated, completion: completion)
    }
    
    /// Configures the imagepicker while checking for the source availability
    private func configure() {
    
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .rear
            imagePickerController.showsCameraControls = true
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
    }
    
}

/// MARK: - UIImagePickerControllerDelegate
/// Apple documentation: https://developer.apple.com/documentation/uikit/uiimagepickercontrollerdelegate
extension PhotoPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// Tells the delegate that the user picked a still image or movie.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uiimagepickercontrollerdelegate/1619126-imagepickercontroller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Cast image to UIImage
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        delegate?.manager(self, didPickImage: image)
    }
    
}
