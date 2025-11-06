#ifndef APPCONTROLLER_H
#define APPCONTROLLER_H

#include <QObject>
#include <QString>

class AppController : public QObject
{
    Q_OBJECT

    // Properties
    Q_PROPERTY(QString currentWorkspace READ currentWorkspace WRITE setCurrentWorkspace NOTIFY currentWorkspaceChanged)
    Q_PROPERTY(QString currentProjectName READ currentProjectName NOTIFY currentProjectNameChanged)
    Q_PROPERTY(bool hasUnsavedChanges READ hasUnsavedChanges NOTIFY hasUnsavedChangesChanged)
    Q_PROPERTY(bool showSplash READ showSplash WRITE setShowSplash NOTIFY showSplashChanged)

public:
    explicit AppController(QObject *parent = nullptr);

    // Property getters
    QString currentWorkspace() const;
    QString currentProjectName() const;
    bool hasUnsavedChanges() const;
    bool showSplash() const;

public slots:
    // Initialization
    void initialize();
    void hideSplash();

    // Workspace Management
    void setCurrentWorkspace(const QString& workspace);
    void openHome();
    void openDashboard();
    void openNodeEditor();
    void openBCIParadigms();
    void openSignalProcessing();
    void openModelTraining();
    void openDataAnalysis();
    void createNewParadigm();

    // Project Management
    void showAllProjects();
    void openProject(const QString& path);
    void createNewProject(const QString& name, const QString& path, const QString& type, const QVariantMap& settings);
    void saveProject();
    void closeProject();

    // Utility
    void showInFileExplorer(const QString& path);
    void removeFromRecent(const QString& path);
    void showSettings();
    void showHelp();
    void quitApplication();

signals:
    // Property signals
    void currentWorkspaceChanged();
    void currentProjectNameChanged();
    void hasUnsavedChangesChanged();
    void showSplashChanged();

    // Action signals
    void projectLoaded(const QString& path);
    void projectCreated(const QString& path);
    void projectSaved(const QString& projectName);
    void projectClosed();
    void recentProjectRemoved(const QString& path);
    void settingsDialogRequested();
    void applicationQuitRequested();

private:
    void loadSettings();
    void setShowSplash(bool show);

private:
    QString m_currentWorkspace;
    QString m_currentProjectName;
    bool m_hasUnsavedChanges;
    bool m_showSplash;
};

#endif // APPCONTROLLER_H
