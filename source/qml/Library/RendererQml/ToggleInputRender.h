#pragma once

#include <memory>

#include "AdaptiveCardQmlRenderer.h"
#include "QmlTag.h"

class ToggleInputElement
{
public:
    ToggleInputElement(std::shared_ptr<AdaptiveCards::ToggleInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context);
    ToggleInputElement() = delete;
    ToggleInputElement(const ToggleInputElement&) = delete;
    ToggleInputElement& operator= (const ToggleInputElement&) = delete;
    std::shared_ptr<RendererQml::QmlTag> getQmlTag();

private:
    std::shared_ptr<RendererQml::QmlTag> mToggleInputColElement;
    std::shared_ptr<AdaptiveCards::ToggleInput> mToggleInput;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext> mContext;
    std::string mEscapedLabelString{ "" };
    std::string mEscapedErrorString{ "" };

private:
    void initialize();
    void addInputLabel();
    void addCheckBox();
    void addErrorMessage();
    void addValidation();

private:
    const std::string origionalElementId;
};
