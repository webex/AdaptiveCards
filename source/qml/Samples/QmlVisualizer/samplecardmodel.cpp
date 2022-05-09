#include "samplecardmodel.h"
#include "samplecardlist.h"
#include "adaptivecard_light_config.h"
#include "adaptivecard_dark_config.h"
#include "AdaptiveCardRenderConfig.h"

#include <windows.h>
#include <shellapi.h>
#include <mutex>

using namespace RendererQml;

std::mutex images_mutex;
std::mutex submit_mutex;

SampleCardModel::SampleCardModel(QObject *parent)
    : QAbstractListModel(parent)
    , mList(nullptr)
{

    std::shared_ptr<AdaptiveSharedNamespace::HostConfig> hostConfig = std::make_shared<AdaptiveSharedNamespace::HostConfig>(AdaptiveSharedNamespace::HostConfig::DeserializeFromString(LightConfig::lightConfig));
    auto renderConfig = getRenderConfig(false);
    renderer_ptr = std::make_shared<AdaptiveCardQmlRenderer>(AdaptiveCardQmlRenderer(hostConfig, renderConfig));
    mContextMenu = new QMenu();
}

int SampleCardModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid() || !mList)
        return 0;

    return mList->cardList().size();
}

QVariant SampleCardModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || !mList)
        return QVariant(QStringLiteral("error"));

    const Card card = mList->cardList().at(index.row());

    switch (role)
    {
    case CardNameRole:
        return QVariant(card.CardName);
    case CardJsonString:
        return QVariant(card.CardJson);
    }
    return QVariant();
}

QHash<int, QByteArray> SampleCardModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[CardNameRole] = "CardName";
    names[CardJsonString] = "CardJson";
    return names;
}

SampleCardList *SampleCardModel::list() const
{
    return mList;
}

void SampleCardModel::setList(SampleCardList *list)
{
    beginResetModel();

    if(mList)
    {
        mList->disconnect(this);
    }
    mList = list;

    endResetModel();
}

std::shared_ptr<AdaptiveCards::HostConfig> SampleCardModel::getHostConfig()
{
    std::shared_ptr<AdaptiveCards::HostConfig> hostConfig = std::make_shared<AdaptiveCards::HostConfig>();

    AdaptiveCards::SpacingConfig spacingConfig = hostConfig->GetSpacing();
    spacingConfig.paddingSpacing = 15;
    hostConfig->SetSpacing(spacingConfig);

    AdaptiveCards::SeparatorConfig separatorConfig = hostConfig->GetSeparator();
    separatorConfig.lineColor = "#FF707070";
    hostConfig->SetSeparator(separatorConfig);

    AdaptiveCards::FontSizesConfig fontSizesConfig = hostConfig->GetFontSizes();
    fontSizesConfig.SetFontSize(AdaptiveCards::TextSize::Small, 12);
    fontSizesConfig.SetFontSize(AdaptiveCards::TextSize::Medium, 17);
    fontSizesConfig.SetFontSize(AdaptiveCards::TextSize::Large, 21);
    fontSizesConfig.SetFontSize(AdaptiveCards::TextSize::ExtraLarge, 26);
    fontSizesConfig.SetFontSize(AdaptiveCards::TextSize::Default, 14);
    hostConfig->SetFontSizes(fontSizesConfig);

    AdaptiveCards::ImageSizesConfig imageSizesConfig = hostConfig->GetImageSizes();
    imageSizesConfig.smallSize = 40;
    imageSizesConfig.mediumSize = 80;
    imageSizesConfig.largeSize = 160;
    hostConfig->SetImageSizes(imageSizesConfig);

    auto containerStyles = hostConfig->GetContainerStyles();
    containerStyles.emphasisPalette.backgroundColor = "#AABBCCDD";
    hostConfig->SetContainerStyles(containerStyles);

    return hostConfig;
}

