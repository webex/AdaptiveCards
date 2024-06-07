#pragma once

#include <memory>

#include "AdaptiveCardQmlRenderer.h"
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
    std::string mEscapedPlaceholderString{ "" };
    std::string mEscapedLabelString{ "" };
    std::string mEscapedErrorString{ "" };

private:
    void renderChoiceSet(RendererQml::ChoiceSet choiceSet, RendererQml::CheckBoxType checkBoxType, const std::string choiceSetId);

    void initialize();
    void addInputLabel(bool isRequired = false);
    void addErrorMessage();
    void updateContext();
    std::ostringstream populateModel(const RendererQml::ChoiceSet& choiceSet);
    const std::string generateChoiceSetButtonId(const std::string& parentId, RendererQml::CheckBoxType ButtonType, const int& ButtonNumber);
};

