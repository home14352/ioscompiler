import SwiftUI

struct IdeasTab: View {
    @EnvironmentObject var taskStore: TaskStore
    @State private var searchText: String = ""
    @State private var selectedFilter: IdeaFilter = .all

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    filterPicker

                    LazyVStack(spacing: 12) {
                        ForEach(filteredIdeas) { idea in
                            IdeaRow(idea: idea) {
                                taskStore.addIdeaAsTask(idea)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color.bgPrimary)
            .navigationTitle("100 идей")
            .searchable(text: $searchText, prompt: "Поиск идей...")
        }
    }

    private var filterPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(IdeaFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.title,
                        count: filter.count(for: taskStore.ideas),
                        isSelected: selectedFilter == filter
                    ) {
                        withAnimation {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var filteredIdeas: [ProjectIdea] {
        var ideas = taskStore.ideas

        switch selectedFilter {
        case .all:
            break
        case .notAdded:
            ideas = ideas.filter { !$0.isAdded }
        case .added:
            ideas = ideas.filter { $0.isAdded }
        }

        if !searchText.isEmpty {
            ideas = ideas.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }

        return ideas
    }
}

enum IdeaFilter: String, CaseIterable {
    case all
    case notAdded
    case added

    var title: String {
        switch self {
        case .all: return "Все"
        case .notAdded: return "Новые"
        case .added: return "Добавленные"
        }
    }

    func count(for ideas: [ProjectIdea]) -> Int {
        switch self {
        case .all: return ideas.count
        case .notAdded: return ideas.filter { !$0.isAdded }.count
        case .added: return ideas.filter { $0.isAdded }.count
        }
    }
}

struct FilterChip: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text("\(count)")
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(isSelected ? Color.white.opacity(0.2) : Color.bgTertiary)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.accentPurple : Color.bgSecondary)
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct IdeaRow: View {
    let idea: ProjectIdea
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: idea.isAdded ? "checkmark.circle.fill" : "lightbulb")
                .font(.title3)
                .foregroundStyle(idea.isAdded ? .green : .yellow)

            Text(idea.title)
                .font(.subheadline)
                .foregroundStyle(idea.isAdded ? .secondary : .primary)
                .strikethrough(idea.isAdded)

            Spacer()

            if !idea.isAdded {
                Button(action: onAdd) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.accentPurple)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color.bgSecondary)
        .cornerRadius(12)
    }
}

#Preview {
    IdeasTab()
        .environmentObject(TaskStore())
}
