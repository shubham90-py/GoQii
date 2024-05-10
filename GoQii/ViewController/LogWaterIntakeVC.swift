//
//  LogWaterIntakeVC.swift
//  GoQii
//
//  Created by Neosoft on 02/05/24.
//

import UIKit
import CoreData

class LogWaterIntakeVC: UIViewController {

    // IB Outlets Text filed & Segment Control
    @IBOutlet weak var tfAmountTextField: UITextField!
    @IBOutlet weak var logInTake: UIButton!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    
    // Add a property to store the selected unit
    var selectedUnit: String = "ml" // Default unit
    var waterIntakeToEdit: WaterIntake?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()

    }
    
    func setupUI() {
        
        if let waterIntake = waterIntakeToEdit {
                    // If editing an existing entry, pre-fill the text field and segmented control
                    tfAmountTextField.text = "\(waterIntake.amount)"
                    if let unit = waterIntake.unit {
                        let segmentIndex = unitSegmentedControl.numberOfSegments - 1
                        for index in 0...segmentIndex {
                            if let title = unitSegmentedControl.titleForSegment(at: index), title == unit {
                                unitSegmentedControl.selectedSegmentIndex = index
                                break
                            }
                        }
                    }
                }
    }
    
    func updateUI () {
        logInTake.applyCornerRadius(8.0)
        logInTake.applyShadow()
        logInTake.applyOpacity(0.8)
    }
    
    
    @IBAction func logIntakeButtonTapped(_ sender: Any) {
        
        guard let amountText = tfAmountTextField.text, let amount = Double(amountText) else {
            return
        }
        
        let unitIndex = unitSegmentedControl.selectedSegmentIndex
        let unit = unitSegmentedControl.titleForSegment(at: unitIndex) ?? ""
        
        let context = CoreDataStack.shared.context
        if let waterIntake = waterIntakeToEdit {
            // If editing an existing entry, update its values
            waterIntake.amount = amount
            waterIntake.unit = unit
        } else {
            // If adding a new entry, create a new WaterIntake object
            let waterIntake = WaterIntake(context: context)
            waterIntake.date = Date()
            waterIntake.amount = amount
            waterIntake.unit = unit
        }
        
        CoreDataStack.shared.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func unitSegmentedControlValueChange(_ sender: Any) {
        
        let selectedUnitIndex = (sender as AnyObject).selectedSegmentIndex
        selectedUnit = (sender as AnyObject).titleForSegment(at: selectedUnitIndex ?? 0) ?? "ml"
    }
    
}
