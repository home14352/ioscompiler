import Foundation
import SwiftUI

@MainActor
class TaskStore: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var ideas: [ProjectIdea] = ProjectIdea.all
    @Published var integrations: [Integration] = [
        Integration(name: "GitHub", icon: "chevron.left.forwardslash.chevron.right", color: "gray", isConnected: true),
        Integration(name: "Notion", icon: "doc.text", color: "orange", isConnected: false),
        Integration(name: "Slack", icon: "message.fill", color: "green", isConnected: false),
        Integration(name: "Google Calendar", icon: "calendar", color: "blue", isConnected: false),
        Integration(name: "Trello", icon: "rectangle.3.group", color: "pink", isConnected: false),
        Integration(name: "Asana", icon: "target", color: "purple", isConnected: false)
    ]

    private let tasksKey = "savedTasks"
    private let ideasKey = "savedIdeas"

    var completedTasks: [Task] {
        tasks.filter { $0.isCompleted }
    }

    var pendingTasks: [Task] {
        tasks.filter { !$0.isCompleted }
    }

    var tasksForToday: [Task] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return tasks.filter { calendar.isDate($0.date, inSameDayAs: today) }
    }

    init() {
        loadTasks()
        loadIdeas()
    }

    func addTask(_ task: Task) {
        tasks.append(task)
        saveTasks()
    }

    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }

    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }

    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }

    func moveTask(_ task: Task, to date: Date) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].date = date
            saveTasks()
        }
    }

    func addIdeaAsTask(_ idea: ProjectIdea, date: Date = Date()) {
        let task = Task(
            title: idea.title,
            description: "Идея из списка проектов",
            category: .learning,
            priority: .low,
            date: date
        )
        addTask(task)
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index].isAdded = true
            saveIdeas()
        }
    }

    func toggleIntegration(_ integration: Integration) {
        if let index = integrations.firstIndex(where: { $0.id == integration.id }) {
            integrations[index].isConnected.toggle()
        }
    }

    func tasks(for date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }

    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }

    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }

    func saveIdeas() {
        let addedIdeas = ideas.filter { $0.isAdded }.map { $0.id }
        UserDefaults.standard.set(addedIdeas, forKey: ideasKey)
    }

    func loadIdeas() {
        if let savedIds = UserDefaults.standard.array(forKey: ideasKey) as? [UUID] {
            for (index, idea) in ideas.enumerated() {
                ideas[index].isAdded = savedIds.contains(idea.id)
            }
        }
    }
}
