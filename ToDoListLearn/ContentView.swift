// ContentView.swift
// ToDoListLearn

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Home()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Home: View {
    
    @EnvironmentObject var data: TaskModel
    @State var editMode = EditMode.inactive
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("To Do List")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                    
                    Text("Stay organized and productive")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // Input Field
            HStack {
                TextField("Enter new task...", text: $data.newTask)
                    .padding()
                    .background(BlurView(style: .systemMaterial))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                addButton
            }
            .padding(.horizontal)
            
        
            List {
                ForEach(Array(data.tasks.enumerated()), id: \.offset) { offset, task in
                    NavigationLink(destination: DetailView(task: task, index: offset)) {
                        HStack(spacing: 15) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.4))
                                .frame(width: 8, height: 50)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(task.task)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.primary)
                                
                                Text("Swipe to or delete")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(BlurView(style: .systemMaterial))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                }
                .onDelete(perform: data.onDelete)
                .onMove(perform: data.onMove)
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarItems(
            leading: EditButton()
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        )
        .environment(\.editMode, $editMode)
    }
    
    private var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(
                Button(action: {
                    self.data.onAdd(task: self.data.newTask)
                }) {
                    Image(systemName: "plus")
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .scaleEffect(1.1) // Sedikit membesarkan untuk efek lebih menarik
                }
            )
        default:
            return AnyView(EmptyView())
        }
    }
}

struct DetailView: View {
    
    @EnvironmentObject var data: TaskModel
    
    @State var newTaskValue: String = ""
    
    var task: Task
    var index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TextField("Update task...", text: $newTaskValue)
                .padding()
                .background(BlurView(style: .systemMaterial))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .onAppear {
                    self.newTaskValue = self.task.task
                }
            
            Button(action: {
                self.data.onUpdate(index: self.index, task: self.newTaskValue)
            }) {
                Text("Update Task")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Edit Task", displayMode: .inline)
    }
}

// Custom Blur View
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    ContentView()
        .environmentObject(TaskModel())
}
