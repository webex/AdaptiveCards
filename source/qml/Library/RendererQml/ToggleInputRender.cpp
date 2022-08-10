#include "ToggleInputRender.h"
#include "Formatter.h"
#include "Utils.h"

ToggleInputElement::ToggleInputElement(std::shared_ptr<AdaptiveCards::ToggleInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
    :mToggleInput(input),
    mContext(context),
    mToggleInputConfig(context->GetRenderConfig()->getToggleButtonConfig())
{
    initialize();
}

std::shared_ptr<RendererQml::QmlTag> ToggleInputElement::getQmlTag()
{
    return mToggleInputColElement;
}

void ToggleInputElement::initialize()
{
    const std::string origionalElementId = mToggleInput->GetId();
    mToggleInput->SetId(mContext->ConvertToValidId(mToggleInput->GetId()));

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        mEscapedLabelString = RendererQml::Utils::getBackQuoteEscapedString(mToggleInput->GetLabel());
        mEscapedErrorString = RendererQml::Utils::getBackQuoteEscapedString(mToggleInput->GetErrorMessage());
    }

    mToggleInputColElement = std::make_shared<RendererQml::QmlTag>("Column");
    mToggleInputColElement->Property("id", RendererQml::Formatter() << mToggleInput->GetId() << "_column");
    mToggleInputColElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));
    mToggleInputColElement->Property("width", "parent.width");
    mToggleInputColElement->Property("visible", mToggleInput->GetIsVisible() ? "true" : "false");

    addInputLabel();

    auto uiCheckBox = getCheckBox();
    uiCheckBox->AddFunctions(getAccessibleName(uiCheckBox));
    mToggleInputColElement->AddChild(uiCheckBox);

    addErrorMessage(uiCheckBox);
    mContext->addToInputElementList(origionalElementId, (uiCheckBox->GetId() + ".value"));
}

std::shared_ptr<RendererQml::QmlTag> ToggleInputElement::getCheckBox()
{
    const auto valueOn = !mToggleInput->GetValueOn().empty() ? mToggleInput->GetValueOn() : "true";
    const auto valueOff = !mToggleInput->GetValueOff().empty() ? mToggleInput->GetValueOff() : "false";
    const bool isChecked = mToggleInput->GetValue().compare(valueOn) == 0 ? true : false;

    auto checkBoxElement = std::make_shared<CheckBoxElement>(RendererQml::Checkbox(mToggleInput->GetId(),
        RendererQml::CheckBoxType::Toggle,
        mToggleInput->GetTitle(),
        mToggleInput->GetValue(),
        valueOn,
        valueOff,
        mToggleInput->GetWrap(),
        mToggleInput->GetIsVisible(),
        isChecked), mContext);
    auto uiCheckBox = checkBoxElement->getQmlTag();

    addColorFunction(uiCheckBox);

    return uiCheckBox;
}

void ToggleInputElement::addInputLabel()
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mToggleInput->GetLabel().empty())
        {
            const auto choiceSetConfig = mContext->GetRenderConfig()->getInputChoiceSetDropDownConfig();
            auto label = std::make_shared<RendererQml::QmlTag>("Label");
            label->Property("id", RendererQml::Formatter() << mToggleInput->GetId() << "_label");
            label->Property("wrapMode", "Text.Wrap");
            label->Property("width", "parent.width");

            std::string color = mContext->GetColor(AdaptiveCards::ForegroundColor::Default, false, false);
            label->Property("color", color);
            label->Property("font.pixelSize", RendererQml::Formatter() << choiceSetConfig.labelSize);
            label->Property("Accessible.ignored", "true");

            if (mToggleInput->GetIsRequired())
            {
                label->Property("text", RendererQml::Formatter() << "String.raw`" << (mToggleInput->GetLabel().empty() ? "Text" : mEscapedLabelString) << " <font color='" << choiceSetConfig.errorMessageColor << "'>*</font>`");
            }
            else
            {
                label->Property("text", RendererQml::Formatter() << "String.raw`" << (mToggleInput->GetLabel().empty() ? "Text" : mEscapedLabelString) << "`");
            }

            mToggleInputColElement->AddChild(label);
        }
        else
        {
            if (mToggleInput->GetIsRequired())
            {
                mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
            }
        }
    }
}

void ToggleInputElement::addErrorMessage(const std::shared_ptr<RendererQml::QmlTag>& uiCheckBox)
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() && mToggleInput->GetIsRequired())
    {
        uiCheckBox->Property("property bool showErrorMessage", "false");
        addValidation(uiCheckBox);

        if (!mToggleInput->GetErrorMessage().empty())
        {
            const auto choiceSetConfig = mContext->GetRenderConfig()->getInputChoiceSetDropDownConfig();
            auto uiErrorMessage = std::make_shared<RendererQml::QmlTag>("Label");
            uiErrorMessage->Property("id", RendererQml::Formatter() << mToggleInput->GetId() << "_errorMessage");
            uiErrorMessage->Property("wrapMode", "Text.Wrap");
            uiErrorMessage->Property("width", "parent.width");
            uiErrorMessage->Property("font.pixelSize", RendererQml::Formatter() << choiceSetConfig.labelSize);
            uiErrorMessage->Property("Accessible.ignored", "true");

            uiErrorMessage->Property("color", mContext->GetHexColor(choiceSetConfig.errorMessageColor));
            uiErrorMessage->Property("text", RendererQml::Formatter() << "String.raw`" << mEscapedErrorString << "`");
            uiErrorMessage->Property("visible", RendererQml::Formatter() << uiCheckBox->GetId() << ".showErrorMessage");
            mToggleInputColElement->AddChild(uiErrorMessage);
        }
    }
}

