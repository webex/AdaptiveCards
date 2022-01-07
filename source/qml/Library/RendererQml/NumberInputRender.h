#pragma once

#include "AdaptiveCardQmlRenderer.h"
#include "QmlTag.h"
#include <memory>

class NumberinputElement
{
public:
    NumberinputElement(std::shared_ptr<AdaptiveCards::NumberInput> input, std::shared_ptr<RendererQml::AdaptiveRenderContext> context);
    NumberinputElement() = delete;
    NumberinputElement(const NumberinputElement&) = delete;
    NumberinputElement& operator= (const NumberinputElement&) = delete;
    std::shared_ptr<RendererQml::QmlTag> getQmlTag();
    void initialize();

private:
    std::string mOrigionalElementId{ "" };
    std::string mContentTagId{ "" };
    std::string mNumberInputRectId{ "" };

private: 
    static std::shared_ptr<RendererQml::QmlTag> getDummyElementforNumberInput(bool isTop);
    void createInputLabel();
    void createErrorMessage();
    std::shared_ptr<RendererQml::QmlTag> getIconTag(const std::shared_ptr<RendererQml::QmlTag> textBackgroundTag);
    std::shared_ptr<RendererQml::QmlTag> getContentItemTag(const std::shared_ptr<RendererQml::QmlTag> textBackgroundTag);
    std::shared_ptr<RendererQml::QmlTag> numberInputColElement;
    const std::shared_ptr<AdaptiveCards::NumberInput>& mInput;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;
    RendererQml::InputNumberConfig numberConfig;
    const std::string getAccessibleName();
    const std::string getColorFunction();
    std::ostringstream getValidatorFunction();
};

