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
        mCheckBoxElement->Property("readonly property string valueOn", mCheckBox.valueOn, true);
        mCheckBoxElement->Property("readonly property string valueOff", mCheckBox.valueOff, true);
        mCheckBoxElement->Property("property string value", "checked ? valueOn : valueOff");
        mCheckBoxElement->Property("width", "parent.width");
    }
    else
    {
        mCheckBoxElement->Property("property string value", RendererQml::Formatter() << "checked ? \"" << mCheckBox.value << "\" : \"\"");
        mCheckBoxElement->Property("Layout.maximumWidth", "parent.parent.parent.width");
    }

    mCheckBoxElement->Property("text", mCheckBox.text, true);
    mCheckBoxElement->Property("font.pixelSize", RendererQml::Formatter() << mCheckBoxConfig.pixelSize);

    if (!mCheckBox.isVisible)
    {
        mCheckBoxElement->Property("visible", "false");
    }

    if (mCheckBox.isChecked)
    {
        mCheckBoxElement->Property("checked", "true");
    }

    mCheckBoxElement->Property("indicator", getIndicator()->ToString());
    mCheckBoxElement->Property("contentItem", getTextElement()->ToString());
    mCheckBoxElement->Property("visible", mCheckBox.isVisible ? "true" : "false");
}

std::shared_ptr<RendererQml::QmlTag> CheckBoxElement::getTextElement()
{
    auto uiText = std::make_shared<RendererQml::QmlTag>("Text");
    uiText->Property("text", "parent.text");
    uiText->Property("font", "parent.font");
    uiText->Property("horizontalAlignment", "Text.AlignLeft");
    uiText->Property("verticalAlignment", "Text.AlignVCenter");
    uiText->Property("leftPadding", "parent.indicator.width + parent.spacing");
    uiText->Property("color", mContext->GetHexColor(mCheckBoxConfig.textColor));

    if (mCheckBox.isWrap)
    {
        uiText->Property("wrapMode", "Text.Wrap");
    }
    else
    {
        uiText->Property("elide", "Text.ElideRight");
    }

    return uiText;
}

std::shared_ptr<RendererQml::QmlTag> CheckBoxElement::getIndicator()
{
    auto uiOuterRectangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
    uiOuterRectangle->Property("width", RendererQml::Formatter() << mCheckBoxConfig.radioButtonOuterCircleSize);
    uiOuterRectangle->Property("height", RendererQml::Formatter() << mCheckBoxConfig.radioButtonOuterCircleSize);
    uiOuterRectangle->Property("y", "parent.topPadding + (parent.availableHeight - height) / 2");
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
        mCheckBoxElement->Property("Keys.onReturnPressed", "{if(!checked){checked = !checked;}}");
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
        mCheckBoxElement->Property("Keys.onReturnPressed", "{checked = !checked;}");
    }

    uiOuterRectangle->AddChild(uiInnerSegment);
    uiOuterRectangle->Property("border.width", RendererQml::Formatter() << "parent.checked ? 0 : " << mCheckBoxConfig.borderWidth);

    return uiOuterRectangle;
}
