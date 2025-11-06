// qml/common/ThemedCard.qml
import QtQuick
import QtQuick.Controls

Card {
    id: themedCard
    
    // رنگ‌های داینامیک بر اساس تم
    backgroundColor: theme.backgroundCard
    borderColor: theme.border
    titleColor: theme.textPrimary
    
    // گرادیان داینامیک
    background: Rectangle {
        gradient: theme.cardGradient
        radius: themedCard.radius
        border.color: themedCard.borderColor
        border.width: themedCard.borderWidth
        
        // سایه داینامیک
        layer.enabled: themedCard.shadowEnabled
        layer.effect: DropShadow {
            color: theme.shadow
            radius: 8
            samples: 16
            verticalOffset: 2
        }
    }
}