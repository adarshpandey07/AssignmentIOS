import Foundation

struct OTPResponse: Codable {
    let status: Bool
    let token: String?
    let message: String?
} 