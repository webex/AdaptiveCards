#include "AdaptiveCardQmlRenderer.h"
#include "ComboBoxRender.h"
#include "ImageDataURI.h"

ComboBoxElement::ComboBoxElement(RendererQml::ChoiceSet choiceSet, const std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
    :mChoiceSet(choiceSet),
    mContext(context),
    mChoiceSetConfig(context->GetRenderConfig()->getInputChoiceSetDropDownConfig())
{
    initialize();
}

std::shared_ptr<RendererQml::QmlTag> ComboBoxElement::getQmlTag()
{
    return mComboBox;
}

void ComboBoxElement::initialize()
{
    mContext->addHeightEstimate(mChoiceSetConfig.height);
    mComboBox = std::make_shared<RendererQml::QmlTag>("ComboBox");
    mEscapedPlaceHolderString = RendererQml::Utils::getBackQuoteEscapedString(mChoiceSet.placeholder);

    mComboBox->Property("id", mChoiceSet.id);
    mComboBox->Property("textRole", "'text'");
    mComboBox->Property("valueRole", "'value'");
    mComboBox->Property("width", "parent.width");
    mComboBox->Property("height", RendererQml::Formatter() << mChoiceSetConfig.height);
    mComboBox->Property("property int choiceWidth", "0");

    mComboBox->Property("model", getModel(mChoiceSet.choices));
    mComboBox->Property("indicator", getArrowIcon()->ToString());
    mComboBox->Property("contentItem", getContentItemText()->ToString());
    mComboBox->Property("delegate", getItemDelegate()->ToString());
    mComboBox->Property("popup", getPopup()->ToString());

    addBackground();
    addColorFunction();
}

std::string ComboBoxElement::getModel(std::vector<RendererQml::Checkbox> Choices)
{
    std::ostringstream model;
    std::string choice_Text;
    std::string choice_Value;

    model << "[";
    for (const auto& choice : Choices)
    {
        choice_Text = choice.text;
        choice_Value = choice.value;
        model << "{ value: String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(choice_Value) << "`, text: String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(choice_Text) << "`},\n";
    }
    model << "]";
    return model.str();
}

std::shared_ptr<RendererQml::QmlTag> ComboBoxElement::getArrowIcon()
{
    const std::string iconId = mChoiceSet.id + "_icon";
    auto iconTag = RendererQml::AdaptiveCardQmlRenderer::GetIconTag(mContext);
    iconTag->RemoveProperty("anchors.margins");
    iconTag->Property("id", iconId);
    iconTag->Property("horizontalPadding", "0");
    iconTag->Property("verticalPadding", "0");
    iconTag->Property("icon.source", RendererQml::Formatter() << mChoiceSet.id << ".popup.visible ? " << "\"" << RendererQml::vector_up << "\"" << ":" << "\"" << RendererQml::vector_down << "\"");
    iconTag->Property("enabled", "false");
    iconTag->Property("width", "35");
    iconTag->Property("horizontalPadding", RendererQml::Formatter() << mChoiceSetConfig.arrowIconHorizontalPadding);
    iconTag->Property("verticalPadding", RendererQml::Formatter() << mChoiceSetConfig.arrowIconVerticalPadding);
    iconTag->Property("icon.color", mContext->GetHexColor(mChoiceSetConfig.arrowIconColor));
    iconTag->Property("icon.height", RendererQml::Formatter() << mChoiceSetConfig.arrowIconHeight);
    iconTag->Property("icon.width", RendererQml::Formatter() << mChoiceSetConfig.arrowIconWidth);

    auto iconBackground = std::make_shared<RendererQml::QmlTag>("Rectangle");
    iconBackground->Property("color", "'transparent'");
    iconBackground->Property("width", "parent.width");
    iconBackground->Property("height", "parent.height");

    iconTag->Property("background", iconBackground->ToString());

    return iconTag;
}

std::shared_ptr<RendererQml::QmlTag> ComboBoxElement::getContentItemText()
{
    auto uiContentItem_Text = std::make_shared<RendererQml::QmlTag>("Text");
    uiContentItem_Text->Property("text", "parent.displayText");
    uiContentItem_Text->Property("font.pixelSize", RendererQml::Formatter() << mChoiceSetConfig.pixelSize);
    uiContentItem_Text->Property("verticalAlignment", "Text.AlignVCenter");
    uiContentItem_Text->Property("padding", RendererQml::Formatter() << mChoiceSetConfig.textHorizontalPadding);
    uiContentItem_Text->Property("leftPadding", RendererQml::Formatter() << mChoiceSetConfig.textHorizontalPadding);
    uiContentItem_Text->Property("elide", "Text.ElideRight");
    uiContentItem_Text->Property("color", mContext->GetHexColor(mChoiceSetConfig.textColor));
    uiContentItem_Text->Property("leftPadding", RendererQml::Formatter() << mChoiceSetConfig.textHorizontalPadding);
    uiContentItem_Text->Property("rightPadding", RendererQml::Formatter() << mChoiceSetConfig.textHorizontalPadding);
    uiContentItem_Text->Property("topPadding", RendererQml::Formatter() << mChoiceSetConfig.textVerticalPadding);
    uiContentItem_Text->Property("bottomPadding", RendererQml::Formatter() << mChoiceSetConfig.textVerticalPadding);

    return uiContentItem_Text;
}

