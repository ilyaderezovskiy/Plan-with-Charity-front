//
//  PlannerWidget.swift
//  PlannerWidget
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(name: String(localized: "Помощь людям с тяжелыми или неизлечимыми заболеваниями"), description: String(localized: "Тем, кого вылечить нельзя, все равно можно помочь. Хосписам в России помогает фонд «Вера», однако таких учреждений в стране катастрофически мало. Например, за Уралом нет ни одного паллиативного центра для детей"), date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(name: String(localized: "Помощь людям с тяжелыми или неизлечимыми заболеваниями"), description: String(localized: "Тем, кого вылечить нельзя, все равно можно помочь. Хосписам в России помогает фонд «Вера», однако таких учреждений в стране катастрофически мало. Например, за Уралом нет ни одного паллиативного центра для детей"), date: Date(), configuration: ConfigurationIntent())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let widgetInfo = getWidgetInfo()
        var entries: [SimpleEntry] = []
        
        let threeSeconds: TimeInterval = 300
        var currentDate = Date()
        let endDate = Calendar.current.date(byAdding: .minute, value: 20, to: currentDate)!

        while currentDate < endDate {
            for item in widgetInfo {
                let entry = SimpleEntry(name: item.title, description: item.description, date: currentDate, configuration: configuration)
                entries.append(entry)
                currentDate += threeSeconds
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CardView: View {
    let name: String
    let description: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: -15) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack() {
                        Text("Планируй, помогая!")
                            .font(.caption2.weight(.bold))
                            .padding(8)
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                    
                        Spacer()
                    }
                    .background(Color("Crayola Bleuet"))
                    
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .frame(height: 1)
                }
                
                Spacer(minLength: 10)
                
                Text(name)
                    .font(.system(size: 15, weight: .heavy, design: .default))
                    .padding(.top)
                    .padding(.horizontal)
                
                Spacer(minLength: 10)
                
                if name.contains("Что") || name.contains("What") {
                    Text(description)
                        .font(.system(size: 11, weight: .light, design: .default))
                        .padding()
                } else if name.contains("Факты") {
                    Text(description)
                        .font(.system(size: 12, weight: .light, design: .default))
                        .padding()
                } else if name.contains("Помощь") || name.contains("Helping") {
                    Text(description)
                        .font(.system(size: 10, weight: .light, design: .default))
                        .padding()
                } else {
                    Text(description)
                        .font(.system(size: 13, weight: .light, design: .default))
                        .padding()
                }
                
                Spacer()
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let name: String
    let description: String
    let date: Date
    let configuration: ConfigurationIntent
}

struct PlannerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        CardView(name: entry.name, description: entry.description)
    }
}

@main
struct PlannerWidget: Widget {
    let kind: String = "PlannerWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PlannerWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Планируй, помогая!")
        .description(String(localized: "Планировщик задач с функцией перевода денежных средств в благотворительные организации"))
    }
}

