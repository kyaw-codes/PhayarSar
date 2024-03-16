//
//  PrayingDurationChartView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 15/03/2024.
//

import SwiftUI
import SwiftUICharts

enum PrayingDurationChartSegment: String, CaseIterable, Identifiable {
  var id: String { self.rawValue }
  
  case weekly
  case monthly
  case yearly
  
  var key: LocalizedKey {
    return .init(rawValue: self.rawValue) ?? .weekly
  }
}

struct PrayingDurationChartView: View {
  @EnvironmentObject private var preferences: UserPreferences
  @EnvironmentObject private var prayingTimeRepo: DailyPrayingTimeRepository
  @State private var weeklyData: BarChartData?
  @State private var selectedMode = PrayingDurationChartSegment.weekly
    
  var body: some View {
    VStack {
      Picker("", selection: $selectedMode) {
        ForEach(PrayingDurationChartSegment.allCases) { segment in
          LocalizedText(segment.key)
            .tag(segment)
        }
      }
      .pickerStyle(.segmented)
      
      if let weeklyData, selectedMode == .weekly {
        BarChart(chartData: weeklyData)
          .touchOverlay(chartData: weeklyData)
          .xAxisGrid(chartData: weeklyData)
          .yAxisGrid(chartData: weeklyData)
          .xAxisLabels(chartData: weeklyData)
          .yAxisLabels(chartData: weeklyData, colourIndicator: .none)
          .headerBox(chartData: weeklyData)
          .id(weeklyData.id)
          .frame(height: 350)
      }
    }
    .onAppear {
      setupWeeklyData()
    }
  }
  
  func setupWeeklyData() {
    let thisWeekData = prayingTimeRepo.prayingDataForThisWeek()
    let totalForThisWeek = thisWeekData.map(\.durationInSeconds).reduce(0, +)
    
    weeklyData = {
      let data: BarDataSet =
      BarDataSet(
        dataPoints: thisWeekData
          .map {
            let localizedDesc = if $0.durationInSeconds < 60 {
              $0.durationInSeconds == 0 ? LocalizedKey.second.localize(preferences.appLang) : LocalizedKey.seconds.localize(preferences.appLang)
            } else if $0.durationInSeconds >= 60 && $0.durationInSeconds < 3600 {
              $0.durationInSeconds == 60 ? LocalizedKey.minute.localize(preferences.appLang) : LocalizedKey.minutes.localize(preferences.appLang)
            } else {
              $0.durationInSeconds == 3600 ? LocalizedKey.hour.localize(preferences.appLang) : LocalizedKey.hours.localize(preferences.appLang)
            }
            return BarChartDataPoint(
              value: Double($0.durationInSeconds),
              xAxisLabel: DaysOfWeek(rawValue: $0.date.toStringWith(.EE).lowercased())!.shortName(appLang: preferences.appLang),
              description: localizedDesc,
              colour: .init(colours: [preferences.accentColor.color.opacity(0.85), preferences.accentColor.color.opacity(0.9), preferences.accentColor.color], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
          }
      )
      
      let localizedTitle = if totalForThisWeek < 60 {
        LocalizedKey.x_sec.localize(preferences.appLang, args: ["\(totalForThisWeek)"]).orEmpty
      } else if totalForThisWeek >= 60 && totalForThisWeek < 3600 {
        LocalizedKey.x_min.localize(preferences.appLang, args: [localizeNumber(preferences.appLang, str: "\(totalForThisWeek / 60)")]).orEmpty
      } else {
        LocalizedKey.x_hour_y_min.localize(
          preferences.appLang,
          args: [
            localizeNumber(preferences.appLang, str: "\(totalForThisWeek / 3600)"),
            localizeNumber(preferences.appLang, str: "\((totalForThisWeek % 3600) / 60)")
          ]
        ).orEmpty
      }
      
      let metadata = ChartMetadata(
        title: localizedTitle,
        subtitle: LocalizedKey.within_this_week.localize(preferences.appLang).orEmpty + "\n",
        titleFont: .dmSerif(24),
        subtitleFont: .qsB(14),
        subtitleColour: .secondary
      )
      
      let gridStyle = GridStyle(
        numberOfLines: 7,
        lineColour: preferences.accentColor.color.opacity(0.25),
        lineWidth: 1
      )
      
      let chartStyle = BarChartStyle(
        infoBoxPlacement: .header,
        infoBoxValueFont: .qsSb(22),
        infoBoxDescriptionFont: .qsSb(14),
        infoBoxDescriptionColour: .secondary,
        markerType: .bottomLeading(),
        xAxisGridStyle: gridStyle,
        xAxisLabelPosition: .bottom,
        xAxisLabelFont: .qsB(12),
        xAxisLabelColour: preferences.accentColor.color,
        xAxisLabelsFrom: .dataPoint(rotation: .degrees(0)),
        xAxisTitle: "",
        xAxisTitleFont: .qsSb(12),
        xAxisTitleColour: .secondary,
        yAxisGridStyle: gridStyle,
        yAxisLabelPosition: .leading,
        yAxisLabelFont: .qsB(12),
        yAxisLabelColour: preferences.accentColor.color,
        yAxisNumberOfLabels: 5,
        yAxisTitleFont: .qsSb(12),
        yAxisTitleColour: .secondary,
        baseline: .zero,
        topLine: .maximumValue
      )
      
      return BarChartData(
        dataSets: data,
        metadata: metadata,
        xAxisLabels: [],
        barStyle: BarStyle(
          barWidth: 0.5,
          cornerRadius: CornerRadius(top: 4, bottom: 0),
          colourFrom: .barStyle,
          colour: .init(colour: preferences.accentColor.color)
        ),
        chartStyle: chartStyle
      )
    }()
  }
}

#Preview {
  PrayingDurationChartView()
    .previewEnvironment()
}
