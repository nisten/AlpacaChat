//
//  Chat.swift
//  AlpacaChat
//
//  Created by Yoshimasa Niwa on 3/18/23.
//

import Foundation
import AlpacaChatObjC

public final class Chat {
    private let chat: ALPChat
    private var currentPredictionTask: ALPChatCancellable?

    public init(model: Model) {
        chat = ALPChat(model: model.model)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func predictTokens(for prompt: String) -> AsyncThrowingStream<String, Error> {
        // Cancel the current prediction task if there is one
        currentPredictionTask?.cancel()

        return AsyncThrowingStream { continuation in
            // Start a new prediction task
            let task = chat.predictTokens(for: prompt) { token in
                continuation.yield(token)
            } completionHandler: { error in
                continuation.finish(throwing: error)
            }

            // Update the current prediction task reference
            self.currentPredictionTask = task
        }
    }
}
