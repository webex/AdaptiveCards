#include "ChoiceSetRender.h"
#include "Formatter.h"
#include "Utils.h"

ChoiceSetElement::ChoiceSetElement(std::shared_ptr<AdaptiveCards::ChoiceSetInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
    :mChoiceSetInput(input),
    mContext(context)
{
    initialize();
}

std::shared_ptr<RendererQml::QmlTag> ChoiceSetElement::getQmlTag()
{
    return mChoiceSetColElement;
}

void ChoiceSetElement::initialize()
{
    const std::string choiceSetId = mChoiceSetInput->GetId();
    mChoiceSetInput->SetId(mContext->ConvertToValidId(mChoiceSetInput->GetId()));

    const bool isWrap = mChoiceSetInput->GetWrap();
    const bool isVisible = mChoiceSetInput->GetIsVisible();
    const std::string id = RendererQml::Formatter() << mChoiceSetInput->GetId() << "_choiceSet";
    bool isChecked;
    int ButtonNumber = 0;

    mEscapedPlaceholderString = RendererQml::Utils::getBackQuoteEscapedString(mChoiceSetInput->GetPlaceholder());
    mEscapedLabelString = RendererQml::Utils::getBackQuoteEscapedString(mChoiceSetInput->GetLabel());
    mEscapedErrorString = RendererQml::Utils::getBackQuoteEscapedString(mChoiceSetInput->GetErrorMessage());

    RendererQml::Checkboxes choices;
    enum RendererQml::CheckBoxType type;

    if(!mChoiceSetInput->GetIsMultiSelect() && mChoiceSetInput->GetChoiceSetStyle() == AdaptiveCards::ChoiceSetStyle::Compact)
    {
        type = RendererQml::ComboBox;
    }
    else if (mChoiceSetInput->GetChoiceSetStyle() == AdaptiveCards::ChoiceSetStyle::Filtered)
    {
        type = RendererQml::Filtered;
    }
    else
    {
        type = mChoiceSetInput->GetIsMultiSelect() ? RendererQml::CheckBox : RendererQml::RadioButton;
    }

    std::shared_ptr<RendererQml::QmlTag> uiChoiceSet;
    const std::vector<std::string> parsedValues = RendererQml::Utils::splitString(mChoiceSetInput->GetValue(), ',');

    for (const auto& choice : mChoiceSetInput->GetChoices())
    {
        isChecked = (std::find(parsedValues.begin(), parsedValues.end(), choice->GetValue()) != parsedValues.end() && (mChoiceSetInput->GetIsMultiSelect() || parsedValues.size() == 1)) ? true : false;
        choices.emplace_back(
            RendererQml::Checkbox(generateChoiceSetButtonId(id, type, ButtonNumber++),
            type,
            choice->GetTitle(),
            choice->GetValue(),
            isWrap,
            isVisible,
            isChecked)
        );
    }

    RendererQml::ChoiceSet choiceSet(
        id,
        mChoiceSetInput->GetIsMultiSelect(),
        mChoiceSetInput->GetChoiceSetStyle(),
        parsedValues,
        choices,
        mChoiceSetInput->GetPlaceholder()
    );

    mChoiceSetColElement = std::make_shared<RendererQml::QmlTag>("ChoiceSetRender");
    mChoiceSetColElement->Property("id", RendererQml::Formatter() << mChoiceSetInput->GetId());
    mChoiceSetColElement->Property("_adaptiveCard", "adaptiveCard");
    mChoiceSetColElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));
    mChoiceSetColElement->Property("width", "parent.width");
    mChoiceSetColElement->Property("visible", mChoiceSetInput->GetIsVisible() ? "true" : "false");

    if (!mEscapedPlaceholderString.empty())
    {
        mChoiceSetColElement->Property("_mEscapedPlaceholderString", RendererQml::Formatter() << "String.raw`" << mEscapedPlaceholderString << "`");
    }

    renderChoiceSet(choiceSet, type, choiceSetId);
}

