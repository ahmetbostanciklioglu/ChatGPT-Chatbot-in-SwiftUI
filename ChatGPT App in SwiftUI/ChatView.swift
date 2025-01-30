import SwiftUI

struct ChatView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages.filter({ message in
                    message.role != .developer
                }), id: \.id) { message in
                    messageView(message: message)
                }
            }
            
            HStack {
                TextField("Enter a message...", text: $viewModel.currentInput)
                
                Button("Send") {
                    viewModel.sendMessage()
                }
            }
        
            
        }
        .padding()
    }
    
    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user { Spacer()}
            
            Text(message.content)
                .padding()
                .background(message.role == .user ? .blue : .gray.opacity(0.2))
                .cornerRadius(8)
            if message.role == .assistant { Spacer() }
        }
        
    }
}

#Preview {
    ChatView()
}

