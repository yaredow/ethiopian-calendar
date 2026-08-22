import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

import "Model.js" as Model

Panel {
  id: root
  moduleName: "user.ethiopian-calendar"
  ipcTarget: "user.ethiopian-calendar"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null
  readonly property var barIdentity: hostWidget || root

  property var currentDate: new Date()
  property var ethDate: Model.getEthiopianDate(currentDate)
  property var ethTime: Model.getEthiopianTime(currentDate)

  property int currentTab: 0 // 0: Calendar, 1: Converter, 2: Fidel

  property int viewYear: ethDate.year
  property int selectedMonth: ethDate.month
  property int selectedDay: ethDate.day

  property bool useGeezNumerals: false
  property int factIndex: 0

  // Converter State
  property int convMode: 0 // 0: Gregorian -> Ethiopian, 1: Ethiopian -> Gregorian
  property int convGYear: currentDate.getFullYear()
  property int convGMonth: currentDate.getMonth() + 1
  property int convGDay: currentDate.getDate()
  readonly property var convEthResult: Model.getEthiopianDate(new Date(convGYear, convGMonth - 1, convGDay, 12, 0, 0))

  property int convEYear: ethDate.year
  property int convEMonth: ethDate.month
  property int convEDay: ethDate.day
  readonly property var convGregResult: Model.ethiopianToGregorian(convEYear, convEMonth, convEDay)

  readonly property var yearMonths: Model.getYearCalendarData(viewYear)
  readonly property bool isCurrentYear: viewYear === ethDate.year
  readonly property string selectedHoliday: Model.getHoliday(selectedMonth, selectedDay, viewYear % 4 === 3)
  readonly property string selectedSaint: Model.getDailySaint(selectedDay)
  readonly property var selectedGregorianDate: Model.ethiopianToGregorian(viewYear, selectedMonth, selectedDay)

  // Theme Palette Tokens (Omarchy System Design)
  property color foreground: Color.popups.text
  property color background: Color.popups.background
  property color border: Color.popups.border
  property color accent: Color.accent
  property color urgent: Color.urgent
  property color dim: Util.alpha(Color.popups.text, 0.55)
  property color faint: Util.alpha(Color.popups.text, 0.08)
  property color cardBg: Util.alpha(Color.popups.text, 0.03)
  property color cardBorder: Util.alpha(Color.popups.border, 0.25)
  property color hoverBg: Util.alpha(Color.popups.text, 0.08)
  property color activeBg: Util.alpha(Color.accent, 0.16)

  Process { id: notifyProc }

  function notify(title, message) {
    if (notifyProc.running) notifyProc.running = false
    notifyProc.command = ["notify-send", "-a", "Ethiopian Calendar", "-i", "x-office-calendar", title, message]
    notifyProc.running = true
  }

  function open() { refresh(); root.controller.show() }
  function close() { root.controller.hide() }
  function toggle() { if (root.opened) root.close(); else root.open() }

  function refresh() {
    currentDate = new Date()
    ethDate = Model.getEthiopianDate(currentDate)
    ethTime = Model.getEthiopianTime(currentDate)
    if (root.isCurrentYear) { selectedMonth = ethDate.month; selectedDay = ethDate.day }
  }

  function resetToToday() {
    refresh()
    viewYear = ethDate.year
    selectedMonth = ethDate.month
    selectedDay = ethDate.day
    convGYear = currentDate.getFullYear()
    convGMonth = currentDate.getMonth() + 1
    convGDay = currentDate.getDate()
    convEYear = ethDate.year
    convEMonth = ethDate.month
    convEDay = ethDate.day
  }

  function moveYear(delta) { viewYear += delta }
  function nextFact() { factIndex = (factIndex + 1) % Model.ethiopianFacts.length }
  function prevFact() { factIndex = (factIndex - 1 + Model.ethiopianFacts.length) % Model.ethiopianFacts.length }
  function formatNum(num) { return useGeezNumerals ? Model.toAmharicNumeral(num) : String(num) }

  function addConvDays(delta) {
    if (convMode === 0) {
      var d = new Date(convGYear, convGMonth - 1, convGDay + delta, 12, 0, 0);
      convGYear = d.getFullYear();
      convGMonth = d.getMonth() + 1;
      convGDay = d.getDate();
    } else {
      var g = Model.ethiopianToGregorian(convEYear, convEMonth, convEDay);
      g.setDate(g.getDate() + delta);
      var eth = Model.getEthiopianDate(g);
      convEYear = eth.year;
      convEMonth = eth.month;
      convEDay = eth.day;
    }
  }

  function addConvMonths(delta) {
    if (convMode === 0) {
      var targetM = convGMonth - 1 + delta;
      var d = new Date(convGYear, targetM, Math.min(convGDay, 28), 12, 0, 0);
      convGYear = d.getFullYear();
      convGMonth = d.getMonth() + 1;
    } else {
      var newM = convEMonth + delta;
      var newY = convEYear;
      while (newM > 13) { newM -= 13; newY += 1; }
      while (newM < 1) { newM += 13; newY -= 1; }
      convEYear = newY;
      convEMonth = newM;
      var maxD = (newM === 13) ? (newY % 4 === 3 ? 6 : 5) : 30;
      if (convEDay > maxD) convEDay = maxD;
    }
  }

  function addConvYears(delta) {
    if (convMode === 0) {
      convGYear += delta;
    } else {
      convEYear += delta;
      var maxD = (convEMonth === 13) ? (convEYear % 4 === 3 ? 6 : 5) : 30;
      if (convEDay > maxD) convEDay = maxD;
    }
  }

  function toggleConvMode() {
    if (convMode === 0) {
      convEYear = convEthResult.year
      convEMonth = convEthResult.month
      convEDay = convEthResult.day
      convMode = 1
    } else {
      convGYear = convGregResult.getFullYear()
      convGMonth = convGregResult.getMonth() + 1
      convGDay = convGregResult.getDate()
      convMode = 0
    }
  }

  function copySelectedDate() {
    var fullStr = Model.amharicMonths[selectedMonth - 1] + " " + formatNum(selectedDay) + " ቀን " + formatNum(viewYear) + " ዓ.ም (" + selectedGregorianDate.toLocaleDateString(Qt.locale("en_US"), "MMMM d, yyyy") + ")"
    Quickshell.clipboardText = fullStr
    notify("ተቀድቷል (Copied)", fullStr)
  }

  function copyConvertedEth() {
    var fullStr = Model.amharicMonths[convEthResult.month - 1] + " " + formatNum(convEthResult.day) + " ቀን " + formatNum(convEthResult.year) + " ዓ.ም"
    Quickshell.clipboardText = fullStr
    notify("ተቀድቷል (Copied)", fullStr)
  }

  function copyConvertedGreg() {
    var fullStr = convGregResult.toLocaleDateString(Qt.locale("en_US"), "dddd, MMMM d, yyyy")
    Quickshell.clipboardText = fullStr
    notify("Copied", fullStr)
  }

  Timer {
    interval: 1000
    running: root.opened
    repeat: true
    onTriggered: { currentDate = new Date(); ethTime = Model.getEthiopianTime(currentDate) }
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.barIdentity
    bar: root.bar
    open: root.opened
    centerOnBar: true
    focusTarget: keyHandler
    contentWidth: panel.fittedContentWidth(Style.space(780))
    contentHeight: panel.fittedContentHeight(Style.space(564))

    Item {
      id: keyHandler
      anchors.fill: parent
      focus: true
      Keys.onPressed: function(event) {
        var isTyping = (typeof yearInput !== "undefined" && yearInput.activeFocus) ||
                       (typeof monthInput !== "undefined" && monthInput.activeFocus) ||
                       (typeof dayInput !== "undefined" && dayInput.activeFocus);

        if (event.key === Qt.Key_Escape) {
          if (isTyping) {
            keyHandler.forceActiveFocus();
          } else {
            root.close();
          }
          event.accepted = true;
          return;
        }

        if (isTyping) return;

        if (event.key === Qt.Key_1) { root.currentTab = 0; event.accepted = true }
        else if (event.key === Qt.Key_2) { root.currentTab = 1; event.accepted = true }
        else if (event.key === Qt.Key_3) { root.currentTab = 2; event.accepted = true }
        else if (event.key === Qt.Key_T) { root.resetToToday(); event.accepted = true }
        else if (event.key === Qt.Key_N) { root.useGeezNumerals = !root.useGeezNumerals; event.accepted = true }
        else if (event.key === Qt.Key_Left && root.currentTab === 0) { root.moveYear(-1); event.accepted = true }
        else if (event.key === Qt.Key_Right && root.currentTab === 0) { root.moveYear(1); event.accepted = true }
        else if (event.key === Qt.Key_C && root.currentTab === 0) { root.copySelectedDate(); event.accepted = true }
      }
    }

    ColumnLayout {
      id: mainColumn
      anchors.fill: parent
      spacing: Style.space(8)

      // =====================================================================
      // UNIFIED HEADER: Tabs + Live Time (Center) + Controls
      // =====================================================================
      RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.space(34)
        implicitHeight: Style.space(34)
        spacing: Style.space(8)

        // Navigation Tabs
        Row {
          spacing: Style.spacing.xs
          Layout.alignment: Qt.AlignVCenter

          Button {
            text: "🗓️ ቀን መቁጠሪያ"
            selected: root.currentTab === 0
            fontSize: Style.font.caption
            foreground: root.foreground
            accent: root.accent
            onClicked: root.currentTab = 0
          }

          Button {
            text: "🔄 መቀየሪያ"
            selected: root.currentTab === 1
            fontSize: Style.font.caption
            foreground: root.foreground
            accent: root.accent
            onClicked: root.currentTab = 1
          }

          Button {
            text: "🔤 ፊደል"
            selected: root.currentTab === 2
            fontSize: Style.font.caption
            foreground: root.foreground
            accent: root.accent
            onClicked: root.currentTab = 2
          }
        }

        Item { Layout.fillWidth: true }

        // Live Ethiopian Time in the Center of Header
        Text {
          text: root.ethTime.formatted
          font.pixelSize: Style.font.body
          font.bold: true
          color: root.foreground
          textFormat: Text.PlainText
          Layout.alignment: Qt.AlignCenter
        }

        Item { Layout.fillWidth: true }

        // Calendar Controls (visible only on calendar tab)
        RowLayout {
          visible: root.currentTab === 0
          spacing: Style.spacing.xs
          Layout.alignment: Qt.AlignVCenter

          // Back to Today button
          Button {
            visible: !root.isCurrentYear
            text: "ዛሬ (Today)"
            fontSize: Style.font.caption
            foreground: root.foreground
            accent: root.accent
            Layout.alignment: Qt.AlignVCenter
            onClicked: root.resetToToday()
          }

          // Year Navigation - Previous (<>)
          Button {
            text: "‹"
            fontSize: Style.font.heading
            foreground: root.foreground
            accent: root.accent
            Layout.alignment: Qt.AlignVCenter
            onClicked: root.moveYear(-1)
          }

          Text {
            text: root.formatNum(root.viewYear) + " ዓ.ም"
            font.pixelSize: Style.font.body
            font.bold: true
            color: root.foreground
            textFormat: Text.PlainText
            Layout.alignment: Qt.AlignVCenter
          }

          Text {
            text: "(" + (root.viewYear + 7) + "–" + (root.viewYear + 8) + ")"
            font.pixelSize: Style.font.caption
            color: root.dim
            textFormat: Text.PlainText
            Layout.alignment: Qt.AlignVCenter
          }

          // Year Navigation - Next (<>)
          Button {
            text: "›"
            fontSize: Style.font.heading
            foreground: root.foreground
            accent: root.accent
            Layout.alignment: Qt.AlignVCenter
            onClicked: root.moveYear(1)
          }

          // Numeral Toggle
          Button {
            text: root.useGeezNumerals ? "፩፪፫" : "123"
            selected: root.useGeezNumerals
            fontSize: Style.font.caption
            foreground: root.foreground
            accent: root.accent
            Layout.alignment: Qt.AlignVCenter
            onClicked: root.useGeezNumerals = !root.useGeezNumerals
          }
        }
      }

      // =====================================================================
      // TAB 0: CALENDAR VIEW
      // =====================================================================
      ColumnLayout {
        id: calendarTab
        visible: root.currentTab === 0
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: Style.space(522)
        implicitHeight: Style.space(522)
        spacing: Style.space(6)

        // 4x4 Grid Container (Months 1-12, Pagume, Dashboard)
        GridLayout {
          id: calGrid
          columns: 4
          columnSpacing: Style.space(6)
          rowSpacing: Style.space(6)
          Layout.fillWidth: true
          Layout.fillHeight: true

          // Regular Months 1-12 (Rows 1-3, all 4 columns)
          Repeater {
            model: 12
            delegate: Rectangle {
              id: monthCard
              readonly property var mData: root.yearMonths[index]
              Layout.fillWidth: true
              Layout.preferredHeight: Style.space(126)
              radius: Style.space(5)
              color: root.cardBg
              border.color: (root.isCurrentYear && root.ethDate.month === (index + 1)) ? root.accent : root.cardBorder
              border.width: 1

              ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.space(6)
                spacing: Style.space(2)

                // Month Header: Amharic Name + English
                RowLayout {
                  Layout.fillWidth: true
                  Text {
                    text: monthCard.mData ? (root.formatNum(index + 1) + ". " + monthCard.mData.nameAm) : ""
                    font.pixelSize: Style.font.body
                    font.bold: true
                    color: (root.isCurrentYear && root.ethDate.month === (index + 1)) ? root.accent : root.foreground
                    textFormat: Text.PlainText
                  }
                  Item { Layout.fillWidth: true }
                  Text {
                    text: monthCard.mData ? monthCard.mData.gregorianSpan : ""
                    font.pixelSize: Style.font.caption
                    color: root.dim
                    textFormat: Text.PlainText
                  }
                }

                // 7-day abbreviation headers (ሰ ማ ረ ሐ ዓ ቅ እ)
                RowLayout {
                  Layout.fillWidth: true
                  spacing: Style.space(1)
                  Repeater {
                    model: Model.amharicDaysShort
                    delegate: Text {
                      text: modelData
                      font.pixelSize: Style.font.caption
                      font.bold: true
                      color: root.dim
                      textFormat: Text.PlainText
                      horizontalAlignment: Text.AlignHCenter
                      Layout.fillWidth: true
                    }
                  }
                }

                // Days Grid (6-row x 7-column calendar cells)
                GridLayout {
                  columns: 7
                  columnSpacing: Style.space(1)
                  rowSpacing: Style.space(1)
                  Layout.fillWidth: true

                  // Padding cells
                  Repeater {
                    model: monthCard.mData.padding
                    delegate: Item {
                      Layout.fillWidth: true
                      Layout.preferredHeight: Style.space(14)
                    }
                  }

                  // Day Number Cells (1 to 30)
                  Repeater {
                    model: monthCard.mData.days
                    delegate: Rectangle {
                      Layout.fillWidth: true
                      Layout.preferredHeight: Style.space(14)
                      radius: Style.space(3)
                      readonly property bool isToday: root.isCurrentYear && (root.ethDate.month === (index + 1)) && (modelData === root.ethDate.day)
                      readonly property bool isHoliday: Model.getHoliday(index + 1, modelData, root.viewYear % 4 === 3) !== null
                      readonly property bool isSelected: (root.selectedMonth === (index + 1)) && (root.selectedDay === modelData)
                      color: isToday ? root.activeBg : (isSelected ? root.hoverBg : (dMouse.containsMouse ? root.faint : "transparent"))
                      border.color: isToday ? root.accent : (isSelected ? root.cardBorder : "transparent")
                      border.width: (isToday || isSelected) ? 1 : 0
                      Text {
                        anchors.centerIn: parent
                        text: root.formatNum(modelData)
                        font.pixelSize: root.useGeezNumerals ? 9 : 10
                        font.bold: isToday || isHoliday || isSelected
                        color: isToday ? root.accent : (isHoliday ? root.urgent : root.foreground)
                        textFormat: Text.PlainText
                      }
                      MouseArea {
                        id: dMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                          root.selectedMonth = index + 1
                          root.selectedDay = modelData
                        }
                        onDoubleClicked: {
                          root.selectedMonth = index + 1
                          root.selectedDay = modelData
                          root.copySelectedDate()
                        }
                      }
                    }
                  }
                }
                Item { Layout.fillHeight: true }
              }
            }
          }

          // Row 4 Slot 1: Pagume (Month 13 — The 13th Month with 5 or 6 days)
          Rectangle {
            id: pagumeCard
            readonly property var mData: root.yearMonths[12]
            Layout.fillWidth: true
            Layout.preferredHeight: Style.space(126)
            radius: Style.space(5)
            color: root.cardBg
            border.color: (root.isCurrentYear && root.ethDate.month === 13) ? root.accent : root.cardBorder
            border.width: 1

            ColumnLayout {
              anchors.fill: parent
              anchors.margins: Style.space(6)
              spacing: Style.space(2)

              RowLayout {
                Layout.fillWidth: true
                Text {
                  text: pagumeCard.mData ? (root.formatNum(13) + ". " + pagumeCard.mData.nameAm) : ""
                  font.pixelSize: Style.font.body
                  font.bold: true
                  color: (root.isCurrentYear && root.ethDate.month === 13) ? root.accent : root.foreground
                  textFormat: Text.PlainText
                }
                Item { Layout.fillWidth: true }
                Text {
                  text: pagumeCard.mData ? (pagumeCard.mData.daysCount + " ቀናት") : ""
                  font.pixelSize: Style.font.caption
                  color: root.dim
                  textFormat: Text.PlainText
                }
              }

              RowLayout {
                Layout.fillWidth: true
                spacing: Style.space(1)
                Repeater {
                  model: Model.amharicDaysShort
                  delegate: Text {
                    text: modelData
                    font.pixelSize: Style.font.caption
                    font.bold: true
                    color: root.dim
                    textFormat: Text.PlainText
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                  }
                }
              }
              GridLayout {
                columns: 7
                columnSpacing: Style.space(1)
                rowSpacing: Style.space(1)
                Layout.fillWidth: true

                Repeater {
                  model: pagumeCard.mData.padding
                  delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.space(14)
                  }
                }

                Repeater {
                  model: pagumeCard.mData.days
                  delegate: Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.space(14)
                    radius: Style.space(3)
                    readonly property bool isToday: root.isCurrentYear && (root.ethDate.month === 13) && (modelData === root.ethDate.day)
                    readonly property bool isHoliday: Model.getHoliday(13, modelData, root.viewYear % 4 === 3) !== null
                    readonly property bool isSelected: (root.selectedMonth === 13) && (root.selectedDay === modelData)
                    color: isToday ? root.activeBg : (isSelected ? root.hoverBg : (pMouse.containsMouse ? root.faint : "transparent"))
                    border.color: isToday ? root.accent : (isSelected ? root.cardBorder : "transparent")
                    border.width: (isToday || isSelected) ? 1 : 0
                    Text {
                      anchors.centerIn: parent
                      text: root.formatNum(modelData)
                      font.pixelSize: root.useGeezNumerals ? 9 : 10
                      font.bold: isToday || isHoliday || isSelected
                      color: isToday ? root.accent : (isHoliday ? root.urgent : root.foreground)
                      textFormat: Text.PlainText
                    }
                    MouseArea {
                      id: pMouse
                      anchors.fill: parent
                      hoverEnabled: true
                      cursorShape: Qt.PointingHandCursor
                      onClicked: {
                        root.selectedMonth = 13
                        root.selectedDay = modelData
                      }
                      onDoubleClicked: {
                        root.selectedMonth = 13
                        root.selectedDay = modelData
                        root.copySelectedDate()
                      }
                    }
                  }
                }
              }

              Item { Layout.fillHeight: true }

              // Pagume Cultural / Leap Year Indicator
              Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.space(24)
                radius: Style.space(3)
                color: root.faint

                RowLayout {
                  anchors.fill: parent
                  anchors.leftMargin: Style.space(6)
                  anchors.rightMargin: Style.space(6)

                  Text {
                    text: (root.viewYear % 4 === 3) ? "✨ ዘመነ ዮሐንስ (Leap · 6 Days)" : "✨ የ13 ወራት ፀጋ (5 Days)"
                    font.pixelSize: Style.font.caption
                    font.bold: true
                    color: root.dim
                    textFormat: Text.PlainText
                    Layout.alignment: Qt.AlignCenter
                  }
                }
              }
            }
          }

          // Row 4 Slots 2-4: Dashboard (Slot 2 = Date & Holiday Details, Slots 3 & 4 = Facts Section)
          Rectangle {
            Layout.columnSpan: 3
            Layout.fillWidth: true
            Layout.preferredHeight: Style.space(126)
            radius: Style.space(5)
            color: root.cardBg
            border.color: root.cardBorder
            border.width: 1

            RowLayout {
              anchors.fill: parent
              anchors.margins: Style.space(8)
              spacing: Style.space(8)

              // Column 2: Date & Holiday Details (Spacious & Clean)
              ColumnLayout {
                Layout.preferredWidth: Style.space(172)
                Layout.minimumWidth: Style.space(172)
                Layout.maximumWidth: Style.space(172)
                Layout.fillWidth: false
                Layout.fillHeight: true
                spacing: Style.space(4)

                Text {
                  text: "📅 " + Model.amharicMonths[root.selectedMonth - 1] + " " + root.formatNum(root.selectedDay) + (root.useGeezNumerals ? " (" + root.selectedDay + ")" : "")
                  font.pixelSize: Style.font.body
                  font.bold: true
                  color: root.foreground
                  textFormat: Text.PlainText
                  elide: Text.ElideRight
                  Layout.fillWidth: true
                }

                Text {
                  text: root.selectedGregorianDate.toLocaleDateString(Qt.locale("en_US"), "MMMM d, yyyy")
                  font.pixelSize: Style.font.caption
                  color: root.dim
                  textFormat: Text.PlainText
                  elide: Text.ElideRight
                  Layout.fillWidth: true
                }

                Text {
                  visible: root.selectedSaint !== ""
                  text: "⛪ " + root.selectedSaint
                  font.pixelSize: Style.font.caption
                  font.bold: true
                  color: root.accent
                  textFormat: Text.PlainText
                  wrapMode: Text.WordWrap
                  Layout.fillWidth: true
                }

                Text {
                  visible: root.selectedHoliday !== ""
                  text: "🌟 " + root.selectedHoliday
                  font.pixelSize: Style.font.caption
                  font.bold: true
                  color: root.urgent
                  textFormat: Text.PlainText
                  wrapMode: Text.WordWrap
                  Layout.fillWidth: true
                }

                Text {
                  visible: !root.selectedHoliday && !root.selectedSaint
                  text: "መደበኛ ቀን (Regular Day)"
                  font.pixelSize: Style.font.caption
                  color: root.dim
                  textFormat: Text.PlainText
                  Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true }
              }

              // Divider between Column 2 and Column 3 (aligned with the grid above)
              Rectangle {
                Layout.preferredWidth: 1
                Layout.fillHeight: true
                color: root.cardBorder
              }

              // Columns 3 & 4: Facts Section (Takes the exact 2 columns of space)
              ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.space(3)

                // Title bar with Previous/Next icon navigation (Pinned to top)
                RowLayout {
                  Layout.fillWidth: true
                  Layout.preferredHeight: Style.space(22)
                  Layout.alignment: Qt.AlignTop
                  spacing: Style.space(4)

                  Text {
                    text: "💡 Did You Know?"
                    font.pixelSize: Style.font.body
                    font.bold: true
                    color: root.foreground
                    textFormat: Text.PlainText
                    Layout.alignment: Qt.AlignVCenter
                  }

                  Item { Layout.fillWidth: true }

                  // Prev / Next Navigation Buttons (<>)
                  RowLayout {
                    spacing: Style.spacing.xs
                    Layout.alignment: Qt.AlignVCenter

                    Button {
                      text: "‹"
                      fontSize: Style.font.heading
                      foreground: root.foreground
                      accent: root.accent
                      Layout.alignment: Qt.AlignVCenter
                      onClicked: root.prevFact()
                    }

                    Text {
                      text: (root.factIndex + 1) + "/" + Model.ethiopianFacts.length
                      font.pixelSize: Style.font.caption
                      font.bold: true
                      color: root.dim
                      textFormat: Text.PlainText
                      Layout.alignment: Qt.AlignVCenter
                    }

                    Button {
                      text: "›"
                      fontSize: Style.font.heading
                      foreground: root.foreground
                      accent: root.accent
                      Layout.alignment: Qt.AlignVCenter
                      onClicked: root.nextFact()
                    }
                  }
                }

                Text {
                  text: Model.ethiopianFacts[root.factIndex].descEn
                  font.pixelSize: Style.font.caption
                  color: root.foreground
                  textFormat: Text.PlainText
                  wrapMode: Text.WordWrap
                  Layout.fillWidth: true
                }

                Text {
                  text: Model.ethiopianFacts[root.factIndex].descAm
                  font.pixelSize: Style.font.caption
                  color: root.dim
                  textFormat: Text.PlainText
                  wrapMode: Text.WordWrap
                  Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true }
              }
            }
          }
        }
      }

      // =====================================================================
      // TAB 1: CONVERTER VIEW (Clean, Big & Focused Date Calculator)
      // =====================================================================
      ColumnLayout {
        id: converterTab
        visible: root.currentTab === 1
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: Style.space(522)
        implicitHeight: Style.space(522)
        spacing: Style.space(12)

        // 1. Direction Switcher & Today Shortcut
        Item {
          Layout.fillWidth: true
          Layout.preferredHeight: Style.space(34)

          Row {
            anchors.centerIn: parent
            spacing: Style.spacing.xs

            Button {
              text: root.convMode === 0 ? "Gregorian" : "Ethiopian"
              selected: true
              fontSize: Style.font.caption
              foreground: root.foreground
              accent: root.accent
              onClicked: root.toggleConvMode()
            }

            Button {
              text: "⇄"
              fontSize: Style.font.title
              foreground: root.foreground
              accent: root.accent
              onClicked: root.toggleConvMode()
            }

            Button {
              text: root.convMode === 0 ? "Ethiopian" : "Gregorian"
              selected: false
              fontSize: Style.font.caption
              foreground: root.foreground
              accent: root.accent
              onClicked: root.toggleConvMode()
            }
          }

          Button {
            id: todayBtn
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: "ዛሬ (Today)"
            fontSize: Style.font.caption
            foreground: root.foreground
            accent: root.accent
            onClicked: {
              root.refresh()
              root.convGYear = root.currentDate.getFullYear()
              root.convGMonth = root.currentDate.getMonth() + 1
              root.convGDay = root.currentDate.getDate()
              root.convEYear = root.ethDate.year
              root.convEMonth = root.ethDate.month
              root.convEDay = root.ethDate.day
            }
          }
        }

        // 2. Interactive Typable Stepper Input Cards
        RowLayout {
          Layout.fillWidth: true
          Layout.preferredHeight: Style.space(110)
          spacing: Style.space(8)

          // ---- Year Input Card
          Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.cornerRadius
            color: root.cardBg
            border.color: yearInput.activeFocus ? root.accent : root.cardBorder
            border.width: 1

            ColumnLayout {
              anchors.fill: parent
              anchors.margins: Style.space(8)
              spacing: Style.space(2)

              Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.convMode === 0 ? "Gregorian Year (ዓመት)" : "የኢትዮጵያ ዓመት (Year)"
                font.pixelSize: Style.font.caption
                font.bold: true
                color: root.dim
                textFormat: Text.PlainText
              }

              RowLayout {
                Layout.fillWidth: true
                spacing: Style.space(4)

                Button {
                  text: "−"
                  fontSize: Style.font.heading
                  foreground: root.foreground
                  accent: root.accent
                  Layout.alignment: Qt.AlignVCenter
                  onClicked: root.addConvYears(-1)
                }

                TextInput {
                  id: yearInput
                  Layout.fillWidth: true
                  text: String(root.convMode === 0 ? root.convGYear : root.convEYear)
                  font.pixelSize: Style.font.display
                  font.bold: true
                  color: root.foreground
                  horizontalAlignment: TextInput.AlignHCenter
                  verticalAlignment: TextInput.AlignVCenter
                  selectByMouse: true
                  validator: IntValidator { bottom: 1; top: 9999 }
                  onTextEdited: {
                    var val = parseInt(text)
                    if (!isNaN(val) && val > 0 && val < 10000) {
                      if (root.convMode === 0) root.convGYear = val
                      else root.convEYear = val
                    }
                  }
                }

                Button {
                  text: "+"
                  fontSize: Style.font.heading
                  foreground: root.foreground
                  accent: root.accent
                  Layout.alignment: Qt.AlignVCenter
                  onClicked: root.addConvYears(1)
                }
              }

              Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.convMode === 0 ? "እ.ኤ.አ (G.C.)" : (Model.toAmharicNumeral(root.convEYear) + " ዓ.ም")
                font.pixelSize: Style.font.caption
                font.bold: true
                color: root.dim
                textFormat: Text.PlainText
              }
            }
          }

          // ---- Month Input Card
          Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.cornerRadius
            color: root.cardBg
            border.color: monthInput.activeFocus ? root.accent : root.cardBorder
            border.width: 1

            ColumnLayout {
              anchors.fill: parent
              anchors.margins: Style.space(8)
              spacing: Style.space(2)

              Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.convMode === 0 ? "Gregorian Month (ወር)" : "የኢትዮጵያ ወር (Month)"
                font.pixelSize: Style.font.caption
                font.bold: true
                color: root.dim
                textFormat: Text.PlainText
              }

              RowLayout {
                Layout.fillWidth: true
                spacing: Style.space(4)

                Button {
                  text: "‹"
                  fontSize: Style.font.heading
                  foreground: root.foreground
                  accent: root.accent
                  Layout.alignment: Qt.AlignVCenter
                  onClicked: root.addConvMonths(-1)
                }

                TextInput {
                  id: monthInput
                  Layout.fillWidth: true
                  text: String(root.convMode === 0 ? root.convGMonth : root.convEMonth)
                  font.pixelSize: Style.font.display
                  font.bold: true
                  color: root.foreground
                  horizontalAlignment: TextInput.AlignHCenter
                  verticalAlignment: TextInput.AlignVCenter
                  selectByMouse: true
                  validator: IntValidator { bottom: 1; top: root.convMode === 0 ? 12 : 13 }
                  onTextEdited: {
                    var maxM = root.convMode === 0 ? 12 : 13
                    var val = parseInt(text)
                    if (!isNaN(val) && val >= 1 && val <= maxM) {
                      if (root.convMode === 0) root.convGMonth = val
                      else {
                        root.convEMonth = val
                        if (root.convEMonth === 13 && root.convEDay > 6) root.convEDay = 5
                      }
                    }
                  }
                }

                Button {
                  text: "›"
                  fontSize: Style.font.heading
                  foreground: root.foreground
                  accent: root.accent
                  Layout.alignment: Qt.AlignVCenter
                  onClicked: root.addConvMonths(1)
                }
              }

              Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.convMode === 0 ? (Model.gregorianMonths[root.convGMonth - 1] + " (ወር " + root.convGMonth + "/12)") : (Model.amharicMonths[root.convEMonth - 1] + " · " + Model.amharicMonthsEn[root.convEMonth - 1] + " (" + root.convEMonth + "/13)")
                font.pixelSize: Style.font.caption
                font.bold: true
                color: root.dim
                textFormat: Text.PlainText
              }
            }
          }

          // ---- Day Input Card
          Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.cornerRadius
            color: root.cardBg
            border.color: dayInput.activeFocus ? root.accent : root.cardBorder
            border.width: 1

            ColumnLayout {
              anchors.fill: parent
              anchors.margins: Style.space(8)
              spacing: Style.space(2)

              Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.convMode === 0 ? "Gregorian Day (ቀን)" : "የኢትዮጵያ ቀን (Day)"
                font.pixelSize: Style.font.caption
                font.bold: true
                color: root.dim
                textFormat: Text.PlainText
              }

              RowLayout {
                Layout.fillWidth: true
                spacing: Style.space(4)

                Button {
                  text: "−"
                  fontSize: Style.font.heading
                  foreground: root.foreground
                  accent: root.accent
                  Layout.alignment: Qt.AlignVCenter
                  onClicked: root.addConvDays(-1)
                }

                TextInput {
                  id: dayInput
                  Layout.fillWidth: true
                  text: String(root.convMode === 0 ? root.convGDay : root.convEDay)
                  font.pixelSize: Style.font.display
                  font.bold: true
                  color: root.foreground
                  horizontalAlignment: TextInput.AlignHCenter
                  verticalAlignment: TextInput.AlignVCenter
                  selectByMouse: true
                  validator: IntValidator { bottom: 1; top: 31 }
                  onTextEdited: {
                    var val = parseInt(text)
                    if (!isNaN(val) && val >= 1 && val <= 31) {
                      if (root.convMode === 0) root.convGDay = val
                      else {
                        var maxD = (root.convEMonth === 13) ? (root.convEYear % 4 === 3 ? 6 : 5) : 30
                        root.convEDay = val <= maxD ? val : maxD
                      }
                    }
                  }
                }

                Button {
                  text: "+"
                  fontSize: Style.font.heading
                  foreground: root.foreground
                  accent: root.accent
                  Layout.alignment: Qt.AlignVCenter
                  onClicked: root.addConvDays(1)
                }
              }

              Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.convMode === 0 ?
                      (new Date(root.convGYear, root.convGMonth - 1, root.convGDay).toLocaleDateString(Qt.locale("en_US"), "dddd") + " · Day " + root.convGDay) :
                      (Model.amharicDays[root.convGregResult.getDay()] + " · " + root.convEDay + " (" + (root.convEMonth === 13 ? (root.convEYear % 4 === 3 ? "ከ 6" : "ከ 5") : "ከ 30") + " ቀናት)")
                font.pixelSize: Style.font.caption
                font.bold: true
                color: root.dim
                textFormat: Text.PlainText
              }
            }
          }
        }

        // 3. Hero Converted Date Card (Focused Exclusively on the Converted Day)
        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          Layout.preferredHeight: Style.space(350)
          radius: Style.cornerRadius
          color: root.cardBg
          border.color: root.cardBorder
          border.width: 1

          ColumnLayout {
            anchors.centerIn: parent
            width: parent.width - Style.space(48)
            spacing: Style.space(18)

            // Header Tag
            Text {
              text: root.convMode === 0 ? "CONVERTED ETHIOPIAN DATE" : "CONVERTED GREGORIAN DATE"
              font.pixelSize: Style.font.caption
              font.bold: true
              color: root.dim
              textFormat: Text.PlainText
              Layout.alignment: Qt.AlignHCenter
            }

            // Primary Converted Headline
            Text {
              text: root.convMode === 0 ?
                    (Model.amharicDays[root.convEthResult.dayOfWeek] + "፣ " + Model.amharicMonths[root.convEthResult.month - 1] + " " + root.formatNum(root.convEthResult.day) + " ቀን " + root.formatNum(root.convEthResult.year) + " ዓ.ም") :
                    root.convGregResult.toLocaleDateString(Qt.locale("en_US"), "dddd, MMMM d, yyyy")
              font.pixelSize: Style.font.displayLarge
              font.bold: true
              color: root.foreground
              textFormat: Text.PlainText
              horizontalAlignment: Text.AlignHCenter
              wrapMode: Text.WordWrap
              Layout.fillWidth: true
              Layout.alignment: Qt.AlignHCenter
            }

            // Secondary Subtitle
            Text {
              text: root.convMode === 0 ?
                    (root.convGregResult.toLocaleDateString(Qt.locale("en_US"), "dddd, MMMM d, yyyy") + " G.C.") :
                    (Model.amharicDays[root.convGregResult.getDay()] + "፣ " + Model.amharicMonths[root.convEMonth - 1] + " " + root.convEDay + " ቀን " + root.convEYear + " ዓ.ም")
              font.pixelSize: Style.font.body
              font.bold: true
              color: root.dim
              textFormat: Text.PlainText
              horizontalAlignment: Text.AlignHCenter
              Layout.alignment: Qt.AlignHCenter
            }

            // Copy Action Button
            Button {
              text: "ቅዳ (Copy Date)"
              fontSize: Style.font.caption
              foreground: root.foreground
              accent: root.accent
              Layout.alignment: Qt.AlignHCenter
              onClicked: {
                if (root.convMode === 0) root.copyConvertedEth()
                else root.copyConvertedGreg()
              }
            }
          }
        }
      }

      // =====================================================================
      // TAB 2: FIDEL VIEW (Two-Column Amharic Alphabet Chart)
      // =====================================================================
      Rectangle {
        id: fidelTab
        visible: root.currentTab === 2
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: Style.space(522)
        implicitHeight: Style.space(522)
        radius: Style.space(5)
        color: root.cardBg
        border.color: root.cardBorder
        border.width: 1

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: Style.space(12)
          spacing: Style.space(8)

          RowLayout {
            Layout.fillWidth: true
            Text {
              text: "🔤 የአማርኛ ፊደላት (Amharic Fidel Chart — 33 × 7)"
              font.pixelSize: Style.font.body
              font.bold: true
              color: root.foreground
              textFormat: Text.PlainText
            }
            Item { Layout.fillWidth: true }
            Text {
              text: "💡 Click any letter to copy"
              font.pixelSize: Style.font.caption
              color: root.dim
              textFormat: Text.PlainText
            }
          }

          QQC.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            QQC.ScrollBar.vertical.policy: QQC.ScrollBar.AsNeeded
            QQC.ScrollBar.horizontal.policy: QQC.ScrollBar.AlwaysOff

            Flickable {
              contentWidth: fidelTabContent.width
              contentHeight: fidelTabContent.height
              boundsBehavior: Flickable.StopAtBounds

              ColumnLayout {
                id: fidelTabContent
                width: fidelTab.width - Style.space(32)
                spacing: Style.space(8)

                // Two columns of consonant families (17 + 17)
                RowLayout {
                  Layout.fillWidth: true
                  spacing: Style.space(12)

                  // Left Column (families 0–16)
                  ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Style.space(2)
                    Repeater {
                      model: 17
                      delegate: RowLayout {
                        id: leftFamRowTab
                        readonly property var fam: Model.fidelFamilies[index]
                        Layout.fillWidth: true
                        spacing: Style.space(1)
                        Repeater {
                          model: 7
                          delegate: Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.space(26)
                            Rectangle {
                              anchors.fill: parent
                              anchors.margins: 1
                              radius: 3
                              color: lCharMouseTab.containsMouse ? root.activeBg : "transparent"
                            }
                            Column {
                              anchors.centerIn: parent
                              spacing: 0
                              Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: leftFamRowTab.fam.row[index]
                                font.pixelSize: Style.font.subtitle
                                font.bold: true
                                color: root.foreground
                                textFormat: Text.PlainText
                              }
                              Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: leftFamRowTab.fam.sounds[index]
                                font.pixelSize: Style.font.caption
                                color: root.dim
                                textFormat: Text.PlainText
                              }
                            }
                            MouseArea {
                              id: lCharMouseTab
                              anchors.fill: parent
                              hoverEnabled: true
                              cursorShape: Qt.PointingHandCursor
                              onClicked: {
                                Quickshell.clipboardText = leftFamRowTab.fam.row[index]
                                root.notify("ተቀድቷል", leftFamRowTab.fam.row[index] + " (" + leftFamRowTab.fam.sounds[index] + ")")
                              }
                            }
                          }
                        }
                      }
                    }
                  }

                  // Vertical Divider
                  Rectangle {
                    Layout.preferredWidth: 1
                    Layout.fillHeight: true
                    color: root.cardBorder
                  }

                  // Right Column (families 17–33)
                  ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Style.space(2)
                    Repeater {
                      model: 17
                      delegate: RowLayout {
                        id: rightFamRowTab
                        readonly property int famIdx: index + 17
                        readonly property var fam: famIdx < Model.fidelFamilies.length ? Model.fidelFamilies[famIdx] : null
                        visible: fam !== null
                        Layout.fillWidth: true
                        spacing: Style.space(1)
                        Repeater {
                          model: rightFamRowTab.fam ? 7 : 0
                          delegate: Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.space(26)
                            Rectangle {
                              anchors.fill: parent
                              anchors.margins: 1
                              radius: 3
                              color: rCharMouseTab.containsMouse ? root.activeBg : "transparent"
                            }
                            Column {
                              anchors.centerIn: parent
                              spacing: 0
                              Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: rightFamRowTab.fam.row[index]
                                font.pixelSize: Style.font.subtitle
                                font.bold: true
                                color: root.foreground
                                textFormat: Text.PlainText
                              }
                              Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: rightFamRowTab.fam.sounds[index]
                                font.pixelSize: Style.font.caption
                                color: root.dim
                                textFormat: Text.PlainText
                              }
                            }
                            MouseArea {
                              id: rCharMouseTab
                              anchors.fill: parent
                              hoverEnabled: true
                              cursorShape: Qt.PointingHandCursor
                              onClicked: {
                                Quickshell.clipboardText = rightFamRowTab.fam.row[index]
                                root.notify("ተቀድቷል", rightFamRowTab.fam.row[index] + " (" + rightFamRowTab.fam.sounds[index] + ")")
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }

                // Divider
                Rectangle {
                  Layout.fillWidth: true
                  Layout.preferredHeight: 1
                  Layout.topMargin: Style.space(4)
                  color: root.cardBorder
                }

                // Diphthongs
                Text {
                  text: "ዲቃላ ፊደላት (Labialized Diphthongs)"
                  font.pixelSize: Style.font.caption
                  font.bold: true
                  color: root.foreground
                  textFormat: Text.PlainText
                  Layout.topMargin: Style.space(2)
                }
                Flow {
                  Layout.fillWidth: true
                  spacing: Style.space(4)
                  Repeater {
                    model: Model.diphthongs
                    delegate: Rectangle {
                      width: Style.space(48)
                      height: Style.space(28)
                      radius: Style.space(3)
                      color: diphMouse.containsMouse ? root.activeBg : "transparent"
                      Column {
                        anchors.centerIn: parent
                        spacing: 0
                        Text {
                          anchors.horizontalCenter: parent.horizontalCenter
                          text: modelData.char
                          font.pixelSize: Style.font.body
                          font.bold: true
                          color: root.foreground
                          textFormat: Text.PlainText
                        }
                        Text {
                          anchors.horizontalCenter: parent.horizontalCenter
                          text: modelData.sound
                          font.pixelSize: Style.font.caption
                          color: root.dim
                          textFormat: Text.PlainText
                        }
                      }
                      MouseArea {
                        id: diphMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                          Quickshell.clipboardText = modelData.char
                          root.notify("ተቀድቷል", modelData.char + " (" + modelData.sound + ")")
                        }
                      }
                    }
                  }
                }

                // Numerals
                Text {
                  text: "ቁጥሮች (Ge'ez Numerals)"
                  font.pixelSize: Style.font.caption
                  font.bold: true
                  color: root.foreground
                  textFormat: Text.PlainText
                  Layout.topMargin: Style.space(4)
                }
                Flow {
                  Layout.fillWidth: true
                  spacing: Style.space(4)
                  Repeater {
                    model: Model.geezNumeralsList
                    delegate: Rectangle {
                      width: Style.space(48)
                      height: Style.space(28)
                      radius: Style.space(3)
                      color: numGeezMouse.containsMouse ? root.activeBg : "transparent"
                      Column {
                        anchors.centerIn: parent
                        spacing: 0
                        Text {
                          anchors.horizontalCenter: parent.horizontalCenter
                          text: modelData.char
                          font.pixelSize: Style.font.subtitle
                          font.bold: true
                          color: root.foreground
                          textFormat: Text.PlainText
                        }
                        Text {
                          anchors.horizontalCenter: parent.horizontalCenter
                          text: modelData.val
                          font.pixelSize: Style.font.caption
                          font.bold: true
                          color: root.dim
                          textFormat: Text.PlainText
                        }
                      }
                      MouseArea {
                        id: numGeezMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                          Quickshell.clipboardText = modelData.char
                          root.notify("ተቀድቷል", modelData.char + " (" + modelData.val + ")")
                        }
                      }
                    }
                  }
                }

                Item { Layout.preferredHeight: Style.space(8) }
              }
            }
          }
        }
      }
    }
  }
}