void ToggleInputElement::addColorFunction(const std::shared_ptr<RendererQml::QmlTag>& uiCheckBox)
{
    uiCheckBox->AddFunctions(RendererQml::Formatter() << "function colorChange(item,isPressed){\n"
        "if (isPressed) item.indicatorItem.color = item.checked ? " << mContext->GetHexColor(mToggleInputConfig.colorOnCheckedAndPressed) << " : " << mContext->GetHexColor(mToggleInputConfig.colorOnUncheckedAndPressed) << ";\n"
        "else  item.indicatorItem.color = item.hovered ? (item.checked ? " << mContext->GetHexColor(mToggleInputConfig.colorOnCheckedAndHovered) << " : " << mContext->GetHexColor(mToggleInputConfig.colorOnUncheckedAndHovered) << ") : (item.checked ? " << mContext->GetHexColor(mToggleInputConfig.colorOnChecked) << " : " << mContext->GetHexColor(mToggleInputConfig.colorOnUnchecked) << ")\n"
        "if (isPressed) item.indicatorItem.border.color = item.checked ? " << mContext->GetHexColor(mToggleInputConfig.borderColorOnCheckedAndPressed) << " : " << mContext->GetHexColor(mToggleInputConfig.borderColorOnUncheckedAndPressed) << ";\n"
        "else  item.indicatorItem.border.color = item.hovered ? (item.checked ? " << mContext->GetHexColor(mToggleInputConfig.borderColorOnCheckedAndHovered) << " : " << mContext->GetHexColor(mToggleInputConfig.borderColorOnUncheckedAndHovered) << ") : (item.checked ? " << mContext->GetHexColor(mToggleInputConfig.borderColorOnChecked) << " : " << mContext->GetHexColor(mToggleInputConfig.borderColorOnUnchecked) << ")\n"
        "}\n"
    );
    uiCheckBox->Property("onPressed", RendererQml::Formatter() << uiCheckBox->GetId() << ".colorChange(" << uiCheckBox->GetId() << ", true)");
    uiCheckBox->Property("onReleased", RendererQml::Formatter() << uiCheckBox->GetId() << ".colorChange(" << uiCheckBox->GetId() << ", false)");
    uiCheckBox->Property("onHoveredChanged", RendererQml::Formatter() << uiCheckBox->GetId() << ".colorChange(" << uiCheckBox->GetId() << ", false)");
    uiCheckBox->Property("onCheckedChanged", RendererQml::Formatter() << uiCheckBox->GetId() << ".colorChange(" << uiCheckBox->GetId() << ", false)");
    uiCheckBox->Property("onActiveFocusChanged", RendererQml::Formatter() << "{" << uiCheckBox->GetId() << ".colorChange(" << uiCheckBox->GetId() << ", false);"
        << "if(activeFocus){Accessible.name = getAccessibleName() + text}}");

    uiCheckBox->Property("Component.onCompleted", RendererQml::Formatter() << "{\n"
        << uiCheckBox->GetId() << ".colorChange(" << uiCheckBox->GetId() << ", false);}\n"
    );
}

void ToggleInputElement::addValidation(const std::shared_ptr<RendererQml::QmlTag>& uiCheckBox)
{
    if (mToggleInput->GetIsVisible())
    {
        mContext->addToRequiredInputElementsIdList(uiCheckBox->GetId());
    }
    uiCheckBox->Property("property bool showErrorMessage", "false");
    uiCheckBox->Property("onCheckStateChanged", "validate()");

    std::ostringstream validator;

    validator << "function validate(){"
        << "if(showErrorMessage){"
        << "if(checked){"
        << "showErrorMessage = false"
        << "}}"
        << "return !checked;}";

    uiCheckBox->AddFunctions(validator.str());
}

std::string ToggleInputElement::getAccessibleName(std::shared_ptr<RendererQml::QmlTag> uiCheckBox)
{
    std::ostringstream accessibleName;
    std::ostringstream labelString;
    std::ostringstream errorString;

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mToggleInput->GetLabel().empty())
        {
            labelString << "accessibleName += String.raw`" << mEscapedLabelString << ". `;";
        }

        if (!mToggleInput->GetErrorMessage().empty())
        {
            errorString << "if(" << uiCheckBox->GetId() << ".showErrorMessage === true){"
                << "accessibleName += String.raw`Error. " << mEscapedErrorString << ". `;}";
        }
    }

    accessibleName << "function getAccessibleName(){"
        << "let accessibleName = '';" << errorString.str() << labelString.str() << "return accessibleName;}";

    return accessibleName.str();
}
