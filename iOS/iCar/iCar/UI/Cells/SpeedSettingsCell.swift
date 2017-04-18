//
//  SpeedSettingsCell.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import UIKit

protocol SpeedSettingsCellDelegate: class {
    func settingsValueChanged(cell: SpeedSettingsCell, value: Int)
}

struct SpeedSettingsCellViewModel {
    let title: String
    let value: Int
}

class SpeedSettingsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var valueStepper: UIStepper!
    
    weak var delegate: SpeedSettingsCellDelegate?
    
    func configure(viewModel: SpeedSettingsCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = "\(viewModel.value)"
        valueSlider.setValue(Float(viewModel.value), animated: false)
        valueStepper.value = Double(viewModel.value)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        valueStepper.value = Double(sender.value)
        let value = Int(floorf(sender.value))
        valueLabel.text = "\(value)"
        delegate?.settingsValueChanged(cell: self, value: value)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        valueSlider.setValue(Float(sender.value), animated: true)
        let value = Int(floor(sender.value))
        valueLabel.text = "\(value)"
        delegate?.settingsValueChanged(cell: self, value: value)
    }
    
    class func reuseIdentifier() -> String {
        return "SpeedSettingsCell"
    }
}
