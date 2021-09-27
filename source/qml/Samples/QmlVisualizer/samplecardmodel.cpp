#include "samplecardmodel.h"
#include "samplecardlist.h"
#include "adaptivecard_light_config.h"
#include "adaptivecard_dark_config.h"
#include "RenderConfig.h"

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
    renderer_ptr = std::make_shared<AdaptiveCardQmlRenderer>(AdaptiveCardQmlRenderer(hostConfig));
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
    auto renderConfig=std::make_shared<RenderConfig>();
    RendererQml::InputTextConfig textInputConfig;
    textInputConfig.height = "16";
    textInputConfig.leftPadding = "16";
    textInputConfig.rightPadding = "16";
    textInputConfig.radius = "16";
    renderConfig->textInputConfig = textInputConfig;

    std::shared_ptr<AdaptiveSharedNamespace::HostConfig> hostConfig;
    if(theme.toStdString() == "Light")
    {
        hostConfig = std::make_shared<AdaptiveSharedNamespace::HostConfig>(AdaptiveSharedNamespace::HostConfig::DeserializeFromString(LightConfig::lightConfig));
    }
    else
    {
        hostConfig = std::make_shared<AdaptiveSharedNamespace::HostConfig>(AdaptiveSharedNamespace::HostConfig::DeserializeFromString(DarkConfig::darkConfig));
    }
    renderer_ptr = std::make_shared<AdaptiveCardQmlRenderer>(AdaptiveCardQmlRenderer(hostConfig));
    RendererQml::AdaptiveCardQmlRenderer::tmp = renderConfig;
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
