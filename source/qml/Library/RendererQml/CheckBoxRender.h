#pragma once

#include <memory>

#include "AdaptiveCardQmlRenderer.h"
#include "QmlTag.h"

class CheckBoxElement
{
public:
    CheckBoxElement(RendererQml::Checkbox checkBox, std::shared_ptr<RendererQml::AdaptiveRenderContext> context);
    CheckBoxElement() = delete;
    CheckBoxElement(const CheckBoxElement&) = delete;
    CheckBoxElement& operator= (const CheckBoxElement&) = delete;
    std::shared_ptr<RendererQml::QmlTag> getQmlTag();
    void initialize();

private:
    std::shared_ptr<RendererQml::QmlTag> mCheckBoxElement;
    const RendererQml::Checkbox mCheckBox;
    const RendererQml::ToggleButtonConfig mCheckBoxConfig;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext> mContext;

private:
    std::shared_ptr<RendererQml::QmlTag> getTextElement();
    std::shared_ptr<RendererQml::QmlTag> getIndicator();
};
