#include "../../ThemeManager.h"
#include <QFontDatabase>

ThemeManager::ThemeManager(QObject *parent) : QObject(parent) {}

ThemeManager* ThemeManager::instance() {
    static ThemeManager instance;
    return &instance;
}

int ThemeManager::currentTheme() const { return m_currentTheme; }
void ThemeManager::setCurrentTheme(int newTheme) {
    if (m_currentTheme == newTheme) return;
    m_currentTheme = newTheme;
    emit themeChanged();
}
void ThemeManager::toggleTheme() { setCurrentTheme(m_currentTheme == 1 ? 0 : 1); }

// --- Dynamic Color Getters ---
QColor ThemeManager::backgroundDark() const { return m_currentTheme == 1 ? QColor("#1E1E1E") : QColor("#F0F0F0"); }
QColor ThemeManager::backgroundMedium() const { return m_currentTheme == 1 ? QColor("#252526") : QColor("#FAFAFA"); }
QColor ThemeManager::backgroundLight() const { return m_currentTheme == 1 ? QColor("#333333") : QColor("#FFFFFF"); }
QColor ThemeManager::surfaceDark() const { return m_currentTheme == 1 ? QColor("#2D2D2D") : QColor("#EAEAEA"); }
QColor ThemeManager::surfaceLight() const { return m_currentTheme == 1 ? QColor("#3C3C3C") : QColor("#FFFFFF"); }
QColor ThemeManager::primary() const { return m_currentTheme == 1 ? QColor("#007ACC") : QColor("#005FB8"); }
QColor ThemeManager::primaryHover() const { return m_currentTheme == 1 ? QColor("#209CFF") : QColor("#007ACC"); }
QColor ThemeManager::secondary() const { return m_currentTheme == 1 ? QColor("#6E6E6E") : QColor("#BDBDBD"); }
QColor ThemeManager::textPrimary() const { return m_currentTheme == 1 ? QColor("#CCCCCC") : QColor("#1E1E1E"); }
QColor ThemeManager::textSecondary() const { return m_currentTheme == 1 ? QColor("#8B8B8B") : QColor("#6E6E6E"); }
QColor ThemeManager::textOnPrimary() const { return QColor("#FFFFFF"); }

// --- Constant Getters ---
QFont ThemeManager::fontBase() const { return QFont("Segoe UI", 11); }
QFont ThemeManager::fontLarge() const { return QFont("Segoe UI", 18, QFont::Bold); }
int ThemeManager::spacingMedium() const { return 8; }
