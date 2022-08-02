//
//  CovidDetailTableViewController.swift
//  COVID19
//
//  Created by 이준혁 on 2022/08/03.
//

import UIKit

class CovidDetailTableViewController: UITableViewController {

    @IBOutlet var cellNewCase: UITableViewCell!
    @IBOutlet var cellTotalCase: UITableViewCell!
    @IBOutlet var cellRecovered: UITableViewCell!
    @IBOutlet var cellDeath: UITableViewCell!
    @IBOutlet var cellPercentage: UITableViewCell!
    @IBOutlet var cellOverseasInflow: UITableViewCell!
    @IBOutlet var cellRegionalOutbreak: UITableViewCell!
    
    var covidOverview: CovidOverview?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        guard let covidOverview = self.covidOverview else { return }
        self.title = covidOverview.countryName
        self.cellNewCase.detailTextLabel?.text = "\(covidOverview.newCase)명"
        self.cellTotalCase.detailTextLabel?.text = "\(covidOverview.totalCase)명"
        self.cellRecovered.detailTextLabel?.text = "\(covidOverview.recovered)명"
        self.cellDeath.detailTextLabel?.text = "\(covidOverview.death)명"
        self.cellPercentage.detailTextLabel?.text = "\(covidOverview.percentage)%"
        self.cellOverseasInflow.detailTextLabel?.text = "\(covidOverview.newFcase)명"
        self.cellRegionalOutbreak.detailTextLabel?.text = "\(covidOverview.newCcase)명"
    }

}
