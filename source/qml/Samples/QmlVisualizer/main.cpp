#include <QGuiApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQmlContext>

#include "samplecardmodel.h"
#include "samplecardlist.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<SampleCardModel>("SampleCard", 1, 0, "SampleCardModel");
    qmlRegisterUncreatableType<SampleCardList>("SampleCard", 1, 0, "SampleCardList",
        QStringLiteral("SampleCardList should not be created in QML"));

	const std::string card_InputNumber = R"({
  "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
  "type": "AdaptiveCard",
  "version": "1.0",
  "body": [
    {
      "type": "TextBlock",
      "text": "Default text input"
    },
    {
      "type": "Input.Text",
      "id": "defaultInputId",
      "placeholder": "enter comment",
      "maxLength": 500
    },
    {
      "type": "TextBlock",
      "text": "Multiline text input"
    },
    {
      "type": "Input.Text",
      "id": "multilineInputId",
      "placeholder": "enter comment",
      "maxLength": 50,
      "isMultiline": true
    },
    {
      "type": "TextBlock",
      "text": "Input Number"
    },
    {
      "type": "Input.Number",
      "id": "number",
      "placeholder": "Enter a number",
      "min": 1,
      "max": 10,
      "value": 3
    }
  ],
  "actions": [
    {
      "type": "Action.Submit",
      "title": "OK"
    }
  ]
})";

const std::string card_richText = R"({
  "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
  "type": "AdaptiveCard",
  "version": "1.0",
  "body": [
    {
      "type": "RichTextBlock",
      "inlines": [
        "This is the first inline. ",
        {
          "type": "TextRun",
          "text": "We support colors,",
          "color": "good"
        },
        {
          "type": "TextRun",
          "text": " both regular and subtle. ",
          "isSubtle": true
        },
        {
          "type": "TextRun",
          "text": "Text ",
          "size": "small"
        },
        {
          "type": "TextRun",
          "text": "of ",
          "size": "medium"
        },
        {
          "type": "TextRun",
          "text": "all ",
          "size": "large"
        },
        {
          "type": "TextRun",
          "text": "sizes! ",
          "size": "extraLarge"
        },
        {
          "type": "TextRun",
          "text": "Light weight text. ",
          "weight": "lighter"
        },
        {
          "type": "TextRun",
          "text": "Bold weight text. ",
          "weight": "bolder"
        },
        {
          "type": "TextRun",
          "text": "Highlights. ",
          "highlight": true
        },
        {
          "type": "TextRun",
          "text": "Italics. ",
          "italic": true
        },
        {
          "type": "TextRun",
          "text": "Strikethrough. ",
          "strikethrough": true
        },
        {
          "type": "TextRun",
          "text": "Monospace too!",
          "fontType": "monospace"
        }
      ]
    },
    {
      "type": "RichTextBlock",
      "inlines": [
        {
          "type": "TextRun",
          "text": "Date-Time parsing: {{DATE(2017-02-14T06:08:39Z,LONG)}} {{TIME(2017-02-14T06:08:39Z)}}"
        }
      ]
    },
    {
      "type": "RichTextBlock",
      "horizontalAlignment": "center",
      "inlines": [
        {
          "type": "TextRun",
          "text": "Rich text blocks also support center alignment. Lorem ipsum dolor Lorem ipsum dolor Lorem ipsum dolor Lorem ipsum dolor Lorem ipsum dolor "
        }
      ]
    },
    {
      "type": "RichTextBlock",
      "horizontalAlignment": "right",
      "inlines": [
        {
          "type": "TextRun",
          "text": "Rich text blocks also support right alignment. Lorem ipsum dolor Lorem ipsum dolor Lorem ipsum dolor Lorem ipsum dolor Lorem ipsum dolor "
        }
      ]
    }
  ]
})";

const std::string card_CheckboxInput = R"({
  "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
  "type": "AdaptiveCard",
  "version": "1.0",
  "body": [
    {
      "type": "TextBlock",
      "text": "Input Number"
    },
    {
      "type": "Input.Number",
      "id": "number",
      "placeholder": "Enter a number",
      "min": 1,
      "max": 10,
      "value": 3
    },
    {
      "type": "TextBlock",
      "text": "Toggle Input"
    },
    {
      "type": "Input.Toggle",
      "id": "acceptTerms",
      "title": "I accept the terms and agreements",
      "value": "true",
      "valueOn": "true",
      "valueOff": "false"
    },
    {
      "type": "TextBlock",
      "text": "Default text input"
    },
    {
      "type": "Input.Text",
      "id": "defaultInputId",
      "placeholder": "enter comment",
      "maxLength": 500
    }
  ],
  "actions": [
    {
      "type": "Action.Submit",
      "title": "OK"
    }
  ]
})";

  const std::string card_dateInput = R"({
	"$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
	"type": "AdaptiveCard",
	"version": "1.0",
	"body": [
		{
		  "type": "TextBlock",
		  "text": "Date Format: MM/DD/YYYY"
		},
		{
		  "type": "Input.Date",
		  "id": "date",
		  "placeholder": "Enter a date",
		  "value": "2017-10-12",
		  "min":"1900-01-01",
		  "max":"2030-01-01"
		},
	    {
		  "type": "TextBlock",
		  "text": "Date Input Test"
		},
		{
		  "type": "Input.Date",
		  "id": "sample2",
		  "placeholder": "Enter a date",
		  "min":"1900-01-01",
		  "max":"2030-01-01"
		}
	]
})";

