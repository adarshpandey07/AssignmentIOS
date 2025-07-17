import Foundation

class OTPViewModel: ObservableObject {
    @Published var otp: String = "1234"
    @Published var errorMessage: String?
    @Published var authToken: String = ""
    
    var isOTPValid: Bool {
        otp.count == 4 && otp.allSatisfy({ $0.isNumber })
    }
    
    func verifyOTP(phoneNumber: String, completion: @escaping () -> Void) {
        errorMessage = nil
        NetworkManager.shared.verifyOTP(number: phoneNumber, otp: otp) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self.authToken = token
                    completion()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
} 