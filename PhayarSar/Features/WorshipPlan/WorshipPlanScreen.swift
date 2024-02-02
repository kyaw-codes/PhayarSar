//
//  WorshipPlanScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 01/02/2024.
//

import SwiftUI

enum WorshipPlanSteps: String, Hashable, CaseIterable {
  case addName
  case addPrayers
}

struct WorshipPlanScreen: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var preferences: UserPreferences
  @FocusState private var focusedName: String?
  
  @State private var name = ""
  @State private var selectedPrayers = [NatPintVO]()
  @State private var color = Color.red

  @State private var currentStep: WorshipPlanSteps = .addName
  @State private var showAllPrayerPickerScreen = false
  
  var body: some View {
    TabView(selection: $currentStep) {
      StepOneNameView()
        .tag(WorshipPlanSteps.addName)
      StepTwoAddPrayersView()
        .tag(WorshipPlanSteps.addPrayers)
      
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .safeAreaInset(edge: .top, spacing: 0) {
      NavView()
    }
    .safeAreaInset(edge: .bottom) {
      VStack {
        Divider()
        AppBtnFilled(action: next, title: .next)
          .allowsHitTesting(enableNextButton())
          .opacity(enableNextButton() ? 1 : 0.5)
          .padding([.top, .horizontal])
          .padding(.bottom, 12)
      }
    }
    .onAppear {
      focusedName = "planname"
    }
    .sheet(isPresented: $showAllPrayerPickerScreen, content: {
      AllPrayerPickerScreen(prayers: $selectedPrayers)
    })
  }
  
  private func enableNextButton() -> Bool {
    switch currentStep {
    case .addName:
      return !name.isEmpty
    case .addPrayers:
      return !selectedPrayers.isEmpty
    }
  }
  
  private func next() {
    switch currentStep {
    case .addName:
      withAnimation(.easeIn) {
        currentStep = .addPrayers
      }
    case .addPrayers:
      ()
    }
  }
  
  @ViewBuilder
  private func NavView() -> some View {
    VStack(spacing: 0) {
      HStack {
        Image(systemName: "sparkles.rectangle.stack")
          .font(.title)
          .foregroundColor(preferences.accentColor.color)
        
          Text("New Plan")
        .font(.dmSerif(28))
        
        Spacer()
        
        Button {
          dismiss()
        } label: {
          Image(systemName: "xmark")
            .font(.title2.bold())
        }
        .tint(.primary)
      }
      
      ProgressView()
        .padding(.bottom, 8)
    }
    .padding()
    .background {
      VStack(spacing: 0) {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        Rectangle()
          .fill(LinearGradient(colors: [Color(uiColor: .systemBackground), .clear], startPoint: .top, endPoint: .bottom))
          .frame(height: 10)
      }
    }
  }
  
  @ViewBuilder
  private func ProgressView() -> some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(.cardBg)
      .frame(height: 12)
      .overlay(alignment: .leading) {
        RoundedRectangle(cornerRadius: 12)
          .fill(
            LinearGradient(
              colors: [preferences.accentColor.color, preferences.accentColor.color.opacity(0.8), preferences.accentColor.color.opacity(0.7), preferences.accentColor.color.opacity(0.5)],
              startPoint: .leading,
              endPoint: .trailing
            )
          )
          .frame(width: 120)
          .overlay(alignment: .trailing) {
            Text("🌟")
              .font(.largeTitle)
              .offset(x: 12, y: -1)
          }
      }
      .padding(.top, 30)
  }
  
  @ViewBuilder
  private func StepOneNameView() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Name your worship plan")
        .font(.qsB(20))
      TextField("Plan name", text: $name)
        .autocorrectionDisabled()
        .font(.qsSb(36))
        .focused($focusedName, equals: "planname")
    }
    .padding()
  }
  
  @ViewBuilder
  private func StepTwoAddPrayersView() -> some View {
    VStack(spacing: 0) {
      AddNewPrayerButton()
        .padding([.horizontal, .top])
        .zIndex(1)
      
      List {
        ForEach(selectedPrayers) { prayer in
          HStack {
            Image(systemName: "minus.circle.fill")
              .foregroundColor(preferences.accentColor.color)
              .padding(12)
              .contentShape(Rectangle())
              .onTapGesture {
                HapticKit.impact(.soft).generate()
                withAnimation(.easeIn) {
                  selectedPrayers.removeAll(where: { $0 == prayer })
                }
              }
            
            Text(prayer.title)
          }
        }
        .onMove(perform: { from, to in
          selectedPrayers.move(fromOffsets: from, toOffset: to)
        })
      }
      .offset(y: -20)
      .listStyle(.inset)
      .environment(\.editMode, .constant(.active))
    }
    .onAppear {
      focusedName = nil
    }
  }
  
  @ViewBuilder
  private func AddNewPrayerButton() -> some View {
    VStack(spacing: 0) {
      Button {
        showAllPrayerPickerScreen.toggle()
      } label: {
        HStack {
          Spacer()
          Image(systemName: "plus")
            .font(.body.bold())
          Text("Add new prayer")
            .font(.qsB(16))
          Spacer()
        }
        .padding()
        .background {
          RoundedRectangle(cornerRadius: 12)
            .stroke(preferences.accentColor.color, style: StrokeStyle(lineWidth: 1.2, lineCap: .butt, lineJoin: .round, dash: [4], dashPhase: 3))
        }
        .foregroundColor(preferences.accentColor.color)
      }
      
      Rectangle()
        .fill(.clear)
        .frame(height: 20)
      
      Rectangle()
        .fill(LinearGradient(colors: [Color(uiColor: .systemBackground), .clear], startPoint: .top, endPoint: .bottom))
        .frame(height: 20)
    }
  }
  
  @ViewBuilder
  private func StepThreeColorView() -> some View {
    VStack(alignment: .leading) {
      ColorPicker(selection: $color, label: {
        HStack {
          Image(systemName: "tag")
          Text("Choose tag color")
            .font(.qsSb(20))
        }
      })
    }
    .padding()
  }
}

#Preview {
  WorshipPlanScreen()
    .previewEnvironment()
}
