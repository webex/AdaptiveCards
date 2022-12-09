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
    qmlRegisterType(QUrl("qrc:/ToggleInputRender.qml"), "AdaptiveCards", 1, 0, "ToggleInputRender");
    qmlRegisterType(QUrl("qrc:/CustomCheckBox.qml"), "AdaptiveCards", 1, 0, "CustomCheckBox");
    qmlRegisterType(QUrl("qrc:/ChoiceSetRender.qml"), "AdaptiveCards", 1, 0, "ChoiceSetRender");
    qmlRegisterType(QUrl("qrc:/ComboboxRender.qml"), "AdaptiveCards", 1, 0, "ComboboxRender");
    qmlRegisterType(QUrl("qrc:/CustomRadioButton.qml"), "AdaptiveCards", 1, 0, "CustomRadioButton");
    qmlRegisterType(QUrl("qrc:/TextElement.qml"), "AdaptiveCards", 1, 0, "TextElement");
    qmlRegisterType(QUrl("qrc:/InputLabel.qml"), "AdaptiveCards", 1, 0, "InputLabel");
    qmlRegisterType(QUrl("qrc:/InputErrorMessage.qml"), "AdaptiveCards", 1, 0, "InputErrorMessage");
    qmlRegisterType(QUrl("qrc:/AdaptiveActionRender.qml"), "AdaptiveCards", 1, 0, "AdaptiveActionRender");

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
