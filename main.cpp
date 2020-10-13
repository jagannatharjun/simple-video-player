#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "systemlockmanager.h"

int main(int argc, char *argv[])
{
    // on Windows, by default multimedialibrary uses "directshow" plugin
    // which is deprecated and doesn't support several video formats
    // NOTE: "windowsmediafoundation" is only available >= Windows vista
    qputenv("QT_MULTIMEDIA_PREFERRED_PLUGINS", "windowsmediafoundation");

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    SystemLockManager systemLockManager;
    qmlRegisterSingletonInstance("SystemLockManager", 0, 1
                                 , "SystemLockManager", &systemLockManager);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
