#include "AppController.h"
#include <QDebug>
#include <QVariantMap>
#include <QDesktopServices>
#include <QUrl>
#include<QFileInfo>

AppController::AppController(QObject *parent)
    : QObject(parent)
    , m_currentWorkspace("home")
    , m_showSplash(true)
    , m_hasUnsavedChanges(false)
{
    qDebug() << "AppController created";
}

QString AppController::currentWorkspace() const
{
    return m_currentWorkspace;
}

void AppController::setCurrentWorkspace(const QString& workspace)
{
    if (m_currentWorkspace != workspace) {
        m_currentWorkspace = workspace;
        qDebug() << "Workspace changed to:" << workspace;
        emit currentWorkspaceChanged();

        // لاگ برای دیباگ بیشتر
        qDebug() << "Emitting currentWorkspaceChanged() signal";
    }
}

QString AppController::currentProjectName() const
{
    return m_currentProjectName;
}

bool AppController::hasUnsavedChanges() const
{
    return m_hasUnsavedChanges;
}

bool AppController::showSplash() const
{
    return m_showSplash;
}

void AppController::setShowSplash(bool show)
{
    if (m_showSplash != show) {
        m_showSplash = show;
        emit showSplashChanged();
    }
}

void AppController::initialize()
{
    qDebug() << "NeuroStudio Pro initialized";

    // تنظیم workspace اولیه
    setCurrentWorkspace("home");

    // بارگذاری تنظیمات، آخرین پروژه، etc.
    loadSettings();
}

void AppController::loadSettings()
{
    qDebug() << "Loading application settings...";
    // در آینده از QSettings استفاده خواهد شد
}

void AppController::hideSplash()
{
    setShowSplash(false);
    qDebug() << "Splash screen hidden";
}

// ==================== WORKSPACE MANAGEMENT ====================

void AppController::openHome()
{
    qDebug() << "Opening home workspace";
    setCurrentWorkspace("home");
}

void AppController::openDashboard()
{
    qDebug() << "Opening dashboard workspace";
    setCurrentWorkspace("dashboard");
}

void AppController::openNodeEditor()
{
    qDebug() << "Opening node editor workspace";
    setCurrentWorkspace("nodeeditor");
}

void AppController::openBCIParadigms()
{
    qDebug() << "Opening BCI paradigms workspace";
    setCurrentWorkspace("bci");
}

void AppController::createNewParadigm()
{
    qDebug() << "Creating new BCI paradigm";
    setCurrentWorkspace("bci");
    // می‌توانید دیالوگ ایجاد پارادایم جدید را اینجا باز کنید
}

void AppController::openSignalProcessing()
{
    qDebug() << "Opening signal processing";
    setCurrentWorkspace("nodeeditor"); // یا workspace مخصوص پردازش سیگنال
}

void AppController::openModelTraining()
{
    qDebug() << "Opening model training";
    setCurrentWorkspace("nodeeditor"); // یا workspace مخصوص training
}

void AppController::openDataAnalysis()
{
    qDebug() << "Opening data analysis";
    setCurrentWorkspace("nodeeditor"); // موقتاً از node editor استفاده می‌کنیم
}

// ==================== PROJECT MANAGEMENT ====================

void AppController::showAllProjects()
{
    qDebug() << "Showing all projects";
    setCurrentWorkspace("home");
}

void AppController::openProject(const QString& path)
{
    qDebug() << "Opening project:" << path;

    // شبیه‌سازی بارگذاری پروژه
    m_currentProjectName = QFileInfo(path).baseName(); // فقط نام فایل
    m_hasUnsavedChanges = false;

    emit currentProjectNameChanged();
    emit hasUnsavedChangesChanged();
    emit projectLoaded(path);

    // پس از باز کردن پروژه، به node editor برو
    setCurrentWorkspace("nodeeditor");
}

void AppController::createNewProject(const QString& name, const QString& path, const QString& type, const QVariantMap& settings)
{
    qDebug() << "Creating new project:";
    qDebug() << "  Name:" << name;
    qDebug() << "  Path:" << path;
    qDebug() << "  Type:" << type;
    qDebug() << "  Settings:" << settings;

    m_currentProjectName = name;
    m_hasUnsavedChanges = true;

    emit currentProjectNameChanged();
    emit hasUnsavedChangesChanged();
    emit projectCreated(path);

    // بر اساس نوع پروژه workspace مناسب را انتخاب کن
    if (type == "bci_paradigm" || type == "p300" || type == "ssvep" || type == "motor_imagery") {
        setCurrentWorkspace("bci");
    } else if (type == "signal_analysis") {
        setCurrentWorkspace("nodeeditor");
    } else if (type == "dashboard_monitor") {
        setCurrentWorkspace("dashboard");
    } else {
        setCurrentWorkspace("nodeeditor"); // پیش‌فرض
    }
}

void AppController::saveProject()
{
    if (m_hasUnsavedChanges) {
        m_hasUnsavedChanges = false;
        qDebug() << "Project saved:" << m_currentProjectName;

        emit hasUnsavedChangesChanged();
        emit projectSaved(m_currentProjectName);
    } else {
        qDebug() << "No unsaved changes to save";
    }
}

void AppController::closeProject()
{
    qDebug() << "Closing current project:" << m_currentProjectName;

    if (m_hasUnsavedChanges) {
        // در آینده دیالوگ ذخیره تغییرات نشان داده شود
        qDebug() << "Project has unsaved changes!";
    }

    m_currentProjectName = "";
    m_hasUnsavedChanges = false;

    emit currentProjectNameChanged();
    emit hasUnsavedChangesChanged();
    emit projectClosed();

    setCurrentWorkspace("home");
}

void AppController::showInFileExplorer(const QString& path)
{
    qDebug() << "Showing in file explorer:" << path;

    QFileInfo fileInfo(path);
    if (fileInfo.exists()) {
        QDesktopServices::openUrl(QUrl::fromLocalFile(fileInfo.absolutePath()));
    } else {
        qWarning() << "Path does not exist:" << path;
    }
}

void AppController::removeFromRecent(const QString& path)
{
    qDebug() << "Removing from recent:" << path;
    // حذف از لیست پروژه‌های اخیر
    emit recentProjectRemoved(path);
}

// ==================== APPLICATION ACTIONS ====================

void AppController::showSettings()
{
    qDebug() << "Opening settings dialog";
    // در آینده دیالوگ تنظیمات باز شود
    emit settingsDialogRequested();
}

void AppController::showHelp()
{
    qDebug() << "Opening help";
    QDesktopServices::openUrl(QUrl("https://github.com/your-bci-studio/docs"));
}

void AppController::quitApplication()
{
    qDebug() << "Quitting application";

    if (m_hasUnsavedChanges) {
        // در آینده دیالوگ تأیید بسته شدن
        qDebug() << "There are unsaved changes!";
    }

    emit applicationQuitRequested();
}
