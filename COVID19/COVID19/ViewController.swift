//
//  ViewController.swift
//  COVID19
//
//  Created by 이준혁 on 2022/08/03.
//

import UIKit

import Alamofire
import Charts

class ViewController: UIViewController {

    @IBOutlet var lblTotalCase: UILabel!
    @IBOutlet var lblNewCase: UILabel!
    @IBOutlet var viewPieChart: PieChartView!
    @IBOutlet var stackViewLabel: UIStackView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.startAnimating()
        self.fetchCovidOverview(completionHandler: { [weak self] result in
            guard let self = self else { return }
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.stackViewLabel.isHidden = false
            self.viewPieChart.isHidden = false
            switch result {
            case let .success(result):
                debugPrint("success \(result)")
                self.configureStackView(koreaCovidOverview: result.korea)
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
                self.configureChatView(covidOverviewList: covidOverviewList)
            case let .failure(error):
                debugPrint("error \(error)")
            }
            
        })
    }
    
    func makeCovidOverviewList(cityCovidOverview: CityCovidOverview) -> [CovidOverview] {
        return [
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.daegu,
            cityCovidOverview.incheon,
            cityCovidOverview.gwangju,
            cityCovidOverview.daejeon,
            cityCovidOverview.ulsan,
            cityCovidOverview.sejong,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.jeju,
        ]
    }
    
    func configureChatView(covidOverviewList: [CovidOverview]) {
        self.viewPieChart.delegate = self
        let entries = covidOverviewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(value: self.removeFormatString(string: overview.newCase),
                                     label: overview.countryName,
                                     data: overview)
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        dataSet.colors = ChartColorTemplates.vordiplom() +
                         ChartColorTemplates.joyful() +
                         ChartColorTemplates.liberty() +
                         ChartColorTemplates.pastel() +
                         ChartColorTemplates.material()
        self.viewPieChart.data = PieChartData(dataSet: dataSet)
        
        self.viewPieChart.spin(duration: 0.3, fromAngle: self.viewPieChart.rotationAngle, toAngle: self.viewPieChart.rotationAngle + 80)
    }
    
    func removeFormatString(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }
    
    func configureStackView(koreaCovidOverview: CovidOverview) {
        self.lblTotalCase.text = "\(koreaCovidOverview.totalCase)명"
        self.lblNewCase.text = "\(koreaCovidOverview.newCase)명"
    }

    func fetchCovidOverview(completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void) {
        let url = "https://api.corona-19.kr/korea/country/new"
        let param = [
            "serviceKey": getApiKey()
        ]
        
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(error))
                    }
                    
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
    }

}

extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailTableViewController = self.storyboard?.instantiateViewController(identifier: "CovidDetailTableViewController") as? CovidDetailTableViewController else { return }
        guard let covidOverview = entry.data as? CovidOverview else { return }
        covidDetailTableViewController.covidOverview = covidOverview
        self.navigationController?.pushViewController(covidDetailTableViewController, animated: true)
    }
}
