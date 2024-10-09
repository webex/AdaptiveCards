#pragma once

#include "pch.h"

namespace AdaptiveCardQmlEngine
{

enum class BleedDirection
{
    Left,
    Both,
    Right,
    None
};

enum class DateFormat
{
    ddmmyy,
    yymmdd,
    yyddmm,
    mmddyy
};

} // namespace RendererQml
