import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://app.aisle.co/V1"
    
    private init() {}
    
    func sendPhoneNumber(number: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: baseURL + "/users/phone_number_login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = "number=\(number)"
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(PhoneNumberResponse.self, from: data)
                if decoded.status {
                    completion(.success(()))
                } else {
                    completion(.failure(NSError(domain: decoded.message ?? "Unknown error", code: -1)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func verifyOTP(number: String, otp: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: baseURL + "/users/verify_otp") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = "number=\(number)&otp=\(otp)"
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(OTPResponse.self, from: data)
                if decoded.status, let token = decoded.token {
                    completion(.success(token))
                } else {
                    completion(.failure(NSError(domain: decoded.message ?? "Unknown error", code: -1)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchNotes(authToken: String, completion: @escaping (Result<[Note], Error>) -> Void) {
        guard let url = URL(string: baseURL + "/users/test_profile_list") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode([Note].self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
} 