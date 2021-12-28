#pragma once

#include <memory>

#include "AdaptiveCardQmlRenderer.h"
#include "QmlTag.h"

class DateInputElement
{
public:
    DateInputElement(std::shared_ptr<AdaptiveCards::DateInput> input, std::shared_ptr<RendererQml::AdaptiveRenderContext> context);
    DateInputElement() = delete;
    DateInputElement(const DateInputElement&) = delete;
    DateInputElement& operator= (const DateInputElement&) = delete;

    void initialize();
    std::shared_ptr<RendererQml::QmlTag> getQmlTag();

private:
    std::string mDateFormat;
    std::string mMinimumDate;
    std::string mMaximumDate;
    std::shared_ptr<RendererQml::QmlTag> mDateInputColElement;
    const std::shared_ptr<AdaptiveCards::DateInput>& mDateInput;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;
    const RendererQml::InputDateConfig mDateConfig;

private:
    void addInputLabel(bool isRequired = false);
    void addErrorMessage();
    void addValidation(std::shared_ptr<RendererQml::QmlTag> uiDateInput, std::shared_ptr<RendererQml::QmlTag> dateInputWrapper);
    std::string getAccessibleName(std::shared_ptr<RendererQml::QmlTag> uiDateInput);

    void renderDateElement();
    std::shared_ptr<RendererQml::QmlTag> getDateInputField();
    std::shared_ptr<RendererQml::QmlTag> getDateInputWrapper();
    std::shared_ptr<RendererQml::QmlTag> getDateInputComboBox(std::shared_ptr<RendererQml::QmlTag> dateInputField, std::shared_ptr<RendererQml::QmlTag> dateInputWrapper, const std::string calendarBoxId);
    std::shared_ptr<RendererQml::QmlTag> getCalendar(const std::string textFieldId, const std::string calendarBoxId);
    std::shared_ptr<RendererQml::QmlTag> getCalendarListView(const std::string dateFieldId);
    std::shared_ptr<RendererQml::QmlTag> getCalendarListViewDelegate(const std::string listViewId, const std::string dateFieldId, const std::string popupId);
    std::shared_ptr<RendererQml::QmlTag> getArrowIconButton(const std::string arrowType, const std::string dateFieldId, const std::string listViewId);
    std::shared_ptr<RendererQml::QmlTag> getDateIconButton(const std::string dateFieldId, const std::string calendarBoxId);
    std::shared_ptr<RendererQml::QmlTag> getClearIconButton(const std::string dateFieldId);
    const std::string getColorFunction(const std::string wrapperId);
};

