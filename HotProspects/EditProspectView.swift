//
//  EditProspectView.swift
//  HotProspects
//
//  Created by Saydulayev on 24.01.25.
//

import SwiftUI

struct EditProspectView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var prospect: Prospect

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $prospect.name)
                    TextField("Email", text: $prospect.emailAddress)
                }
            }
            .navigationTitle("Edit")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        try? modelContext.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let previewProspect = Prospect(name: "John Doe", emailAddress: "johndoe@example.com", isContacted: false)
    return EditProspectView(prospect: previewProspect)
        .modelContainer(for: Prospect.self, inMemory: true) // Используем in-memory контейнер для тестирования
}