QString SampleCardModel::generateQml(const QString& cardQml)
{
    std::shared_ptr<int> imgCounter{ 0 };

    std::shared_ptr<AdaptiveCards::ParseResult> mainCard = AdaptiveCards::AdaptiveCard::DeserializeFromString(cardQml.toStdString(), "2.0");
    std::map<int, std::string> urls = GetImageUrls(mainCard->GetAdaptiveCard(), std::map<int, std::string>());
    auto [result, contentIndexes] = renderer_ptr->RenderCard(mainCard->GetAdaptiveCard(), 0);
    const auto generatedQml = result->GetResult();
	
    //SYNCHRONOUS
    ImageDownloader::clearImageFolder();

    for (auto& x : urls) {
        auto [contentNumber, url] = x;
        const std::string imageName = Formatter() << contentNumber << ".jpg";

        char* imgUrl = ImageDownloader::Convert(url);

        if (!ImageDownloader::download_jpeg(imageName, imgUrl))
        {
            printf("!! Failed to download file!");
        }
    }

	//ASYNCHRONOUS
	/*generatedQml->Transform([&urls](QmlTag& genQml)
	{
		if (genQml.GetElement() == "Frame" && genQml.HasProperty("readonly property bool hasBackgroundImage"))
		{
			auto url = genQml.GetProperty("property var imgSource");
			urls[genQml.GetId()] = Utils::Replace(url, "\"", "");
		}
		else if (genQml.GetElement() == "Image" && genQml.HasProperty("readonly property bool isImage"))
		{
			auto url = genQml.GetProperty("source");
			urls[genQml.GetId()] = Utils::Replace(url, "\"", "");
		}
		else if (genQml.GetElement() == "Button" && genQml.HasProperty("readonly property bool hasIconUrl"))
		{
			auto url = genQml.GetProperty("property var imgSource");
			urls[genQml.GetId()] = Utils::Replace(url, "\"", "");
		}
	});

	std::thread thread_object([urls]() {
		images_mutex.lock();
		const std::map<std::string, std::string> paths = rehostImage(urls);
		printf("Number of Images downloaded: %d\n", paths.size());
		images_mutex.unlock();
		});

	//Detaching the thread to make it asynchronous
	thread_object.detach();*/

	const QString generatedQmlString = QString::fromStdString(generatedQml->ToString());
    return generatedQmlString;
}

const std::map<std::string, std::string> SampleCardModel::rehostImage(const std::map<std::string, std::string>& urls)
{
	ImageDownloader::clearImageFolder();
	const std::map<std::string, std::string> file_paths = ImageDownloader::download_multiple_jpeg(urls);
	return file_paths;
}

void SampleCardModel::setTheme(const QString& theme)
{
    std::shared_ptr<AdaptiveSharedNamespace::HostConfig> hostConfig;
    bool isDark = true;

    if(theme.toStdString() == "Light")
    {
        isDark = false;
        hostConfig = std::make_shared<AdaptiveSharedNamespace::HostConfig>(AdaptiveSharedNamespace::HostConfig::DeserializeFromString(LightConfig::lightConfig));
    }
    else
    {
        hostConfig = std::make_shared<AdaptiveSharedNamespace::HostConfig>(AdaptiveSharedNamespace::HostConfig::DeserializeFromString(DarkConfig::darkConfig));
    }

    auto renderConfig = getRenderConfig(isDark);
    renderer_ptr = std::make_shared<AdaptiveCardQmlRenderer>(AdaptiveCardQmlRenderer(hostConfig, renderConfig));

    emit reloadCardOnThemeChange();
}

std::wstring SampleCardModel::toWString(const std::string& input)
{
#ifdef _WIN32
    // Convert UTF-8 to UTF-16
    if (!input.empty())
    {
        int size_needed = MultiByteToWideChar(CP_UTF8, 0, &input[0], static_cast<int>(input.length()), nullptr, 0);
        std::wstring utf16String(size_needed, 0);
        MultiByteToWideChar(CP_UTF8, 0, &input[0], static_cast<int>(input.length()), &utf16String[0], size_needed);
        return utf16String;
    }

    return std::wstring();
#else
    return converterToString->from_bytes(input);
#endif
}

void SampleCardModel::onAdaptiveCardButtonClicked(const QString& title, const QString& type, const QString& data)
{
    if (type == "Action.OpenUrl")
    {
        actionOpenUrlButtonClicked(title, type, data);
    }
    else if(type == "Action.Submit")
    {
        actionSubmitButtonClicked(title, type, data);
    }
}

