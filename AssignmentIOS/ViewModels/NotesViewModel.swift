import Foundation

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func fetchNotes(authToken: String) {
        isLoading = true
        errorMessage = nil
        NetworkManager.shared.fetchNotes(authToken: authToken) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let notes):
                    self.notes = notes
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
} 