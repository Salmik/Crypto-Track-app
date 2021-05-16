//
//  ViewController.swift
//  CryptoTrack
//
//  Created by Zhanibek Lukpanov on 11.05.2021.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK:- Properties
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.reuseID)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    private var cryptoViewModel = [CryptoTableViewCellViewModel]()
    private var cryptoIcons = [Icon]()
    
    static let numberFormatter: NumberFormatter = {
       let numberFormatter = NumberFormatter()
        numberFormatter.locale = .current
        numberFormatter.allowsFloats = true
        numberFormatter.formatterBehavior = .default
//      numberFormatter.numberStyle = .currency
        return numberFormatter
    }()

    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        APICaller.shared.getAllCryptoData {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.cryptoViewModel = model.compactMap({ model in
                    
                    let price = model.price_usd ?? 0
                    let formatter = ViewController.numberFormatter
                    guard let priceString = formatter.string(from: NSNumber(value: price.rounded())) else{ return nil}
                    
                    let iconUrl = URL(string: APICaller.shared.icons.filter({ icon in
                        icon.asset_id == model.asset_id
                   }).first?.url ?? "N/A")
                                        
                 return CryptoTableViewCellViewModel(name: model.name ?? "N/A",
                                                     symbol: model.asset_id ?? "no assets found",
                                                     price: "$\(priceString)" ,
                                                     iconUrl: iconUrl)
                })
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.reuseID, for: indexPath) as? CryptoTableViewCell else { return UITableViewCell() }
        
        let crypto = cryptoViewModel[indexPath.row]
        
        cell.configure(viewModel: crypto)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