void SampleCardModel::onOpenContextMenu(const QPoint& pos, const QString& selectedText, const QString& link)
{
    mContextMenu->clear();

    if (!link.isEmpty())
    {
        mContextMenu->addAction(QString::fromStdString("Copy link"), [link, this]() { QApplication::clipboard()->setText(link); });
    }

    if (!selectedText.isEmpty())
    {
        mContextMenu->addAction(QString::fromStdString("Copy text"), [selectedText, this]() { QApplication::clipboard()->setText(selectedText); });
    }

    mContextMenu->popup(pos);
}

void SampleCardModel::actionOpenUrlButtonClicked(const QString& title, const QString& type, const QString& data)
{
    QString output;
    output.append("Title: " + title + "\n");
    output.append("Type: " + type + "\n");
    output.append("Url: " + data);
    emit sendCardResponseToQml(output);

    // Open url in default browser
    ShellExecute(0, 0, toWString(data.toStdString()).c_str(), 0, 0, SW_SHOW);
}

void SampleCardModel::actionSubmitButtonClicked(const QString& title, const QString& type, const QString& data)
{
    QString output;
    output.append("Title: " + title + "\n");
    output.append("Type: " + type + "\n");
    output.append("data: " + data);
    emit sendCardResponseToQml(output);

    //To enable the button 2s after Action.Submit
    std::thread thread_object([this]() {
        submit_mutex.lock();
        std::chrono::seconds duration(2);
        std::this_thread::sleep_for(duration);
        emit enableAdaptiveCardSubmitButton();
        submit_mutex.unlock();
        });

    thread_object.detach();
}

std::pair<std::map<int, std::string>, std::vector<std::shared_ptr<AdaptiveCards::AdaptiveCard>>> SampleCardModel::GetCardImageUrls(std::shared_ptr<AdaptiveCards::BaseCardElement> cardElement, std::map<int, std::string> urls, std::vector<std::shared_ptr<AdaptiveCards::AdaptiveCard>> showCards)
{
    int contentIndex = urls.size();
    if (cardElement->GetElementType() == AdaptiveCards::CardElementType::TextInput)
    {
        auto textInput = std::dynamic_pointer_cast<AdaptiveCards::TextInput>(cardElement);
        auto action = textInput->GetInlineAction();
        if (action && !action->GetIconUrl().empty() && !action->GetIconUrl().rfind("data:image", 0) == 0)
        {
            urls[contentIndex] = action->GetIconUrl();
            contentIndex++;
        }
    }
    else if (cardElement->GetElementType() == AdaptiveCards::CardElementType::Image)
    {
        auto image = std::dynamic_pointer_cast<AdaptiveCards::Image>(cardElement);
        if (!image->GetUrl().empty() && !image->GetUrl().rfind("data:image", 0) == 0)
        {
            urls[contentIndex] = image->GetUrl();
            contentIndex++;
        }
    }
    else if (cardElement->GetElementType() == AdaptiveCards::CardElementType::ImageSet)
    {
        auto imageSet = std::dynamic_pointer_cast<AdaptiveCards::ImageSet>(cardElement);
        auto images = imageSet->GetImages();
        for (auto& image : images)
        {
            if (!image->GetUrl().empty() && !image->GetUrl().rfind("data:image", 0) == 0)
            {
                urls[contentIndex] = image->GetUrl();
                contentIndex++;
            }
        }
    }
    else if (cardElement->GetElementType() == AdaptiveCards::CardElementType::ActionSet)
    {
        auto actionSet = std::dynamic_pointer_cast<AdaptiveCards::ActionSet>(cardElement);
        auto actions = actionSet->GetActions();
        std::tie(urls, showCards) = GetActionImageUrls(actions, urls, showCards);
    }
    else if (cardElement->GetElementType() == AdaptiveCards::CardElementType::ColumnSet)
    {
        auto columnSet = std::dynamic_pointer_cast<AdaptiveCards::ColumnSet>(cardElement);
        auto columns = columnSet->GetColumns();
        for (auto& column : columns)
        {
            std::tie(urls, showCards) = GetCardImageUrls(column, urls, showCards);
        }
    }
    else if (cardElement->GetElementType() == AdaptiveCards::CardElementType::Column)
    {
        auto column = std::dynamic_pointer_cast<AdaptiveCards::Column>(cardElement);
        if (column->GetBackgroundImage() && !column->GetBackgroundImage()->GetUrl().rfind("data:image", 0) == 0)
        {
            urls[contentIndex] = column->GetBackgroundImage()->GetUrl();
            contentIndex++;
        }
        auto body = column->GetItems();
        for (auto& item : body)
        {
            std::tie(urls, showCards) = GetCardImageUrls(item, urls, showCards);
        }
    }
    else if (cardElement->GetElementType() == AdaptiveCards::CardElementType::Container)
    {
        auto container = std::dynamic_pointer_cast<AdaptiveCards::Container>(cardElement);
        if (container->GetBackgroundImage() && !container->GetBackgroundImage()->GetUrl().rfind("data:image", 0) == 0)
        {
            urls[contentIndex] = container->GetBackgroundImage()->GetUrl();
            contentIndex++;
        }
        auto body = container->GetItems();
        for (auto& item : body)
        {
            std::tie(urls, showCards) = GetCardImageUrls(item, urls, showCards);
        }
    }
    else if (cardElement->GetElementType() == AdaptiveCards::CardElementType::AdaptiveCard)
    {
        auto card = std::dynamic_pointer_cast<AdaptiveCards::AdaptiveCard>(cardElement);
        urls = GetImageUrls(card, urls);
    }

    return std::make_pair(urls, showCards);
}

