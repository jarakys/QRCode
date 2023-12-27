//
//  HistoryView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI
import Combine

struct HistoryView: View {
    @StateObject public var viewModel: HistoryViewModel
    @State private var multiSelection = Set<UUID>()
    @Environment(\.editMode) var editMode
    var body: some View {
        VStack {
            pickerView()
            SearchBarView(searchText: $viewModel.searchText, onCommit: {
                
            })
            .padding(.top, 16)
            .padding(.bottom, 16)
            if !viewModel.sections.isEmpty {
                notEmptyState()
            } else {
                emptyState()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.secondaryBackground)
        .toolbarBackground(.red, for: .navigationBar)
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            if viewModel.isSelected {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        viewModel.deleteDidTap()
                    }, label: {
                        Image(.hisotryTrashIcon)
                    })
                    .padding(.zero)
                })
                if !viewModel.isMultipleSelection {
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button(action: {
                            viewModel.editDidTap()
                        }, label: {
                            Image(.historyEditIcon)
                        })
                        .padding(.zero)
                    })
                }
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        viewModel.editDidTap()
                    }, label: {
                        Image(.historyShareIcon)
                    })
                    .padding(.zero)
                })
            } else if !viewModel.isEditing  {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        viewModel.sortDidTap()
                    }, label: {
                        Image(.historySortIcon)
                    })
                    .padding(.zero)
                    .frame(width: 28, height: 28)
                })
            } else {
                ToolbarItem(placement: .topBarLeading, content: {
                    EmptyView()
                })
            }
            
        })
        .navigationBarColor(backgroundColor: .white, titleColor: .black)
        .onReceive(editMode.publisher, perform: { value in
            viewModel.editListDidTap(isEditing: value.wrappedValue == .active)
        })
        .actionSheet(isPresented: $viewModel.showAlert) {
            ActionSheet(
                title: Text("Sort"),
                buttons: [
                    .default(Text("Sort alphabetically")) {
                        viewModel.setSort(type: .alhabet)
//                        selection = "Red"
                    },
                    .default(Text("Sort manuallly")) {
                        viewModel.setSort(type: .manual)
//                        selection = "Green"
                    },
                    .cancel(Text("Cancel"))
                ]
            )
        }
    }

    @ViewBuilder
    private func pickerView() -> some View {
        Picker("", selection: $viewModel.selectedType) {
            Text(HistorySegmentType.scanned.description)
                .tag(0)
                .font(.system(size: 15))
            Text(HistorySegmentType.created.description)
                .tag(1)
                .font(.system(size: 15))
        }
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder
    private func emptyState() -> some View {
        ScrollView {
            if viewModel.selectedType == 0 {
                ScanQRCodeEmptyCellView(scanDidTap: {
                    
                })
                .padding(.top, 23)
            } else {
                CreateQRCodeEmptyCellView(createDidTap: {
                    
                })
                .padding(.top, 23)
            }
        }
    }
    
    private func notEmptyState() -> some View {
        List(viewModel.sections, id:\.title, selection: $viewModel.selectedItems) { section in
            Section(content: {
                ForEach(section.items) { model in
                    HistoryQrCodeCellView(model: model)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            Color.white
                                .cornerRadius(10)
                                .padding(.vertical, 4)
                        )
                        .onTapGesture {
                            
                        }
                }
                .onMove(perform: move)
            }, header: {
                Text(section.title)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .scrollContentBackground(.hidden)
        }
        .listStyle(.grouped)
        .toolbar(content: {
            EditButton()
                .foregroundStyle(.tint)
                .font(.system(size: 17, weight: .semibold))
        })
    }
    
    func move(from source: IndexSet, to destination: Int) {
//            users.move(fromOffsets: source, toOffset: destination)
        }
    
    
    func delete(at offsets: IndexSet) {
//           users.remove(atOffsets: offsets)
       }
}

#Preview {
    HistoryView(viewModel: HistoryViewModel(navigationSender: PassthroughSubject<HistoryEventFlow, Never>()))
}
