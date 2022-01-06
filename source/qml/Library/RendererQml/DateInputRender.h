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
    std::string mDateFormat{ "" };
    std::string mMinimumDate{ "" };
    std::string mMaximumDate{ "" };
    std::string mDateFieldId{ "" };
    std::string mOrigionalElementId{ "" };
    std::string mCalendarBoxId{ "" };
    std::string mDateInputColElementId{ "" };
    std::string mDateInputWrapperId{ "" };
    std::string mDateInputComboboxId{ "" };
    std::string mDateInputRowId{ "" };
    std::string mDateIconId{ "" };
    std::string mClearIconId{ "" };

    std::shared_ptr<RendererQml::QmlTag> mDateInputColElement;
    std::shared_ptr<RendererQml::QmlTag> mDateInputTextField;
    std::shared_ptr<RendererQml::QmlTag> mDateInputWrapper;
    std::shared_ptr<RendererQml::QmlTag> mDateInputCombobox;
    std::shared_ptr<RendererQml::QmlTag> mDateInputCalendar;
    std::shared_ptr<RendererQml::QmlTag> mDateInputRow;
    std::shared_ptr<RendererQml::QmlTag> mDateIcon;
    std::shared_ptr<RendererQml::QmlTag> mClearIcon;

    const std::shared_ptr<AdaptiveCards::DateInput>& mDateInput;
    const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;
    const RendererQml::InputDateConfig mDateConfig;

private:
    void renderDateElement();

    void initDateInputField();
    void initDateInputWrapper();
    void initDateInputComboBox();
    void initCalendar();
    void initDateIconButton();
    void initClearIconButton();

    void addInputLabel(bool isRequired = false);
    void addErrorMessage();
    void addValidation();

    std::shared_ptr<RendererQml::QmlTag> getCalendarListView();
    std::shared_ptr<RendererQml::QmlTag> getCalendarListViewDelegate(const std::string listViewId);
    std::shared_ptr<RendererQml::QmlTag> getArrowIconButton(const std::string arrowType, const std::string listViewId);

    const std::string getColorFunction();
    const std::string getAccessibleName();
};

