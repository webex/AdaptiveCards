#pragma once

#include <memory>

#include "AdaptiveCardQmlRenderer.h"
#include "QmlTag.h"

class CheckBoxElement
{
public:
    CheckBoxElement(RendererQml::Checkbox checkBox, const std::shared_ptr<RendererQml::AdaptiveRenderContext>& context);
    CheckBoxElement() = delete;
    CheckBoxElement(const CheckBoxElement&) = delete;
    CheckBoxElement& operator= (const CheckBoxElement&) = delete;
    std::shared_ptr<RendererQml::QmlTag> getQmlTag();

private:
    std::shared_ptr<RendererQml::QmlTag> mCheckBoxElement;
    const RendererQml::Checkbox mCheckBox;
    const RendererQml::ToggleButtonConfig mCheckBoxConfig;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;

private:
    void initialize();

    std::shared_ptr<RendererQml::QmlTag> getTextElement();
    std::shared_ptr<RendererQml::QmlTag> getIndicator();
};
