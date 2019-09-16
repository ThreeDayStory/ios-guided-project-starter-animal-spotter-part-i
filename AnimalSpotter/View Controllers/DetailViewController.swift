//
//  DetailViewController.swift
//  AnimalSpotter
//
//  Created by Jessie Ann Griffin on 9/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var dateTimeLabel: UILabel! // spottedOnLabel
    @IBOutlet weak var locationLabel: UILabel! // coordinatesLabel
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var animalImageView: UIImageView!
    
    // MARK: Properties
    var apiController: APIController?
    var animalName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
    }
    
    private func getDetails() {
        guard let apiController = apiController, let animalName = animalName else { return }
        
        apiController.fetchDetails(for: animalName) { (result) in
            do {
                let animal = try result.get() // take off the if let because the try is no longer optional
                DispatchQueue.main.async {
                    self.updateViews(with: animal)
                }
                
                apiController.fetchImage(from: animal.imageURL, completion: { (result) in
                    if let image = try? result.get() {
                        DispatchQueue.main.async {
                            self.animalImageView.image = image
                        }
                    }
                })
            } catch let error as NetworkError { // handling the different errors
                switch error {
                case .noAuth:
                    // present the login screen
                    print("No auth error")
                default:
                    print("error")
                }
            } catch {
                print(error)
            }
            
        }
    }
    
    private func updateViews(with animal: Animal) {
        title = animal.name
        descriptionLabel.text = animal.description
        locationLabel.text = "lat: \(animal.latitude), long: \(animal.longitude)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateTimeLabel.text = dateFormatter.string(from: animal.timeSeen)
    }
}