static std::shared_ptr<AdaptiveCards::HostConfig> GetHostConfig()
{
    std::shared_ptr<AdaptiveCards::HostConfig> hostConfig = std::make_shared<AdaptiveCards::HostConfig>();

    AdaptiveCards::SpacingConfig spacingConfig = hostConfig->GetSpacing();
    spacingConfig.paddingSpacing = 15;
    hostConfig->SetSpacing(spacingConfig);

    AdaptiveCards::SeparatorConfig separatorConfig = hostConfig->GetSeparator();
    separatorConfig.lineColor = "#FF707070";
    hostConfig->SetSeparator(separatorConfig);

    AdaptiveCards::FontSizesConfig fontSizesConfig = hostConfig->GetFontSizes();
    fontSizesConfig.SetFontSize(AdaptiveCards::TextSize::Small, 12);
    fontSizesConfig.SetFontSize(AdaptiveCards::TextSize::Medium, 17);
    fontSizesConfig.SetFontSize(AdaptiveCards::TextSize::Large, 21);
    fontSizesConfig.SetFontSize(AdaptiveCards::TextSize::ExtraLarge, 26);
    fontSizesConfig.SetFontSize(AdaptiveCards::TextSize::Default, 14);
    hostConfig->SetFontSizes(fontSizesConfig);

    AdaptiveCards::ImageSizesConfig imageSizesConfig = hostConfig->GetImageSizes();
    imageSizesConfig.smallSize = 40;
    imageSizesConfig.mediumSize = 80;
    imageSizesConfig.largeSize = 160;
    hostConfig->SetImageSizes(imageSizesConfig);

    auto containerStyles = hostConfig->GetContainerStyles();
    containerStyles.emphasisPalette.backgroundColor = "#AABBCCDD";
    hostConfig->SetContainerStyles(containerStyles);

    return hostConfig;
}

static std::string GenerateQml(std::string card)
{
    std::shared_ptr<AdaptiveCards::ParseResult> mainCard = AdaptiveCards::AdaptiveCard::DeserializeFromString(card, "2.0");

    std::shared_ptr<AdaptiveCards::HostConfig> hostConfig = GetHostConfig();

    AdaptiveCardQmlRenderer renderer = AdaptiveCardQmlRenderer(hostConfig);
    std::shared_ptr<RenderedQmlAdaptiveCard> result = renderer.RenderCard(mainCard->GetAdaptiveCard(), nullptr);

    const auto generatedQml = result->GetResult();
    return generatedQml->ToString();
}

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView view;
    QQmlContext* context = view.engine()->rootContext();

    const std::string qmlString = "import QtQuick 2.15; import QtQuick.Layouts 1.3; import QtQuick.Controls 2.15; import QtGraphicalEffects 1.15; Rectangle{ id:adaptiveCard; implicitHeight:adaptiveCardLayout.implicitHeight; width:600; ColumnLayout{ id:adaptiveCardLayout; width:parent.width; Rectangle{ id:adaptiveCardRectangle; color:Qt.rgba(255, 255, 255, 1.00); Layout.margins:15; Layout.fillWidth:true; Layout.preferredHeight:bodyLayout.height; Column{ id:bodyLayout; width:parent.width; spacing:8; Text{ width:parent.width; elide:Text.ElideRight; text:\"Default text input\"; horizontalAlignment:Text.AlignLeft; color:Qt.rgba(0, 0, 0, 1.00); lineHeight:1.33; font.pixelSize:14; font.weight:Font.Normal; } TextField{ width:parent.width; maximumLength:500; id:defaultInputId; font.pixelSize:14; background:Rectangle{ radius:5; color:defaultInputId.hovered ? 'lightgray' : 'white'; border.color:defaultInputId.activeFocus? 'black' : 'grey'; border.width:1; layer.enabled:defaultInputId.activeFocus ? true : false; layer.effect:Glow{ samples:25; color:'skyblue'; } } placeholderText:\"enter comment\"; } Text{ width:parent.width; elide:Text.ElideRight; text:\"Multiline text input\"; horizontalAlignment:Text.AlignLeft; color:Qt.rgba(0, 0, 0, 1.00); lineHeight:1.33; font.pixelSize:14; font.weight:Font.Normal; } ScrollView{ width:parent.width; height:50; ScrollBar.vertical.interactive:true; TextArea{ wrapMode:Text.Wrap; onTextChanged:remove(500, length); id:multilineInputId; font.pixelSize:14; background:Rectangle{ radius:5; color:multilineInputId.hovered ? 'lightgray' : 'white'; border.color:multilineInputId.activeFocus? 'black' : 'grey'; border.width:1; layer.enabled:multilineInputId.activeFocus ? true : false; layer.effect:Glow{ samples:25; color:'skyblue'; } } placeholderText:\"enter comment\"; } } Text{ width:parent.width; elide:Text.ElideRight; text:\"Pre-filled value\"; horizontalAlignment:Text.AlignLeft; color:Qt.rgba(0, 0, 0, 1.00); lineHeight:1.33; font.pixelSize:14; font.weight:Font.Normal; } ScrollView{ width:parent.width; height:50; ScrollBar.vertical.interactive:true; TextArea{ wrapMode:Text.Wrap; onTextChanged:remove(50, length); padding: 10; id:prefilledInputId; font.pixelSize:14; background:Rectangle{ radius:5; color:prefilledInputId.hovered ? 'lightgray' : 'white'; border.color:prefilledInputId.activeFocus? 'black' : 'grey'; border.width:1; layer.enabled:prefilledInputId.activeFocus ? true : false; layer.effect:Glow{ samples:25; color:'skyblue'; } } text:\"This value was pre-filled\"; placeholderText:\"enter comment\"; } } } } } }";

    context->setContextProperty("_aQmlCard", QString::fromStdString(qmlString));
    context->setContextProperty("_aModel", &model);

    view.setSource(QUrl("qrc:main.qml"));
    view.show();

    return app.exec();
}
