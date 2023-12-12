//
//  SidebarView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import SwiftUI

struct SidebarView: View {
    
    var conversations: [ConversationSD]
    var onConversationTap: (_ conversation: ConversationSD) -> ()
    @State var showSettings = false
    
    var body: some View {
        VStack {
            ScrollView() {
                ConversationHistoryList(conversations: conversations, onTap: onConversationTap)
            }
            .scrollIndicators(.never)
            
            Button(action: {showSettings.toggle()}) {
                HStack {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    
                    Text("Settings")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                    
                    Spacer()
                }
                .foregroundColor(Color(.label))
                .padding(.vertical)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

#Preview {
    SidebarView(conversations: ConversationSD.sample, onConversationTap: {_ in})
}