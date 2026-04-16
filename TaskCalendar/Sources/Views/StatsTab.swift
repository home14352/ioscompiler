import SwiftUI

struct StatsTab: View {
    @EnvironmentObject var taskStore: TaskStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    statsGrid

                    completionChart

                    categoryBreakdown

                    recentActivity
                }
                .padding()
            }
            .background(Color.bgPrimary)
            .navigationTitle("Статистика")
        }
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatCard(
                title: "Всего задач",
                value: "\(taskStore.tasks.count)",
                icon: "list.bullet",
                color: .purple
            )

            StatCard(
                title: "Выполнено",
                value: "\(taskStore.completedTasks.count)",
                icon: "checkmark.circle.fill",
                color: .green
            )

            StatCard(
                title: "В процессе",
                value: "\(taskStore.pendingTasks.count)",
                icon: "clock.fill",
                color: .orange
            )

            StatCard(
                title: "Сегодня",
                value: "\(taskStore.tasksForToday.count)",
                icon: "calendar",
                color: .cyan
            )
        }
    }

    private var completionChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Выполнение")
                .font(.headline)

            GeometryReader { geometry in
                let total = max(taskStore.tasks.count, 1)
                let completed = taskStore.completedTasks.count
                let percentage = Double(completed) / Double(total)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.bgTertiary)
                        .frame(height: 20)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [.accentPurple, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * percentage, height: 20)
                }
            }
            .frame(height: 20)

            Text("\(Int(Double(taskStore.completedTasks.count) / Double(max(taskStore.tasks.count, 1)) * 100))% выполнено")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.bgSecondary)
        .cornerRadius(16)
    }

    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("По категориям")
                .font(.headline)

            ForEach(TaskCategory.allCases, id: \.self) { category in
                let count = taskStore.tasks.filter { $0.category == category }.count
                let total = max(taskStore.tasks.count, 1)
                let percentage = Double(count) / Double(total)

                CategoryProgressRow(
                    category: category,
                    count: count,
                    percentage: percentage
                )
            }
        }
        .padding()
        .background(Color.bgSecondary)
        .cornerRadius(16)
    }

    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Последние задачи")
                .font(.headline)

            if taskStore.tasks.isEmpty {
                Text("Пока нет задач")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                ForEach(Array(taskStore.tasks.prefix(5))) { task in
                    HStack(spacing: 12) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(task.isCompleted ? .green : .secondary)

                        Text(task.title)
                            .font(.subheadline)
                            .lineLimit(1)

                        Spacer()

                        Text(task.date.shortDate)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.bgSecondary)
        .cornerRadius(16)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.bgSecondary)
        .cornerRadius(16)
    }
}

struct CategoryProgressRow: View {
    let category: TaskCategory
    let count: Int
    let percentage: Double

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(category.name)
                    .font(.subheadline)

                Spacer()

                Text("\(count)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.bgTertiary)
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(categorySwiftUIColor)
                        .frame(width: geometry.size.width * percentage, height: 8)
                }
            }
            .frame(height: 8)
        }
    }

    private var categorySwiftUIColor: Color {
        switch category {
        case .work: return .purple
        case .personal: return .green
        case .health: return .orange
        case .learning: return .cyan
        case .finance: return .red
        }
    }
}

#Preview {
    StatsTab()
        .environmentObject(TaskStore())
}
