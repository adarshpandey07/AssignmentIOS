import Foundation

class PhoneNumberViewModel: ObservableObject {
    @Published var countryCode: String = "+91"
    @Published var phoneNumber: String = "9876543212"
    @Published var errorMessage: String?
    
    var isPhoneNumberValid: Bool {
        phoneNumber.count == 10 && phoneNumber.allSatisfy({ $0.isNumber })
    }
    
    var fullPhoneNumber: String {
        return countryCode + phoneNumber
    }
    
    func submitPhoneNumber(completion: @escaping () -> Void) {
        errorMessage = nil
        NetworkManager.shared.sendPhoneNumber(number: fullPhoneNumber) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
} 