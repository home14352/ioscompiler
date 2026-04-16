import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .calendar
    @EnvironmentObject var taskStore: TaskStore

    var body: some View {
        TabView(selection: $selectedTab) {
            CalendarTab()
                .tabItem {
                    Label("Календарь", systemImage: "calendar")
                }
                .tag(Tab.calendar)

            IdeasTab()
                .tabItem {
                    Label("Идеи", systemImage: "lightbulb.fill")
                }
                .tag(Tab.ideas)

            IntegrationsTab()
                .tabItem {
                    Label("Интеграции", systemImage: "link.circle.fill")
                }
                .tag(Tab.integrations)

            StatsTab()
                .tabItem {
                    Label("Статистика", systemImage: "chart.bar.fill")
                }
                .tag(Tab.stats)
        }
        .tint(Color.accentPurple)
    }
}

enum Tab: String, CaseIterable {
    case calendar
    case ideas
    case integrations
    case stats
}

#Preview {
    ContentView()
        .environmentObject(TaskStore())
}
