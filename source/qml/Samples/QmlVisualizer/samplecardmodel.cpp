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

SampleCardModel::SampleCardModel(QObject *parent)
    : QAbstractListModel(parent)
    , mList(nullptr)
{

    std::shared_ptr<AdaptiveSharedNamespace::HostConfig> hostConfig = std::make_shared<AdaptiveSharedNamespace::HostConfig>(AdaptiveSharedNamespace::HostConfig::DeserializeFromString(LightConfig::lightConfig));
    auto renderConfig = getRenderConfig(false);
    renderer_ptr = std::make_shared<AdaptiveCardQmlRenderer>(AdaptiveCardQmlRenderer(hostConfig, renderConfig));
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
    std::map<std::string, std::string> urls;

    std::shared_ptr<int> imgCounter{ 0 };

    std::shared_ptr<AdaptiveCards::ParseResult> mainCard = AdaptiveCards::AdaptiveCard::DeserializeFromString(cardQml.toStdString(), "2.0");
    std::shared_ptr<RenderedQmlAdaptiveCard> result = renderer_ptr->RenderCard(mainCard->GetAdaptiveCard());
    const auto generatedQml = result->GetResult();
	
    //SYNCHRONOUS
    ImageDownloader::clearImageFolder();
	
	generatedQml->Transform([&urls](QmlTag& genQml)
	{
		if (genQml.GetElement() == "Frame" && genQml.HasProperty("readonly property bool hasBackgroundImage"))
		{
            auto url = genQml.GetProperty("property var imgSource");
            urls[genQml.GetId()] = Utils::Replace(url, "\"", "");

            //Temp
            char* imgUrl = ImageDownloader::Convert(url);
            const std::string imageName = genQml.GetId() + ".jpg";

            if (ImageDownloader::download_jpeg(imageName, imgUrl))
            {
                genQml.Property("property var imgSource", "\"" + getImagePath(imageName) + "\"");
            }
            else
            {
                printf("!! Failed to download file!");
            }
            //Temp            
		}
		else if (genQml.GetElement() == "Image" && genQml.HasProperty("readonly property bool isImage"))
		{
            auto url = genQml.GetProperty("source");
            urls[genQml.GetId()] = Utils::Replace(url, "\"", "");

            //Temp
            char* imgUrl = ImageDownloader::Convert(url);
            const std::string imageName = genQml.GetId() + ".jpg";

            if (ImageDownloader::download_jpeg(imageName, imgUrl))
            {
                genQml.Property("source", "\"" + getImagePath(imageName) + "\"");
            }
            else
            {
                printf("!! Failed to download file!");
            }
            //Temp 
		}
		else if (genQml.GetElement() == "Button" && genQml.HasProperty("readonly property bool hasIconUrl"))
		{
            auto url = genQml.GetProperty("property var imgSource");
            urls[genQml.GetId()] = Utils::Replace(url, "\"", "");

            //Temp
            char* imgUrl = ImageDownloader::Convert(url);
            const std::string imageName = genQml.GetId() + ".jpg";

            if (ImageDownloader::download_jpeg(imageName, imgUrl))
            {
                genQml.Property("property var imgSource", "\"" + getImagePath(imageName) + "\"");
            }
            else
            {
                printf("!! Failed to download file!");
            }
            //Temp 
		}
	});

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
}

const std::string SampleCardModel::getImagePath(const std::string& imageName)
{
	std::string file_path = __FILE__;
	std::string dir_path = file_path.substr(0, file_path.rfind("\\"));
    dir_path.append("\\Images\\" + imageName);
	std::replace(dir_path.begin(), dir_path.end(), '\\', '/');
	dir_path = std::string("file:/") + dir_path;

	return dir_path;
}

std::shared_ptr<AdaptiveCardRenderConfig> SampleCardModel::getRenderConfig(const bool isDark)
{
    auto renderConfig = std::make_shared<AdaptiveCardRenderConfig>(isDark);
    renderConfig->setInputTextConfig(getInputTextConfig(isDark));
    renderConfig->setInputNumberConfig(getInputNumberConfig(isDark));
    renderConfig->setInputTimeConfig(getInputTimeConfig(isDark));
    renderConfig->setInputChoiceSetDropDownConfig(getInputChoiceSetDropDownConfig(isDark));
    renderConfig->setToggleButtonConfig(getToggleButtonConfig(isDark));
    renderConfig->setInputDateConfig(getInputDateConfig(isDark));
    renderConfig->setActionButtonsConfig(getActionButtonsConfig(isDark));
    return renderConfig;
}

