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

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        mEscapedLabelString = RendererQml::Utils::getBackQuoteEscapedString(mChoiceSetInput->GetLabel());
        mEscapedErrorString = RendererQml::Utils::getBackQuoteEscapedString(mChoiceSetInput->GetErrorMessage());
    }

    RendererQml::Checkboxes choices;
    enum RendererQml::CheckBoxType type;

    if(!mChoiceSetInput->GetIsMultiSelect() && mChoiceSetInput->GetChoiceSetStyle() == AdaptiveCards::ChoiceSetStyle::Compact)
    {
        type = RendererQml::ComboBox;
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

    renderChoiceSet(choiceSet, type, choiceSetId);
}

void ChoiceSetElement::renderChoiceSet(RendererQml::ChoiceSet choiceSet, RendererQml::CheckBoxType checkBoxType, const std::string choiceSetId)
{
    std::shared_ptr<RendererQml::QmlTag> uiChoiceSet;

    addInputLabel(mChoiceSetInput->GetIsRequired());

    std::ostringstream model;

    if (checkBoxType == RendererQml::CheckBoxType::ComboBox)
    {
        std::string choice_Text;
        std::string choice_Value;

        model << "[";
        for (const auto& choice : choiceSet.choices)
        {
            choice_Text = choice.text;
            choice_Value = choice.value;
            model << "{ valueOn: String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(choice_Value) << "`, text: String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(choice_Text) << "`},\n";
        }
        model << "]";
        mChoiceSetColElement->Property("_elementType", "'Combobox'");
        mChoiceSetColElement->Property("_comboboxCurrentIndex", RendererQml::Formatter() << (choiceSet.placeholder.empty() ? "0" : "-1"));

        if (choiceSet.values.size() == 1)
        {
            const std::string target = choiceSet.values[0];
            auto index = std::find_if(choiceSet.choices.begin(), choiceSet.choices.end(), [target](const RendererQml::Checkbox& options) {
                return options.value == target;
                }) - choiceSet.choices.begin();

                if (index < (signed int)(choiceSet.choices.size()))
                {
                    mChoiceSetColElement->Property("_comboboxCurrentIndex", std::to_string(index));
                }
        }

        //uiChoiceSet->Property("onCurrentValueChanged", "{Accessible.name = displayText}");
        //mChoiceSetColElement->AddChild(uiChoiceSet);
    }
    else
    {
        std::string choice_Text;
        std::string initialValues;

        model << "ListModel{Component.onCompleted : {";
        //uiChoiceSet = getButtonGroup(choiceSet, checkBoxType);
        for (const auto& choice : choiceSet.choices)
        {
            std::string choice_Text = RendererQml::TextUtils::ApplyTextFunctions(choice.text, mContext->GetLang());

            auto markdownParser = std::make_shared<AdaptiveSharedNamespace::MarkDownParser>(choice_Text);
            choice_Text = markdownParser->TransformToHtml();
            choice_Text = RendererQml::Utils::HandleEscapeSequences(choice_Text);

            const std::string linkColor = mContext->GetColor(AdaptiveCards::ForegroundColor::Accent, false, false);
            const std::string textDecoration = "none";
            choice_Text = RendererQml::Utils::FormatHtmlUrl(choice_Text, linkColor, textDecoration);

            model << "append({ valueOn: String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(choice.value) << "`,";
            model << "title: '" << choice_Text << "',";
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
        //addColorFunction();
    }

    mChoiceSetColElement->Property("_choiceSetModel", model.str());
    mContext->addToInputElementList(choiceSetId, mChoiceSetColElement->GetId() + ".selectedValues");

    addErrorMessage(uiChoiceSet, checkBoxType);
    //uiChoiceSet->AddFunctions(getAccessibleName(uiChoiceSet, checkBoxType));
}

void ChoiceSetElement::addInputLabel(bool isRequired)
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mChoiceSetInput->GetLabel().empty())
        {
            const auto choiceSetConfig = mContext->GetRenderConfig()->getInputChoiceSetDropDownConfig();
            mContext->addHeightEstimate(mContext->getEstimatedTextHeight(mChoiceSetInput->GetLabel()));
            mChoiceSetColElement->Property("_mEscapedLabelString", mEscapedLabelString);
        }
        else
        {
            if (mChoiceSetInput->GetIsRequired())
            {
                mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
            }
        }
    }
}

void ChoiceSetElement::addErrorMessage(const std::shared_ptr<RendererQml::QmlTag> uiChoiceSet, RendererQml::CheckBoxType checkBoxType)
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() && mChoiceSetInput->GetIsRequired())
    {
        //addValidation(uiChoiceSet, checkBoxType);
        mContext->addToRequiredInputElementsIdList(uiChoiceSet->GetId());
        if (!mChoiceSetInput->GetErrorMessage().empty())
        {
            mChoiceSetColElement->Property("_mEscapedErrorString", mEscapedErrorString);
        }
    }
}

std::shared_ptr<RendererQml::QmlTag> ChoiceSetElement::getButtonGroup(RendererQml::ChoiceSet choiceset, RendererQml::CheckBoxType checkBoxType)
{
    auto uiButtonGroup = std::make_shared<RendererQml::QmlTag>("ButtonGroup");
    uiButtonGroup->Property("id", choiceset.id + "_btngrp");
    uiButtonGroup->Property("property bool isButtonGroup", "true");
    uiButtonGroup->Property("property bool visible", RendererQml::Formatter() << mChoiceSetColElement->GetId() << ".visible");
    uiButtonGroup->AddFunctions(RendererQml::Formatter() << "function focusFirstButton(){" << choiceset.choices[0].id << ".forceActiveFocus();}");

    if (choiceset.isMultiSelect)
    {
        uiButtonGroup->Property("buttons", choiceset.id + "_checkbox.children");
        uiButtonGroup->Property("exclusive", "false");

        if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() && mChoiceSetInput->GetIsRequired())
        {
            uiButtonGroup->Property("onCheckStateChanged", "validate()");
        }
    }
    else
    {
        uiButtonGroup->Property("buttons", choiceset.id + "_radio.children");

        if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() && mChoiceSetInput->GetIsRequired())
        {
            uiButtonGroup->Property("onCheckedButtonChanged", "validate()");
        }
    }

    mChoiceSetColElement->AddChild(uiButtonGroup);

    auto uiInnerColumn = std::make_shared<RendererQml::QmlTag>("ColumnLayout");

    if (choiceset.isMultiSelect)
    {
        uiInnerColumn->Property("id", choiceset.id + "_checkbox");
    }
    else
    {
        uiInnerColumn->Property("id", choiceset.id + "_radio");
    }

    // render as a series of buttons
    for (const auto& choice : choiceset.choices)
    {
        auto checkBoxElement = std::make_shared<CheckBoxElement>(choice, mContext);
        auto button = checkBoxElement->getQmlTag();

        button->Property("onPressed", RendererQml::Formatter() << mChoiceSetColElement->GetId() << ".colorChange(" << button->GetId() << ", true)");
        button->Property("onReleased", RendererQml::Formatter() << mChoiceSetColElement->GetId() << ".colorChange(" << button->GetId() << ", false)");
        button->Property("onHoveredChanged", RendererQml::Formatter() << mChoiceSetColElement->GetId() << ".colorChange(" << button->GetId() << ", false)");
        button->Property("onCheckedChanged", RendererQml::Formatter() << mChoiceSetColElement->GetId() << ".colorChange(" << button->GetId() << ", false)");
        button->Property("Component.onCompleted", RendererQml::Formatter() << "{\n"
            << mChoiceSetColElement->GetId() << ".colorChange(" << button->GetId() << ", false);}\n"
        );
        button->Property("onActiveFocusChanged", RendererQml::Formatter() << "{" << mChoiceSetColElement->GetId() << ".colorChange(" << button->GetId() << ", false);"
            << "if(activeFocus){Accessible.name = " << uiButtonGroup->GetId() << ".getAccessibleName() + " << button->GetId() << ".getContentText() + ' ';}}"
        );
        uiInnerColumn->AddChild(button);
    }

    addAccessibilityToRadioButton(choiceset, uiInnerColumn, uiButtonGroup);

    mChoiceSetColElement->AddChild(uiInnerColumn);
    uiButtonGroup->AddFunctions(getChoiceSetSelectedValuesFunc(uiButtonGroup, choiceset.isMultiSelect));

    return uiButtonGroup;
}

void ChoiceSetElement::addValidation(std::shared_ptr<RendererQml::QmlTag> uiChoiceSet, RendererQml::CheckBoxType checkBoxType)
{
    uiChoiceSet->Property("property bool showErrorMessage", "false");

    std::ostringstream validator;
    std::string condition;

    if (checkBoxType == RendererQml::CheckBoxType::ComboBox)
    {
        uiChoiceSet->Property("onCurrentValueChanged", "{validate(); Accessible.name = displayText}");
        condition = "var isValid = (currentIndex !== -1);";
    }
    else
    {
        condition = "var isValid = (getSelectedValues() !== '');";
    }

    validator << "function validate(){"
        << condition
        << "if(showErrorMessage){"
        << "if(isValid){"
        << "showErrorMessage = false"
        << "}}"
        << "return !isValid;}";

    uiChoiceSet->AddFunctions(validator.str());
}

void ChoiceSetElement::addColorFunction()
{
    auto toggleButtonConfig = mContext->GetRenderConfig()->getToggleButtonConfig();

    mChoiceSetColElement->AddFunctions(RendererQml::Formatter() << "function colorChange(item,isPressed){\n"
        "if (isPressed) item.indicatorItem.color = item.checked ? " << mContext->GetHexColor(toggleButtonConfig.colorOnCheckedAndPressed) << " : " << mContext->GetHexColor(toggleButtonConfig.colorOnUncheckedAndPressed) << ";\n"
        "else  item.indicatorItem.color = item.hovered ? (item.checked ? " << mContext->GetHexColor(toggleButtonConfig.colorOnCheckedAndHovered) << " : " << mContext->GetHexColor(toggleButtonConfig.colorOnUncheckedAndHovered) << ") : (item.checked ? " << mContext->GetHexColor(toggleButtonConfig.colorOnChecked) << " : " << mContext->GetHexColor(toggleButtonConfig.colorOnUnchecked) << ")\n"
        "if (isPressed) item.indicatorItem.border.color = item.checked ? " << mContext->GetHexColor(toggleButtonConfig.borderColorOnCheckedAndPressed) << " : " << mContext->GetHexColor(toggleButtonConfig.borderColorOnUncheckedAndPressed) << ";\n"
        "else  item.indicatorItem.border.color = item.hovered ? (item.checked ? " << mContext->GetHexColor(toggleButtonConfig.borderColorOnCheckedAndHovered) << " : " << mContext->GetHexColor(toggleButtonConfig.borderColorOnUncheckedAndHovered) << ") : (item.checked ? " << mContext->GetHexColor(toggleButtonConfig.borderColorOnChecked) << " : " << mContext->GetHexColor(toggleButtonConfig.borderColorOnUnchecked) << ")\n"
        "}\n"
    );
}

const std::string ChoiceSetElement::getChoiceSetSelectedValuesFunc(const std::shared_ptr<RendererQml::QmlTag> btnGroup, const bool isMultiselect)
{
    std::ostringstream function;
    function << "function getSelectedValues(isMultiselect){\n";
    function << "var values = \"\";\n";
    if (isMultiselect)
    {
        function << "for (var i = 0; i < " << btnGroup->GetId() << ".buttons.length; ++i) {\n";
        function << "if(i !== 0 && " << btnGroup->GetId() << ".buttons[i].value !== \"\" && values !== \"\"){\n";
        function << "values += \",\";\n";
        function << "}\n";
        function << "values += " << btnGroup->GetId() << ".buttons[i].value;\n";
        function << "}\n";
    }
    else
    {
        function << "for (var i = 0; i < " << btnGroup->GetId() << ".buttons.length; ++i) {\n";
        function << "if(" << btnGroup->GetId() << ".buttons[i].value !== \"\"){\n";
        function << "values += " << btnGroup->GetId() << ".buttons[i].value;\n";
        function << "break;\n";
        function << "}\n}\n";
    }
    function << "return values;\n";
    function << "}\n";
    return function.str();
}

void ChoiceSetElement::addAccessibilityToRadioButton(RendererQml::ChoiceSet choiceset, std::shared_ptr<RendererQml::QmlTag> buttonsParent, std::shared_ptr<RendererQml::QmlTag> buttonGroup)
{
    if (!choiceset.isMultiSelect && buttonsParent->GetChildren().size() > 1)
    {
        mChoiceSetColElement->Property("activeFocusOnTab", "true");
        mChoiceSetColElement->Property("onActiveFocusChanged", RendererQml::Formatter() << "{"
            "if(activeFocus){"
            "if(" << buttonGroup->GetId() << ".checkedButton !== null){"
            << buttonGroup->GetId() << ".checkedButton.forceActiveFocus();}"
            "else{"
            << buttonsParent->GetChildren()[0]->GetId() << ".forceActiveFocus()}}}");

        for (int i = 0; i < buttonsParent->GetChildren().size(); i++)
        {
            std::string upString = "";
            std::string downString = "";
            std::string tabString = RendererQml::Formatter() << "if(event.key == Qt.Key_Tab)\n"
                << "{" << mChoiceSetColElement->GetId() << ".nextItemInFocusChain().forceActiveFocus(); event.accepted = true;}\n";

            auto button = buttonsParent->GetChildren()[i];

            if (i != 0)
            {
                auto prevButtonId = buttonsParent->GetChildren()[i - 1]->GetId();
                upString = RendererQml::Formatter() << "if(event.key == Qt.Key_Up)\n"
                    << "{" << prevButtonId << ".checked = true; " << prevButtonId << ".forceActiveFocus(); event.accepted = true;}\n";
            }

            if (i != buttonsParent->GetChildren().size() - 1)
            {
                auto nextButtonId = buttonsParent->GetChildren()[i + 1]->GetId();
                downString = RendererQml::Formatter() << "if(event.key == Qt.Key_Down)\n"
                    << "{" << nextButtonId << ".checked = true; " << nextButtonId << ".forceActiveFocus(); event.accepted = true;}\n";
            }

            button->Property("Keys.onPressed", RendererQml::Formatter() << "{" << upString << downString << tabString << "}");
            button->Property("activeFocusOnTab", "false");
        }
    }
}

const std::string ChoiceSetElement::generateChoiceSetButtonId(const std::string& parentId, RendererQml::CheckBoxType ButtonType, const int& ButtonNumber)
{
    return parentId + "_" + std::to_string(ButtonType) + "_" + std::to_string(ButtonNumber);
}

std::string ChoiceSetElement::getAccessibleName(std::shared_ptr<RendererQml::QmlTag> uiChoiceSet, RendererQml::CheckBoxType checkBoxType)
{
    std::ostringstream accessibleName;
    std::ostringstream labelString;
    std::ostringstream errorString;
    std::ostringstream placeHolderString;

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mChoiceSetInput->GetLabel().empty())
        {
            labelString << "accessibleName += String.raw`" << mEscapedLabelString << ". `;";
        }

        if (!mChoiceSetInput->GetErrorMessage().empty())
        {
            errorString << "if(" << uiChoiceSet->GetId() << ".showErrorMessage === true){"
                << "accessibleName += String.raw`Error. " << mEscapedErrorString << ". `;}";
        }
    }

    if (checkBoxType == RendererQml::CheckBoxType::ComboBox)
    {
        placeHolderString << "if(" << uiChoiceSet->GetId() << ".currentIndex !== -1){"
            << "accessibleName += (" << uiChoiceSet->GetId() << ".displayText + '. ');"
            << "}else{"
            << "accessibleName += String.raw`" << (mChoiceSetInput->GetPlaceholder().empty() ? "Choice Set" : mEscapedPlaceholderString) << "`;}";
    }

    accessibleName << "function getAccessibleName(){"
        << "let accessibleName = '';" << errorString.str() << labelString.str() << placeHolderString.str() << "return accessibleName;}";

    return accessibleName.str();
}
