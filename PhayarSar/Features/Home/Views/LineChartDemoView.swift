//
//  LineChartDemoView.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 15/03/2024.
//

import SwiftUI
import SwiftUICharts

struct FilledLineChartDemoView: View {
    
    @State var data : LineChartData = weekOfData()
    
    var body: some View {
        VStack {
            FilledLineChart(chartData: data)
                .filledTopLine(chartData: data,
                               lineColour: ColourStyle(colour: .red),
                               strokeStyle: StrokeStyle(lineWidth: 3))
                .touchOverlay(chartData: data, unit: .suffix(of: "Steps"))
                .pointMarkers(chartData: data)
//                .yAxisPOI(chartData: data,
//                          markerName: "Step Count Aim",
//                          markerValue: 15_000,
//                          labelPosition: .center(specifier: "%.0f"),
//                          labelColour: Color.black,
//                          labelBackground: Color(red: 1.0, green: 0.75, blue: 0.25),
//                          lineColour: Color(red: 1.0, green: 0.75, blue: 0.25),
//                          strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
//                .yAxisPOI(chartData: data,
//                          markerName: "Minimum Recommended",
//                          markerValue: 10_000,
//                          labelPosition: .center(specifier: "%.0f"),
//                          labelColour: Color.white,
//                          labelBackground: Color(red: 0.25, green: 0.75, blue: 1.0),
//                          lineColour: Color(red: 0.25, green: 0.75, blue: 1.0),
//                          strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
//                .averageLine(chartData: data, strokeStyle: StrokeStyle(lineWidth: 1, dash: [5,10]))
                .xAxisGrid(chartData: data)
                .yAxisGrid(chartData: data)
                .xAxisLabels(chartData: data)
                .yAxisLabels(chartData: data)
                .headerBox(chartData: data)
//                .legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible())])
//                .id(data.id)
//                .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
                .frame(height: 300)
                .padding(.horizontal)
        }
        .navigationTitle("Filled Line")
    }
    
    static func weekOfData() -> LineChartData {
        let data = LineDataSet(dataPoints: [
            LineChartDataPoint(value: 12000, xAxisLabel: "M", description: "Monday"),
            LineChartDataPoint(value: 13000, xAxisLabel: "T", description: "Tuesday"),
            LineChartDataPoint(value: 8000,  xAxisLabel: "W", description: "Wednesday"),
            LineChartDataPoint(value: 17500, xAxisLabel: "T", description: "Thursday"),
            LineChartDataPoint(value: 16000, xAxisLabel: "F", description: "Friday"),
            LineChartDataPoint(value: 11000, xAxisLabel: "S", description: "Saturday"),
            LineChartDataPoint(value: 9000,  xAxisLabel: "S", description: "Sunday")
        ],
        legendTitle: "Test One",
        pointStyle: PointStyle(),
        style: LineStyle(lineColour: ColourStyle(colours: [Color.red.opacity(0.50),
                                                           Color.red.opacity(0.00)],
                                                 startPoint: .top,
                                                 endPoint: .bottom),
                         lineType: .line))
        
        return LineChartData(dataSets: data,
                             metadata: ChartMetadata(title: "Some Data", subtitle: "A Week"),
                             xAxisLabels: ["Monday", "Thursday", "Sunday"],
                             chartStyle: LineChartStyle(infoBoxPlacement: .header,
                                                        markerType: .full(attachment: .point),
                                                        xAxisLabelsFrom: .chartData(rotation: .degrees(0)),
                                                        baseline: .minimumWithMaximum(of: 5000)))
    }
}

struct FilledLineChartDemoView_Previews: PreviewProvider {
    static var previews: some View {
        FilledLineChartDemoView()
    }
}
