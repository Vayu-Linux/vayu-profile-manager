import QtQuick 2.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami
import QtQuick.Controls 2.15

PlasmaComponents.ToolButton {
    id: root

    // Set default to the first index (which corresponds to "default" profile)
    property int currentIndex: -1

    // Hardcoded profiles: default, gaming, hacking
    ListModel {
        id: profileModel
        ListElement { name: "Default"}
        ListElement { name: "Gaming" }
        ListElement { name: "Hacking" }
    }

    // Display current profile (default to the profile at currentIndex)
    text: i18nd("plasma-desktop-sddm-theme", "Profile: %1", profileModel.get(currentIndex).name)
    visible: profileModel.count > 1

    Component.onCompleted: {
        currentIndex = 0  // Default to "default" profile on load
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

    signal profileChanged()

    PlasmaComponents.Menu {
        Kirigami.Theme.colorSet: Kirigami.Theme.Window
        Kirigami.Theme.inherit: false

        id: menu
        Instantiator {
            id: instantiator
            model: profileModel
            onObjectAdded: (index, object) => menu.insertItem(index, object)
            onObjectRemoved: (index, object) => menu.removeItem(object)
            delegate: PlasmaComponents.MenuItem {
                text: model.name
                onTriggered: {
                    root.currentIndex = model.index
                    profileChanged()
                }
            }
        }
    }
}
