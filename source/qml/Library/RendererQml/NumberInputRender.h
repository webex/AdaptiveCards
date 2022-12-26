#pragma once

#include "AdaptiveCardQmlRenderer.h"
#include "QmlTag.h"
#include <memory>

class NumberInputElement
{
public:
    NumberInputElement(std::shared_ptr<AdaptiveCards::NumberInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context);
    NumberInputElement() = delete;
    NumberInputElement(const NumberInputElement&) = delete;
    NumberInputElement& operator= (const NumberInputElement&) = delete;
    std::shared_ptr<RendererQml::QmlTag> getQmlTag();

private:
    std::shared_ptr<RendererQml::QmlTag> mNumberInputQmlElement;
    const std::shared_ptr<AdaptiveCards::NumberInput>& mInput;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;
    RendererQml::InputNumberConfig numberConfig;
    std::string mOrigionalElementId{ "" };

private: 
    void initialize();
    void createInputLabel();
    void createErrorMessage();
};

