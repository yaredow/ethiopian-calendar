import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

import "Model.js" as Model

BarWidget {
  id: root
  moduleName: "user.ethiopian-calendar"

  property date displayDate: new Date()
  property int formatIndex: setting("formatIndex", 0)

  function refresh() {
    displayDate = new Date()
    if (panelLoader.item && typeof panelLoader.item.refresh === "function") {
      panelLoader.item.refresh()
    }
  }

  function cycleFormat() {
    var next = (formatIndex + 1) % 4
    formatIndex = next
    var entry = { id: root.moduleName, formatIndex: next }
    root.settings = entry
    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function") {
      root.bar.shell.updateEntryInline(root.moduleName, entry)
    }
  }

  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false

  function open() {
    if (panelLoader.item) panelLoader.item.open()
  }

  function close() {
    if (panelLoader.item) panelLoader.item.close()
  }

  function togglePanel() {
    if (panelLoader.item) panelLoader.item.toggle()
  }

  function injectPanel() {
    var target = panelLoader.item
    if (!target) return
    if ("bar" in target) target.bar = root.bar
    if ("settings" in target) target.settings = root.settings
    if ("anchorItem" in target) target.anchorItem = button
    if ("hostWidget" in target) target.hostWidget = root
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onBarChanged: injectPanel()
  onSettingsChanged: {
    formatIndex = setting("formatIndex", 0)
    injectPanel()
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
    onDateChanged: root.refresh()
  }

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }

  function formatBarLabel(date, mode) {
    var eth = Model.getEthiopianDate(date)
    var dayName = Model.amharicDays[eth.dayOfWeek]
    var monthName = Model.amharicMonths[eth.month - 1]
    
    switch (mode) {
      case 1: // Full with Year: "ቅዳሜ፣ ነሐሴ ፲፮ ፳፻፲፰"
        return "\uf073 " + dayName + "፣ " + monthName + " " + Model.toAmharicNumeral(eth.day) + " " + Model.toAmharicNumeral(eth.year)
      case 2: // With Ethiopian Time: "ነሐሴ ፲፮ · 4:59 ቀን"
        var time = Model.getEthiopianTime(date)
        return "\uf073 " + monthName + " " + Model.toAmharicNumeral(eth.day) + " · " + time.formatted
      case 3: // Arabic Numerals: "ቅዳሜ፣ ነሐሴ 16, 2018"
        return "\uf073 " + dayName + "፣ " + monthName + " " + eth.day + ", " + eth.year
      case 0: // Medium default: "ቅዳሜ፣ ነሐሴ ፲፮"
      default:
        return "\uf073 " + dayName + "፣ " + monthName + " " + Model.toAmharicNumeral(eth.day)
    }
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.formatBarLabel(root.displayDate, root.formatIndex)
    tooltipText: "የኢትዮጵያ ዘመን አቆጣጠር (Right-click to change format)"

    onPressed: function(b) {
      if (b === Qt.RightButton) {
        root.cycleFormat()
      } else if (b === Qt.LeftButton) {
        root.togglePanel()
      }
    }
  }
}
