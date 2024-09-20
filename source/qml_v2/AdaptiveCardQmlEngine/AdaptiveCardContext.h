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
#include "AdaptiveWarning.h"

namespace AdaptiveCardQmlEngine
{
    class AdaptiveCardContext : public QObject
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

        void addHeightEstimate(const int height);
        void setHeightEstimate(const int height);
        const int getHeightEstimate();

        const int getEstimatedTextHeight(const std::string text);

        QString getColor(AdaptiveCards::ForegroundColor color, bool isSubtle, bool highlight, bool isQml = true);

        std::string getLang();
        void setLang(const std::string& lang);

        const std::vector<AdaptiveWarning>& getWarnings();
        void addWarning(const AdaptiveWarning& warning);

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
        std::string m_lang;
        int m_HeightEstimate{0};
        std::vector<AdaptiveWarning> m_warnings;
        std::string m_defaultId;
        int m_DefaultIdCounter{0};
        std::map<std::string, std::string> m_inputElementList;
    };
} // namespace AdaptiveCardQmlEngine