std::pair<std::map<int, std::string>, std::vector<std::shared_ptr<AdaptiveCards::AdaptiveCard>>> SampleCardModel::GetActionImageUrls(std::vector<std::shared_ptr<AdaptiveCards::BaseActionElement>> actions, std::map<int, std::string> urls, std::vector<std::shared_ptr<AdaptiveCards::AdaptiveCard>> showCards)
{
    auto contentIndex = urls.size();
    for (auto& action : actions)
    {
        if (!action->GetIconUrl().empty() && !action->GetIconUrl().rfind("data:image", 0) == 0)
        {
            urls[contentIndex] = action->GetIconUrl();
            contentIndex++;
        }

        if (Utils::IsInstanceOfSmart<AdaptiveCards::ShowCardAction>(action))
        {
            auto showCardAction = std::dynamic_pointer_cast<AdaptiveCards::ShowCardAction>(action);
            showCards.emplace_back(showCardAction->GetCard());
        }
    }

    return std::make_pair(urls, showCards);
}

std::map<int, std::string> SampleCardModel::GetImageUrls(std::shared_ptr<AdaptiveCards::AdaptiveCard> card, std::map<int, std::string> urls)
{
    auto contentIndex = urls.size();
    std::vector<std::shared_ptr<AdaptiveCards::AdaptiveCard>> showCards;

    if (card->GetBackgroundImage() && !card->GetBackgroundImage()->GetUrl().rfind("data:image", 0) == 0)
    {
        urls[contentIndex] = card->GetBackgroundImage()->GetUrl();
        contentIndex++;
    }
    auto body = card->GetBody();
    for (auto& item : body)
    {
        std::tie(urls, showCards) = GetCardImageUrls(item, urls, showCards);
    }

    auto actions = card->GetActions();
    std::tie(urls, showCards) = GetActionImageUrls(actions, urls, showCards);

    for (auto& showCard : showCards)
    {
        urls = GetImageUrls(showCard, urls);
    }
    return urls;
}


std::map<std::string, bool> SampleCardModel::getFeatureToggleMap()
{
    std::map<std::string, bool> featureMap;
    featureMap.emplace(std::make_pair(std::string("FEATURE_1_3"), true));
    return featureMap;
}

