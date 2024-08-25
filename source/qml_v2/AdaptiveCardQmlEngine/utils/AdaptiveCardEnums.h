#pragma once

#include <QObject>

namespace AdaptiveCardEnums
{
    Q_NAMESPACE
    enum class CardElementType {
        AdaptiveCard,
        TextBlock,
        Image,
        Container,
        Column,
        ColumnSet,
        ToggleInput,
        ActionSet
    };
    Q_ENUM_NS(CardElementType)

    enum class ActionElementType {
        Submit,
        OpenUrl,
        ToggleVisibility,
        ShowCard
    };

    enum class AdaptiveCardTheme
    {
		DarkTheme = 0,
		LightTheme
	};

    Q_ENUM_NS(ActionElementType)
}
