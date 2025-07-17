import SwiftUI

struct PhoneNumberView: View {
    @StateObject private var viewModel = PhoneNumberViewModel()
    @State private var otpPhoneNumber: String? = nil
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Enter your phone number")
                .font(.title)
                .bold()
            HStack {
                TextField("+91", text: $viewModel.countryCode)
                    .frame(width: 60)
                    .keyboardType(.phonePad)
                    .disabled(true)
                TextField("9876543212", text: $viewModel.phoneNumber)
                    .keyboardType(.numberPad)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            Button(action: {
                viewModel.submitPhoneNumber {
                    otpPhoneNumber = viewModel.fullPhoneNumber
                }
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.isPhoneNumberValid)
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            Spacer()
            NavigationLink(
                tag: viewModel.fullPhoneNumber,
                selection: $otpPhoneNumber,
                destination: { OTPView(phoneNumber: viewModel.fullPhoneNumber) },
                label: { EmptyView() }
            )
        }
        .padding()
    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView()
    }
} 