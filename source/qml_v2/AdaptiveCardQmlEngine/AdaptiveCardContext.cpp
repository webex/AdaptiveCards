#include "AdaptiveCardContext.h"


namespace AdaptiveCardQmlEngine
{
    AdaptiveCardContext::AdaptiveCardContext() : mHostConfig(nullptr)
    {
    }

    AdaptiveCardContext::~AdaptiveCardContext()
    {
    }

    void AdaptiveCardContext::initAdaptiveCardContext()
    {
        // Initializing Host config and Card config
        mCardConfig = std::make_shared<AdaptiveCardQmlEngine::AdaptiveCardConfig>(true);
        mHostConfig = std::make_shared<AdaptiveCards::HostConfig>(AdaptiveCards::HostConfig::DeserializeFromString(DarkConfig::darkConfig));
    }

    void AdaptiveCardContext::setAdaptiveCardTheme(AdaptiveCardEnums::AdaptiveCardTheme theme)
    {
        mAdaptiveCardTheme = theme;

        // ReInitializing AdaptiveCard and Host config
        mCardConfig = std::make_shared<AdaptiveCardConfig>(mAdaptiveCardTheme == AdaptiveCardEnums::AdaptiveCardTheme::DarkTheme ? true : false);

        if (mAdaptiveCardTheme == AdaptiveCardEnums::AdaptiveCardTheme::DarkTheme)
        {
            mHostConfig = std::make_shared<AdaptiveCards::HostConfig>(AdaptiveCards::HostConfig::DeserializeFromString(DarkConfig::darkConfig));
        }
        else
        {
            mHostConfig = std::make_shared<AdaptiveCards::HostConfig>(AdaptiveCards::HostConfig::DeserializeFromString(LightConfig::lightConfig));
        }
    }

    std::shared_ptr<AdaptiveCards::HostConfig> AdaptiveCardContext::getHostConfig()
    {
        return mHostConfig;
    }

    std::shared_ptr<AdaptiveCardConfig> AdaptiveCardContext::getCardConfig()
    {
        return mCardConfig;
    }

    QString AdaptiveCardContext::getColor(AdaptiveCards::ForegroundColor color, bool isSubtle, bool highlight, bool isQml)
    {
        AdaptiveCards::ColorConfig colorConfig;
        switch (color)
        {
        case AdaptiveCards::ForegroundColor::Accent:
            colorConfig = mRenderArgs.GetForegroundColors().accent;
            break;
        case AdaptiveCards::ForegroundColor::Good:
            colorConfig = mRenderArgs.GetForegroundColors().good;
            break;
        case AdaptiveCards::ForegroundColor::Warning:
            colorConfig = mRenderArgs.GetForegroundColors().warning;
            break;
        case AdaptiveCards::ForegroundColor::Attention:
            colorConfig = mRenderArgs.GetForegroundColors().attention;
            break;
        case AdaptiveCards::ForegroundColor::Dark:
            colorConfig = mRenderArgs.GetForegroundColors().attention;
            break;
        case AdaptiveCards::ForegroundColor::Light:
            colorConfig = mRenderArgs.GetForegroundColors().light;
            break;
        default:
            if (mAdaptiveCardTheme == AdaptiveCardEnums::AdaptiveCardTheme::DarkTheme)
            {
                colorConfig = mRenderArgs.GetForegroundColors().light;
            }
            break;
        }

        if (highlight)
        {
            const auto color = isSubtle ? colorConfig.highlightColors.subtleColor : colorConfig.highlightColors.defaultColor;
            return QString::fromStdString(color);
        }
        else
        {
            const auto color = isSubtle ? colorConfig.subtleColor : colorConfig.defaultColor;
            return QString::fromStdString(color);
        }
    }

    std::string AdaptiveCardContext::getLang()
    {
        return m_lang;
    }

    void AdaptiveCardContext::setLang(const std::string& lang)
    {
        m_lang = lang;
    }

    void AdaptiveCardContext::addHeightEstimate(const int height)
    {
        m_HeightEstimate += height;
    }

    void AdaptiveCardContext::setHeightEstimate(const int height)
    {
        m_HeightEstimate = height;
    }

    const int AdaptiveCardContext::getHeightEstimate()
    {
        return m_HeightEstimate;
    }

    const int AdaptiveCardQmlEngine::AdaptiveCardContext::getEstimatedTextHeight(const std::string text)
    {
        auto mCardConfig = this->getCardConfig()->getCardConfig();

        int height = 0;

        height += ((((int(text.size()) * mCardConfig.averageCharWidth) / mCardConfig.cardWidth) + 1) * mCardConfig.averageCharHeight);
        height += (int(std::count(text.begin(), text.end(), '\n')) * mCardConfig.averageCharHeight);
        height += mCardConfig.averageSpacing;

        return height;
    }

    	const std::vector<AdaptiveWarning>& AdaptiveCardContext::GetWarnings()
    {
        return m_warnings;
    }

    void AdaptiveCardContext::AddWarning(const AdaptiveWarning& warning)
    {
        m_warnings.push_back(warning);
    }


    void AdaptiveCardQmlEngine::AdaptiveCardContext::addToRequiredInputElementsIdList(const std::string& elementId)
    {
        m_RequiredInputElementsIdList.push_back(elementId);
    }

     const std::vector<std::string>& AdaptiveCardQmlEngine::AdaptiveCardContext::getRequiredInputElementsIdList()
    {
        return m_RequiredInputElementsIdList;
    }

} // namespace AdaptiveCardQmlEngine

