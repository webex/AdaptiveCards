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
    std::shared_ptr<RendererQml::QmlTag> numberInputColElement;
    const std::shared_ptr<AdaptiveCards::NumberInput>& mInput;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;
    RendererQml::InputNumberConfig numberConfig;
    std::string mOrigionalElementId{ "" };
    std::string mContentTagId{ "" };
    std::string mNumberInputRectId{ "" };

private: 
    void initialize();
    void createInputLabel();
    void createErrorMessage();

    static std::shared_ptr<RendererQml::QmlTag> getDummyElementforNumberInput(bool isTop);
    std::shared_ptr<RendererQml::QmlTag> getIconTag(const std::shared_ptr<RendererQml::QmlTag> textBackgroundTag);
    std::shared_ptr<RendererQml::QmlTag> getContentItemTag(const std::shared_ptr<RendererQml::QmlTag> textBackgroundTag);

    const std::string getAccessibleName();
    const std::string getColorFunction();
    std::ostringstream getValidatorFunction();
};