void ChoiceSetElement::renderChoiceSet(RendererQml::ChoiceSet choiceSet, RendererQml::CheckBoxType checkBoxType, const std::string choiceSetId)
{
    addInputLabel(mChoiceSetInput->GetIsRequired());
    std::ostringstream model;

    if (checkBoxType == RendererQml::CheckBoxType::ComboBox)
    {
        updateContext();
         
        model = populateModel(choiceSet);
        
        mChoiceSetColElement->Property("_elementType", "'Combobox'");
        mChoiceSetColElement->Property("_comboboxCurrentIndex", "-1");

        if (choiceSet.values.size() == 1)
        {
            const std::string target = choiceSet.values[0];
            auto index = std::find_if(
                             choiceSet.choices.begin(),
                             choiceSet.choices.end(),
                             [target](const RendererQml::Checkbox& options) { return options.value == target; }) -
                         choiceSet.choices.begin();

            if (index < (signed int)(choiceSet.choices.size()))
            {
                mChoiceSetColElement->Property("_comboboxCurrentIndex", std::to_string(index));
            }
        }
    }
    else if (checkBoxType == RendererQml::CheckBoxType::Filtered)
    {
        updateContext();
        
        model = populateModel(choiceSet);
        
        mChoiceSetColElement->Property("_elementType", "'Filtered'");
        mChoiceSetColElement->Property("_isMultiselect", mChoiceSetInput->GetIsMultiSelect() ? "true" : "false");
    }
    else
    {
        if (mChoiceSetInput->GetIsVisible())
        {
            mContext->addHeightEstimate(int(choiceSet.choices.size()) * mContext->GetRenderConfig()->getCardConfig().checkBoxRowHeight);
        }
        std::string choice_Text;
        std::string initialValues;

        model << "ListModel{Component.onCompleted : {";
        for (const auto& choice : choiceSet.choices)
        {
            std::string choice_Text = RendererQml::AdaptiveCardQmlRenderer::ParseMarkdownString(choice.text, mContext);

            model << "append({ valueOn: String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(choice.value) << "`,";
            model << "title: \"" << choice_Text << "\",";
            model << "isWrap : " << (choice.isWrap ? "true" : "false") << ", isChecked : " << (choice.isChecked ? "true" : "false") << "}); \n";

            if (choice.isChecked)
            {
                initialValues += (!initialValues.empty() ? "," : "");
                initialValues += choice.value;
            }
        }
        model << "}}";

        if (!initialValues.empty())
        {
            initialValues.insert(0, "String.raw`");
            initialValues += "`";
            mChoiceSetColElement->Property("selectedValues", initialValues);
        }
        mChoiceSetColElement->Property("_elementType", checkBoxType == RendererQml::CheckBoxType::CheckBox ? "'CheckBox'" : "'RadioButton'");
    }

    mChoiceSetColElement->Property("_choiceSetModel", model.str());
    mContext->addToInputElementList(choiceSetId, mChoiceSetColElement->GetId() + ".selectedValues");

    addErrorMessage();
}

void ChoiceSetElement::addInputLabel(bool isRequired)
{
    if (!mChoiceSetInput->GetLabel().empty())
    {
        const auto choiceSetConfig = mContext->GetRenderConfig()->getInputChoiceSetDropDownConfig();
        if (mChoiceSetInput->GetIsVisible())
        {
            mContext->addHeightEstimate(mContext->getEstimatedTextHeight(mChoiceSetInput->GetLabel()));
        }
        mChoiceSetColElement->Property("_mEscapedLabelString", RendererQml::Formatter() << "String.raw`" << mEscapedLabelString << "`");
    }
    else
    {
        if (mChoiceSetInput->GetIsRequired())
        {
            mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
        }
    }
}

void ChoiceSetElement::addErrorMessage()
{
    if (mChoiceSetInput->GetIsRequired())
    {
        mChoiceSetColElement->Property("_isRequired", "true");
        mContext->addToRequiredInputElementsIdList(mChoiceSetColElement->GetId());
    }
    if (!mChoiceSetInput->GetErrorMessage().empty())
    {
        mChoiceSetColElement->Property("_mEscapedErrorString", RendererQml::Formatter() << "String.raw`" << mEscapedErrorString << "`");
    }
}

void ChoiceSetElement::updateContext()
{
    if (mChoiceSetInput->GetIsVisible())
    {
        mContext->addHeightEstimate(mContext->GetRenderConfig()->getCardConfig().inputElementHeight);
    }
}

std::ostringstream ChoiceSetElement::populateModel(const RendererQml::ChoiceSet& choiceSet)
{
    std::ostringstream model;
    
    std::string choice_Text;
    std::string choice_Value;

    model << "[";
    for (const auto& choice : choiceSet.choices)
    {
        choice_Text = choice.text;
        choice_Value = choice.value;
        model << "{ valueOn: String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(choice_Value)
              << "`, text: String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(choice_Text) << "`},\n";
    }
     model << "]";
    return  model;
}

const std::string ChoiceSetElement::generateChoiceSetButtonId(const std::string& parentId, RendererQml::CheckBoxType ButtonType, const int& ButtonNumber)
{
    return parentId + "_" + std::to_string(ButtonType) + "_" + std::to_string(ButtonNumber);
}
