//
//  ExchangeRatesViewController.swift
//  CurrencyConverter
//
//  Created by Anthony Jerez on 11/18/23.
//


import UIKit
import Charts
import DGCharts

class ExchangeRatesViewController: UIViewController, CodeSelectionDelegate {
    
    var lineChartView: LineChartView!
    @IBOutlet weak var baseCodeButton: UIButton!
    @IBOutlet weak var targetCodesButton: UIButton!
    @IBOutlet weak var graphButton: UIButton!
    var targetCodes: [Currency] = []
    var exchangeRates: ExchangeRates?
    var isGraphButtonSelected: Bool = false
    let baseCodeButtonLen = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        lineChartView = LineChartView()
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineChartView)
        setConstraints()
        setupEmptyLineChart()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCodeSelectionViewController" {
            if let destinationVC = segue.destination as? CodeSelectionViewController {
                destinationVC.delegate = self
            }
        } 
    }
    
    @IBAction func unwindToChartViewController(_ segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? TargetCodesSelectionViewController {
            if targetCodes != sourceViewController.selectedCurrencies {
                targetCodes = sourceViewController.selectedCurrencies
                resetGraphButtonInteraction()
            }
        }
    }
    
    @IBAction func graphButtonTapped(_ sender: UIButton) {
        guard let baseText = baseCodeButton.titleLabel?.text else { return }
        if baseText.count == baseCodeButtonLen && !targetCodes.isEmpty && !isGraphButtonSelected {
            setData()
            isGraphButtonSelected = true
            graphButton.isUserInteractionEnabled = false
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([ lineChartView.topAnchor.constraint(equalTo: baseCodeButton.bottomAnchor, constant: 8), lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor), lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor), lineChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarController!.tabBar.frame.height)])
    }
    
    private func setupEmptyLineChart() {
        lineChartView.clear()
        lineChartView.noDataText = "Select a base currency code and up to 8 target currency codes to see real-time exchange rates!"
        lineChartView.noDataTextColor = UIColor.lightGray
        lineChartView.noDataFont = UIFont.systemFont(ofSize: 20.0)
        lineChartView.noDataTextAlignment = .center
    }
    
    private func setData() {
        guard let baseCode = baseCodeButton.titleLabel?.text else { return }
        CurrencySelectionService.fetchExchangeRates(on: self, baseCode) { [weak self] exchangeRates in
            self?.exchangeRates = exchangeRates
            self?.loadData()
        }
    }
   
    private func loadData() {
        guard let exchangeRates = exchangeRates else { return }
        let selectedExchangeRates = exchangeRates.conversionRates.filter { (key, value) in targetCodes.map { $0.code }.contains(key) }
        let dataEntries: [ChartDataEntry] = selectedExchangeRates.enumerated().map { (index, element) in
            return ChartDataEntry(x: Double(index), y: element.value)
        }
        let dataSet = LineChartDataSet(entries: dataEntries, label: "Exchange Rates")
        dataSet.mode = .cubicBezier // Set mode to cubic Bezier
        dataSet.colors = [NSUIColor.blue] // Line color
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = NSUIColor.blue
        dataSet.fillAlpha = 0.5
        dataSet.valueTextColor = UIColor.white
        dataSet.valueFont = UIFont.systemFont(ofSize: 12.0)
        let data = LineChartData(dataSet: dataSet)
        // Set X-axis labels
        let xValues = selectedExchangeRates.keys.map { $0 }
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        lineChartView.xAxis.granularity = 1.0
        lineChartView.xAxis.labelPosition = .bottom
        // Set exchange rates label to be at top
        lineChartView.legend.verticalAlignment = .top
        lineChartView.legend.horizontalAlignment = .center
        lineChartView.legend.orientation = .horizontal
        lineChartView.legend.drawInside = false
        // Set text color for axis labels
        lineChartView.xAxis.labelTextColor = UIColor.white
        lineChartView.leftAxis.labelTextColor = UIColor.white
        lineChartView.rightAxis.labelTextColor = UIColor.white
        // Set text color for grind lines
        lineChartView.xAxis.axisLineColor = UIColor.gray
        lineChartView.xAxis.gridColor = UIColor.gray
        // Set text color for exchange rates label
        lineChartView.legend.textColor = UIColor.white
        // Set up the chart view
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    private func resetGraphButtonInteraction() {
        graphButton.isUserInteractionEnabled = true
        isGraphButtonSelected = false
    }
    
    func didSelectCurrency(_ code: String, _ flag: String) {
        guard let baseCode = baseCodeButton.titleLabel?.text else { return }
        if baseCode != code {
            baseCodeButton.setTitle(code, for: .normal)
            resetGraphButtonInteraction()
        }
    }
}
