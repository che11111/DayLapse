//
//  ContentView.swift
//  DayLapse
//
//  Created by macbook air m2 on 2025/4/29.
//

import SwiftUI

struct EventCardView: View {
    let event: Event
    @ObservedObject var eventManager: EventManager
    @Binding var showingAddView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(event.title)
                    .font(.headline)
                Spacer()
                Button(action: {
                    eventManager.startEditing(event)
                    showingAddView = true
                }) {
                    Image(systemName: "pencil.circle")
                        .foregroundColor(.blue)
                }
            }
            
            Text(event.targetDate, style: .date)
            Text("剩余天数：\(event.daysRemaining)")
                .foregroundStyle(event.daysRemaining > 0 ? .green : .red)
        }
        .padding()
        .background(.background)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

struct ContentView: View {
    @StateObject private var eventManager = EventManager()
    @State private var showingAddView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))]) {
                    ForEach(eventManager.events) { event in
                        EventCardView(event: event, 
                                     eventManager: eventManager,
                                     showingAddView: $showingAddView)
                    }
                }
                .padding(.top)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image("DayLapse")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(6)
                        Text("Count Down The Important Days !")
                            .font(.headline)
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddEventView(eventManager: eventManager)
            }
        }
    }
}

#Preview {
    ContentView()
}
