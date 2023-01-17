#pragma once

#include <memory>

#include "AdaptiveCardQmlRenderer.h"
#include "QmlTag.h"

class DateInputElement
{
public:
    DateInputElement(std::shared_ptr<AdaptiveCards::DateInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context);
    DateInputElement() = delete;
    DateInputElement(const DateInputElement&) = delete;
    DateInputElement& operator= (const DateInputElement&) = delete;

    std::shared_ptr<RendererQml::QmlTag> getQmlTag();

private:
    std::string mDateFormat{ "" };
    std::string mOrigionalElementId{ "" };
    std::string mEscapedPlaceHolderString{ "" };
    std::string mEscapedLabelString{ "" };
    std::string mEscapedErrorString{ "" };

    std::shared_ptr<RendererQml::QmlTag> mDateInputElement;

    const std::shared_ptr<AdaptiveCards::DateInput>& mDateInput;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;
    const RendererQml::InputDateConfig mDateConfig;

private:
    void initialize();
    void addDateFormat();
};

