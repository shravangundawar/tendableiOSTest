//
//  NetworkManager.swift
//  TendableiOSTest
//
//  Created by Shravan Gundawar on 05/06/24.
//

import Foundation

class NetworkManager {
    //MARK: Properties
    private let baseURL = URL(string: AppConstants.APIConstants.baseUrl)!
    private let session = URLSession.shared
    
    //MARK: Methods
    func request<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL.appendingPathComponent(endpoint)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func postRequest<T: Decodable, U: Encodable>(endpoint: String, requestBody: U, completion: @escaping (Result<(T, Int), Error>) -> Void) {
            let url = baseURL.appendingPathComponent(endpoint)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONEncoder().encode(requestBody)
            } catch {
                completion(.failure(error))
                return
            }
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success((decodedObject, httpResponse.statusCode)))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }}
