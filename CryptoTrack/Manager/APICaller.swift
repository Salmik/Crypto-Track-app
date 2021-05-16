//
//  APICaller.swift
//  CryptoTrack
//
//  Created by Zhanibek Lukpanov on 11.05.2021.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    public var icons = [Icon]()
    
    private var whenReadyBlock:((Result<[Crypto], Error>) -> Void)?
    
    // MARK:- Constants
    private struct Constants {
        static let apiKey = ""
        static let assetsEndPoint = "https://rest-sandbox.coinapi.io/v1/assets"
        static let realEndPoint = "https://rest.coinapi.io/v1/assets"
    }
    
    private init() {}
    
    // MARK:-
    public func getAllCryptoData(completion: @escaping ((Result<[Crypto], Error>) -> Void)) {
        
        guard !icons.isEmpty else {
            whenReadyBlock = completion
            return
        }
        
        guard let url = URL(string: Constants.realEndPoint + "?apikey=" + Constants.apiKey) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let cryptosJson = try JSONDecoder().decode([Crypto].self, from: data)
                
//                completion(.success(cryptosJson.sorted(by: { first, second in
//                    return first.price_usd ?? 0 > second.price_usd ?? 0
//                })))
                
                completion(.success(cryptosJson.filter({
                    return $0.price_usd ?? 0 > 2
                })))
                
//                completion(.success(cryptosJson))
                
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    public func getAllIcons() {
        
        let apiKey = ""
        
        guard let url = URL(string: "https://rest-sandbox.coinapi.io/v1/assets/icons/55?apikey=\(apiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.whenReadyBlock {
                    self?.getAllCryptoData(completion: completion)
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
    }
    
}
