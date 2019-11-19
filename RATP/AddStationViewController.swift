//
//  AddStation.swift
//  RATP
//
//  Created by jpo on 18/11/2019.
//  Copyright © 2019 jpo. All rights reserved.
//

import UIKit
import Alamofire

class AddStationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var homeViewController: HomeViewController?
    
    var lignes: [Rer] = []
    // MARK: - Welcome
    struct APIResponse: Codable {
        let result: Result
    }
    
    // MARK: - Result
    struct Result: Codable {
        let rers: [Rer]
    }
    
    // MARK: - Rer
    struct Rer: Codable {
        let code, name, directions, id: String
    }
    
    // MARK: - Welcome
    struct StationsAPIResponse: Codable {
        let result: StationsResult
    }
    
    // MARK: - Result
    struct StationsResult: Codable {
        let stations: [Station]
    }
    
    // MARK: - Station
    struct Station: Codable {
        let name, slug: String
    }
    
    // MARK: - Welcome
    struct DirectionAPIResponse: Codable {
        let result: DirectionResult
    }
    
    // MARK: - Result
    struct DirectionResult: Codable {
        let destinations: [Destination]
    }
    
    // MARK: - Destination
    struct Destination: Codable {
        let name, way: String
    }
    
    var stations: [Station] = []
    var sens: [Destination] = []
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func dataSource(index: Int) -> [String]{
        switch index {
        case 0:
            return lignes.map{"\($0.name) \($0.directions)"}
            
        case 1:
            return sens.map{"\($0.name)"}
            
        case 2:
            return stations.map{"\($0.name)"}
            
        default:
            return []
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var temp: Int = 0
        if (linePicker == pickerView) {
            temp = 0
        }else if (destinationPicker == pickerView){
            temp = 1
        }else {
            temp = 2
        }
        return dataSource(index: temp).count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var temp: Int = 0
        if (linePicker == pickerView) {
            temp = 0
        }else if (destinationPicker == pickerView){
            temp = 1
        }else {
            temp = 2
        }
        return dataSource(index: temp)[row]
    }
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var linePicker: UIPickerView!
    @IBOutlet weak var stationPicker: UIPickerView!
    @IBOutlet weak var destinationPicker: UIPickerView!
    
    @IBAction func onNext(_ sender: Any) {
        progress.progress += 1/2
        
        update()
        if (progress.progress == 1){
            buttonNext.isHidden = true
            buttonAdd.isHidden = false
        }else {
            buttonAdd.isHidden = true
            buttonNext.isHidden = false
            buttonPrevious.isHidden = false
        }
    }
    @IBAction func onPrevious(_ sender: Any) {
        progress.progress -= 1/2
        
        update()
        if (progress.progress == 0){
            buttonPrevious.isHidden = true
        }else {
            buttonAdd.isHidden = true
            buttonNext.isHidden = false
            buttonPrevious.isHidden = false
        }
    }
    
    func update() {
        switch progress.progress {
        case 0:
            onLines()
            break
        case 1/2:
            onDirection()
            break
        case 1:
            onStation()
            break
        default:
            linePicker.isHidden = false
            stationPicker.isHidden = true
            destinationPicker.isHidden = true
        }
    }
    
    
    @IBAction func onAdd(_ sender: Any) {
        print(lignes.count)
        print(linePicker.selectedRow(inComponent: 0))
        
        print(sens.count)
        print(destinationPicker.selectedRow(inComponent: 0))
        
        print(stations.count)
        print(stationPicker.selectedRow(inComponent: 0))
        
        homeViewController?.addLine(code: lignes[linePicker.selectedRow(inComponent: 0)].code, direction: sens[destinationPicker.selectedRow(inComponent: 0)].way, station: stations[stationPicker.selectedRow(inComponent: 0)].slug)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        self.present(homeViewController, animated: true, completion: nil)
    }
    
    func onLines() {
        linePicker.isHidden = false
        stationPicker.isHidden = true
        destinationPicker.isHidden = true
    }
    
    func onStation() {
        linePicker.isHidden = true
        stationPicker.isHidden = false
        destinationPicker.isHidden = true
        
    Alamofire.request("https://api-ratp.pierre-grimaud.fr/v4/stations/rers/\(lignes[linePicker.selectedRow(inComponent: 0)].code)?way=A").response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(StationsAPIResponse.self, from: data)
                self.stations = apiResponse.result.stations
                self.stationPicker.reloadAllComponents()
            } catch let error {
                print(error)
            }
        }
    }
    
    func onDirection() {
        linePicker.isHidden = true
        stationPicker.isHidden = true
        destinationPicker.isHidden = false
        
    Alamofire.request("https://api-ratp.pierre-grimaud.fr/v4/destinations/rers/\(lignes[linePicker.selectedRow(inComponent: 0)].code)").response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(DirectionAPIResponse.self, from: data)
                self.sens = apiResponse.result.destinations
                self.destinationPicker.reloadAllComponents()
            } catch let error {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.progress = 0
        buttonAdd.isHidden = true
        buttonPrevious.isHidden = true
        
        update()
        
        // Init the first picker with all lines
        Alamofire.request("https://api-ratp.pierre-grimaud.fr/v4/lines/rers").response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                self.lignes = apiResponse.result.rers
                self.linePicker.reloadAllComponents()
            } catch let error {
                print(error)
            }
        }
    }
}
