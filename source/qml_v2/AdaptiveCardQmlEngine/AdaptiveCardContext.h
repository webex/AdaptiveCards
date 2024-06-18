#pragma once
#include <QObject>
#include "SharedAdaptiveCard.h"

#include "AdaptiveCardConfig.h"
#include "AdaptiveCardDarkThemeConfig.h"
#include "AdaptiveCardLightThemeConfig.h"

#include "AdaptiveRenderArgs.h"

#include "HostConfig.h"
#include "Formatter.h"
#include "utils/Utils.h"
#include "utils/AdaptiveCardEnums.h"

namespace AdaptiveCardQmlEngine
{
    class AdaptiveCardContext:public QObject
    {
        Q_OBJECT
        enum AdaptiveCardTheme
        {   
            DarkTheme = 0,
            LightTheme 
        };

    public:
        static AdaptiveCardContext& getInstance()
        {
            static AdaptiveCardContext instance;
            return instance;
		}

        void initAdaptiveCardContext();
        void setAdaptiveCardTheme(AdaptiveCardEnums::AdaptiveCardTheme theme);

        std::shared_ptr<AdaptiveCards::HostConfig> getHostConfig();
        std::shared_ptr<AdaptiveCardConfig> getCardConfig();

        QString getColor(AdaptiveCards::ForegroundColor color, bool isSubtle, bool highlight, bool isQml = true);

    private:
        AdaptiveCardContext();
        ~AdaptiveCardContext();

        AdaptiveCardContext(const AdaptiveCardContext&) = delete;
        AdaptiveCardContext& operator=(const AdaptiveCardContext&) = delete;

    private:
        AdaptiveRenderArgs mRenderArgs;
        std::shared_ptr<AdaptiveCards::HostConfig> mHostConfig;
        std::shared_ptr<AdaptiveCardConfig> mCardConfig;
        AdaptiveCardEnums::AdaptiveCardTheme mAdaptiveCardTheme;
    };
}
