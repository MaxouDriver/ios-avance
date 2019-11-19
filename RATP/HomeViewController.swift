//
//  HomeViewController.swift
//  RATP
//
//  Created by jpo on 18/11/2019.
//  Copyright © 2019 jpo. All rights reserved.
//

import UIKit
import FirebaseCore
import Alamofire

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    struct APIResponse: Codable {
        let result: Result
    }
    
    // MARK: - Result
    struct Result: Codable {
        let schedules: [Schedule]
    }
    
    // MARK: - Rer
    struct Schedule: Codable {
        let code, message, destination: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            for (index, element) in Favourites.lignes.enumerated() {
            Alamofire.request("https://api-ratp.pierre-grimaud.fr/v4/schedules/rers/\(element.code)/\(element.station)/\(element.direction)").response { response in
                    guard let data = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let apiResponse = try decoder.decode(APIResponse.self, from: data)
                        Favourites.updateTimeOnLine(index: index, time: apiResponse.result.schedules[0].message)
                        self.table.reloadData()
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var table: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favourites.lignes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Label", for: indexPath) as! LineViewCell
        
        cell.name?.text = "\(Favourites.lignes[indexPath.row].station)"
        cell.nextTrain?.text = Favourites.lignes[indexPath.row].next
        
        return cell
    }
    
    func addLine(code: String, direction: String, station: String) {
        
        
        Favourites.addLigne(code: code, direction: direction, station: station)
        self.table.reloadData()
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addStationViewController = storyBoard.instantiateViewController(withIdentifier: "addStationViewController") as! AddStationViewController
        addStationViewController.homeViewController = self
        self.present(addStationViewController, animated: true, completion: nil)
    }
}
