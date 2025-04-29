import Foundation

struct Event: Identifiable, Codable {
    let id: UUID
    var title: String
    var targetDate: Date
    
    var daysRemaining: Int {
        Calendar.current.dateComponents([.day], from: Date().startOfDay, to: targetDate.startOfDay).day ?? 0
    }
    
    init(id: UUID = UUID(), title: String, targetDate: Date) {
        self.id = id
        self.title = title
        self.targetDate = targetDate
    }
}