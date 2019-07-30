//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 23.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class DiaryDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var entryImage: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var entryTextview: UITextView!
    @IBOutlet weak var entryLocationButton: UIButton!
    @IBOutlet weak var locationActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    private let locationButtonText = "Add Location"
    private let saveButtonText = "Save"
    private let maxCharactersForEntry = "200"
    private let characterLimit = 200
    var indexPath: IndexPath?
    var managedObjectContext: NSManagedObjectContext!
    var diaryEntry: DiaryEntry?
    var mood: Mood?
    var imageSet = false
    
    lazy var delegate: UITableViewDelegate = {
        return EntryDetailDelegate(tableView: self.tableView, indexPath: self.indexPath)
    }()
    
    lazy var dataSource: UITableViewDataSource = {
        return EntryDetailDatasource(tableView: self.tableView, context: self.managedObjectContext, viewController: self, indexPath: indexPath)
    }()
    
    lazy var photoPickerManager: PhotoPickerManager = {
        let manager = PhotoPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()
    
    lazy var locationManager: LocationManager = {
        return LocationManager(delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        entryTextview.delegate = self
        setDiaryEntry()
        setupSaveButton()
    }
    
    // MARK: - Actions
    @IBAction func setMood(_ sender: UIButton) {
        moodImage.image = Mood(rawValue: Int16(sender.tag))?.image
        switch sender.tag {
        case 1:
            mood = .bad
        case 2:
            mood = .average
        case 3:
            mood = .good
        default:
            mood = nil
        }
    }
    
    /// Action to trigger location search
    @IBAction func getLocation(_ sender: Any) {
        
        if !locationManager.isAuthorized {
            do {
                try locationManager.requestLocationAuthorization()
            } catch LocationError.disallowedByUser {
                showSettingsAlert(with: "No Access", and: "Please allow location services in the settings to proceed.")
            } catch {
                fatalError()
            }
        } else {
            self.locationActivityIndicator.startAnimating()
            locationManager.requestLocation()
        }
        
    }
    
    /// Action to trigger photo picker
    @IBAction func pickPhoto(_ sender: Any) {
        photoPickerManager.presentPhotoPicker(animated: true)
    }
    
    
    // MARK: - Helper Methods
    
    /// Setup save button
    func setupSaveButton() {
        let saveButton = UIBarButtonItem(title: saveButtonText, style: .done, target: self, action: #selector(saveEntry))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    /// Save the entry
    @objc func saveEntry() {
        
        if diaryEntry == nil {
            let newEntry = DiaryEntry(context: managedObjectContext)
            
            newEntry.creationDate = NSDate()
            newEntry.updatedDate = NSDate()
            newEntry.entry = entryTextview.text
            if let rating = mood { newEntry.rating = rating.rawValue }
            newEntry.location = entryLocationButton.titleLabel?.text == locationButtonText ? nil : entryLocationButton.titleLabel?.text
            
            if imageSet {
                if let newImage = entryImage.image {
                    newEntry.image = newImage.jpegData(compressionQuality: 0.2) as NSData?
                }
            }
            
        } else {
            diaryEntry?.updatedDate = NSDate()
            diaryEntry?.entry = entryTextview.text
            if let rating = mood { diaryEntry?.rating = rating.rawValue }
            
            diaryEntry?.location = entryLocationButton.titleLabel?.text == locationButtonText ? nil : entryLocationButton.titleLabel?.text
            
            if imageSet {
                if let newImage = entryImage.image {
                    diaryEntry?.image = newImage.jpegData(compressionQuality: 0.2) as NSData?
                }
            }
            
        }
        // Update Changes
        managedObjectContext.saveChanges()
        navigationController?.popViewController(animated: true)
    }
    
    /// Sets up view for existing entry
    func setDiaryEntry() {
        if let diaryEntry = diaryEntry {
            self.title = (diaryEntry.creationDate as Date).getReadableWith(weekday: false, day: true, year: true)
            
            let creationDate = diaryEntry.creationDate as Date
            if diaryEntry.image != nil {
                entryImage.image = UIImage(data: diaryEntry.image! as Data)
                entryImage.contentMode = .scaleToFill
                plusImageView.isHidden = true
            } else {
                entryImage.contentMode = .center
                plusImageView.isHidden = false
            }
            
            monthLabel.text = creationDate.getReadableWith(weekday: false, day: false, year: true)
            entryDateLabel.text = creationDate.getReadableWith(weekday: true, day: true, year: false)
            moodImage.image = Mood(rawValue: diaryEntry.rating)?.image
            entryTextview.text = diaryEntry.entry
            entryLocationButton.setTitle(diaryEntry.location, for: .normal)
            setCharacterCountLabel(with: diaryEntry.entry.count)
            
            if diaryEntry.location == nil {
                entryLocationButton.setTitle(locationButtonText, for: .normal)
            }
            
        } else {
            entryImage.image = UIImage(imageLiteralResourceName: "icn_picture")
            entryImage.contentMode = .center
            plusImageView.isHidden = false
            self.title = Date().getReadableWith(weekday: false, day: true, year: true)
            setCharacterCountLabel(with: 0)
            monthLabel.text = Date().getReadableWith(weekday: false, day: false, year: true)
            entryDateLabel.text = Date().getReadableWith(weekday: true, day: true, year: false)
        }
    }
    
}

/// Apple documentation: https://developer.apple.com/documentation/uikit/uitextviewdelegate
extension DiaryDetailViewController: UITextViewDelegate {

    /// Asks the delegate whether the specified text should be replaced in the text view.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uitextviewdelegate/1618630-textview
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        setCharacterCountLabel(with: changedText.count)
        
        return changedText.count <= characterLimit
    }
    
    
    // MARK: Helper method
    
    /// Sets up the charachter count label with different colors using attributed strings
    func setCharacterCountLabel(with count: Int) {
        var range = NSRange(location:0, length:1)
        
        let greenColor = UIColor(red: 125/255, green: 156/255, blue: 91/255, alpha: 1.0)
        
        if count < 10 {
            range = NSRange(location: 0, length: 1)
        } else if count < 100 {
            range = NSRange(location: 0, length: 2)
        } else if count < 300 {
            range = NSRange(location: 0, length: 3)
        }
        
        let attributedString = NSMutableAttributedString(string: "\(count)/\(maxCharactersForEntry)", attributes: [NSAttributedString.Key.font:UIFont(name: "Avenir-Heavy", size: 12.0)!])
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: greenColor, range: range)
        
        characterCountLabel.attributedText = attributedString
    }
    
}

extension DiaryDetailViewController: LocationManagerDelegate {
    
    /// Tells delegsated that location has been obtained
    /// Obtains location (city and country name) from coordinate and sets up the button
    func obtainedCoordinates(_ coordinate: Coordinate) {
        
        locationManager.getCityFrom(coordinate) { place, error in
            
            if let place = place?.first, let city = place.locality, let country = place.country {
                self.entryLocationButton.setTitle("\(city), \(country)", for: .normal)
                self.locationActivityIndicator.stopAnimating()
            }
            
            if error != nil {
                self.showAlert(with: "Error", and: error!.localizedDescription)
            }
            
        }
        
    }
    /// Informs delegate of failure
    func failedWithError(_ error: LocationError) {
        showAlert(with: "Error", and: error.localizedDescription)
    }
}

extension DiaryDetailViewController: PhotoPickerManagerDelegate {
    
    /// Tells delegate that photo has been picked
    func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage) {
        
        manager.dismissPhotoPicker(animated: true) {
            self.entryImage.image = image
            self.imageSet = true
            self.plusImageView.isHidden = true
            self.entryImage.contentMode = .scaleAspectFill
        }
    }
    
}