struct PlannerWidget_Previews: PreviewProvider {
    static var previews: some View {
        PlannerWidgetEntryView(entry: SimpleEntry(name: String(localized: "Помощь людям с тяжелыми или неизлечимыми заболеваниями"), description: String(localized: "Тем, кого вылечить нельзя, все равно можно помочь. Хосписам в России помогает фонд «Вера», однако таких учреждений в стране катастрофически мало. Например, за Уралом нет ни одного паллиативного центра для детей"), date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct WidgetInfo: Identifiable {
    var id: String = UUID().uuidString
    let title: String
    let description: String
}

func getWidgetInfo() -> [WidgetInfo] {
    let info1 = WidgetInfo(title: String(localized: "Что такое паллиативная помощь?"), description: String(localized: "Паллиативная помощь направлена на улучшение качества жизни человека с тяжелым и опасным для здоровья заболеванием. Чтобы каждый неизлечимо больной человек мог получить качественную помощь вне зависимости от места жительства, возраста и материального положения"))
    
    let info2 = WidgetInfo(title: String(localized: "Как понять, какому фонду можно безбоязненно отдать деньги?"), description: String(localized: "Не переводите деньги частным лицам, жертвуйте только через благотворительные фонды"))

    let info5 = WidgetInfo(title: String(localized: "Как понять, какому фонду можно безбоязненно отдать деньги?"), description: String(localized:"Ищите на сайте организации открытую информацию о том, кто собирает средства и с какой целью"))

    let info9 = WidgetInfo(title: String(localized: "Как понять, какому фонду можно безбоязненно отдать деньги?"), description: String(localized:"Проверяйте качество ввода персональных и платежных данных. Они должны быть зашифрованы"))

    let info13 = WidgetInfo(title: String(localized: "Как понять, какому фонду можно безбоязненно отдать деньги?"), description: String(localized:"Следите за реквизитами перевода. Они не должны вести на карты физических лиц"))

    let info3 = WidgetInfo(title: "Факты о благотворительности в России", description: "Средняя сумма пожертвований в России на одного человека – 3300 рублей. Более 40 миллионов россиян участвуют в благотворительности. Крупные пожертвования чаще перечисляют организации")

    let info6 = WidgetInfo(title: "Факты о благотворительности в России", description: "По подсчетам специалистов, только 1% благотворителей вносят пожертвования для оказания помощи взрослым людям. Основные перечисления рассчитаны на оказание помощи детям")

    let info10 = WidgetInfo(title: "Факты о благотворительности в России", description: "Для привлечения населения России к благотворительным акциям чаще всего используются интернет ресурсы. В этом направлении работают около 70% фондов")

    let info4 = WidgetInfo(title: String(localized: "Помощь людям с тяжелыми или неизлечимыми заболеваниями"), description: String(localized: "Тем, кого вылечить нельзя, все равно можно помочь. Хосписам в России помогает фонд «Вера», однако таких учреждений в стране катастрофически мало. Например, за Уралом нет ни одного паллиативного центра для детей"))

    let info7 = WidgetInfo(title: String(localized: "Помощь пожилым людям"), description: String(localized: "Пожилые люди нуждаются в том же, в чем и все остальные. Чтобы помочь, можно присоединиться к волонтерской группе, у которой есть опыт и знание специфики работы с пожилыми людьми. Например, можно помочь с ремонтом в квартирах нуждающихся, медицинским уходом, организацией занятия и развлечения для одиноких пожилых людей"))

    let info8 = WidgetInfo(title: String(localized: "Помощь пострадавшим"), description: String(localized: "Первое правило — сдавать кровь, ее всегда не хватает. Если вы хотите пожертвовать вещи — проследите, чтобы они были чистые и целые. Если хотите стать волонтером, обратитесь к фондам, которые организуют волонтерскую работу, самодеятельностью заниматься не стоит"))

    let info11 = WidgetInfo(title: String(localized: "Помощь людям с ограниченными возможностями"), description: String(localized: "Общайтесь с людьми с инвалидностью так же, как вы общаетесь со всеми остальными. Если ваш собеседник незрячий, не забывайте предупреждать, когда отходите, если слабослышащий — убедитесь, что ему хорошо видно ваше лицо. Если вы хотите помочь человеку, сначала узнайте, действительно ли ему нужна помощь"))

    let info12 = WidgetInfo(title: String(localized: "Помощь бездомным"), description: String(localized: "С октября по апрель самое страшное время для бездомных. Запишите телефоны служб помощи, они подскажут, куда направить бездомного. Помните: нечеткая дикция и нарушенная координация могут быть следствием не опьянения, а переохлаждения. Таким бездомным нужно вызвать «Скорую помощь» (телефоны 03 или 112)"))

    let info14 = WidgetInfo(title: String(localized: "Помощь детям-сиротам"), description: String(localized: "В действительности дети-сироты нуждаются в двух вещах: в подготовке к самостоятельной жизни и эмоциях, которые они не получили из-за отсутствия близких. Найдите несколько часов в неделю и станьте для ребенка значимым взрослым, который покажет, как устроен мир, и научит общению"))

    let info15 = WidgetInfo(title: String(localized: "Помощь тем, кому никто не помогает"), description: String(localized: "Есть множество людей, которые оказались в трудной ситуации, но их заявки не проходят ни в один из существующих фондов, а сил справиться с обстоятельствами у них нет. Это может быть ваш сосед или даже близкий родственник — зачастую, чтобы найти человека, который готов принять вашу помощь, достаточно оглянуться вокруг"))
    
    if Locale.current.languageCode == "ru" {
        return [info1, info2, info3, info4,
                info5, info6, info7, info8,
                info9, info10, info11, info12,
                info13, info14, info15]
    } else {
        return [info1, info2, info4, info5,
                info7, info8, info9, info11,
                info12, info13, info14, info15]
    }
}
