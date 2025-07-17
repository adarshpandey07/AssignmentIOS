import SwiftUI

struct OTPView: View {
    let phoneNumber: String
    @StateObject private var viewModel = OTPViewModel()
    @State private var notesAuthToken: String? = nil
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Enter OTP")
                .font(.title)
                .bold()
            TextField("1234", text: $viewModel.otp)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
            Button(action: {
                viewModel.verifyOTP(phoneNumber: phoneNumber) {
                    notesAuthToken = viewModel.authToken
                }
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.isOTPValid)
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            Spacer()
            NavigationLink(
                tag: viewModel.authToken,
                selection: $notesAuthToken,
                destination: { NotesView(authToken: viewModel.authToken) },
                label: { EmptyView() }
            )
        }
        .padding()
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(phoneNumber: "+919876543212")
    }
} 