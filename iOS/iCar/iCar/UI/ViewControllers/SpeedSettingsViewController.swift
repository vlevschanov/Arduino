//
//  SpeedSettingsViewController.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import UIKit


class SpeedSettingsViewController: BaseViewController, WebSocketUseCaseDelegate, SpeedSettingsCellDelegate, UITableViewDataSource, UITableViewDelegate {

    let settingsUseCase = SettingsUseCase(withSocketManager: WebSocketManager.sharedManager)
    
    private let sections = ["Front left motor", "Front right motor", "Rear left motor", "Rear right motor"]
    private let rows = ["Forward speed", "Backward speed"]
    
    @IBOutlet weak var tableView: UITableView!
    
    private var settings = Settings()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib.init(nibName: "SpeedSettingsCell", bundle: Bundle.main), forCellReuseIdentifier: SpeedSettingsCell.reuseIdentifier())
        
        reloadSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsUseCase.beginWebSocketInteraction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        settingsUseCase.endWebSocketInteraction()
    }
    
    // MARK: - WebSocketUseCaseDelegate
    
    func useCaseDidFailWithError(useCase: WebSocketUseCase, error: Error) {
        showToastMessage(message: "\(error)")
    }
    
    // MARK: - SpeedSettingsCellDelegate
    
    func settingsValueChanged(cell: SpeedSettingsCell, value: Int) {
        guard let ip = tableView.indexPath(for: cell) else {
            return
        }
        switch ip.section {
        case 0:
            if ip.row == 0 {
                settings.frontLeftForwardSpeed = value
            }
            else {
                settings.frontLeftBackwardSpeed = value
            }
        case 1:
            if ip.row == 0 {
                settings.frontRightForwardSpeed = value
            }
            else {
                settings.frontRightBackwardSpeed = value
            }
        case 2:
            if ip.row == 0 {
                settings.rearLeftForwardSpeed = value
            }
            else {
                settings.rearLeftBackwardSpeed = value
            }
        case 3:
            if ip.row == 0 {
                settings.rearRightForwardSpeed = value
            }
            else {
                settings.rearRightBackwardSpeed = value
            }
        default:
            preconditionFailure("unexpected behaviour")
        }
    }

    // MARK: - Actions

    @IBAction func reset(_ sender: UIBarButtonItem) {
        reloadSettings()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Private 
    
    private func reloadSettings() {
        showLoadingView()
        settingsUseCase.requestSettings { [weak self] (settings) in
            self?.hideLoadingView()
            self?.settings = settings
            self?.tableView.reloadData()
        }
    }

    // MARK: - UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SpeedSettingsCell.reuseIdentifier()) as? SpeedSettingsCell else {
            precondition(false)
        }
        
        let isForward = indexPath.row == 0
        let title = rows[indexPath.row]
        
        var value: Int = 0
        switch indexPath.section {
        case 0:
            value = isForward ? settings.frontLeftForwardSpeed : settings.frontLeftBackwardSpeed
        case 1:
            value = isForward ? settings.frontRightForwardSpeed : settings.frontRightBackwardSpeed
        case 2:
            value = isForward ? settings.rearLeftForwardSpeed : settings.rearLeftBackwardSpeed
        case 3:
            value = isForward ? settings.rearRightForwardSpeed : settings.rearRightBackwardSpeed
        default: break
        }
        cell.configure(viewModel: SpeedSettingsCellViewModel(title: title, value: value))
        return cell
    }
    
   // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
