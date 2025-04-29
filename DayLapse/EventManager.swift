import Foundation

class EventManager: ObservableObject {
    @Published var events: [Event] = []
    @Published var editingEvent: Event?
    
    init() {
        loadEvents()
    }
    
    func addEvent(_ event: Event) {
        events.append(event)
        saveEvents()
    }
    
    func deleteEvent(at indexSet: IndexSet) {
        events.remove(atOffsets: indexSet)
        saveEvents()
    }
    
    func deleteEvent(withId id: UUID) {
        events.removeAll { $0.id == id }
        saveEvents()
    }
    
    func startEditing(_ event: Event) {
        editingEvent = event
    }
    
    func updateEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            saveEvents()
            editingEvent = nil
        }
    }
    
    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: "savedEvents")
        }
    }
    
    private func loadEvents() {
        if let data = UserDefaults.standard.data(forKey: "savedEvents"),
           let decoded = try? JSONDecoder().decode([Event].self, from: data) {
            events = decoded
        }
    }
}
