//
//  PhotosViewController.swift
//  TestTask2
//
//  Created by leanid niadzelin on 18.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData

class PhotosViewController: UIViewController, SWRevealViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var sideMenuBarButton: UIBarButtonItem!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    
    var entityDescription: NSEntityDescription?
    var resultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longPressRecognizer)

        fetchPhotos()
        getLocation()
        setupReveal()
        setupCollectionViewInsets()
        setupShadows()
    
    }
    
    private func setupShadows() {
        addButton.layer.shadowColor = UIColor.gray.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        addButton.layer.shadowRadius = 1.5
        addButton.layer.shadowOpacity = 1
        
        navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 3.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.7
    }
    
    // Reveal
    
    
    private func setupReveal() {
        self.revealViewController().delegate = self
        if self.revealViewController() != nil {
            sideMenuBarButton.target = self.revealViewController()
            sideMenuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPosition.right {
            blackView.isHidden = false
        } else {
            blackView.isHidden = true
        }
    }
    
    // Get photos
    
    private func fetchPhotos() {
        entityDescription = NSEntityDescription.entity(forEntityName: "Photo", in: CoreDataManager.shared.managedObjectContext)
        resultsController = CoreDataManager.shared.getFetchedResultController(entityName: "Photo", sortDescriptor: "date", ascending: false)
        do {
            try resultsController?.performFetch()
        } catch {
            let err = error as NSError
            print("Failed fetch request:", err.localizedDescription)
        }
    }
    
    // Post Image
    
    @IBAction func addPhoto(_ sender: Any) {
        
        
        imagePicker.delegate = self
        
        let addSheet = UIAlertController(title: "Add Photo", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) {[unowned self] action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Failed to use camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        addSheet.addAction(camera)
        
        let gallery = UIAlertAction(title: "Gallery", style: .default) {[unowned self] action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Failed to get photo from gallery", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        addSheet.addAction(gallery)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in }
        addSheet.addAction(cancelButton)
        
        self.present(addSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            postImage(image: image)
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            postImage(image: image)
        } else {
            print("Failed to post image")
        }
        dismiss(animated:true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func postImage(image: UIImage)  {
        
        guard let imageData = UIImageJPEGRepresentation(image.compressImageLow(), 0.1) else { return }
        let timeInterval: Int = Int(Date().timeIntervalSince1970)
        
        API.shared.postPhoto(imageData: imageData.base64EncodedString(), date: timeInterval, latitude: currentLocation.latitude , longitude: currentLocation.longitude , completion: { success, response, error in
            
            if success {
                guard let entityDescription = self.entityDescription else { return }
                let photo = Photo(entity: entityDescription, insertInto: CoreDataManager.shared.managedObjectContext)
                photo.itemId = (response?["data"]["id"].int32!)!
                photo.date = (response?["data"]["date"].int32!)!
                photo.imageURL = response?["data"]["url"].stringValue
                photo.comment = nil
                photo.latitude = (response?["data"]["lat"].doubleValue)!
                photo.longitude = (response?["data"]["lng"].doubleValue)!
                CoreDataManager.shared.saveContext()
                
                DispatchQueue.main.async {
                    let savedLabel = UILabel()
                    savedLabel.text = "Saved Successfully"
                    savedLabel.textColor = .white
                    savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                    savedLabel.numberOfLines = 0
                    savedLabel.textAlignment = .center
                    savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                    savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                    savedLabel.center = self.view.center
                    self.view.addSubview(savedLabel)
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    }, completion: { (isCompleted) in
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                            savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                            savedLabel.alpha = 0
                        }, completion: { (isCompleted) in
                            savedLabel.removeFromSuperview()
                            self.fetchPhotos()
                            self.photoCollectionView.reloadData()
                        })
                    })
                }
            }
        })
    }
    
    // Long press remove photo
    
    @objc private func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.photoCollectionView)
            
            if let indexPath = photoCollectionView?.indexPathForItem(at: touchPoint) {
                guard let resultsController = resultsController else { return }
                let photo = resultsController.object(at: indexPath) as! Photo
                
                let alert = UIAlertController(title: "", message: "Do you want to delete this photo?", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                    
                    API.shared.removePhoto(itemId: Int(photo.itemId), completion: { success, response, error in
                        if success {
                            if error == "removePhotoError" {
                                let alert = UIAlertController(title: "", message: "Internal Server Error", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: nil))
                                CoreDataManager.shared.managedObjectContext.delete(photo)
                                CoreDataManager.shared.saveContext()
                                self.fetchPhotos()
                                self.photoCollectionView?.reloadData()
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                CoreDataManager.shared.managedObjectContext.delete(photo)
                                CoreDataManager.shared.saveContext()
                                self.fetchPhotos()
                                self.photoCollectionView?.reloadData()
                            }
                        }
                    })
                    
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Location
    
    private func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let coordinate = manager.location?.coordinate else { return }
        self.currentLocation = coordinate
        locationManager.stopUpdatingLocation()
    }

    // Collection View
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCellId", for: indexPath) as! PhotoCell
        let photo = resultsController?.object(at: indexPath) as! Photo
        cell.imageView.loadImage(urlString: photo.imageURL ?? "")
        let date = Date(timeIntervalSince1970: TimeInterval(photo.date))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        cell.timeLabel.text = formatter.string(from: date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = resultsController?.fetchedObjects?.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        let storyboard = UIStoryboard(name: "DetailPhoto", bundle: nil)
        let detailPhotoController = storyboard.instantiateViewController(withIdentifier: "detailPhoto") as! DetailPhotoController
        let photo = resultsController?.object(at: indexPath) as! Photo
        let date = Date(timeIntervalSince1970: TimeInterval(photo.date))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH.mm"
        detailPhotoController.photo = photo
        detailPhotoController.dateText = formatter.string(from: date)
        detailPhotoController.image = cell.imageView.image
        self.navigationController?.pushViewController(detailPhotoController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        return CGSize(width: width / 4, height: (width / 4) + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
            return view.frame.width / 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

            return view.frame.width / 16
    }
    
    private func setupCollectionViewInsets() {
        
        let inset = view.frame.width / 16
        photoCollectionView.contentInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}
