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
    @State var editMode = EditMode.inactive
    var body: some View {
        VStack {
            pickerView()
            SearchBarView(searchText: $viewModel.searchText, onCommit: {
                
            })
            .padding(.top, 16)
            .padding(.bottom, 16)
            if !viewModel.sections.isEmpty {
                if viewModel.editType == .move {
                    notSelectionNotEmtyState()
                } else {
                    notEmptyState()
                }
            } else {
                emptyState()
            }
            if viewModel.shouldShowUnlockButton {
                unlockButtonView()
                    .padding(.bottom, 39)
            }
            if !viewModel.isPremium {
                AdMobBannerView(adUnitId: "ca-app-pub-3940256099942544/9214589741")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.all, 2)
                    .background(.adBackground)
                    .padding(.top, 8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.secondaryBackground)
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            if !viewModel.sections.isEmpty {
                if viewModel.isSelected {
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button(action: {
                            viewModel.deleteDidTap()
                        }, label: {
                            Image(.hisotryTrashIcon)
                        })
                        .padding(.zero)
                    })
                    if !viewModel.isMultipleSelection && viewModel.selectedType == 1 {
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
                            viewModel.shareDidTap()
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
                        Button(action: {
                            viewModel.selectAll()
                        }, label: {
                            Text("Select all")
                                .font(.system(size: 17))
                                .foregroundStyle(.tint)
                        })
                    })
                }
            } else {
                ToolbarItem(placement: .topBarLeading, content: {
                    EmptyView()
                })
            }
        })
        .onReceive(viewModel.$sortType, perform: { type in
            guard type == .manual else { return }
            editMode = .active
        })
        .onReceive(viewModel.$shouldEdit, perform: { value in
            guard !value else { return }
            editMode = .inactive
        })
        .onChange(of: editMode, perform: { mode in
            viewModel.editListDidTap(isEditing: mode == .active)
        })
        .actionSheet(isPresented: $viewModel.showAlert) {
            actionSheetView()
        }
    }
    
    private func actionSheetView() -> ActionSheet {
        return ActionSheet(
            title: Text("Sort"),
            buttons: [
                .default(Text("Sort alphabetically")) {
                    viewModel.setSort(type: .alhabet)
                },
                .default(Text("Sort manuallly")) {
                    viewModel.setSort(type: .manual)
                },
                .cancel(Text("Cancel"))
            ]
        )
    }
    
    @ViewBuilder
    private func unlockButtonView() -> some View {
        Button(action: {
            viewModel.unlockDidTap()
        }, label: {
            HStack(spacing: 8) {
                Text("Unlock")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                Image(.historyUnlockIcon)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 72)
            .background(.primaryApp)
            .cornerRadius(10)
        })
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
        .scaleEffect(1.12)
        .pickerStyle(.segmented)
        .padding(.horizontal, 22)
    }
    
    @ViewBuilder
    private func emptyState() -> some View {
        ScrollView {
            if viewModel.selectedType == 0 {
                ScanQRCodeEmptyCellView(scanDidTap: {
                    viewModel.scanDidTap()
                })
                .padding(.top, 23)
            } else {
                CreateQRCodeEmptyCellView(createDidTap: {
                    viewModel.createDidTap()
                })
                .padding(.top, 23)
            }
        }
    }
    
    private func notSelectionNotEmtyState() -> some View {
        List(viewModel.sections, id:\.title) { section in
            Section(content: {
                ForEach(section.items) { model in
                    historyCell(model: model)
                }
                .onMove(perform: { source, destination in
                    viewModel.move(from: source, to: destination, section: section)
                })
            }, header: {
                historyHeaderView(section: section)
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
        .environment(\.editMode, $editMode)
    }
    
    private func notEmptyState() -> some View {
        List(viewModel.sections, id:\.title, selection: $viewModel.selectedItems) { section in
            Section(content: {
                ForEach(section.items) { model in
                    historyCell(model: model)
                }
            }, header: {
                historyHeaderView(section: section)
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
        .environment(\.editMode, $editMode)
    }
    
    func delete(at offsets: IndexSet) {
//           users.remove(atOffsets: offsets)
       }
    
    @ViewBuilder
    private func historyCell(model: QRCodeEntityModel) -> some View {
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
                viewModel.itemDidTap(model: model)
            }
    }
    
    @ViewBuilder
    private func historyHeaderView(section: QRCodeEntitySection) -> some View {
        HStack {
            Text(section.title)
                .font(.system(size: 13, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.secondaryTitle)
            if !viewModel.isPremium && section.title == viewModel.lastSection?.title {
                Spacer()
                Text("\(viewModel.selectedType == 0 ? viewModel.countScans : viewModel.countCreates) of 5")
                    .textCase(.lowercase)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.secondaryTitle)
            }
        }
    }
}

#Preview {
    HistoryView(viewModel: HistoryViewModel(subscriptionManager: .init(), navigationSender: PassthroughSubject<HistoryEventFlow, Never>()))
}
