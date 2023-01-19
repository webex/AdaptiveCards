#include "DateInputRender.h"
#include "Formatter.h"
#include "ImageDataURI.h"
#include "Utils.h"

DateInputElement::DateInputElement(std::shared_ptr<AdaptiveCards::DateInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
    :mDateInput(input),
    mContext(context),
    mDateConfig(context->GetRenderConfig()->getInputDateConfig())
{
    initialize();
}

std::shared_ptr<RendererQml::QmlTag> DateInputElement::getQmlTag()
{
    return mDateInputElement;
}

void DateInputElement::initialize()
{
    mOrigionalElementId = mDateInput->GetId();
    mDateInput->SetId(mContext->ConvertToValidId(mDateInput->GetId()));

    mEscapedPlaceHolderString = RendererQml::Utils::getBackQuoteEscapedString(mDateInput->GetPlaceholder());
    mEscapedLabelString = RendererQml::Utils::getBackQuoteEscapedString(mDateInput->GetLabel());
    mEscapedErrorString = RendererQml::Utils::getBackQuoteEscapedString(mDateInput->GetErrorMessage());

    mDateInputElement = std::make_shared<RendererQml::QmlTag>("DateInputRender");
    mDateInputElement->Property("id", mDateInput->GetId());
    mDateInputElement->Property("property int minWidth", "300");
    mDateInputElement->Property("_adaptiveCard", "adaptiveCard");
    mDateInputElement->Property("_mEscapedLabelString", RendererQml::Formatter() << "String.raw`" << mEscapedLabelString << "`");
    mDateInputElement->Property("_mEscapedErrorString", RendererQml::Formatter() << "String.raw`" << mEscapedErrorString << "`");
    mDateInputElement->Property("_mEscapedPlaceholderString", RendererQml::Formatter() << "String.raw`" << mEscapedPlaceHolderString << "`");
    mDateInputElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));

    if (!mDateInput->GetMin().empty() && RendererQml::Utils::isValidDate(mDateInput->GetMin()))
    {
        mDateInputElement->Property("_minDate", RendererQml::Utils::GetDate(mDateInput->GetMin()));
    }

    if (!mDateInput->GetMax().empty() && RendererQml::Utils::isValidDate(mDateInput->GetMax()))
    {
        mDateInputElement->Property("_maxDate", RendererQml::Utils::GetDate(mDateInput->GetMax()));
    }

    if (!mDateInput->GetValue().empty() && RendererQml::Utils::isValidDate(mDateInput->GetValue()))
    {
        mDateInputElement->Property("_currentDate", RendererQml::Utils::GetDate(mDateInput->GetValue()));
    }

    if (mDateInput->GetIsRequired() || !mDateInput->GetMin().empty() || !mDateInput->GetMax().empty())
    {
        mContext->addToRequiredInputElementsIdList(mDateInputElement->GetId());
        mDateInputElement->Property((mDateInput->GetIsRequired() ? "_isRequired" : "_validationRequired"), "true");
    }

    mContext->addToInputElementList(mOrigionalElementId, (mDateInputElement->GetId() + "._submitValue"));
    mContext->addHeightEstimate(mDateConfig.height);

    if (!mDateInput->GetLabel().empty())
    {
        mContext->addHeightEstimate(mContext->getEstimatedTextHeight(mDateInput->GetLabel()));
    }

    mDateInputElement->Property("visible", mDateInput->GetIsVisible() ? "true" : "false");

    addDateFormat();
}

void DateInputElement::addDateFormat()
{
    auto EnumDateFormat = RendererQml::Utils::GetSystemDateFormat();

    const auto dateSeparator = "\\/";
    const auto day_Regex = "([-0123]-|0\\d|[12]\\d|3[01])";
    const auto month_Regex = "(---|[JFMASOND]--|Ja-|Jan|Fe-|Feb|Ma-|Mar|Ap-|Apr|May|Ju-|Jun|Jul|Au-|Aug|Se-|Sep|Oc-|Oct|No-|Nov|De-|Dec)";
    const auto year_Regex = "(-{4}|\\d-{3}|\\d{2}-{2}|\\d{3}-|\\d{4})";

    //Default date format: MMM-dd-yyyy
    std::string DateRegex;
    std::string inputMask;

    switch (EnumDateFormat)
    {
        case RendererQml::DateFormat::ddmmyy:
        {
            mDateFormat = RendererQml::Formatter() << "dd" << dateSeparator << "MMM" << dateSeparator << "yyyy";
            inputMask = RendererQml::Formatter() << "xx" << dateSeparator << ">x<xx" << dateSeparator << "xxxx;-";
            DateRegex = RendererQml::Formatter() << "new RegExp(/^" << day_Regex << dateSeparator << month_Regex << dateSeparator << year_Regex << "$/)";
            break;
        }
        case RendererQml::DateFormat::yymmdd:
        {
            mDateFormat = RendererQml::Formatter() << "yyyy" << dateSeparator << "MMM" << dateSeparator << "dd";
            inputMask = RendererQml::Formatter() << "xxxx" << dateSeparator << ">x<xx" << dateSeparator << "xx;-";
            DateRegex = RendererQml::Formatter() << "new RegExp(/^" << year_Regex << dateSeparator << month_Regex << dateSeparator << day_Regex << "$/)";
            break;
        }
        case RendererQml::DateFormat::yyddmm:
        {
            mDateFormat = RendererQml::Formatter() << "yyyy" << dateSeparator << "dd" << dateSeparator << "MMM";
            inputMask = RendererQml::Formatter() << "xxxx" << dateSeparator << "xx" << dateSeparator << ">x<xx;-";
            DateRegex = RendererQml::Formatter() << "new RegExp(/^" << year_Regex << dateSeparator << day_Regex << dateSeparator << month_Regex << "$/)";
            break;
        }
        default:
        {
            mDateFormat = RendererQml::Formatter() << "MMM" << dateSeparator << "dd" << dateSeparator << "yyyy";
            inputMask = RendererQml::Formatter() << ">x<xx" << dateSeparator << "xx" << dateSeparator << "xxxx;-";
            DateRegex = RendererQml::Formatter() << "new RegExp(/^" << month_Regex << dateSeparator << day_Regex << dateSeparator << year_Regex << "$/)";
            break;
        }
    }

    mDateInputElement->Property("_dateInputFormat", mDateFormat, true);
    mDateInputElement->Property("_inputMask", inputMask, true);
    mDateInputElement->Property("_regex", DateRegex);
}
