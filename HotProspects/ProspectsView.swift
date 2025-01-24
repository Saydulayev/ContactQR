//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Saydulayev on 22.01.25.
//

import SwiftData
import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    @Query var prospects: [Prospect]
    @Environment(\.modelContext) var modelContext
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()
    @State private var editingProspect: Prospect?
    @State private var sortOption: SortOption = .name

    enum SortOption: String, CaseIterable {
        case name = "Name"
        case mostRecent = "Most Recent"
    }

    enum FilterType {
        case none, contacted, uncontacted
    }
    let filter: FilterType

    var title: String {
        switch filter {
        case .none: return "Everyone"
        case .contacted: return "Contacted people"
        case .uncontacted: return "Uncontacted people"
        }
    }

    var filteredProspects: [Prospect] {
        let sortedProspects: [Prospect]
        switch sortOption {
        case .name:
            sortedProspects = prospects.sorted { $0.name < $1.name }
        case .mostRecent:
            sortedProspects = prospects // Assuming most recent is based on insertion order
        }

        switch filter {
        case .none:
            return sortedProspects
        case .contacted:
            return sortedProspects.filter { $0.isContacted }
        case .uncontacted:
            return sortedProspects.filter { !$0.isContacted }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredProspects, selection: $selectedProspects) { prospect in
                HStack {
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: prospect.isContacted ? "person.crop.circle.fill.badge.checkmark" : "person.crop.circle.badge.xmark")
                        .foregroundColor(statusColor(for: prospect))
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    markButton(for: prospect)
                    Button("Remind Me", systemImage: "bell") {
                        NotificationManager.addNotification(for: prospect)
                    }
                    .tint(.orange)
                }
                .tag(prospect)
                .swipeActions(edge: .leading) {
                    Button("Edit", systemImage: "pencil") {
                        editingProspect = prospect
                    }
                    .tint(.blue)
                }
                .tag(prospect)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort By", selection: $sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(.inline)
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Selected", action: delete)
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Ahmad\nsaydulayev.wien@gmail.com") {
                    handleScan(result: $0)
                }
            }
            .sheet(item: $editingProspect) { prospect in
                EditProspectView(prospect: prospect)
            }
        }
    }

    init(filter: FilterType) {
        self.filter = filter
        if filter != .none {
            let showContactedOnly = filter == .contacted
            _prospects = Query(filter: #Predicate {
                $0.isContacted == showContactedOnly
            })
        } else {
            _prospects = Query()
        }
    }

    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            modelContext.insert(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
        selectedProspects.removeAll()
    }

    private func markButton(for prospect: Prospect) -> some View {
        if prospect.isContacted {
            return Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                prospect.isContacted.toggle()
            }
            .tint(.blue)
        } else {
            return Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                prospect.isContacted.toggle()
            }
            .tint(.green)
        }
    }

    private func statusColor(for prospect: Prospect) -> Color {
        prospect.isContacted ? .green : .blue
    }
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}




//import SwiftUI
//import SwiftData
//
//struct EditProspectView: View {
//    @Environment(\.dismiss) private var dismiss
//    @Environment(\.modelContext) private var modelContext
//    
//    @Bindable var prospect: Prospect   // iOS 17: даёт прямое привязку к полям
//
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section("Основные данные") {
//                    TextField("Имя", text: $prospect.name)
//                    TextField("Email", text: $prospect.emailAddress)
//                }
//            }
//            .navigationTitle("Редактирование")
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Готово") {
//                        // Можно вызвать сохранение явно (для надёжности)
//                        try? modelContext.save()
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//}
