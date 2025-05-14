//
//  NetworkManager.swift
//  jeolhak
//
//  Created by 윤대현 on 5/14/25.
//


import Alamofire

// MARK: - API Error 열거형
enum APIError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
    case encodingError
}

// MARK: - 네트워크 매니저 클래스 (싱글톤)
class NetworkManager {
    // 싱글톤 객체
    static let shared = NetworkManager()
    
    private init() {}
    
    // GET
    func requestGET<T: Decodable>(urlString: String, completion: @escaping (Result<T, APIError>) -> Void) {
        
        // Alamofire - GET
        AF.request(urlString, method: .get).validate().responseDecodable(of: T.self) { response in
            self.handleResponse(response, completion: completion)
        }
    }
    
    // POST
    func requestPOST<T: Decodable, U: Encodable>(urlString: String, parameters: U, completion: @escaping (Result<T, APIError>) -> Void) {
        
        // Alamofire - POST
        AF.request(urlString, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: T.self) { response in
                self.handleResponse(response, completion: completion)
            }
    }
    
    // MARK: - Response 핸들러
    private func handleResponse<T: Decodable>(_ response: AFDataResponse<T>, completion: @escaping (Result<T, APIError>) -> Void) {
        switch response.result {
        case .success(let value):
            completion(.success(value))
        case .failure:
            if let statusCode = response.response?.statusCode, !(200...299).contains(statusCode) {
                completion(.failure(.invalidResponse))
            } else {
                completion(.failure(.requestFailed))
            }
        }
    }
}
