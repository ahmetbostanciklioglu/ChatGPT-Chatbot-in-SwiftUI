import Foundation


extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = [Message(
            id: UUID(),
            content: "You are coding assistant. You will help me understand how to write only Swift code. You do not have enough information about other languages to give advice so avoid doing so at ALL times",
            createAt: Date(),
            role: .developer)]
        
        @Published var currentInput: String = ""
        
        private let openAIService = OpenAIService()
        
        
        func sendMessage() {
            let newMessage = Message(id: UUID(), content: currentInput, createAt: Date(), role: .user)
            messages.append(newMessage)
            
            currentInput = ""
            
            Task {
                let response = await openAIService.sendMessage(messages: messages)
                guard let receivedOpenAIMessage = response?.choices.first?.message else {
                    print("Had no received message")
                    return
                }
                let receivedMessage = Message(id: UUID(), content: receivedOpenAIMessage.content, createAt: Date(), role: receivedOpenAIMessage.role)
                
                await MainActor.run {
                    messages.append(receivedMessage)
                }
                
                
            }
        }
    }
}


struct Message: Decodable {
    let id: UUID
    let content: String
    let createAt: Date
    let role: SenderRole
}
