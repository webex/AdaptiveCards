#include <QApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQmlContext>

#include "SampleCardController.h"
#include "../AdaptiveCardQmlEngine/AdaptiveCardQmlTypes.h"

int main(int argc, char* argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    Q_INIT_RESOURCE(resourceEngine);
    AdaptiveCardQmlEngine::registerAdaptiveCardTypes();

    Q_INIT_RESOURCE(resourceVisualizer);
    qmlRegisterType(QUrl("qrc:qmlFiles/SampleCardListView.qml"), "CardVisualizer", 1, 0, "SampleCardListView");
    qmlRegisterType(QUrl("qrc:qmlFiles/CardEditor.qml"), "CardVisualizer", 1, 0, "CardEditor");
    qmlRegisterType(QUrl("qrc:qmlFiles/CardViewer.qml"), "CardVisualizer", 1, 0, "CardViewer");

    qmlRegisterType<SampleCardController>("SampleCards", 1, 0, "SampleCardController");

    QQuickView view;
    view.setSource(QUrl("qrc:qmlFiles/main.qml"));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.showMaximized();   

    return app.exec();
}
