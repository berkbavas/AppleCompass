#include "Oscillator.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "CompassBackend.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    qmlRegisterType<Oscillator>("com.github.berkbavas.oscillator", 1, 0, "Oscillator");
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/Qml/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    CompassBackend *backend = new CompassBackend;
    engine.rootContext()->setContextProperty("backend", backend);
    engine.load(url);

    return app.exec();
}
