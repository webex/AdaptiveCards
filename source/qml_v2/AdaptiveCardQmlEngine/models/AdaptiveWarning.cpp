#include "pch.h"

#include "AdaptiveWarning.h"

namespace AdaptiveCardQmlEngine
{
    AdaptiveWarning::AdaptiveWarning(Code code, const std::string& message) :
        mCode(code), mMessage(message)
    {

    }

    Code AdaptiveWarning::GetStatusCode() const
    {
        return mCode;
    }

    const std::string& AdaptiveWarning::GetReason() const
    {
        return mMessage;
    }
}
