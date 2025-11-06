#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QFontDatabase>

#include "src/AppController.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // تنظیمات برنامه
    app.setOrganizationName("NeuroTech");
    app.setOrganizationDomain("neurostudio.com");
    app.setApplicationName("NeuroStudio Pro");
    app.setApplicationVersion("1.0.0");

    // ثبت فونت‌ها
    QFontDatabase::addApplicationFont(":/resources/fonts/Roboto-Regular.ttf");
    QFontDatabase::addApplicationFont(":/resources/fonts/Roboto-Bold.ttf");

    // ثبت تایپ‌های C++ برای QML
    qmlRegisterType<AppController>("BCIStudio", 1, 0, "AppController");

    // ایجاد کنترلر اصلی
    AppController appController;

    // ایجاد موتور QML
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appController", &appController);

    // بارگذاری QML اصلی
    const QUrl url(u"qrc:/qml/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
