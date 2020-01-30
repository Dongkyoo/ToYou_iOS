//
//  CalendarVC.swift
//  ToYou_iOS
//
//  Created by dongkyoo on 2020/01/30.
//  Copyright © 2020 dongkyoo. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarVC: UIViewController {

    @IBOutlet weak var calendarView: JTAppleCalendarView!

}

extension CalendarVC: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return ConfigurationParameters(startDate: dateFormatter.date(from: "2020-01-01")!, endDate: dateFormatter.date(from: "2100-12-31")!)
    }
}

extension CalendarVC: JTAppleCalendarViewDelegate {
    
    // 각 셀에 대해서 그리기 전에 한 번씩은 실행되는 메소드
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        
        handleCell(cell, cellState: cellState)
        return cell
    }
    
    //
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCell
        handleCell(cell, cellState: cellState)
    }
    
    private func handleCell(_ cell: DateCell, cellState: CellState) {
        cell.dateLabel.text = cellState.text
    }
}
