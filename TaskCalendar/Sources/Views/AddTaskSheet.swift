import SwiftUI

struct AddTaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var taskStore: TaskStore

    let date: Date
    @Binding var category: TaskCategory

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: TaskCategory = .work
    @State private var selectedPriority: TaskPriority = .low
    @State private var taskDate: Date

    init(date: Date, category: Binding<TaskCategory>) {
        self.date = date
        self._category = category
        self._taskDate = State(initialValue: date)
        self._selectedCategory = State(initialValue: category.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Название") {
                    TextField("Введите название задачи", text: $title)
                }

                Section("Описание") {
                    TextField("Опционально", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Категория") {
                    Picker("Категория", selection: $selectedCategory) {
                        ForEach(TaskCategory.allCases, id: \.self) { cat in
                            Text(cat.name).tag(cat)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Приоритет") {
                    HStack(spacing: 12) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            PriorityButton(
                                priority: priority,
                                isSelected: selectedPriority == priority
                            ) {
                                selectedPriority = priority
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                Section("Дата") {
                    DatePicker(
                        "Дата",
                        selection: $taskDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .tint(Color.accentPurple)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.bgPrimary)
            .navigationTitle("Новая задача")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        saveTask()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func saveTask() {
        let task = Task(
            title: title,
            description: description,
            category: selectedCategory,
            priority: selectedPriority,
            date: taskDate
        )
        taskStore.addTask(task)
        category = selectedCategory
        dismiss()
    }
}

struct PriorityButton: View {
    let priority: TaskPriority
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(priorityIcon)
                    .font(.title2)

                Text(priority.name)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? priorityColor.opacity(0.2) : Color.bgTertiary)
            .foregroundStyle(isSelected ? priorityColor : .secondary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? priorityColor : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var priorityIcon: String {
        switch priority {
        case .low: return "1.circle"
        case .medium: return "2.circle"
        case .high: return "3.circle"
        }
    }

    private var priorityColor: Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

#Preview {
    AddTaskSheet(date: Date(), category: .constant(.work))
        .environmentObject(TaskStore())
}
