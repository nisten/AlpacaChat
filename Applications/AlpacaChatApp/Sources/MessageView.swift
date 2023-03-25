//
//  MessageView.swift
//  AlpacaChatApp
//
//  Created by Yoshimasa Niwa on 3/20/23.
//

import SwiftUI

struct MessageView: View {
    var message: Message

    @ViewBuilder
    private func senderLabel(for sender: Message.Sender) -> some View {
        switch sender {
        case .user:
            Text("You")
                .font(.caption)
                .foregroundColor(.secondary)
        case .system:
            Text(
                message.isLoading ? "Alpaca (typing...)" : "Alpaca"
            )
                .font(.caption)
                .foregroundColor(.secondary)
//            if message.isLoading {
//                ProgressView()
//            }
        }
    }

    @ViewBuilder
    private func messageContent(for message: Message) -> some View {
        if message.isLoading && message.text == "" {
            ProgressView()
        } else {
            Text(message.text)
                .padding(12.0)
                .background(
                    RoundedRectangle(cornerRadius: 12.0)
                        .fill(message.sender == .system ? Color.blue : Color.secondary.opacity(0.2))
                )
                .foregroundColor(message.sender == .system ? .white : .primary)
            
        }
    }

    var body: some View {
        HStack {
            if message.sender == .user {
                Spacer()
            }

            VStack(alignment: message.sender == .system ? .leading : .trailing, spacing: 6.0) {
                senderLabel(for: message.sender)
                messageContent(for: message)
            }

            if message.sender == .system {
                Spacer()
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: Message(sender: .user, text: "Hello, world!"))
        MessageView(message: Message(sender: .system,
                                     isLoading: true, text: "Hello, world!"))
    }
}
