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
    
    private var naverClientID: String {
        return Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_ID") as? String ?? ""
    }
    
    private var naverClientSecret: String {
        return Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_SECRET") as? String ?? ""
    }
    
    // 싱글톤 객체
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - GET
    func requestGET<T: Decodable>(urlString: String, parameters: [String: Any]? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        
        // Alamofire - GET
        AF.request(urlString, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: T.self) { response in
                self.handleResponse(response, completion: completion)
            }
    }
    
    // MARK: - POST
    func requestPOST<T: Decodable, U: Encodable>(urlString: String, parameters: U, completion: @escaping (Result<T, APIError>) -> Void) {
        
        // Alamofire - POST
        AF.request(urlString, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: T.self) { response in
                self.handleResponse(response, completion: completion)
            }
    }
    
    // MARK: - 위도,경도를 도로명주소, 지번주소로 변경
    func getAddressFromCoordinate(lat: Double, lng: Double, completion: @escaping (Result<String, APIError>) -> Void) {
        let url = "https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc"
        
        let headers: HTTPHeaders = [
            "x-ncp-apigw-api-key-id": naverClientID,
            "x-ncp-apigw-api-key": naverClientSecret
        ]
        
        let parameters: [String: Any] = [
            "coords": "\(lng),\(lat)",
            "output": "json",
            "orders": "roadaddr"  // 도로명 주소 우선
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: NaverReverseGeocodeResponse.self) { response in
                switch response.result {
                case .success(let geoData):
                    if let roadAddr = geoData.results.first(where: { $0.name == "roadaddr" }) {
                        let area1 = roadAddr.region.area1.name
                        let area2 = roadAddr.region.area2.name
                        let area3 = roadAddr.region.area3.name
                        let roadName = roadAddr.land?.name ?? ""
                        let roadNumber = roadAddr.land?.number1 ?? ""
                        
                        let fullAddress = "\(area1) \(area2) \(area3) \(roadName) \(roadNumber)"
                        print("도로명 주소: \(fullAddress)")
                        completion(.success(fullAddress))
                    } else {
                        print("❌ 도로명 주소 없음")
                        completion(.failure(.invalidResponse))
                    }
                    
                case .failure:
                    print("❌ 요청 실패: \(response.error?.localizedDescription ?? "알 수 없는 오류")")
                    completion(.failure(.requestFailed))
                }
            }
    }
    
    // MARK: - Response 핸들러
    private func handleResponse<T: Decodable>(_ response: AFDataResponse<T>, completion: @escaping (Result<T, APIError>) -> Void) {
        switch response.result {
        case .success(let value):
            completion(.success(value))
        case .failure:
            if let statusCode = response.response?.statusCode, !(200...299).contains(statusCode) {
                print("invalidResponse 에러 핸들링 : ", response.result)
                completion(.failure(.invalidResponse))
            } else {
                print("requestFailed 에러 핸들링 : ", response.result)
                completion(.failure(.requestFailed))
            }
        }
    }
}
