//
//  ContentView.swift
//  BerlinClock
//
//  Created by Manarbek Bibit on 11.04.2023.
//

import SwiftUI

struct ContentView: View {
    
    var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
        formatter.timeStyle = .medium
            return formatter
        }
    
    @State var selectedDate = Date()
    @State var topLightSeconds: Bool = false
    @State var fiveHoursLight: Int = 0
    @State var singleHoursLight: Int = 0
    @State var fiveMinutesLight: Int = 0
    @State var singleMinutesLight: Int = 0
    
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(CGColor(red: 0.949, green: 0.949, blue: 0.933, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 10) {
                
                Text("Time is \(selectedDate, formatter: dateFormatter)")
//                    .font(.custom("SFProText-Semibold", size: 17))
                    .fontWeight(.semibold)
                    .padding([.bottom,.top], 10)
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .frame(height: 312)
                    VStack(spacing: 16) {
                        SecondsLamp(isOn: topLightSeconds)
                        FiveHoursLamp(fiveHoursLampIsOn: fiveHoursLight)
                        SingleHourseLamp(singleHoursLampIsOn: singleHoursLight)
                        FiveMinutesRow(fiveMinutesLampIsOn: fiveMinutesLight)
                        SingleMinutesRow(singleMinutesLampIsOn: singleMinutesLight)
                    }
                }
                .frame(height: 312)
                .padding([.leading, .trailing], 16)
                
                datePickerView
                Spacer()
            }
            
            .onReceive(timer) { _ in
                updateBerlinClock()
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    selectedDate = Date()
                }
            }
        }
        

        
    }
    var datePickerView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(height: 54)
            HStack {
                DatePicker("Insert time", selection: $selectedDate, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
            }
            .padding([.leading, .trailing], 16)
        }
        .padding([.leading, .trailing], 16)
    }

    func updateBerlinClock() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: selectedDate)
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        topLightSeconds = seconds % 2 != 0
        SecondsLamp(isOn: topLightSeconds)
        
        fiveHoursLight = hours / 5
        FiveHoursLamp(fiveHoursLampIsOn: fiveHoursLight)
        
        singleHoursLight = hours % 5
        SingleHourseLamp(singleHoursLampIsOn: singleHoursLight)
        
        fiveMinutesLight = minutes / 5
        FiveMinutesRow(fiveMinutesLampIsOn: fiveMinutesLight)
        
        singleMinutesLight = minutes % 5
        SingleMinutesRow(singleMinutesLampIsOn: singleMinutesLight)
    }
}

struct SecondsLamp: View {
    var isOn: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(isOn ? CustomColor.brightYellowColor : CustomColor.dullYellowColor)
            .frame(width: 56, height: 56)
    }
}

struct FiveHoursLamp: View {
    var fiveHoursLampIsOn: Int
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<4) { index in
                RectangleForHourse(isOn: index < fiveHoursLampIsOn)
            }
        }
    }
}

struct SingleHourseLamp: View {
    var singleHoursLampIsOn: Int
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<4) {index in
                RectangleForHourse(isOn: index < singleHoursLampIsOn)
            }
        }
    }
}

struct FiveMinutesRow: View {
    var fiveMinutesLampIsOn: Int
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<11) {index in
                if (index < fiveMinutesLampIsOn) {
                    if (index + 1) % 3 == 0 {
                        SmallRectForMinutesRed(isOn: true)
                    } else {
                        SmallRectForMinutesYellow(isOn: true)
                    }
                    
                } else {
                    RoundedRectangle(cornerRadius: 4).fill(CustomColor.dullYellowColor)
                        .frame(width: 21, height: 32)
                }
            }
        }
    }
}

struct SingleMinutesRow: View {
    var singleMinutesLampIsOn: Int
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<4) {index in
                RectangleForMinutes(isOn: index < singleMinutesLampIsOn)
            }
        }
    }
}

// MARK: Rectangles for View
struct RectangleForHourse: View {
    var isOn: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 4).fill(isOn ? CustomColor.brightRedColor : CustomColor.dullRedColor)
            .frame(width: 74, height: 32)
    }
}
struct RectangleForMinutes: View {
    var isOn: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 4).fill(isOn ? CustomColor.brightYellowColor : CustomColor.dullYellowColor)
            .frame(width: 74, height: 32)
    }
}
struct SmallRectForMinutesYellow: View {
    var isOn: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 4).fill(isOn ? CustomColor.brightYellowColor : CustomColor.dullYellowColor)
            .frame(width: 21, height: 32)
    }
}
struct SmallRectForMinutesRed: View {
    var isOn: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 4).fill(isOn ? CustomColor.brightRedColor : CustomColor.dullRedColor)
            .frame(width: 21, height: 32)
    }
}

struct CustomColor {
    static let dullRedColor = Color("dullRed")
    static let dullYellowColor = Color("dullYellow")
    
    static let brightRedColor = Color("brightRed")
    static let brightYellowColor = Color("brightYellow")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, Locale(identifier: "ru_RU"))
    }
}
