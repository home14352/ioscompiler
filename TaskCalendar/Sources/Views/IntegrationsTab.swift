import SwiftUI

struct IntegrationsTab: View {
    @EnvironmentObject var taskStore: TaskStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(taskStore.integrations) { integration in
                        IntegrationRow(integration: integration) {
                            withAnimation {
                                taskStore.toggleIntegration(integration)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.bgPrimary)
            .navigationTitle("Интеграции")
        }
    }
}

struct IntegrationRow: View {
    let integration: Integration
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: integration.icon)
                .font(.title2)
                .foregroundStyle(integration.isConnected ? .white : .secondary)
                .frame(width: 50, height: 50)
                .background(integrationColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(integration.name)
                    .font(.headline)

                Text(integration.isConnected ? "Подключено" : "Не подключено")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { integration.isConnected },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
            .tint(.green)
        }
        .padding()
        .background(Color.bgSecondary)
        .cornerRadius(16)
    }

    private var integrationColor: Color {
        switch integration.color {
        case "gray": return .gray
        case "orange": return .orange
        case "green": return .green
        case "blue": return .blue
        case "pink": return .pink
        case "purple": return .purple
        default: return .gray
        }
    }
}

#Preview {
    IntegrationsTab()
        .environmentObject(TaskStore())
}