std::shared_ptr<AdaptiveCardRenderConfig> SampleCardModel::getRenderConfig(const bool isDark)
{
    auto renderConfig = std::make_shared<AdaptiveCardRenderConfig>(isDark, getFeatureToggleMap());
    renderConfig->setCardConfig(getCardConfig(isDark));
    renderConfig->setInputTextConfig(getInputTextConfig(isDark));
    renderConfig->setInputNumberConfig(getInputNumberConfig(isDark));
    renderConfig->setInputTimeConfig(getInputTimeConfig(isDark));
    renderConfig->setInputChoiceSetDropDownConfig(getInputChoiceSetDropDownConfig(isDark));
    renderConfig->setToggleButtonConfig(getToggleButtonConfig(isDark));
    renderConfig->setInputDateConfig(getInputDateConfig(isDark));
    renderConfig->setActionButtonsConfig(getActionButtonsConfig(isDark));
    return renderConfig;
}

CardConfig SampleCardModel::getCardConfig(const bool isDark)
{
    CardConfig cardConfig;
    if (!isDark)
    {
        cardConfig.cardBorderColor = "#33000000";
        cardConfig.focusRectangleColor = "#80000000";
        cardConfig.textHighlightBackground = "#FFC7F6FF";
    }
    return cardConfig;
}

template <typename InputConfig>
InputConfig SampleCardModel::getInputFieldConfig(InputConfig inputConfig, const bool isDark)
{
    //Dark Values are default in the struct
    if (!isDark)
    {
        inputConfig.backgroundColorNormal = "#FFFFFFFF";
        inputConfig.backgroundColorOnHovered = "#0A000000";
        inputConfig.backgroundColorOnPressed = "#4D000000";
        inputConfig.backgroundColorOnError = "#FFFFE8EA";
        inputConfig.borderColorNormal = "#80000000";
        inputConfig.borderColorOnFocus = "#FF1170CF";
        inputConfig.borderColorOnError = "#FFAB0A15";
        inputConfig.placeHolderColor = "#99000000";
        inputConfig.textColor = "#F2000000";
        inputConfig.errorMessageColor = "#FFAB0A15";
        inputConfig.clearIconColorNormal = "#99000000";
        inputConfig.clearIconColorOnFocus = "#FF1170CF";
    }

    return inputConfig;
}

InputTextConfig SampleCardModel::getInputTextConfig(const bool isDark)
{
    InputTextConfig textInputConfig;
    textInputConfig = getInputFieldConfig(textInputConfig, isDark);
    return textInputConfig;
}

InputNumberConfig SampleCardModel::getInputNumberConfig(const bool isDark)
{
    InputNumberConfig numberInputConfig;
    numberInputConfig = getInputFieldConfig(numberInputConfig, isDark);

    if (!isDark)
    {
        numberInputConfig.upDownIconColor = "#F2000000";
    }

    return numberInputConfig;
}

InputTimeConfig SampleCardModel::getInputTimeConfig(const bool isDark)
{
    InputTimeConfig timeInputConfig;
    timeInputConfig = getInputFieldConfig(timeInputConfig, isDark);

    if (!isDark)
    {
        timeInputConfig.timeIconColorNormal = "#F2000000";
        timeInputConfig.timeIconColorOnFocus = "#FF1170CF";
        timeInputConfig.timeIconColorOnError = "#FFAB0A15";
        timeInputConfig.timePickerBorderColor = "#80000000";
        timeInputConfig.timePickerBackgroundColor = "#FFFFFFFF";
        timeInputConfig.timePickerElementColorNormal = "#FFFFFFFF";
        timeInputConfig.timePickerElementColorOnHover = "#12000000";
        timeInputConfig.timePickerElementColorOnFocus = "#FF1170CF";
        timeInputConfig.timePickerElementTextColorNormal = "#F2000000";
    }

    return timeInputConfig;
}