template <typename InputConfig>
InputConfig SampleCardModel::getInputFieldConfig(InputConfig inputConfig, const bool isDark)
{
    //Dark Values are default in the struct
    if (!isDark)
    {
        inputConfig.backgroundColorNormal = "#ffffffff";
        inputConfig.backgroundColorOnHovered = "#0a000000";
        inputConfig.backgroundColorOnPressed = "#4d000000";
        inputConfig.borderColorNormal = "#80000000";
        inputConfig.borderColorOnFocus = "#ff1170cf";
        inputConfig.placeHolderColor = "#99000000";
        inputConfig.textColor = "#f2000000";
        inputConfig.clearIconColorNormal = "#99000000";
        inputConfig.clearIconColorOnFocus = "#ff1170cf";
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
        numberInputConfig.upDownIconColor = "#f2000000";
    }

    return numberInputConfig;
}

InputTimeConfig SampleCardModel::getInputTimeConfig(const bool isDark)
{
    InputTimeConfig timeInputConfig;
    timeInputConfig = getInputFieldConfig(timeInputConfig, isDark);

    if (!isDark)
    {
        timeInputConfig.timeIconColorNormal = "#f2000000";
        timeInputConfig.timeIconColorOnFocus = "#ff1170cf";
        timeInputConfig.timePickerBorderColor = "#80000000";
        timeInputConfig.timePickerBackgroundColor = "#ffffffff";
        timeInputConfig.timePickerElementColorNormal = "#ffffffff";
        timeInputConfig.timePickerElementColorOnHover = "#12000000";
        timeInputConfig.timePickerElementColorOnFocus = "#ff1170cf";
        timeInputConfig.timePickerElementTextColorNormal = "#f2000000";
    }

    return timeInputConfig;
}

InputDateConfig SampleCardModel::getInputDateConfig(const bool isDark)
{
    InputDateConfig dateInputConfig;
    dateInputConfig = getInputFieldConfig(dateInputConfig, isDark);

    if (!isDark)
    {
        dateInputConfig.dateIconColorNormal = "#f2000000";
        dateInputConfig.dateIconColorOnFocus = "#ff1170cf";
        dateInputConfig.calendarBorderColor = "#80000000";
        dateInputConfig.calendarBackgroundColor = "#FFFFFFFF";
        dateInputConfig.dateElementColorNormal = "#FFFFFFFF";
        dateInputConfig.dateElementColorOnHover = "#12000000";
        dateInputConfig.dateElementColorOnFocus = "#ff1170cf";
        dateInputConfig.dateElementTextColorNormal = "#f2000000";
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
        choiceSetDropdownInputConfig.arrowIconColor = "#f2000000";
        choiceSetDropdownInputConfig.dropDownElementColorPressed = "#4d000000";
        choiceSetDropdownInputConfig.dropDownElementColorHovered = "#0a000000";
        choiceSetDropdownInputConfig.dropDownElementColorNormal = "#ffffffff";
        choiceSetDropdownInputConfig.dropDownBorderColor = "#80000000";
        choiceSetDropdownInputConfig.dropDownBackgroundColor = "#ffffffff";
    }

    return choiceSetDropdownInputConfig;
}

ToggleButtonConfig SampleCardModel::getToggleButtonConfig(const bool isDark)
{
    ToggleButtonConfig toggleButtonConfig;

    if (!isDark)
    {
        toggleButtonConfig.colorOnCheckedAndPressed = "#ff063a75";
        toggleButtonConfig.colorOnCheckedAndHovered = "#ff0353a8";
        toggleButtonConfig.colorOnChecked = "#ff1170cf";
        toggleButtonConfig.colorOnUncheckedAndPressed = "#33000000";
        toggleButtonConfig.colorOnUncheckedAndHovered = "#33000000";
        toggleButtonConfig.colorOnUnchecked = "#1c000000";
        toggleButtonConfig.borderColorOnCheckedAndPressed = "#ff063a75";
        toggleButtonConfig.borderColorOnCheckedAndHovered = "#ff0353a8";
        toggleButtonConfig.borderColorOnChecked = "#ff1170cf";
        toggleButtonConfig.borderColorOnUncheckedAndPressed = "#33000000";
        toggleButtonConfig.borderColorOnUncheckedAndHovered = "#33000000";
        toggleButtonConfig.borderColorOnUnchecked = "#1c000000";
        toggleButtonConfig.textColor = "#f2000000";
        toggleButtonConfig.radioButtonInnerCircleColorOnChecked = "#ffffffff";
    }

    return toggleButtonConfig;
}

