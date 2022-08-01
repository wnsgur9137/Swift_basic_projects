//
//  ViewController.swift
//  Weather
//
//  Created by 이준혁 on 2022/07/31.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var txtCityName: UITextField!
    @IBOutlet var lblCityName: UILabel!
    @IBOutlet var lblWeatherDescription: UILabel!
    @IBOutlet var lblTemp: UILabel!
    @IBOutlet var lblMaxTemp: UILabel!
    @IBOutlet var lblMinTemp: UILabel!
    @IBOutlet var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapFetchWeather(_ sender: UIButton) {
        if let cityName = self.txtCityName.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    
    func configureView(weatherInformation: WeatherInformation) {
        self.lblCityName.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {
            self.lblWeatherDescription.text = weather.description
        }
        self.lblTemp.text = "\(Int(weatherInformation.temp.temp - 273.15))℃"
        self.lblMinTemp.text = "최저: \(Int(weatherInformation.temp.minTemp - 273.15))℃"
        self.lblMaxTemp.text = "최고: \(Int(weatherInformation.temp.maxTemp - 273.15))℃"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(weatherApiKey)") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            let successRange = (200..<300)
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            
            // 응답 받은 statusCode가 200번대인지 확인
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                DispatchQueue.main.async {  // main Thread에서 작업할 수 있도록 함.
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                }
                debugPrint(weatherInformation)
            } else {    // statusCode가 200번대가 아닐 경우(Error)
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
                debugPrint(errorMessage)
            }
        }.resume()
    }
}

