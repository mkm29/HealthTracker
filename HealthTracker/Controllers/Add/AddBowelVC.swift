//
//  NewBowelViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/20/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//
import UIKit

class AddBowelVC: AddEntityVC, SetDateProtocol {
    
    override var entityType: Constants.EntityType { return Constants.EntityType.Bowel }

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var manualTime: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var largeLabel: UILabel!
    @IBOutlet var setDateTimeView: UIView!
    var setTime = false
    var setDate: Date?
    let types: [String] = ["small", "normal", "large"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        addButton.roundBottom(withRadius: Constants.Design.cornerRadius)
        slider.isContinuous = false
        smallLabel.sizeToFit()
        largeLabel.sizeToFit()
    }
    
    @IBAction func setDateButtonTapped(_ sender: Any) {
        setTime = true
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "setDateTimeViewController") as! SetDateTimeVC
        controller.setDateProtocol = self
        controller.preferredContentSize = CGSize(width: view.frame.width-50, height: view.frame.height/2)
        controller.view.layer.cornerRadius = 10
        controller.view.layer.borderColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0).cgColor
        controller.view.layer.borderWidth = 1.5
        showPopup(controller, sourceView: addButton)
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    func setDate(date: Date) {
        setDate = date
    }
    
    @IBAction func save(_ sender: Any) {
        var date: Date!
        if setTime, let setDate = setDate {
            date = setDate
        } else {
            date = Date()
        }

        let dict: [String:Any] = ["date" : date.string(withFormat: Constants.DateFormat.Normal),
                                  "timestamp" : date,
                                  "intensity" : Int16(slider.value)]
        _ = addEntity(fromDict: dict)

        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
