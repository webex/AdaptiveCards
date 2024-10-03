#include "DateInputModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include <QDateTime>
#include "Utils.h"
#include "MarkDownParser.h"

DateInputModel::DateInputModel(std::shared_ptr<AdaptiveCards::DateInput> dateInput, QObject* parent) :
    QObject(parent), mDateInput(dateInput)
{
    
    initialize();
    addDateFormat();
}

void DateInputModel::initialize()
{
    const auto hostConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig();

    mEscapedLabelString = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mDateInput->GetLabel()));
    mEscapedErrorString = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mDateInput->GetErrorMessage()));
    mPlaceholder = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mDateInput->GetPlaceholder()));
    mSpacing = AdaptiveCardQmlEngine::Utils::getSpacing(AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig()->GetSpacing(), AdaptiveCards::Spacing::Small);

    if (!mDateInput->GetMin().empty() && AdaptiveCardQmlEngine::Utils::isValidDate(mDateInput->GetMin()))
    {
        mMinDate = QString::fromStdString(mDateInput->GetMin());
    }

    if (!mDateInput->GetMax().empty() && AdaptiveCardQmlEngine::Utils::isValidDate(mDateInput->GetMax()))
    {
        mMaxDate = QString::fromStdString(mDateInput->GetMax());
    }

    if (!mDateInput->GetValue().empty() && AdaptiveCardQmlEngine::Utils::isValidDate(mDateInput->GetValue()))
    {
        mCurrentDate = QString::fromStdString(mDateInput->GetValue());

        // Convert to QDate object
        QDateTime dateTime = QDateTime::fromString(mCurrentDate, "yyyy-MM-dd");

        // Format to desired string
        mCurrentDate = dateTime.toString("dd/MMM/yyyy");
 
    }


    if (mDateInput->GetIsRequired() || !mDateInput->GetMin().empty() || !mDateInput->GetMax().empty())
    {
        mIsRequired = mDateInput->GetIsRequired();
        mValidationRequired = mDateInput->GetIsRequired();
    }

    AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addHeightEstimate(mDateConfig.height);

    if (!mDateInput->GetLabel().empty())
    {
        AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addHeightEstimate(AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getEstimatedTextHeight(mDateInput->GetLabel()));
    }

    mVisible = mDateInput->GetIsVisible();
} 
void DateInputModel::addDateFormat()
{
    auto EnumDateFormat = AdaptiveCardQmlEngine::Utils::GetSystemDateFormat();

    const auto dateSeparator = "/";
    const auto dayRegex = "([-0123]-|0\\d|[12]\\d|3[01])";
    const auto monthRegex =
        "(---|[JFMASOND]--|Ja-|Jan|Fe-|Feb|Ma-|Mar|Ap-|Apr|May|Ju-|Jun|Jul|Au-|Aug|Se-|Sep|Oc-|Oct|No-|Nov|De-|Dec)";
    const auto yearRegex = "(-{4}|\\d-{3}|\\d{2}-{2}|\\d{3}-|\\d{4})";

    // Default date format: MMM-dd-yyyy
    std::string DateRegex;
    std::string inputMask;

    switch (EnumDateFormat)
    {
    case AdaptiveCardQmlEngine::DateFormat::ddmmyy:
    {
        mDateFormat = QString::fromStdString(AdaptiveCardQmlEngine::Formatter() << "dd" << dateSeparator << "MMM" << dateSeparator << "yyyy");
        inputMask = AdaptiveCardQmlEngine::Formatter() << "xx" << dateSeparator << ">x<xx" << dateSeparator << "xxxx;-";
        DateRegex = AdaptiveCardQmlEngine::Formatter() << "new RegExp(/^" << dayRegex << dateSeparator << monthRegex<< dateSeparator << yearRegex << "$/)";
        break;
    }
    case AdaptiveCardQmlEngine::DateFormat::yymmdd:
    {
        mDateFormat = QString::fromStdString(AdaptiveCardQmlEngine::Formatter() << "yyyy" << dateSeparator << "MMM" << dateSeparator << "dd");
        inputMask = AdaptiveCardQmlEngine::Formatter() << "xxxx" << dateSeparator << ">x<xx" << dateSeparator << "xx;-";
        DateRegex = AdaptiveCardQmlEngine::Formatter() << "new RegExp(/^" << yearRegex << dateSeparator << monthRegex<< dateSeparator << dayRegex << "$/)";
        break;
    }
    case AdaptiveCardQmlEngine::DateFormat::yyddmm:
    {
        mDateFormat = QString::fromStdString(AdaptiveCardQmlEngine::Formatter() << "yyyy" << dateSeparator << "dd" << dateSeparator << "MMM");
        inputMask = AdaptiveCardQmlEngine::Formatter() << "xxxx" << dateSeparator << "xx" << dateSeparator << ">x<xx;-";
        DateRegex = AdaptiveCardQmlEngine::Formatter() << "new RegExp(/^" << yearRegex << dateSeparator << dayRegex<< dateSeparator << monthRegex << "$/)";
        break;
    }
    default:
    {
        mDateFormat = QString::fromStdString(AdaptiveCardQmlEngine::Formatter() << "MMM" << dateSeparator << "dd" << dateSeparator << "yyyy");
        inputMask = AdaptiveCardQmlEngine::Formatter() << ">x<xx" << dateSeparator << "xx" << dateSeparator << "xxxx;-";
        DateRegex = AdaptiveCardQmlEngine::Formatter() << "new RegExp(/^" << monthRegex << dateSeparator << dayRegex<< dateSeparator << yearRegex << "$/)";
        break;
    }
    }

    mDateInputFormat = mDateFormat;
    mInputMask = QString::fromStdString(inputMask);
    mRegex = QString::fromStdString(DateRegex);
}

DateInputModel::~DateInputModel()
{
}
