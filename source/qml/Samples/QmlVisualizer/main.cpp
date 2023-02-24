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
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
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
    qmlRegisterType(QUrl("qrc:/TextInputRender.qml"), "AdaptiveCards", 1, 0, "TextInputRender");
    qmlRegisterType(QUrl("qrc:/CustomCheckBox.qml"), "AdaptiveCards", 1, 0, "CustomCheckBox");
    qmlRegisterType(QUrl("qrc:/ChoiceSetRender.qml"), "AdaptiveCards", 1, 0, "ChoiceSetRender");
    qmlRegisterType(QUrl("qrc:/ComboboxRender.qml"), "AdaptiveCards", 1, 0, "ComboboxRender");
    qmlRegisterType(QUrl("qrc:/CustomRadioButton.qml"), "AdaptiveCards", 1, 0, "CustomRadioButton");
    qmlRegisterType(QUrl("qrc:/TextElement.qml"), "AdaptiveCards", 1, 0, "TextElement");
    qmlRegisterType(QUrl("qrc:/InputLabel.qml"), "AdaptiveCards", 1, 0, "InputLabel");
    qmlRegisterType(QUrl("qrc:/InputErrorMessage.qml"), "AdaptiveCards", 1, 0, "InputErrorMessage");
    qmlRegisterType(QUrl("qrc:/AdaptiveActionRender.qml"), "AdaptiveCards", 1, 0, "AdaptiveActionRender");
    qmlRegisterType(QUrl("qrc:/ActionsContentLayout.qml"), "AdaptiveCards", 1, 0, "ActionsContentLayout");
    qmlRegisterType(QUrl("qrc:/ActionSetHorizontalRender.qml"), "AdaptiveCards", 1, 0, "ActionSetHorizontalRender");
    qmlRegisterType(QUrl("qrc:/ActionSetVerticalRender.qml"), "AdaptiveCards", 1, 0, "ActionSetVerticalRender");
    qmlRegisterType(QUrl("qrc:/ActionSetRepeaterElement.qml"), "AdaptiveCards", 1, 0, "ActionSetRepeaterElement");
    qmlRegisterType(QUrl("qrc:/NumberInputRender.qml"), "AdaptiveCards", 1, 0, "NumberInputRender");
    qmlRegisterType(QUrl("qrc:/SinglelineTextInputRender.qml"), "AdaptiveCards", 1, 0, "SinglelineTextInputRender");
    qmlRegisterType(QUrl("qrc:/MultiLineTextInputRender.qml"), "AdaptiveCards", 1, 0, "MultiLineTextInputRender");
    qmlRegisterType(QUrl("qrc:/DateInputRender.qml"), "AdaptiveCards", 1, 0, "DateInputRender");
    qmlRegisterType(QUrl("qrc:/DateInputTextField.qml"), "AdaptiveCards", 1, 0, "DateInputTextField");
    qmlRegisterType(QUrl("qrc:/DateInputPopout.qml"), "AdaptiveCards", 1, 0, "DateInputPopout");
    qmlRegisterType(QUrl("qrc:/TimeInputRender.qml"), "AdaptiveCards", 1, 0, "TimeInputRender");
    qmlRegisterType(QUrl("qrc:/TimeInputTextField.qml"), "AdaptiveCards", 1, 0, "TimeInputTextField");
    qmlRegisterType(QUrl("qrc:/TimeInputPopout.qml"), "AdaptiveCards", 1, 0, "TimeInputPopout");
    qmlRegisterType(QUrl("qrc:/TimePickerListView.qml"), "AdaptiveCards", 1, 0, "TimePickerListView");
    qmlRegisterType(QUrl("qrc:/WCustomFocusItem.qml"), "AdaptiveCards", 1, 0, "WCustomFocusItem");

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