ActionButtonsConfig SampleCardModel::getActionButtonsConfig(const bool isDark)
{
    ActionButtonsConfig actionButtonsConfig;

    if (!isDark)
    {
        actionButtonsConfig.primaryColorConfig.buttonColorNormal = "#f2000000";
        actionButtonsConfig.primaryColorConfig.buttonColorHovered = "#cc000000";
        actionButtonsConfig.primaryColorConfig.buttonColorPressed = "#b3000000";
        actionButtonsConfig.primaryColorConfig.borderColorNormal = "#f2000000";
        actionButtonsConfig.primaryColorConfig.borderColorHovered = "#f2000000";
        actionButtonsConfig.primaryColorConfig.borderColorPressed = "#f2000000";
        actionButtonsConfig.primaryColorConfig.borderColorFocussed = "#ff1170cf";
        actionButtonsConfig.primaryColorConfig.textColorNormal = "#f2ffffff";
        actionButtonsConfig.primaryColorConfig.textColorHovered = "#f2ffffff";
        actionButtonsConfig.primaryColorConfig.textColorPressed = "#f2ffffff";

        actionButtonsConfig.secondaryColorConfig.buttonColorNormal = "#00000000";
        actionButtonsConfig.secondaryColorConfig.buttonColorHovered = "#12000000";
        actionButtonsConfig.secondaryColorConfig.buttonColorPressed = "#33000000";
        actionButtonsConfig.secondaryColorConfig.borderColorNormal = "#4d000000";
        actionButtonsConfig.secondaryColorConfig.borderColorHovered = "#4d000000";
        actionButtonsConfig.secondaryColorConfig.borderColorPressed = "#4d000000";
        actionButtonsConfig.secondaryColorConfig.borderColorFocussed = "#ff1170cf";
        actionButtonsConfig.secondaryColorConfig.textColorNormal = "#f2000000";
        actionButtonsConfig.secondaryColorConfig.textColorHovered = "#f2000000";
        actionButtonsConfig.secondaryColorConfig.textColorPressed = "#f2000000";

        actionButtonsConfig.positiveColorConfig.buttonColorNormal = "#00000000";
        actionButtonsConfig.positiveColorConfig.buttonColorHovered = "#ff185e46";
        actionButtonsConfig.positiveColorConfig.buttonColorPressed = "#ff134231";
        actionButtonsConfig.positiveColorConfig.borderColorNormal = "#ff185e46";
        actionButtonsConfig.positiveColorConfig.borderColorHovered = "#ff185e46";
        actionButtonsConfig.positiveColorConfig.borderColorPressed = "#ff134231";
        actionButtonsConfig.positiveColorConfig.borderColorFocussed = "#ff1170cf";
        actionButtonsConfig.positiveColorConfig.textColorNormal = "#ff185e46";
        actionButtonsConfig.positiveColorConfig.textColorHovered = "#f2ffffff";
        actionButtonsConfig.positiveColorConfig.textColorPressed = "#f2ffffff";

        actionButtonsConfig.destructiveColorConfig.buttonColorNormal = "#00000000";
        actionButtonsConfig.destructiveColorConfig.buttonColorHovered = "#ffab0a15";
        actionButtonsConfig.destructiveColorConfig.buttonColorPressed = "#ff780d13";
        actionButtonsConfig.destructiveColorConfig.borderColorNormal = "#ffab0a15";
        actionButtonsConfig.destructiveColorConfig.borderColorHovered = "#ffab0a15";
        actionButtonsConfig.destructiveColorConfig.borderColorPressed = "#ff780d13";
        actionButtonsConfig.destructiveColorConfig.borderColorFocussed = "#ff1170cf";
        actionButtonsConfig.destructiveColorConfig.textColorNormal = "#ffab0a15";
        actionButtonsConfig.destructiveColorConfig.textColorHovered = "#f2ffffff";
        actionButtonsConfig.destructiveColorConfig.textColorPressed = "#f2ffffff";
    }

    return actionButtonsConfig;
}
