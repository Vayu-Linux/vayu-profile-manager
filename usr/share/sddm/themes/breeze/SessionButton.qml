import QtQuick 2.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami

PlasmaComponents.ToolButton {
    id: root

    property int currentIndex: -1

    // Hardcoded sessions
    ListModel {
        id: sessionModel
        ListElement { name: "Plasma (Wayland)" }
        ListElement { name: "Plasma (X11)" }
    }

    text: i18nd("plasma-desktop-sddm-theme", "Desktop Session: %1", sessionModel.get(currentIndex).name || "")
    visible: sessionModel.count > 1

    Component.onCompleted: {
        currentIndex = 0  // Default to the first session on load
    }
    
    checkable: true
    checked: menu.opened
    onToggled: {
        if (checked) {
            menu.popup(root, 0, 0)
        } else {
            menu.dismiss()
        }
    }

    signal sessionChanged()

    PlasmaComponents.Menu {
        Kirigami.Theme.colorSet: Kirigami.Theme.Window
        Kirigami.Theme.inherit: false

        id: menu
        Instantiator {
            id: instantiator
            model: sessionModel
            onObjectAdded: (index, object) => menu.insertItem(index, object)
            onObjectRemoved: (index, object) => menu.removeItem(object)
            delegate: PlasmaComponents.MenuItem {
                text: model.name
                onTriggered: {
                    root.currentIndex = model.index
                    sessionChanged()
                }
            }
        }
    }
}
