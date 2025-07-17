import SwiftUI

struct NotesView: View {
    let authToken: String
    @StateObject private var viewModel = NotesViewModel()
    
    var body: some View {
        VStack {
            Text("Notes")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else {
                List(viewModel.notes) { note in
                    VStack(alignment: .leading) {
                        Text(note.title)
                            .font(.headline)
                        Text(note.content)
                            .font(.subheadline)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchNotes(authToken: authToken)
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(authToken: "sample_token")
    }
} 