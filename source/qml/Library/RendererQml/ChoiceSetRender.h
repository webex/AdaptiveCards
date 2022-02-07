#pragma once

#include <memory>

#include "AdaptiveCardQmlRenderer.h"
#include "ComboBoxRender.h"
#include "CheckBoxRender.h"
#include "QmlTag.h"

class ChoiceSetElement
{
public:
    ChoiceSetElement(std::shared_ptr<AdaptiveCards::ChoiceSetInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context);
    ChoiceSetElement() = delete;
    ChoiceSetElement(const ChoiceSetElement&) = delete;
    ChoiceSetElement& operator= (const ChoiceSetElement&) = delete;

    std::shared_ptr<RendererQml::QmlTag> getQmlTag();

private:
    std::shared_ptr<RendererQml::QmlTag> mChoiceSetColElement;
    const std::shared_ptr<AdaptiveCards::ChoiceSetInput>& mChoiceSetInput;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;

private:
    void renderChoiceSet(RendererQml::ChoiceSet choiceSet, RendererQml::CheckBoxType checkBoxType, const std::string choiceSetId);

    void initialize();
    void addColorFunction();
    void addInputLabel(bool isRequired = false);
    void addErrorMessage(const std::shared_ptr<RendererQml::QmlTag> uiChoiceSet, RendererQml::CheckBoxType checkBoxType);
    void addValidation(std::shared_ptr<RendererQml::QmlTag> uiChoiceSet, RendererQml::CheckBoxType checkBoxType);
    void addAccessibilityToRadioButton(RendererQml::ChoiceSet choiceset, std::shared_ptr<RendererQml::QmlTag> buttonsParent, std::shared_ptr<RendererQml::QmlTag> buttonGroup);
    std::string getAccessibleName(std::shared_ptr<RendererQml::QmlTag> uiChoiceSet, RendererQml::CheckBoxType checkBoxType);

    const std::string generateChoiceSetButtonId(const std::string& parentId, RendererQml::CheckBoxType ButtonType, const int& ButtonNumber);
    const std::string getChoiceSetSelectedValuesFunc(const std::shared_ptr<RendererQml::QmlTag> btnGroup, const bool isMultiselect);
    std::shared_ptr<RendererQml::QmlTag> getButtonGroup(RendererQml::ChoiceSet choiceSet, RendererQml::CheckBoxType checkBoxType);
};

