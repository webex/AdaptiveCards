#pragma once

#include <memory>

#include "AdaptiveCardQmlRenderer.h"
#include "QmlTag.h"

class TimeInputElement
{
public:
    TimeInputElement(std::shared_ptr<AdaptiveCards::TimeInput> input, std::shared_ptr<RendererQml::AdaptiveRenderContext> context);
    TimeInputElement() = delete;
    TimeInputElement(const TimeInputElement&) = delete;
    TimeInputElement& operator= (const TimeInputElement&) = delete;

    void initialize();
    std::shared_ptr<RendererQml::QmlTag> getQmlTag();

private:
    std::string origionalElementId{ "" };
    std::string id{ "" };
    std::string timePopupId{ "" };
    std::string timeComboboxId{ "" };
    std::string listViewHoursId{ "" };
    std::string listViewMinId{ "" };
    std::string listViewttId{ "" };

    std::shared_ptr<RendererQml::QmlTag> mTimeInputColElement;
    std::shared_ptr<RendererQml::QmlTag> mTimeInputWrapper;
    std::shared_ptr<RendererQml::QmlTag> mTimeInputComboBox;
    std::shared_ptr<RendererQml::QmlTag> mTimeInputPopup;
    std::shared_ptr<RendererQml::QmlTag> mTimeInputTextField;
    std::shared_ptr<RendererQml::QmlTag> mTimeInputRow;
    std::shared_ptr<RendererQml::QmlTag> mTimeIcon;
    std::shared_ptr<RendererQml::QmlTag> mClearIcon;

    const std::shared_ptr<AdaptiveCards::TimeInput>& mTimeInput;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;
    const RendererQml::InputTimeConfig mTimeInputConfig;
    const bool mIs12hour;

private:
    void renderTimeElement();

    void initTimeInputWrapper();
    void initTimeInputTextField();
    void initTimeInputComboBox();
    void initTimeInputPopup();
    void initTimeInputRow();
    void initTimeIcon();
    void initClearIcon();

    void addInputLabel(bool isRequired = false);
    void addErrorMessage();
    void addValidation();

    const std::string getColorFunction();
    const std::string getAccessibleName();
    std::shared_ptr<RendererQml::QmlTag> getListViewTagforTimeInput(const std::string& parent_id, const std::string& listView_id, std::map<std::string, std::map<std::string, std::string>>& properties, bool isThirdTag, std::shared_ptr<RendererQml::AdaptiveRenderContext> context);
};

