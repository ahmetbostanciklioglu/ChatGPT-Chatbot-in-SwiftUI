import Foundation
import Alamofire


class OpenAIService {
    
    private let endpointUrl = "https://api.openai.com/v1/chat/completions"
    
    
  
    func sendMessage(messages: [Message]) async -> OpenAIChatResponse? {
        let openAIMessages = messages.map { message in
            OpenAIChatMessage(role: message.role, content: message.content)
        }
        let body = OpenAIChatBody(model: "gpt-4-turbo", messages: openAIMessages)
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Constants.OPENAI_API_KEY)"
        ]
        return try? await AF.request(endpointUrl, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }
}


//MARK: - Request Chat Body
struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

//MARK: - Request Chat Message
struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

//MARK: - Request Sender Roles
enum SenderRole: String, Codable {
    case developer, user, assistant
}

//MARK: - OpenAI Response
struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}


struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}
