#include <QApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQmlContext>

#include "SampleCardController.h"

int main(int argc, char* argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    qmlRegisterType(QUrl("qrc:SampleCardListView.qml"), "CardVisualizer", 1, 0, "SampleCardListView");
    qmlRegisterType(QUrl("qrc:CardEditor.qml"), "CardVisualizer", 1, 0, "CardEditor");
    qmlRegisterType(QUrl("qrc:CardViewer.qml"), "CardVisualizer", 1, 0, "CardViewer");

    qmlRegisterType<SampleCardController>("SampleCards", 1, 0, "SampleCardController");

    QQuickView view;
    view.setSource(QUrl("qrc:main.qml"));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();

    return app.exec();
}
