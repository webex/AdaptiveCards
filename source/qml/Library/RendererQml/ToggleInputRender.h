#pragma once

#include <memory>

#include "AdaptiveCardQmlRenderer.h"
#include "CheckBoxRender.h"
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
    const RendererQml::ToggleButtonConfig mToggleInputConfig;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext> mContext;

private:
    void initialize();
    void addInputLabel();
    void addErrorMessage(const std::shared_ptr<RendererQml::QmlTag>& uiCheckBox);
    void addColorFunction(const std::shared_ptr<RendererQml::QmlTag>& uiCheckBox);
    void addValidation(const std::shared_ptr<RendererQml::QmlTag>& uiCheckBox);
    std::string getAccessibleName(std::shared_ptr<RendererQml::QmlTag> uiCheckBox);
    std::shared_ptr<RendererQml::QmlTag> getCheckBox();
};