InputDateConfig SampleCardModel::getInputDateConfig(const bool isDark)
{
    InputDateConfig dateInputConfig;
    dateInputConfig = getInputFieldConfig(dateInputConfig, isDark);

    if (!isDark)
    {
        dateInputConfig.dateIconColorNormal = "#F2000000";
        dateInputConfig.dateIconColorOnFocus = "#FF1170CF";
        dateInputConfig.dateIconColorOnError = "#FFAB0A15";
        dateInputConfig.calendarBorderColor = "#80000000";
        dateInputConfig.calendarBackgroundColor = "#FFFFFFFF";
        dateInputConfig.dateElementColorNormal = "#FFFFFFFF";
        dateInputConfig.dateElementColorOnHover = "#12000000";
        dateInputConfig.dateElementColorOnFocus = "#FF1170CF";
        dateInputConfig.dateElementTextColorNormal = "#F2000000";
        dateInputConfig.notAvailabledateElementTextColor = "#99000000";
    }

    return dateInputConfig;
}

InputChoiceSetDropDownConfig SampleCardModel::getInputChoiceSetDropDownConfig(const bool isDark)
{
    InputChoiceSetDropDownConfig choiceSetDropdownInputConfig;
    choiceSetDropdownInputConfig = getInputFieldConfig(choiceSetDropdownInputConfig, isDark);

    if (!isDark)
    {
        choiceSetDropdownInputConfig.arrowIconColor = "#F2000000";
        choiceSetDropdownInputConfig.dropDownElementColorPressed = "#4D000000";
        choiceSetDropdownInputConfig.dropDownElementColorHovered = "#0A000000";
        choiceSetDropdownInputConfig.dropDownElementColorNormal = "#FFFFFFFF";
        choiceSetDropdownInputConfig.dropDownBorderColor = "#80000000";
        choiceSetDropdownInputConfig.dropDownBackgroundColor = "#FFFFFFFF";
    }

    return choiceSetDropdownInputConfig;
}

ToggleButtonConfig SampleCardModel::getToggleButtonConfig(const bool isDark)
{
    ToggleButtonConfig toggleButtonConfig;

    if (!isDark)
    {
        toggleButtonConfig.colorOnCheckedAndPressed = "#FF063A75";
        toggleButtonConfig.colorOnCheckedAndHovered = "#FF0353A8";
        toggleButtonConfig.colorOnChecked = "#FF1170CF";
        toggleButtonConfig.colorOnUncheckedAndPressed = "#33000000";
        toggleButtonConfig.colorOnUncheckedAndHovered = "#33000000";
        toggleButtonConfig.colorOnUnchecked = "#1C000000";
        toggleButtonConfig.borderColorOnCheckedAndPressed = "#FF063A75";
        toggleButtonConfig.borderColorOnCheckedAndHovered = "#FF0353A8";
        toggleButtonConfig.borderColorOnChecked = "#FF1170CF";
        toggleButtonConfig.borderColorOnUncheckedAndPressed = "#33000000";
        toggleButtonConfig.borderColorOnUncheckedAndHovered = "#33000000";
        toggleButtonConfig.borderColorOnUnchecked = "#1C000000";
        toggleButtonConfig.textColor = "#F2000000";
        toggleButtonConfig.radioButtonInnerCircleColorOnChecked = "#F2FFFFFF";
        toggleButtonConfig.checkBoxIconColorOnChecked = "#F2FFFFFF";
        toggleButtonConfig.focusRectangleColor = "#80000000";
    }

    return toggleButtonConfig;
}

