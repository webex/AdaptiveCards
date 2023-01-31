#pragma once

#include <memory>

#include "AdaptiveCardQmlRenderer.h"
#include "QmlTag.h"

class TimeInputElement
{
public:
    TimeInputElement(std::shared_ptr<AdaptiveCards::TimeInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context);
    TimeInputElement() = delete;
    TimeInputElement(const TimeInputElement&) = delete;
    TimeInputElement& operator= (const TimeInputElement&) = delete;

    std::shared_ptr<RendererQml::QmlTag> getQmlTag();

private:
    std::string mOrigionalElementId{ "" };
    std::string mEscapedPlaceholderString{ "" };
    std::string mEscapedLabelString{ "" };
    std::string mEscapedErrorString{ "" };

    std::shared_ptr<RendererQml::QmlTag> mTimeInputElement;

    const std::shared_ptr<AdaptiveCards::TimeInput>& mTimeInput;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;
    const RendererQml::InputTimeConfig mTimeInputConfig;
    const bool mIs12hour;

private:
    void initialize();
};

