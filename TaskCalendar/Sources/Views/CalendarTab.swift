import SwiftUI

struct CalendarTab: View {
    @EnvironmentObject var taskStore: TaskStore
    @State private var currentDate: Date = Date()
    @State private var selectedDate: Date = Date()
    @State private var showingAddTask = false
    @State private var selectedCategory: TaskCategory = .work

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    calendarHeader
                    weekdayHeader
                    calendarGrid
                    todayTasks
                }
                .padding()
            }
            .background(Color.bgPrimary)
            .navigationTitle("Календарь")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.accentPurple)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskSheet(date: selectedDate, category: $selectedCategory)
            }
        }
    }

    private var calendarHeader: some View {
        HStack {
            Button {
                withAnimation {
                    currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.bgSecondary)
                    .clipShape(Circle())
            }

            Spacer()

            Text(currentDate.monthName)
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            Button {
                withAnimation {
                    currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.bgSecondary)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
    }

    private var weekdayHeader: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"], id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
    }

    private var calendarGrid: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(daysInMonth(), id: \.self) { date in
                CalendarDayCell(
                    date: date,
                    isCurrentMonth: isCurrentMonth(date),
                    isToday: calendar.isDateInToday(date),
                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                    tasks: taskStore.tasks(for: date)
                )
                .onTapGesture {
                    withAnimation {
                        selectedDate = date
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private var todayTasks: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(selectedDate.isSameDay(as: Date()) ? "Сегодня" : selectedDate.shortDate)
                    .font(.headline)

                Spacer()

                Text("\(taskStore.tasks(for: selectedDate).count) задач")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if taskStore.tasks(for: selectedDate).isEmpty {
                EmptyTasksView()
            } else {
                ForEach(taskStore.tasks(for: selectedDate)) { task in
                    TaskRow(task: task)
                }
            }
        }
        .padding()
        .background(Color.bgSecondary)
        .cornerRadius(16)
        .padding(.horizontal)
    }

    private func daysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }

        var days: [Date] = []
        let firstDayOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let offset = (firstWeekday + 5) % 7

        guard let monthFirstSunday = calendar.date(byAdding: .day, value: -offset, to: firstDayOfMonth) else {
            return []
        }

        for i in 0..<42 {
            if let day = calendar.date(byAdding: .day, value: i, to: monthFirstSunday) {
                days.append(day)
            }
        }

        return days
    }

    private func isCurrentMonth(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
    }
}

struct CalendarDayCell: View {
    let date: Date
    let isCurrentMonth: Bool
    let isToday: Bool
    let isSelected: Bool
    let tasks: [Task]

    var body: some View {
        VStack(spacing: 4) {
            Text("\(date.dayNumber)")
                .font(.system(size: 16, weight: isToday ? .bold : .regular))
                .foregroundStyle(foregroundColor)

            if !tasks.isEmpty {
                HStack(spacing: 2) {
                    ForEach(tasks.prefix(3)) { task in
                        Circle()
                            .fill(categoryColor(task.category))
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isToday ? Color.accentPurple : Color.clear, lineWidth: 2)
        )
    }

    private var foregroundColor: Color {
        if !isCurrentMonth {
            return .secondary.opacity(0.3)
        }
        if isSelected {
            return .white
        }
        return .primary
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.accentPurple
        }
        return Color.bgSecondary
    }

    private func categoryColor(_ category: TaskCategory) -> Color {
        switch category {
        case .work: return .purple
        case .personal: return .green
        case .health: return .orange
        case .learning: return .cyan
        case .finance: return .red
        }
    }
}

struct EmptyTasksView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text("Нет задач")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Нажмите + чтобы добавить")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

struct TaskRow: View {
    let task: Task
    @EnvironmentObject var taskStore: TaskStore

    var body: some View {
        HStack(spacing: 12) {
            Button {
                taskStore.toggleTaskCompletion(task)
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.isCompleted ? .green : .secondary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)

                HStack(spacing: 8) {
                    Text(task.category.name)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(categoryColor.opacity(0.2))
                        .foregroundStyle(categoryColor)
                        .clipShape(Capsule())

                    priorityBadge
                }
            }

            Spacer()
        }
        .padding()
        .background(Color.bgTertiary)
        .cornerRadius(12)
    }

    private var categoryColor: Color {
        switch task.category {
        case .work: return .purple
        case .personal: return .green
        case .health: return .orange
        case .learning: return .cyan
        case .finance: return .red
        }
    }

    private var priorityBadge: some View {
        Group {
            switch task.priority {
            case .low:
                EmptyView()
            case .medium:
                Text("⚡")
            case .high:
                Text("🔥")
            }
        }
    }
}

#Preview {
    CalendarTab()
        .environmentObject(TaskStore())
}
