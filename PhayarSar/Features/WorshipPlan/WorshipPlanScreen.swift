//
//  WorshipPlanScreen.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 01/02/2024.
//

import SwiftUI

struct WorshipPlanScreen: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var moc
  @EnvironmentObject private var preferences: UserPreferences
  
  @ObservedObject var worshipPlanRepo: WorshipPlanRepository
  @Binding var worshipPlan: WorshipPlan?

  @FocusState private var focusedName: String?
  
  // MARK: - Step one
  @State private var name = ""
  // MARK: - Step two
  @State private var selectedPrayers = [NatPintVO]()
  // MARK: - Step three
  @State private var selectedColor = Color("Tag1")
  @State private var selectedDays = [DaysOfWeek.everyday]
  @State private var hasPrayingTime = true
  @State private var selectedTime: Date = .init()
  @State private var enableReminder = true
  @State private var remindMeBefore = 5
  @State private var expandedSteps: [WorshipPlanConfigStep] = [.selectDay]
  
  @State private var currentStep: WorshipPlanSteps = .addName
  @State private var showAllPrayerPickerScreen = false
  @State private var ctaBtnText = LocalizedKey.next
  @State private var progress: CGFloat = 1/3
  
  var body: some View {
    VStack(spacing: 0) {
      TabView(selection: $currentStep) {
        StepOneNameView()
          .tag(WorshipPlanSteps.addName)
        StepTwoAddPrayersView()
          .tag(WorshipPlanSteps.addPrayers)
        StepThreeConfigView()
          .tag(WorshipPlanSteps.addConfigData)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      
      Divider()
      AppBtnFilled(action: next, title: ctaBtnText)
        .allowsHitTesting(enableNextButton())
        .opacity(enableNextButton() ? 1 : 0.5)
        .padding([.top, .horizontal])
        .padding(.bottom, 12)
    }
    .safeAreaInset(edge: .top, spacing: 0) {
      NavView()
    }
    .onAppear {
      focusedName = "planname"
      if let plan = worshipPlan {
        name = plan.planName
        selectedPrayers = plan.selectedPrayers
        selectedDays = plan.selectedDaysEnum ?? []
        selectedTime = plan.selectedTime ?? .init()
        hasPrayingTime = plan.hasPrayingTime
        remindMeBefore = Int(plan.remindMeBefore)
        enableReminder = plan.enableReminder
      }
    }
    .onChange(of: currentStep) { _ in
      updateProgressAndButtonText()
    }
    .sheet(isPresented: $showAllPrayerPickerScreen, content: {
      AllPrayerPickerScreen(prayers: $selectedPrayers)
    })
  }
  
  private func updateProgressAndButtonText() {
    let position = WorshipPlanSteps.allCases.firstIndex(where: { $0 == currentStep }).orElse(0) + 1
    
    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.7)) {
      progress = CGFloat(position) / CGFloat(WorshipPlanSteps.allCases.count)
    }
    
    switch currentStep {
    case .addName, .addPrayers:
      ctaBtnText = .next
    case .addConfigData:
      ctaBtnText = .finished
    }
  }
  
  private func enableNextButton() -> Bool {
    switch currentStep {
    case .addName:
      return !name.isEmpty
    case .addPrayers:
      return !selectedPrayers.isEmpty
    case .addConfigData:
      return !name.isEmpty && !selectedPrayers.isEmpty && !selectedDays.isEmpty
    }
  }
  
  private func next() {
    switch currentStep {
    case .addName:
      withAnimation(.easeIn) {
        currentStep = .addPrayers
      }
    case .addPrayers:
      withAnimation(.easeIn) {
        currentStep = .addConfigData
      }
    case .addConfigData:
      saveWorshipPlan()
      dismiss()
    }
  }
  
  private func saveWorshipPlan() {
    let plan = worshipPlan ?? WorshipPlan(context: moc)
    let encoder = JSONEncoder()
    
    plan.planName = name
    print(selectedPrayers.map(\.id))
    
    if let data = try? encoder.encode(selectedPrayers.map(\.id)) {
      plan.selectedPrayerIds = data
      let arr = try? JSONDecoder().decode([String].self, from: data)
      print(arr)
    }
    
    if let data = try? encoder.encode(selectedDays.map(\.rawValue)) {
      plan.selectedDays = data
    }
    
    plan.hasPrayingTime = hasPrayingTime
    plan.selectedTime = selectedTime
    plan.enableReminder = enableReminder
    plan.remindMeBefore = Int16(remindMeBefore)
    
    worshipPlanRepo.savePlan(plan)
  }
  
  // MARK: - Sub views
  @ViewBuilder
  private func NavView() -> some View {
    VStack(spacing: 0) {
      HStack {
        Image(systemName: "sparkles.rectangle.stack")
          .font(.title)
          .foregroundColor(preferences.accentColor.color)
        
        LocalizedText(worshipPlan.isNotNil ? .edit_plan : .new_plan)
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
    .padding([.horizontal, .top])
  }
  
  @ViewBuilder
  private func ProgressView() -> some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(.cardBg)
      .frame(height: 12)
      .overlay(alignment: .leading) {
        GeometryReader {
          let width = $0.size.width
          
          RoundedRectangle(cornerRadius: 12)
            .fill(
              LinearGradient(
                colors: [preferences.accentColor.color, preferences.accentColor.color.opacity(0.8), preferences.accentColor.color.opacity(0.7), preferences.accentColor.color.opacity(0.5)],
                startPoint: .leading,
                endPoint: .trailing
              )
            )
            .frame(width: width * progress)
            .overlay(alignment: .trailing) {
              Text("🌟")
                .font(.largeTitle)
                .offset(x: 12, y: -1)
            }
        }
      }
      .padding(.top, 30)
  }
  
  @ViewBuilder
  private func StepOneNameView() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      LocalizedText(.name_your_worship_plan)
        .font(.qsB(20))
      TextField(LocalizedKey.plan_name.localize(preferences.appLang).orEmpty, text: $name)
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
        .padding(.top)
        .zIndex(1)
      
      List {
        ForEach(selectedPrayers) { prayer in
          HStack {
            Image(systemName: "minus.circle.fill")
              .foregroundColor(preferences.accentColor.color)
              .padding(.vertical, 12)
              .padding(.horizontal, 8)
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
          LocalizedText(.add_new_prayer)
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
  private func StepThreeConfigView() -> some View {
    ScrollView(showsIndicators: false) {
      VStack {
        CollapsableView(step: .selectDay, valid: !selectedDays.isEmpty) {
          DaysOfWeekGridView()
        }
        
        CollapsableView(step: .selectTime) {
          TimeGridView()
        }
        
//        CollapsableView(step: .selectTagColor) {
//          TagColorGridView()
//        }
        
        CollapsableView(step: .setReminder) {
          SetReminderView()
        }
      }
      .padding(.top, 16)
    }
    .overlay(alignment: .top) {
      Rectangle()
        .fill(LinearGradient(colors: [.init(uiColor: .systemBackground), .clear, .clear], startPoint: .top, endPoint: .bottom))
        .frame(height: 30)
    }
    .tint(preferences.accentColor.color)
    .padding()
  }
  
  @ViewBuilder
  private func SetReminderView() -> some View {
    HStack(spacing: 4) {
      LocalizedText(.remind)
        .font(preferences.appLang == .Mm ? .qsB(13) : .qsB(14))
        .opacity(enableReminder ? 1 : 0.2)
      Menu {
        ForEach(0 ... 60, id: \.self) { id in
          Button {
            HapticKit.selection.generate()
            remindMeBefore = id
          } label: {
            LocalizedText(.x_min_s, args: [localizeNumber(preferences.appLang, str: "\(id)")])
              .font(.qsB(18))
          }
        }
      } label: {
        LocalizedText(.x_min_s, args: [localizeNumber(preferences.appLang, str: "\(remindMeBefore)")])
          .font(.qsB(15))
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background {
            RoundedRectangle(cornerRadius: 12)
              .foregroundColor(preferences.accentColor.color.opacity(0.2))
          }
          .opacity(enableReminder ? 1 : 0.2)
      }
      .allowsHitTesting(enableReminder)
      
      LocalizedText(.before)
        .font(preferences.appLang == .Mm ? .qsB(13) : .qsB(14))
        .opacity(enableReminder ? 1 : 0.2)
      
      Spacer()
      
      Toggle(isOn: $enableReminder, label: {})
        .padding(.trailing, -10)
        .scaleEffect(0.85)
    }
    .padding(.horizontal)
    .padding(.vertical)
    .background {
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.cardBg)
    }
  }
  
  @ViewBuilder
  private func DaysOfWeekGridView() -> some View {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), content: {
      ForEach(DaysOfWeek.allCases, id: \.rawValue) { day in
        DaysOfWeekGridCell(day)
          .opacity(selectedDays.contains(.everyday) ? (day == .everyday ? 1 : 0.4) : 1)
          .allowsHitTesting(selectedDays.contains(.everyday) ? (day == .everyday) : true)
      }
    })
  }
  
  @ViewBuilder
  private func DaysOfWeekGridCell(_ day: DaysOfWeek) -> some View {
    HStack {
      LocalizedText(day.key)
      Spacer()
      Image(systemName: selectedDays.contains(day) ? "checkmark.square.fill" : "square")
    }
    .font(.qsSb(14))
    .foregroundColor(selectedDays.contains(day) ? preferences.accentColor.color : .secondary)
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.cardBg)
    )
    .overlay {
      RoundedRectangle(cornerRadius: 12)
        .stroke(selectedDays.contains(day) ? preferences.accentColor.color.opacity(0.7) : Color.clear, lineWidth: 1)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      withAnimation(.easeIn(duration: 0.2)) {
        if selectedDays.contains(day) {
          selectedDays.removeAll(where: { $0 == day })
        } else {
          selectedDays.append(day)
        }
      }
    }
  }
  
  @ViewBuilder
  private func TagColorGridView() -> some View {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 6), spacing: 20, content: {
      ForEach(1 ... 20, id: \.self) { id in
        Circle()
          .fill(LinearGradient(colors: [Color("Tag\(id)").opacity(0.8), Color("Tag\(id)").opacity(0.9), Color("Tag\(id)")], startPoint: .topLeading, endPoint: .bottomTrailing))
          .shadow(color: Color("Tag\(id)").opacity(0.2), radius: 10, x: 2, y: 2)
          .overlay {
            Image(systemName: "checkmark")
              .foregroundColor(.white)
              .font(.headline)
              .opacity(Color("Tag\(id)") == selectedColor ? 1 : 0)
          }
          .contentShape(Circle())
          .onTapGesture {
            HapticKit.selection.generate()
            withAnimation(.easeIn(duration: 0.2)) {
              selectedColor = Color("Tag\(id)")
            }
          }
      }
    })
  }
  
  @ViewBuilder
  private func TimeGridView() -> some View {
    VStack {
      VStack(alignment: .leading, spacing: 14) {
        LocalizedText(.do_you_have_praying_time)
          .multilineTextAlignment(.leading)
          .font(.qsSb(16))
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), content: {
          HStack {
            LocalizedText(.yes_i_do)
            Spacer()
            Image(systemName: hasPrayingTime ? "circle.inset.filled" : "circle")
          }
          .font(.qsSb(14))
          .foregroundColor(hasPrayingTime ? preferences.accentColor.color : .secondary)
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.cardBg)
          )
          .overlay {
            RoundedRectangle(cornerRadius: 12)
              .stroke(hasPrayingTime ? preferences.accentColor.color : Color.clear, lineWidth: 1)
          }
          .contentShape(Rectangle())
          .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.7)) {
              hasPrayingTime = true
            }
          }
          
          HStack {
            LocalizedText(.no_i_dont)
            Spacer()
            Image(systemName: !hasPrayingTime ? "circle.inset.filled" : "circle")
          }
          .font(.qsSb(14))
          .foregroundColor(!hasPrayingTime ? preferences.accentColor.color : .secondary)
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.cardBg)
          )
          .overlay {
            RoundedRectangle(cornerRadius: 12)
              .stroke(!hasPrayingTime ? preferences.accentColor.color : Color.clear, lineWidth: 1)
          }
          .contentShape(Rectangle())
          .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.7)) {
              hasPrayingTime = false
            }
          }
        })
        
        if hasPrayingTime {
          DatePicker(selection: $selectedTime, displayedComponents: [.hourAndMinute]) {
            HStack {
              Image(systemName: "alarm")
              LocalizedText(.time)
            }
            .font(.qsSb(16))
          }
          .padding(.horizontal)
          .padding(.vertical, 12)
          .background {
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.cardBg)
          }
          .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.2, anchor: .top)))
        }
      }
    }
  }
  
  @ViewBuilder
  private func CollapsableView<Content: View>(
    step: WorshipPlanConfigStep,
    valid: Bool = true,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    HStack(alignment: .top) {
      VStack {
        Image(systemName: expandedSteps.contains(step) ? "circle.inset.filled" : "record.circle")
          .scaleEffect(expandedSteps.contains(step) ? 1.3 : 1, anchor: .top)
          .foregroundColor(!expandedSteps.contains(step) && !valid ? .red : expandedSteps.contains(step) ? preferences.accentColor.color : .primary)
        
        StraightLine()
          .stroke(Color.secondary, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .bevel, dash: [6], dashPhase: 1))
          .frame(width: step == .setReminder ? 0 : 1)
          .padding(.top, 8)
      }
      .frame(width: 30)
      
      VStack(alignment: .leading) {
        HStack {
          LocalizedText(step.key)
            .font(preferences.appLang == .Mm ? .qsB(17) : .qsB(expandedSteps.contains(step) ? 20 : 17))
            .foregroundColor(!expandedSteps.contains(step) && !valid ? .red : expandedSteps.contains(step) ? preferences.accentColor.color : .primary)
          
          if !expandedSteps.contains(step) && !valid {
            Image(systemName: "exclamationmark.triangle.fill")
              .foregroundColor(.red)
          }
          Spacer()
          Image(systemName: "chevron.forward")
            .rotationEffect(.degrees(expandedSteps.contains(step) ? 90 : 0))
            .foregroundColor(expandedSteps.contains(step) ? preferences.accentColor.color : .primary)
        }
        .background(Color(uiColor: .systemBackground))
        .zIndex(2)
        
        if expandedSteps.contains(step) {
          content()
            .transition(.move(edge: .trailing).combined(with: .opacity).combined(with: .scale(scale: 0.1, anchor: .topTrailing)))
            .padding(.top, 12)
            .padding(.bottom, 20)
            .zIndex(1)
        }
        
        Rectangle()
          .fill(.clear)
          .padding(.bottom, expandedSteps.contains(step) ? 0 : 12)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .overlay(alignment: .top) {
      Rectangle()
        .fill(.clear)
        .frame(height: 35)
        .contentShape(Rectangle())
        .onTapGesture {
          withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.7)) {
            if expandedSteps.contains(step) {
              expandedSteps.removeAll(where: { $0 == step })
            } else {
              expandedSteps.append(step)
            }
          }
        }
    }
  }
}

#Preview {
  WorshipPlanScreen(worshipPlanRepo: .init(), worshipPlan: .constant(nil))
    .previewEnvironment()
}