std::shared_ptr<RendererQml::QmlTag> ComboBoxElement::getItemDelegate()
{
    const auto fontFamily = mContext->GetConfig()->GetFontFamily(AdaptiveCards::FontType::Default);

    auto itemDelegateId = mChoiceSet.id + "_itemDelegate";
    auto uiItemDelegate = std::make_shared<RendererQml::QmlTag>("ItemDelegate");
    uiItemDelegate->Property("id", itemDelegateId);
    uiItemDelegate->Property("width", RendererQml::Formatter() << "Math.max(" << mChoiceSet.id << ".choiceWidth, " << mChoiceSet.id << ".width)");
    uiItemDelegate->Property("height", RendererQml::Formatter() << mChoiceSetConfig.dropDownElementHeight);
    uiItemDelegate->Property("verticalPadding", RendererQml::Formatter() << mChoiceSetConfig.dropDownElementVerticalPadding);
    uiItemDelegate->Property("horizontalPadding", RendererQml::Formatter() << mChoiceSetConfig.dropDownElementHorizontalPadding);
    uiItemDelegate->Property("highlighted", "ListView.isCurrentItem");
    uiItemDelegate->Property("Accessible.name", "modelData.text");

    auto backgroundTagDelegate = std::make_shared<RendererQml::QmlTag>("Rectangle");
    backgroundTagDelegate->Property("color", RendererQml::Formatter() << itemDelegateId << ".pressed ? " << mContext->GetHexColor(mChoiceSetConfig.dropDownElementColorPressed) << " : " << itemDelegateId << ".highlighted? " << mContext->GetHexColor(mChoiceSetConfig.dropDownElementColorHovered) << " : " << mContext->GetHexColor(mChoiceSetConfig.dropDownElementColorNormal));
    backgroundTagDelegate->Property("radius", RendererQml::Formatter() << mChoiceSetConfig.dropDownElementRadius);
    uiItemDelegate->Property("background", backgroundTagDelegate->ToString());

    auto uiItemDelegate_Text = std::make_shared<RendererQml::QmlTag>("Text");
    uiItemDelegate_Text->Property("text", "modelData.text");
    uiItemDelegate_Text->Property("font.family", fontFamily, true);
    uiItemDelegate_Text->Property("font.pixelSize", RendererQml::Formatter() << mChoiceSetConfig.pixelSize);
    uiItemDelegate_Text->Property("color", mContext->GetHexColor(mChoiceSetConfig.textColor));
    uiItemDelegate_Text->Property("font.family", fontFamily, true);
    uiItemDelegate_Text->Property("elide", "Text.ElideRight");

    std::ostringstream widthFunc;
    widthFunc << "onImplicitWidthChanged : {";
    widthFunc << "var maxWidth = implicitWidth > 800 ? 800 : implicitWidth;";
    widthFunc << mComboBox->GetId() << ".choiceWidth = Math.max(maxWidth, " << mComboBox->GetId() << ".choiceWidth);}";
    uiItemDelegate_Text->AddFunctions(widthFunc.str());

    uiItemDelegate->Property("contentItem", uiItemDelegate_Text->ToString());

    return uiItemDelegate;
}