ActionButtonsConfig SampleCardModel::getActionButtonsConfig(const bool isDark)
{
    ActionButtonsConfig actionButtonsConfig;

    if (!isDark)
    {
        actionButtonsConfig.primaryColorConfig.buttonColorNormal = "#F2000000";
        actionButtonsConfig.primaryColorConfig.buttonColorHovered = "#CC000000";
        actionButtonsConfig.primaryColorConfig.buttonColorPressed = "#B3000000";
        actionButtonsConfig.primaryColorConfig.buttonColorDisabled = "#33000000";
        actionButtonsConfig.primaryColorConfig.borderColorNormal = "#F2000000";
        actionButtonsConfig.primaryColorConfig.borderColorHovered = "#F2000000";
        actionButtonsConfig.primaryColorConfig.borderColorPressed = "#F2000000";
        actionButtonsConfig.primaryColorConfig.borderColorFocussed = "#FF1170CF";
        actionButtonsConfig.primaryColorConfig.textColorNormal = "#F2FFFFFF";
        actionButtonsConfig.primaryColorConfig.textColorHovered = "#F2FFFFFF";
        actionButtonsConfig.primaryColorConfig.textColorPressed = "#F2FFFFFF";
        actionButtonsConfig.primaryColorConfig.textColorDisabled = "#66000000";
        actionButtonsConfig.primaryColorConfig.focusRectangleColor = "#80000000";

        actionButtonsConfig.secondaryColorConfig.buttonColorNormal = "#00000000";
        actionButtonsConfig.secondaryColorConfig.buttonColorHovered = "#12000000";
        actionButtonsConfig.secondaryColorConfig.buttonColorPressed = "#33000000";
        actionButtonsConfig.secondaryColorConfig.buttonColorDisabled = "#33000000";
        actionButtonsConfig.secondaryColorConfig.borderColorNormal = "#4D000000";
        actionButtonsConfig.secondaryColorConfig.borderColorHovered = "#4D000000";
        actionButtonsConfig.secondaryColorConfig.borderColorPressed = "#4D000000";
        actionButtonsConfig.secondaryColorConfig.borderColorFocussed = "#FF1170CF";
        actionButtonsConfig.secondaryColorConfig.textColorNormal = "#F2000000";
        actionButtonsConfig.secondaryColorConfig.textColorHovered = "#F2000000";
        actionButtonsConfig.secondaryColorConfig.textColorPressed = "#F2000000";
        actionButtonsConfig.secondaryColorConfig.textColorDisabled = "#66000000";
        actionButtonsConfig.secondaryColorConfig.focusRectangleColor = "#80000000";

        actionButtonsConfig.positiveColorConfig.buttonColorNormal = "#00000000";
        actionButtonsConfig.positiveColorConfig.buttonColorHovered = "#FF185E46";
        actionButtonsConfig.positiveColorConfig.buttonColorPressed = "#FF134231";
        actionButtonsConfig.positiveColorConfig.buttonColorDisabled = "#33000000";
        actionButtonsConfig.positiveColorConfig.borderColorNormal = "#FF185E46";
        actionButtonsConfig.positiveColorConfig.borderColorHovered = "#FF185E46";
        actionButtonsConfig.positiveColorConfig.borderColorPressed = "#FF134231";
        actionButtonsConfig.positiveColorConfig.borderColorFocussed = "#FF1170CF";
        actionButtonsConfig.positiveColorConfig.textColorNormal = "#FF185E46";
        actionButtonsConfig.positiveColorConfig.textColorHovered = "#F2FFFFFF";
        actionButtonsConfig.positiveColorConfig.textColorPressed = "#F2FFFFFF";
        actionButtonsConfig.positiveColorConfig.textColorDisabled = "#66000000";
        actionButtonsConfig.positiveColorConfig.focusRectangleColor = "#80000000";

        actionButtonsConfig.destructiveColorConfig.buttonColorNormal = "#00000000";
        actionButtonsConfig.destructiveColorConfig.buttonColorHovered = "#FFAB0A15";
        actionButtonsConfig.destructiveColorConfig.buttonColorPressed = "#FF780D13";
        actionButtonsConfig.destructiveColorConfig.buttonColorDisabled = "#33000000";
        actionButtonsConfig.destructiveColorConfig.borderColorNormal = "#FFAB0A15";
        actionButtonsConfig.destructiveColorConfig.borderColorHovered = "#FFAB0A15";
        actionButtonsConfig.destructiveColorConfig.borderColorPressed = "#FF780D13";
        actionButtonsConfig.destructiveColorConfig.borderColorFocussed = "#FF1170CF";
        actionButtonsConfig.destructiveColorConfig.textColorNormal = "#FFAB0A15";
        actionButtonsConfig.destructiveColorConfig.textColorHovered = "#F2FFFFFF";
        actionButtonsConfig.destructiveColorConfig.textColorPressed = "#F2FFFFFF";
        actionButtonsConfig.destructiveColorConfig.textColorDisabled = "#66000000";
        actionButtonsConfig.destructiveColorConfig.focusRectangleColor = "#80000000";
    }

    return actionButtonsConfig;
}
