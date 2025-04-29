import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var eventManager: EventManager
    @State private var eventTitle = ""
    @State private var selectedDate = Date()
    @State private var isEditing = false
    @State private var showDeleteAlert = false
    
    init(eventManager: EventManager) {
        self.eventManager = eventManager
        if let editingEvent = eventManager.editingEvent {
            _eventTitle = State(initialValue: editingEvent.title)
            _selectedDate = State(initialValue: editingEvent.targetDate)
            _isEditing = State(initialValue: true)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("事件信息") {
                    TextField("请输入事件标题", text: $eventTitle)
                    DatePicker(
                        "选择目标日期",
                        selection: $selectedDate,
                        in: Date()...,
                        displayedComponents: [.date]
                    )
                }
            }
            .navigationTitle(isEditing ? "编辑事件" : "新建事件")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                if isEditing {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("删除") {
                            showDeleteAlert = true
                        }
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        if isEditing {
                            if let id = eventManager.editingEvent?.id {
                                eventManager.updateEvent(Event(id: id, title: eventTitle, targetDate: selectedDate))
                            }
                        } else {
                            let newEvent = Event(title: eventTitle, targetDate: selectedDate)
                            eventManager.addEvent(newEvent)
                        }
                        dismiss()
                    }
                    .disabled(eventTitle.isEmpty)
                }
            }
            .alert("确认删除", isPresented: $showDeleteAlert) {
                Button("取消", role: .cancel) {}
                Button("删除", role: .destructive) {
                    if let id = eventManager.editingEvent?.id {
                        eventManager.deleteEvent(withId: id)
                    }
                    dismiss()
                }
            } message: {
                Text("确定要删除这个事件吗？此操作无法撤销。")
            }
        }
    }
}

#Preview {
    AddEventView(eventManager: EventManager())
}
