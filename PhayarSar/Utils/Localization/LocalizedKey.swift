//
//  LocalizedKey.swift
//  PhayarSar
//
//  Created by Kyaw Zay Ya Lin Tun on 16/12/2023.
//

import Foundation

enum LocalizedKey: String {
  case welcome_to_phayarsar
  case onboarding_desc
  case btn_get_started
  case choose_a_language
  case next
  case finished
  case today_pray_time_x
  case today_pray_time
  case x_min
  case x_sec
  case x_hour_y_min
  case btn_add
  case btn_pray
  case home
  case settings
  case app_language
  case app_accent_color
  case choose_accent_color
  case haptic_on
  case themes_and_settings
  case about_x
  case jasmine
  case panglong
  case msquare
  case yoeyar
  case page_white
  case page_yellow
  case page_grey
  case page_black
  case font
  case background_and_color
  case letter_and_line_spacing
  case letter_spacing
  case line_spacing
  case paragraph_spacing
  case text_size_and_alignment
  case align_left
  case align_right
  case align_center
  case justify
  case show_pronunciation
  case scrolling_speed
  case spotlight_text
  case x0_5
  case x0_75
  case x1
  case x1_25
  case x1_5
  case x2
  case tap_to_scroll
  case mode
  case reader_mode
  case player_mode
  case selected
  case add_new
  case worship_plan_helps_you_pray
  case view_collection
  case plus_x_more
  case other_prayers
  case new_plan
  case name_your_worship_plan
  case plan_name
  case add_new_prayer
  case btn_close
  case btn_save
  case select_prayers
  case everyday
  case sun
  case mon
  case tue
  case wed
  case thu
  case fri
  case sat
  case selectDay
  case selectTime
  case selectTagColor
  case setReminder
  case do_you_have_praying_time
  case yes_i_do
  case no_i_dont
  case time
  case remind
  case before
  case x_min_s
  case su
  case mo
  case tu
  case we
  case th
  case fr
  case sa
  case worship_plan
  case view_more
  case notify_x_mins_before
  case x_prayers
  case not_specified
  case new_worship_plan
  case all_worship_plans
  case edit_plan
  case prayers_x
  case selected_days
  case remind_me_before
  case plan_detail
  case edit
  case delete
  case plan_deleted_successfully
  case x_of_y
  case reset_prayers_theme
  case reset_prayers_theme_desc
  case prayers_theme_data_reset_successfully
  case delete_confirmation
  case cancel
  case disable_worship_reminders
  case disable_worship_reminders_desc
  case enable_worship_reminders
  case enable_worship_reminders_desc
  case disable_worship_reminders_success
  case disabled
  case seconds
  case minutes
  case hours
  case second
  case minute
  case hour
  case within_this_week
  case weekly
  case monthly
  case yearly
  case within_this_month
  
  func localize(_ lang: AppLanguage) -> String? {
    let dict = langDict[self.rawValue]
    switch lang {
    case .Eng:
      return dict?["En"]
    case .Mm:
      return dict?["Mm"]
    }
  }
  
  func localize(_ lang: AppLanguage, args: [String]) -> String? {
    let templateString = localize(lang)?.replacingOccurrences(of: "{$}", with: "%@") ?? ""
    return String(format: templateString, arguments: args).replacingOccurrences(of: "0.000000", with: "% F")
  }
}

func localizeNumber(_ appLang: AppLanguage, str: String) -> String {
  appLang == .Eng ? convertNumberMmToEng(str) : convertNumberEngToMm(str)
}

func localizeTime(_ appLang: AppLanguage, str: String) -> String {
  guard appLang == .Mm else { return str }
  let arr = str.split(separator: " ")
  guard let time = arr.first else { return "" }
  let localizedNumber = localizeNumber(appLang, str: "\(time)")
  return "\(localizedNumber) နာရီ"
}

func convertNumberEngToMm(_ engText: String) -> String {
  var mmText = ""
  for char in engText {
    switch char {
    case "0": mmText.append("၀")
    case "1": mmText.append("၁")
    case "2": mmText.append("၂")
    case "3": mmText.append("၃")
    case "4": mmText.append("၄")
    case "5": mmText.append("၅")
    case "6": mmText.append("၆")
    case "7": mmText.append("၇")
    case "8": mmText.append("၈")
    case "9": mmText.append("၉")
    default: mmText.append(char)
    }
  }
  return mmText.isEmpty ? engText : mmText
}

func convertNumberMmToEng(_ mmText: String) -> String {
  var engText = ""
  for char in mmText {
    switch char {
    case "၀": engText.append("0")
    case "၁": engText.append("1")
    case "၂": engText.append("2")
    case "၃": engText.append("3")
    case "၄": engText.append("4")
    case "၅": engText.append("5")
    case "၆": engText.append("6")
    case "၇": engText.append("7")
    case "၈": engText.append("8")
    case "၉": engText.append("9")
    default: engText.append(char)
    }
  }
  return engText.isEmpty ? mmText : engText
}
