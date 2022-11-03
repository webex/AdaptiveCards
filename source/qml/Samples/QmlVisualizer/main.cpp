#include "stdafx.h"
#include "samplecardmodel.h"
#include "samplecardlist.h"
#include "SampleCardJson.h"

#include <QApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQmlContext>

int main(int argc, char* argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<SampleCardModel>("SampleCard", 1, 0, "SampleCardModel");
    qmlRegisterUncreatableType<SampleCardList>("SampleCard", 1, 0, "SampleCardList",
        QStringLiteral("SampleCardList should not be created in QML"));
    qmlRegisterType(QUrl("qrc:/TextBlockRender.qml"), "AdaptiveCards", 1, 0, "TextBlockRender");
    qmlRegisterType(QUrl("qrc:/RichBlockRender.qml"), "AdaptiveCards", 1, 0, "RichBlockRender");
    qmlRegisterType(QUrl("qrc:/ImageRender.qml"), "AdaptiveCards", 1, 0, "ImageRender");
    qmlRegisterType(QUrl("qrc:/SeparatorRender.qml"), "AdaptiveCards", 1, 0, "SeparatorRender");
    qmlRegisterSingletonType(QUrl("qrc:/CardConstants.qml"), "AdaptiveCards", 1, 0, "CardConstants");

    QQuickView view;
    QQmlContext* context = view.engine()->rootContext();

    SampleCardList cardList;
    SampleCardModel model;
    model.setList(&cardList);

    const QString qmlString = model.generateQml(QString::fromStdString(Samples::card_Empty));

	context->setContextProperty("_aQmlCard", qmlString);
    context->setContextProperty("_aModel", &model);

    view.setSource(QUrl("qrc:main.qml"));
	view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();

    return app.exec();
}
