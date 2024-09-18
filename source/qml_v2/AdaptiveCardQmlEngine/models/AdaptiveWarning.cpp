#include "pch.h"

#include "AdaptiveWarning.h"

namespace AdaptiveCardQmlEngine
{

    AdaptiveWarning::AdaptiveWarning(Code code, const std::string& message) :
        m_code(code), m_message(message)
    {

    }

    Code AdaptiveWarning::GetStatusCode() const
    {
        return m_code;
    }

    const std::string& AdaptiveWarning::GetReason() const
    {
        return m_message;
    }

}
