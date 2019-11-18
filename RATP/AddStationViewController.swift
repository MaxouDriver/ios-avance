//
//  AddStation.swift
//  RATP
//
//  Created by jpo on 18/11/2019.
//  Copyright © 2019 jpo. All rights reserved.
//

import UIKit

class AddStationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    lazy var lignes: [Int] = self.getMetroLines()
    
    func getMetroLines() -> [Int]{
        var temp: [Int] = []
        for i in 0...17 {
            temp.append(i + 1)
        }
        return temp
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lignes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(lignes[row])"
    }
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    
    @IBAction func next(_ sender: Any) {
        progress.progress += 1/2
        if (progress.progress == 1){
            buttonNext.isHidden = true
            buttonAdd.isHidden = false
        }else {
            buttonAdd.isHidden = true
            buttonNext.isHidden = false
            buttonPrevious.isHidden = false
        }
    }
    @IBAction func previous(_ sender: Any) {
        progress.progress -= 1/2
        if (progress.progress == 0){
            buttonPrevious.isHidden = true
        }else {
            buttonAdd.isHidden = true
            buttonNext.isHidden = false
            buttonPrevious.isHidden = false
        }
    }
    
    @IBAction func onAdd(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.progress = 0
        buttonAdd.isHidden = true
        buttonPrevious.isHidden = true
    }
}