std::shared_ptr<RendererQml::QmlTag> ComboBoxElement::getPopup()
{
    auto contentListViewId = mChoiceSet.id + "_listView";
    auto contentListViewTag = std::make_shared<RendererQml::QmlTag>("ListView");
    contentListViewTag->Property("id", contentListViewId);
    contentListViewTag->Property("clip", "true");
    contentListViewTag->Property("model", RendererQml::Formatter() << mChoiceSet.id << ".delegateModel");
    contentListViewTag->Property("currentIndex", RendererQml::Formatter() << mChoiceSet.id << ".highlightedIndex");
    contentListViewTag->Property("onCurrentIndexChanged", RendererQml::Formatter() << "{if(currentIndex !== -1){" << mChoiceSet.id << ".currentIndex = currentIndex}}");
    contentListViewTag->Property("Keys.onReturnPressed", RendererQml::Formatter() << mChoiceSet.id << ".accepted()");

    auto scrollBarTag = std::make_shared<RendererQml::QmlTag>("ScrollBar");
    scrollBarTag->Property("width", "10");
    scrollBarTag->Property("policy", RendererQml::Formatter() << contentListViewId << ".contentHeight > " << mChoiceSetConfig.dropDownHeight << "?" << "ScrollBar.AlwaysOn : ScrollBar.AsNeeded");

    contentListViewTag->Property("ScrollBar.vertical", scrollBarTag->ToString());

    auto popupBackgroundTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    popupBackgroundTag->Property("anchors.fill", "parent");
    popupBackgroundTag->Property("color", mContext->GetHexColor(mChoiceSetConfig.dropDownBackgroundColor));
    popupBackgroundTag->Property("border.color", mContext->GetHexColor(mChoiceSetConfig.dropDownBorderColor));
    popupBackgroundTag->Property("radius", RendererQml::Formatter() << mChoiceSetConfig.dropDownRadius);

    auto popupTag = std::make_shared<RendererQml::QmlTag>("Popup");
    popupTag->Property("y", RendererQml::Formatter() << mChoiceSet.id << ".height + 5");
    popupTag->Property("width", RendererQml::Formatter() << "Math.max(" << mChoiceSet.id << ".choiceWidth, " << mChoiceSet.id << ".width)");
    popupTag->Property("padding", RendererQml::Formatter() << mChoiceSetConfig.dropDownPadding);
    popupTag->Property("height", RendererQml::Formatter() << contentListViewId << ".contentHeight + (2 * " << mChoiceSetConfig.dropDownPadding << ")" << " > " << mChoiceSetConfig.dropDownHeight << " ? " << mChoiceSetConfig.dropDownHeight << " :" << contentListViewId << ".contentHeight + ( 2 * " << mChoiceSetConfig.dropDownPadding << ")");

    popupTag->Property("background", popupBackgroundTag->ToString());
    popupTag->Property("contentItem", contentListViewTag->ToString());

    return popupTag;
}

void ComboBoxElement::addBackground()
{
    auto backgroundTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    backgroundTag->Property("radius", RendererQml::Formatter() << mChoiceSetConfig.borderRadius);
    backgroundTag->Property("color", mContext->GetHexColor(mChoiceSetConfig.backgroundColorNormal));
    backgroundTag->Property("border.color", RendererQml::Formatter() << "(" << mChoiceSet.id << ".activeFocus || " << mChoiceSet.id << ".popup.visible) ? " << mContext->GetHexColor(mChoiceSetConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(mChoiceSetConfig.borderColorNormal));
    backgroundTag->Property("border.width", RendererQml::Formatter() << mChoiceSetConfig.borderWidth);
    mComboBox->Property("background", backgroundTag->ToString());
    mComboBox->Property("currentIndex", RendererQml::Formatter() << (mChoiceSet.placeholder.empty() ? "0" : "-1"));
    mComboBox->Property("displayText", "currentIndex === -1 ? String.raw`" + mEscapedPlaceHolderString + "` : currentText");

    if (mChoiceSet.values.size() == 1)
    {
        const std::string target = mChoiceSet.values[0];
        auto index = std::find_if(mChoiceSet.choices.begin(), mChoiceSet.choices.end(), [target](const RendererQml::Checkbox& options) {
            return options.value == target;
            }) - mChoiceSet.choices.begin();

        if(index < (signed int)(mChoiceSet.choices.size()))
        {
            mComboBox->Property("currentIndex", std::to_string(index));
            mComboBox->Property("displayText", "currentText");
        }
    }
}

void ComboBoxElement::addColorFunction()
{
    mComboBox->AddFunctions(RendererQml::Formatter() << "function colorChange(isPressed){\n"
        "if (isPressed) background.color = " << mContext->GetHexColor(mChoiceSetConfig.backgroundColorOnPressed) << ";\n"
        "else background.color = activeFocus ? " << mContext->GetHexColor(mChoiceSetConfig.backgroundColorOnPressed) << " : hovered ? " << mContext->GetHexColor(mChoiceSetConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(mChoiceSetConfig.backgroundColorNormal) << "}\n"
    );
    mComboBox->Property("onPressedChanged", RendererQml::Formatter() << "{\n"
        "if (pressed) colorChange(true);\n"
        "else colorChange(false);}\n"
    );
    mComboBox->Property("onActiveFocusChanged", "{colorChange(false); if(activeFocus){Accessible.name = getAccessibleName()}}");
    mComboBox->Property("onHoveredChanged", "colorChange(false)");
}
