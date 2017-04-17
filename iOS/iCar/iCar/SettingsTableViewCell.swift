//
//  SettingsTableViewCell.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import UIKit

protocol SettingsTableViewCellDelegate: class {
    func settingsValueChanged(cell: SettingsTableViewCell, value: Int)
}

struct SettingsTableViewCellModel {
    let title: String
    let value: Int
}

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!
    
    weak var delegate: SettingsTableViewCellDelegate?
    
    func configure(viewModel: SettingsTableViewCellModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = "\(viewModel.value)"
        valueSlider.setValue(Float(viewModel.value), animated: false)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        delegate?.settingsValueChanged(cell: self, value: Int(floorf(sender.value)))
    }
    
    class func reuseIdentifier() -> String {
        return "SettingsTableViewCell"
    }
}
