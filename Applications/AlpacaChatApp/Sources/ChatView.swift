//
//  ChatView.swift
//  AlpacaChatApp
//
//  Created by Yoshimasa Niwa on 3/18/23.
//

import SwiftUI

struct ChatView: View {
    @StateObject
    private var viewModel = ChatViewModel()

    @State
    private var inputText: String = ""
    
    
    @FocusState
    private var isInputFieldFocused: Bool
    
    
    var body: some View {
           VStack {
//           if viewModel.isLoading {
//               ProgressView {
//                   Text("Loading...")
//               }
//           }
           List {
               ForEach(viewModel.messages) { message in
                   MessageView(message: message)
               }
               .listRowSeparator(.hidden)
           }.listStyle(PlainListStyle())
           
            HStack {
            
                TextField("Type your message...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isInputFieldFocused)
                                        
                Button {
                    Task {
                        let text = inputText
                        inputText = ""
                        await viewModel.send(message: text)
                    }
                } label: {
                    Image(systemName: "paperplane")
                }
                .padding(.horizontal, 6.0)
                .disabled(inputText.isEmpty || viewModel.isLoading)
                
            }
            .padding(.all)
        }
        .navigationTitle("Chat")
        .task {
            // Focus the input field once the model is prepared
            isInputFieldFocused = true
            
            await viewModel.prepare()
            
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
