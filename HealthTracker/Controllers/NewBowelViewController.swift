//
//  NewBowelViewController.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/20/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

class NewBowelViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var typePickerView: UIPickerView!
    
    
    let types: [String] = ["small", "normal", "large"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        typePickerView.delegate = self
        typePickerView.dataSource = self
        
        timestampLabel.text = Date().string(withFormat: Constants.DateFormat.Long)
        typePickerView.becomeFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }

    @IBAction func newBowel(_ sender: Any) {
        let timestamp = NSDate()
        var bowelDict = [String:Any]()
        // now get just the date from the timestamp
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.Normal
        
        bowelDict["timestamp"] = timestamp
        bowelDict["date"] = formatter.string(from: timestamp as Date)
        bowelDict["type"] = types[typePickerView.selectedRow(inComponent: 0)]
        _ = Coordinator.shared.coreDataManager.createNewObject(ofType: CoreDataManager.EntityType.Bowel, objectDictionary: bowelDict)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
