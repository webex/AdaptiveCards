#include "AdaptiveCardQmlRenderer.h"
#include "CheckBoxRender.h"
#include "ImageDataURI.h"

CheckBoxElement::CheckBoxElement(RendererQml::Checkbox checkBox, const std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
    :mCheckBox(checkBox),
    mContext(context),
    mCheckBoxConfig(context->GetRenderConfig()->getToggleButtonConfig())
{
    initialize();
}

std::shared_ptr<RendererQml::QmlTag> CheckBoxElement::getQmlTag()
{
    return mCheckBoxElement;
}

void CheckBoxElement::initialize()
{
    mEscapedValueOn = RendererQml::Utils::getBackQuoteEscapedString(mCheckBox.valueOn);
    mEscapedValueOff = RendererQml::Utils::getBackQuoteEscapedString(mCheckBox.valueOff);
    if (mCheckBox.type == RendererQml::CheckBoxType::RadioButton)
    {
        mCheckBoxElement = std::make_shared<RendererQml::QmlTag>("RadioButton");
    }
    else
    {
        mCheckBoxElement = std::make_shared<RendererQml::QmlTag>("CheckBox");
    }

    mCheckBoxElement->Property("id", mCheckBox.id);

    if (mCheckBox.type == RendererQml::CheckBoxType::Toggle)
    {
        mCheckBoxElement->Property("readonly property string valueOn", RendererQml::Formatter() << "String.raw`" << mEscapedValueOn << "`");
        mCheckBoxElement->Property("readonly property string valueOff", RendererQml::Formatter() << "String.raw`" << mEscapedValueOff << "`");
        mCheckBoxElement->Property("property string value", "checked ? valueOn : valueOff");
        mCheckBoxElement->Property("width", "parent.width");
    }
    else
    {
        mCheckBoxElement->Property("property string value", RendererQml::Formatter() << "checked ? String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(mCheckBox.value) << "` : \"\"");
        mCheckBoxElement->Property("Layout.maximumWidth", "parent.parent.parent.width");
    }

    mCheckBoxElement->Property("text", RendererQml::Formatter() << "String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(mCheckBox.text) << "`");
    mCheckBoxElement->Property("font.pixelSize", RendererQml::Formatter() << mCheckBoxConfig.pixelSize);

    if (!mCheckBox.isVisible)
    {
        mCheckBoxElement->Property("visible", "false");
    }

    if (mCheckBox.isChecked)
    {
        mCheckBoxElement->Property("checked", "true");
    }

    mCheckBoxElement->Property("indicator", "Rectangle{}");
    mCheckBoxElement->Property("contentItem", getContentItem()->ToString());
    mCheckBoxElement->Property("visible", mCheckBox.isVisible ? "true" : "false");
}

std::shared_ptr<RendererQml::QmlTag> CheckBoxElement::getContentItem()
{
    mContext->addHeightEstimate(mCheckBoxConfig.rowHeight);
    auto contentItem = std::make_shared<RendererQml::QmlTag>("RowLayout");

    contentItem->Property("height", RendererQml::Formatter() << mCheckBoxConfig.rowHeight);
    contentItem->Property("width", RendererQml::Formatter() << mCheckBoxElement->GetId() << ".width");
    contentItem->Property("spacing", RendererQml::Formatter() << mCheckBoxConfig.rowSpacing);

    auto indicator = getIndicator();
    auto textElement = getTextElement();

    mCheckBoxElement->Property("property var indicatorItem", indicator->GetId());
    contentItem->AddChild(indicator);
    contentItem->AddChild(textElement);

    return contentItem;
}

std::shared_ptr<RendererQml::QmlTag> CheckBoxElement::getTextElement()
{
    auto uiTextBlock = std::make_shared<RendererQml::QmlTag>("TextEdit");
    uiTextBlock->Property("clip", "true");
    uiTextBlock->Property("textFormat", "Text.RichText");
    uiTextBlock->Property("horizontalAlignment", "Text.AlignLeft");
    uiTextBlock->Property("verticalAlignment", "Text.AlignVCenter");
    uiTextBlock->Property("font.pixelSize", RendererQml::Formatter() << mCheckBoxConfig.pixelSize);
    uiTextBlock->Property("color", mContext->GetHexColor(mCheckBoxConfig.textColor));
    uiTextBlock->Property("Layout.fillWidth", "true");
    uiTextBlock->Property("id", RendererQml::Formatter() << mCheckBoxElement->GetId() << "_title");

    if (mCheckBox.isWrap)
    {
        uiTextBlock->Property("wrapMode", "Text.Wrap");
    }

    std::string text = RendererQml::TextUtils::ApplyTextFunctions(mCheckBox.text, mContext->GetLang());

    auto markdownParser = std::make_shared<AdaptiveSharedNamespace::MarkDownParser>(text);
    text = markdownParser->TransformToHtml();
    text = RendererQml::Utils::HandleEscapeSequences(text);

    const std::string linkColor = mContext->GetColor(AdaptiveCards::ForegroundColor::Accent, false, false);
    const std::string textDecoration = "none";
    text = RendererQml::Utils::FormatHtmlUrl(text, linkColor, textDecoration);

    uiTextBlock->Property("text", text, true);

    std::string onLinkActivatedFunction = RendererQml::Formatter() << "{"
        << "adaptiveCard.buttonClicked(\"\", \"Action.OpenUrl\", link);"
        << "console.log(link);"
        << "}";
    uiTextBlock->Property("onLinkActivated", onLinkActivatedFunction);
    uiTextBlock->AddFunctions(RendererQml::Formatter() << "function onButtonClicked(){" << mCheckBoxElement->GetId() << ".onButtonClicked()}");

    auto MouseAreaTag = RendererQml::AdaptiveCardQmlRenderer::GetTextBlockMouseArea(uiTextBlock->GetId(), true);
    uiTextBlock->AddChild(MouseAreaTag);

    uiTextBlock = RendererQml::AdaptiveCardQmlRenderer::AddAccessibilityToTextBlock(uiTextBlock, mContext);

    mCheckBoxElement->AddFunctions(RendererQml::Formatter() << "function getContentText(){ return " << uiTextBlock->GetId() << ".getText(0, " << uiTextBlock->GetId() << ".length);}");

    return uiTextBlock;
}

std::shared_ptr<RendererQml::QmlTag> CheckBoxElement::getIndicator()
{
    auto uiOuterRectangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
    uiOuterRectangle->Property("id", RendererQml::Formatter() << mCheckBoxElement->GetId() << "_button");
    uiOuterRectangle->Property("width", RendererQml::Formatter() << mCheckBoxConfig.radioButtonOuterCircleSize);
    uiOuterRectangle->Property("height", RendererQml::Formatter() << mCheckBoxConfig.radioButtonOuterCircleSize);
    uiOuterRectangle->Property("y", RendererQml::Formatter() << mCheckBoxConfig.indicatorTopPadding);
    if (mCheckBox.type == RendererQml::CheckBoxType::RadioButton)
    {
        uiOuterRectangle->Property("radius", "height/2");
    }
    else
    {
        uiOuterRectangle->Property("radius", RendererQml::Formatter() << mCheckBoxConfig.checkBoxBorderRadius);
    }

    std::shared_ptr<RendererQml::QmlTag> uiInnerSegment;

    if (mCheckBox.type == RendererQml::CheckBoxType::RadioButton)
    {
        uiInnerSegment = std::make_shared<RendererQml::QmlTag>("Rectangle");
        uiInnerSegment->Property("width", RendererQml::Formatter() << mCheckBoxConfig.radioButtonInnerCircleSize);
        uiInnerSegment->Property("height", RendererQml::Formatter() << mCheckBoxConfig.radioButtonInnerCircleSize);
        uiInnerSegment->Property("x", "(parent.width - width)/2");
        uiInnerSegment->Property("y", "(parent.height - height)/2");
        uiInnerSegment->Property("radius", "height/2");
        uiInnerSegment->Property("color", RendererQml::Formatter() << mCheckBox.id << ".checked ? " << mContext->GetHexColor(mCheckBoxConfig.radioButtonInnerCircleColorOnChecked) << " : 'transparent'");
        uiInnerSegment->Property("visible", mCheckBox.id + ".checked");
        mCheckBoxElement->Property("Keys.onReturnPressed", "onButtonClicked()");
        mCheckBoxElement->AddFunctions("function onButtonClicked(){if(!checked){checked = !checked;}}");
    }
    else
    {
        uiInnerSegment = std::make_shared<RendererQml::QmlTag>("Button");
        uiInnerSegment->Property("anchors.centerIn", "parent");
        uiInnerSegment->Property("width", "parent.width - 3");
        uiInnerSegment->Property("height", "parent.height - 3");
        uiInnerSegment->Property("verticalPadding", "0");
        uiInnerSegment->Property("horizontalPadding", "0");
        uiInnerSegment->Property("enabled", "false");
        uiInnerSegment->Property("background", "Rectangle{color:'transparent'}");
        uiInnerSegment->Property("icon.width", "width");
        uiInnerSegment->Property("icon.height", "height");
        uiInnerSegment->Property("icon.color", mContext->GetHexColor(mCheckBoxConfig.checkBoxIconColorOnChecked));
        uiInnerSegment->Property("icon.source", RendererQml::check_icon_12, true);
        uiInnerSegment->Property("visible", mCheckBox.id + ".checked");
        mCheckBoxElement->Property("Keys.onReturnPressed", "onButtonClicked()");
        mCheckBoxElement->AddFunctions("function onButtonClicked(){checked = !checked;}");
    }

    uiOuterRectangle->AddChild(uiInnerSegment);
    uiOuterRectangle->Property("border.width", RendererQml::Formatter() << "parent.checked ? 0 : " << mCheckBoxConfig.borderWidth);

    return uiOuterRectangle;
}
