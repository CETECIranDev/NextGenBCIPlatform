#ifndef THEMEMANAGER_H
#define THEMEMANAGER_H

#include <QObject>
#include <QColor>
#include <QFont>

class ThemeManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentTheme READ currentTheme WRITE setCurrentTheme NOTIFY themeChanged)

    // پراپرتی‌های پویا برای رنگ‌ها
    Q_PROPERTY(QColor backgroundDark READ backgroundDark NOTIFY themeChanged)
    Q_PROPERTY(QColor backgroundMedium READ backgroundMedium NOTIFY themeChanged)
    Q_PROPERTY(QColor backgroundLight READ backgroundLight NOTIFY themeChanged)
    Q_PROPERTY(QColor surfaceDark READ surfaceDark NOTIFY themeChanged)
    Q_PROPERTY(QColor surfaceLight READ surfaceLight NOTIFY themeChanged)
    Q_PROPERTY(QColor primary READ primary NOTIFY themeChanged)
    Q_PROPERTY(QColor primaryHover READ primaryHover NOTIFY themeChanged)
    Q_PROPERTY(QColor secondary READ secondary NOTIFY themeChanged)
    Q_PROPERTY(QColor textPrimary READ textPrimary NOTIFY themeChanged)
    Q_PROPERTY(QColor textSecondary READ textSecondary NOTIFY themeChanged)
    Q_PROPERTY(QColor textOnPrimary READ textOnPrimary NOTIFY themeChanged)

    // پراپرتی‌های ثابت برای فونت‌ها و اندازه‌ها
    Q_PROPERTY(QFont fontBase READ fontBase CONSTANT)
    Q_PROPERTY(QFont fontLarge READ fontLarge CONSTANT)
    Q_PROPERTY(int spacingMedium READ spacingMedium CONSTANT)
    // ... بقیه فونت‌ها و اندازه‌ها ...

public:
    explicit ThemeManager(QObject *parent = nullptr);
    static ThemeManager* instance();

    int currentTheme() const;
    void setCurrentTheme(int newTheme);

    // Getters for dynamic properties
    QColor backgroundDark() const;
    QColor backgroundMedium() const;
    QColor backgroundLight() const;
    QColor surfaceDark() const;
    QColor surfaceLight() const;
    QColor primary() const;
    QColor primaryHover() const;
    QColor secondary() const;
    QColor textPrimary() const;
    QColor textSecondary() const;
    QColor textOnPrimary() const;

    // Getters for constant properties
    QFont fontBase() const;
    QFont fontLarge() const;
    int spacingMedium() const;

    Q_INVOKABLE void toggleTheme();

signals:
    void themeChanged();

private:
    int m_currentTheme = 1; // 1 for Dark
};

#endif // THEMEMANAGER_H
