//
//  ChatViewModel.swift
//  AlpacaChatApp
//
//  Created by Yoshimasa Niwa on 3/19/23.
//

import AlpacaChat
import Foundation

extension String: Error {
}

@MainActor
final class ChatViewModel: ObservableObject {
    private var chat: Chat?

    @Published
    var isLoading: Bool = false

    @Published
    var messages: [Message] = []

    func prepare() async {
        guard chat == nil else {
            return
        }

        do {
            isLoading = true
            guard let modelURL = Bundle.main.url(forResource: "model", withExtension: "bin") else {
                throw "Model not found."
            }
            let model = try await Model.load(from: modelURL)
            chat = Chat(model: model)
        } catch {
            let message = Message(sender: .system, text: "Failed to load model.")
            messages.append(message)
        }
        isLoading = false
    }

    func send(message text: String) async {
        let requestMessage = Message(sender: .user, text: text)
        messages.append(requestMessage)

        guard let chat = chat else {
            let message = Message(sender: .system, text: "Chat is unavailable.")
            messages.append(message)
            return
        }
        var responseMessage = Message(sender: .system, isLoading: true, text: "")
        messages.append(responseMessage)
        let responseMessageIndex = messages.endIndex - 1
        do {
            for try await token in chat.predictTokens(for: text) {
                responseMessage.text += token
                messages[responseMessageIndex] = responseMessage
            }
        } catch {
            if(responseMessage.text == ""){
                responseMessage.text = error.localizedDescription;
            }else{
                responseMessage.text += "—";
            }
//            let message = Message(sender: .system, text: error.localizedDescription)
//            messages.append(message)
        }
        responseMessage.isLoading = false
        messages[responseMessageIndex] = responseMessage
    }
}
