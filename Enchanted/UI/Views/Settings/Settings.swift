//
//  Settings.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 28/12/2023.
//

import SwiftUI

struct Settings: View {
    @Environment(LanguageModelStore.self) private var languageModelStore
    @Environment(ConversationStore.self) private var conversationStore
    
    @AppStorage("ollamaUri") private var ollamaUri: String = ""
    @AppStorage("systemPrompt") private var systemPrompt: String = ""
    @AppStorage("vibrations") private var vibrations: Bool = true
    @AppStorage("colorScheme") private var colorScheme = AppColorScheme.system
    @AppStorage("defaultOllamaModel") private var defaultOllamaModel: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    private func save() {
        Haptics.shared.play(.medium)
        // remove trailing slash
        if ollamaUri.last == "/" {
            ollamaUri = String(ollamaUri.dropLast())
        }
        
        OllamaService.reinit(url: ollamaUri)
        Task {
            presentationMode.wrappedValue.dismiss()
            try? await languageModelStore.loadModels()
        }
    }
    
    private func checkServer() {
        Task {
            OllamaService.reinit(url: ollamaUri)
            ollamaStatus = await OllamaService.shared.reachable()
            try? await languageModelStore.loadModels()
        }
    }
    
    @State var ollamaStatus: Bool?
    var body: some View {
        SettingsView(
            ollamaUri: $ollamaUri,
            systemPrompt: $systemPrompt, 
            vibrations: $vibrations,
            colorScheme: $colorScheme,
            defaultOllamModel: $defaultOllamaModel, 
            save: save,
            checkServer: checkServer,
            deleteAllConversations: conversationStore.deleteAllConversations, 
            ollamaLangugeModels: languageModelStore.models
        )
        .onChange(of: defaultOllamaModel) { _, modelName in
            languageModelStore.setModel(modelName: modelName)
        }
    }
}

#Preview {
    Settings()
}
