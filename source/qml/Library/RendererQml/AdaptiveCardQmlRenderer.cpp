#include "AdaptiveCardQmlRenderer.h"
#include "pch.h"

namespace RendererQml
{
	int AdaptiveCardQmlRenderer::containerCounter = 0;
	int AdaptiveCardQmlRenderer::imageCounter = 0;

	AdaptiveCardQmlRenderer::AdaptiveCardQmlRenderer()
		: AdaptiveCardQmlRenderer(std::make_shared<AdaptiveCards::HostConfig>())
	{
	}

	AdaptiveCardQmlRenderer::AdaptiveCardQmlRenderer(std::shared_ptr<AdaptiveCards::HostConfig> hostConfig)
		: AdaptiveCardsRendererBase(AdaptiveCards::SemanticVersion("1.2"))
	{
		SetObjectTypes();
		SetHostConfig(hostConfig);
	}

	std::shared_ptr<RenderedQmlAdaptiveCard> AdaptiveCardQmlRenderer::RenderCard(std::shared_ptr<AdaptiveCards::AdaptiveCard> card, AdaptiveCardDependency::OnClickFunction onClick)
	{
		std::shared_ptr<RenderedQmlAdaptiveCard> output;
		auto context = std::make_shared<AdaptiveRenderContext>(GetHostConfig(), GetElementRenderers());
		context->SetOnClickFunction(onClick);
		std::shared_ptr<QmlTag> tag;

		try
		{
			context->SetLang(card->GetLanguage());
			tag = context->Render(card, &AdaptiveCardRender);
			output = std::make_shared<RenderedQmlAdaptiveCard>(tag, card, context->GetWarnings());
		}
		catch (const std::exception & e)
		{
			context->AddWarning(AdaptiveWarning(Code::RenderException, e.what()));
		}

		return output;
	}    

    void AdaptiveCardQmlRenderer::SetObjectTypes()
    {
        (*GetElementRenderers()).Set<AdaptiveCards::TextBlock>(AdaptiveCardQmlRenderer::TextBlockRender);
        (*GetElementRenderers()).Set<AdaptiveCards::RichTextBlock>(AdaptiveCardQmlRenderer::RichTextBlockRender);
        (*GetElementRenderers()).Set<AdaptiveCards::Image>(AdaptiveCardQmlRenderer::ImageRender);
        /*(*GetElementRenderers()).Set<AdaptiveCards::Media>(AdaptiveCardQmlRenderer::MediaRender);*/
        (*GetElementRenderers()).Set<AdaptiveCards::Container>(AdaptiveCardQmlRenderer::ContainerRender);
        /*(*GetElementRenderers()).Set<AdaptiveCards::Column>(AdaptiveCardQmlRenderer::ColumnRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ColumnSet>(AdaptiveCardQmlRenderer::ColumnSetRender);*/
        (*GetElementRenderers()).Set<AdaptiveCards::FactSet>(AdaptiveCardQmlRenderer::FactSetRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ImageSet>(AdaptiveCardQmlRenderer::ImageSetRender);
        /*(*GetElementRenderers()).Set<AdaptiveCards::ActionSet>(AdaptiveCardQmlRenderer::ActionSetRender);*/
        (*GetElementRenderers()).Set<AdaptiveCards::ChoiceSetInput>(AdaptiveCardQmlRenderer::ChoiceSetRender);
        (*GetElementRenderers()).Set<AdaptiveCards::TextInput>(AdaptiveCardQmlRenderer::TextInputRender);
        (*GetElementRenderers()).Set<AdaptiveCards::NumberInput>(AdaptiveCardQmlRenderer::NumberInputRender);
        (*GetElementRenderers()).Set<AdaptiveCards::DateInput>(AdaptiveCardQmlRenderer::DateInputRender);
        (*GetElementRenderers()).Set<AdaptiveCards::TimeInput>(AdaptiveCardQmlRenderer::TimeInputRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ToggleInput>(AdaptiveCardQmlRenderer::ToggleInputRender);
        /*(*GetElementRenderers()).Set<AdaptiveCards::SubmitAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);
        (*GetElementRenderers()).Set<AdaptiveCards::OpenUrlAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ShowCardAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ToggleVisibilityAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);
        (*GetElementRenderers()).Set<AdaptiveCards::SubmitAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);*/
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::AdaptiveCardRender(std::shared_ptr<AdaptiveCards::AdaptiveCard> card, std::shared_ptr<AdaptiveRenderContext> context)
    {
        auto uiCard = std::make_shared<QmlTag>("Rectangle");
        uiCard->AddImports("import QtQuick 2.15");
        uiCard->AddImports("import QtQuick.Layouts 1.3");
        uiCard->AddImports("import QtQuick.Controls 2.15");
        uiCard->AddImports("import QtGraphicalEffects 1.15");
        uiCard->SetProperty("id", "adaptiveCard");
        uiCard->SetProperty("implicitHeight", "adaptiveCardLayout.implicitHeight");
        //TODO: Width can be set as config
        uiCard->SetProperty("width", "600");

		auto columnLayout = std::make_shared<QmlTag>("ColumnLayout");
		columnLayout->SetProperty("id", "adaptiveCardLayout");
		columnLayout->SetProperty("width", "parent.width");
		uiCard->AddChild(columnLayout);

		auto rectangle = std::make_shared<QmlTag>("Rectangle");
		rectangle->SetProperty("id", "adaptiveCardRectangle");
		rectangle->SetProperty("color", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));
		rectangle->SetProperty("Layout.margins", std::to_string(context->GetConfig()->GetSpacing().paddingSpacing));
		rectangle->SetProperty("Layout.fillWidth", "true");
		rectangle->SetProperty("Layout.preferredHeight", "40");

		if (card->GetMinHeight() > 0)
		{
			rectangle->SetProperty("Layout.minimumHeight", std::to_string(card->GetMinHeight()));
		}
		columnLayout->AddChild(rectangle);

		//TODO: Add card vertical content alignment

		AddContainerElements(rectangle, card->GetBody(), context);

		return uiCard;
	}

    void AdaptiveCardQmlRenderer::AddContainerElements(std::shared_ptr<QmlTag> uiContainer, const std::vector<std::shared_ptr<AdaptiveCards::BaseCardElement>>& elements, std::shared_ptr<AdaptiveRenderContext> context)
    {
        if (!elements.empty())
        {
            auto bodyLayout = std::make_shared<QmlTag>("Column");
            bodyLayout->SetProperty("id", "bodyLayout");
            bodyLayout->SetProperty("width", "parent.width");
            //TODO: Set spacing from host config
            bodyLayout->SetProperty("spacing", "8");
            uiContainer->SetProperty("Layout.preferredHeight", "bodyLayout.height");
            uiContainer->AddChild(bodyLayout);

            for (const auto& cardElement : elements)
            {
                auto uiElement = context->Render(cardElement);

                if (uiElement != nullptr)
                {
                    //TODO: Add separator
                    //TODO: Add collection element
                    bodyLayout->AddChild(uiElement);
                }
            }
        }
    }

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::TextBlockRender(std::shared_ptr<AdaptiveCards::TextBlock> textBlock, std::shared_ptr<AdaptiveRenderContext> context)
	{
		//TODO:Parse markdown in the text

		//TODO: To get the Qml equivalant of monospace fontType and add it to config
		std::string fontFamily = context->GetConfig()->GetFontFamily(textBlock->GetFontType());
		int fontSize = context->GetConfig()->GetFontSize(textBlock->GetFontType(), textBlock->GetTextSize());

		auto uiTextBlock = std::make_shared<QmlTag>("Text");
		std::string textType = textBlock->GetElementTypeString();
		std::string horizontalAlignment = AdaptiveCards::EnumHelpers::getHorizontalAlignmentEnum().toString(textBlock->GetHorizontalAlignment());

		uiTextBlock->SetProperty("width", "parent.width");
		uiTextBlock->SetProperty("elide", "Text.ElideRight");
		uiTextBlock->SetProperty("text", "\"" + textBlock->GetText() + "\"");

		uiTextBlock->SetProperty("horizontalAlignment", Utils::GetHorizontalAlignment(horizontalAlignment));

		//TODO: Need to fix the color calculation
		std::string color = context->GetColor(textBlock->GetTextColor(), textBlock->GetIsSubtle(), false);

		uiTextBlock->SetProperty("color", color);

		//Value based on what is mentioned in the html renderer
		uiTextBlock->SetProperty("lineHeight", "1.33");

		uiTextBlock->SetProperty("font.pixelSize", std::to_string(fontSize));

		//TODO: lighter weight showing same behaviour as default
		uiTextBlock->SetProperty("font.weight", Utils::GetWeight(textBlock->GetTextWeight()));

		if (!textBlock->GetId().empty())
		{
			uiTextBlock->SetProperty("id", textBlock->GetId());
		}

		if (!textBlock->GetIsVisible())
		{
			uiTextBlock->SetProperty("visible", "false");
		}

		if (textBlock->GetMaxLines() > 0)
		{
			uiTextBlock->SetProperty("maximumLineCount", std::to_string(textBlock->GetMaxLines()));
		}

		if (textBlock->GetWrap())
		{
			uiTextBlock->SetProperty("wrapMode", "Text.WordWrap");
		}

		if (!fontFamily.empty())
		{
			uiTextBlock->SetProperty("font.family", fontFamily);
		}

		return uiTextBlock;

	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::TextInputRender(std::shared_ptr<AdaptiveCards::TextInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
		//TODO: Add inline action

		std::shared_ptr<QmlTag> uiTextInput;
		std::shared_ptr<QmlTag> scrollViewTag;

		if (input->GetIsMultiline())
		{
			scrollViewTag = std::make_shared<QmlTag>("ScrollView");
			scrollViewTag->SetProperty("width", "parent.width");
			scrollViewTag->SetProperty("height", "50");
			scrollViewTag->SetProperty("ScrollBar.vertical.interactive", "true");

			uiTextInput = std::make_shared<QmlTag>("TextArea");
			uiTextInput->SetProperty("id", input->GetId());
			uiTextInput->SetProperty("wrapMode", "Text.Wrap");
			uiTextInput->SetProperty("padding", "10");

			if (input->GetMaxLength() > 0)
			{
				uiTextInput->SetProperty("onTextChanged", Formatter() << "remove(" << input->GetMaxLength() << ", length)");
			}

			scrollViewTag->AddChild(uiTextInput);
		}
		else
		{
			uiTextInput = std::make_shared<QmlTag>("TextField");
			uiTextInput->SetProperty("id", input->GetId());
			uiTextInput->SetProperty("width", "parent.width");

			if (input->GetMaxLength() > 0)
			{
				uiTextInput->SetProperty("maximumLength", std::to_string(input->GetMaxLength()));
			}
		}

		uiTextInput->SetProperty("font.pixelSize", std::to_string(context->GetConfig()->GetFontSize(AdaptiveSharedNamespace::FontType::Default, AdaptiveSharedNamespace::TextSize::Default)));

		auto glowTag = std::make_shared<QmlTag>("Glow");
		glowTag->SetProperty("samples", "25");
		glowTag->SetProperty("color", "'skyblue'");

		auto backgroundTag = std::make_shared<QmlTag>("Rectangle");
		backgroundTag->SetProperty("radius", "5");
		//TODO: These color styling should come from css
		backgroundTag->SetProperty("color", Formatter() << input->GetId() << ".hovered ? 'lightgray' : 'white'");
		backgroundTag->SetProperty("border.color", Formatter() << input->GetId() << ".activeFocus? 'black' : 'grey'");
		backgroundTag->SetProperty("border.width", "1");
		backgroundTag->SetProperty("layer.enabled", Formatter() << input->GetId() << ".activeFocus ? true : false");
		backgroundTag->SetProperty("layer.effect", glowTag->ToString());
		uiTextInput->SetProperty("background", backgroundTag->ToString());

		if (!input->GetValue().empty())
		{
			uiTextInput->SetProperty("text", "\"" + input->GetValue() + "\"");
		}

		if (!input->GetPlaceholder().empty())
		{
			uiTextInput->SetProperty("placeholderText", "\"" + input->GetPlaceholder() + "\"");
		}

		//TODO: Add stretch property

		if (!input->GetIsVisible())
		{
			uiTextInput->SetProperty("visible", "false");
		}

		if (input->GetIsMultiline())
		{
			return scrollViewTag;
		}

		return uiTextInput;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::NumberInputRender(std::shared_ptr<AdaptiveCards::NumberInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
		const auto inputId = input->GetId();

		auto glowTag = std::make_shared<QmlTag>("Glow");
		glowTag->SetProperty("samples", "25");
		glowTag->SetProperty("color", "'skyblue'");

		auto backgroundTag = std::make_shared<QmlTag>("Rectangle");
		backgroundTag->SetProperty("radius", "5");
		//TODO: These color styling should come from css
		backgroundTag->SetProperty("color", Formatter() << inputId + "_contentItem" << ".hovered ? 'lightgray' : 'white'");
		backgroundTag->SetProperty("layer.enabled", Formatter() << inputId + "_contentItem" << ".activeFocus ? true : false");
		backgroundTag->SetProperty("layer.effect", glowTag->ToString());

		auto contentItemTag = std::make_shared<QmlTag>("TextField");
		contentItemTag->SetProperty("id", inputId + "_contentItem");
		contentItemTag->SetProperty("padding", "10");
		contentItemTag->SetProperty("font.pixelSize", std::to_string(context->GetConfig()->GetFontSize(AdaptiveSharedNamespace::FontType::Default, AdaptiveSharedNamespace::TextSize::Default)));
		contentItemTag->SetProperty("readOnly", Formatter() << "!" << inputId << ".editable");
		contentItemTag->SetProperty("validator", Formatter() << inputId << ".validator");
		contentItemTag->SetProperty("inputMethodHints", "Qt.ImhFormattedNumbersOnly");
		contentItemTag->SetProperty("text", Formatter() << inputId << ".textFromValue(" << inputId << ".value, " << inputId << ".locale)");
		if (!input->GetPlaceholder().empty())
		{
			contentItemTag->SetProperty("placeholderText", "\"" + input->GetPlaceholder() + "\"");
		}
		contentItemTag->SetProperty("background", backgroundTag->ToString());

		auto doubleValidatorTag = std::make_shared<QmlTag>("DoubleValidator");

		auto uiNumberInput = std::make_shared<QmlTag>("SpinBox");
		uiNumberInput->SetProperty("id", input->GetId());
		uiNumberInput->SetProperty("width", "parent.width");
		uiNumberInput->SetProperty("stepSize", "1");
		uiNumberInput->SetProperty("editable", "true");
		uiNumberInput->SetProperty("validator", doubleValidatorTag->ToString());

		if ((input->GetMin() == input->GetMax() && input->GetMin() == 0) || input->GetMin() > input->GetMax())
		{
			input->SetMin(INT_MIN);
			input->SetMax(INT_MAX);
		}
		if (input->GetValue() < input->GetMin())
		{
			input->SetValue(input->GetMin());
		}
		if (input->GetValue() > input->GetMax())
		{
			input->SetValue(input->GetMax());
		}

		uiNumberInput->SetProperty("from", std::to_string(input->GetMin().value()));
		uiNumberInput->SetProperty("to", std::to_string(input->GetMax().value()));
		uiNumberInput->SetProperty("value", std::to_string(input->GetValue().value()));

		//TODO: Add stretch property

		if (!input->GetIsVisible())
		{
			uiNumberInput->SetProperty("visible", "false");
		}

		uiNumberInput->SetProperty("contentItem", contentItemTag->ToString());

		return uiNumberInput;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::RichTextBlockRender(std::shared_ptr<AdaptiveCards::RichTextBlock> richTextBlock, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto uiTextBlock = std::make_shared<QmlTag>("Text");
		std::string textType = richTextBlock->GetElementTypeString();
		std::string horizontalAlignment = AdaptiveCards::EnumHelpers::getHorizontalAlignmentEnum().toString(richTextBlock->GetHorizontalAlignment());

		uiTextBlock->SetProperty("textFormat", "Text.RichText");
		uiTextBlock->SetProperty("wrapMode", "Text.WordWrap");
		uiTextBlock->SetProperty("width", "parent.width");

		uiTextBlock->SetProperty("horizontalAlignment", Utils::GetHorizontalAlignment(horizontalAlignment));
		std::string textrun_all = "\"";

		if (!richTextBlock->GetIsVisible())
		{
			uiTextBlock->SetProperty("visible", "false");
		}

		for (const auto& inlineRun : richTextBlock->GetInlines())
		{
			if (Utils::IsInstanceOfSmart<AdaptiveCards::TextRun>(inlineRun))
			{
				auto textRun = std::dynamic_pointer_cast<AdaptiveCards::TextRun>(inlineRun);
				textrun_all.append(TextRunRender(textRun, context));
			}
		}
		textrun_all = textrun_all.append("\"");
		uiTextBlock->SetProperty("text", textrun_all);

		return uiTextBlock;

	}

	std::string AdaptiveCardQmlRenderer::TextRunRender(std::shared_ptr<AdaptiveCards::TextRun> textRun, std::shared_ptr<AdaptiveRenderContext> context)
	{
		const std::string fontFamily = context->GetConfig()->GetFontFamily(textRun->GetFontType());
		const int fontSize = context->GetConfig()->GetFontSize(textRun->GetFontType(), textRun->GetTextSize());
		const int weight = context->GetConfig()->GetFontWeight(textRun->GetFontType(), textRun->GetTextWeight());

		//Value based on what is mentioned in the html renderer
		const auto lineHeight = fontSize * 1.33;

		std::string uiTextRun = "<span style='";
		std::string textType = textRun->GetInlineTypeString();

		//TODO: Add font to hostconfig
		uiTextRun.append("font-family:" + std::string("\\\"") + fontFamily + std::string("\\\"") + ";");

		//TODO: Need to fix the color calculation
		std::string color = context->GetColor(textRun->GetTextColor(), textRun->GetIsSubtle(), false).substr(3);
		uiTextRun.append("color:" + color + ";");

		std::string lineheight = Formatter() << std::fixed << std::setprecision(2) << lineHeight << "px";
		uiTextRun.append("line-height:" + lineheight + ";");

		uiTextRun.append("font-size:" + std::to_string(fontSize) + "px" + ";");

		uiTextRun.append("font-weight:" + std::to_string(weight) + ";");

		//TODO: Exact calculation for background color
		if (textRun->GetHighlight())
		{
			uiTextRun.append("background-color:" + Utils::GetTextHighlightColor(color) + ";");
		}

		if (textRun->GetItalic())
		{
			uiTextRun.append("font-style:" + std::string("italic") + ";");
		}

		if (textRun->GetStrikethrough())
		{
			uiTextRun.append("text-decoration:" + std::string("line-through") + ";");
		}

		uiTextRun.append("'>");
		uiTextRun.append(TextUtils::ApplyTextFunctions(textRun->GetText(), context->GetLang()));
		uiTextRun.append("</span>");

		return uiTextRun;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ToggleInputRender(std::shared_ptr<AdaptiveCards::ToggleInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
		const auto valueOn = !input->GetValueOn().empty() ? input->GetValueOn() : "true";
		const auto valueOff = !input->GetValueOff().empty() ? input->GetValueOff() : "false";
		const bool isChecked = input->GetValue().compare(valueOn) == 0 ? true : false;

		//TODO: Add Height
		return GetCheckBox(RendererQml::Checkbox(input->GetId(),
			CheckBoxType::Toggle,
			input->GetTitle(),
			input->GetValue(),
			valueOn,
			valueOff,
			context->GetConfig()->GetFontSize(AdaptiveCards::FontType::Default, AdaptiveCards::TextSize::Default),
			input->GetWrap(),
			input->GetIsVisible(),
			isChecked));

	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ChoiceSetRender(std::shared_ptr<AdaptiveCards::ChoiceSetInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
		int ButtonNumber = 0;
		RendererQml::Checkboxes choices;
		const std::string id = input->GetId();
		enum CheckBoxType type = !input->GetIsMultiSelect() && input->GetChoiceSetStyle() == AdaptiveCards::ChoiceSetStyle::Compact ? ComboBox : input->GetIsMultiSelect() ? CheckBox : RadioButton;
		const int fontSize = context->GetConfig()->GetFontSize(AdaptiveCards::FontType::Default, AdaptiveCards::TextSize::Default);
		const bool isWrap = input->GetWrap();
		const bool isVisible = input->GetIsVisible();
		bool isChecked;

		std::vector<std::string> parsedValues;
		parsedValues = Utils::ParseChoiceSetInputDefaultValues(input->GetValue());

		for (const auto& choice : input->GetChoices())
		{
			isChecked = (std::find(parsedValues.begin(), parsedValues.end(), choice->GetValue()) != parsedValues.end() && (input->GetIsMultiSelect() || parsedValues.size() == 1)) ? true : false;
			choices.emplace_back(RendererQml::Checkbox(id + GenerateButtonId(type, ButtonNumber++),
				type,
				choice->GetTitle(),
				choice->GetValue(),
				fontSize,
				isWrap,
				isVisible,
				isChecked));
		}

		RendererQml::ChoiceSet choiceSet(id,
			input->GetIsMultiSelect(),
			input->GetChoiceSetStyle(),
			parsedValues,
			choices,
			input->GetPlaceholder());

		if (CheckBoxType::ComboBox == type)
		{
			return GetComboBox(choiceSet);
		}
		else
		{
			return GetButtonGroup(choiceSet);
		}

		std::shared_ptr<QmlTag> uiColumn;
		return uiColumn;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetComboBox(ChoiceSet choiceset)
	{
		auto uiComboBox = std::make_shared<QmlTag>("ComboBox");
				
		uiComboBox->SetProperty("id",choiceset.id);
		uiComboBox->SetProperty("textRole", "'text'");
		uiComboBox->SetProperty("valueRole", "'value'");
		uiComboBox->SetProperty("width", "parent.width");
		//TODO : Add Height
				
		uiComboBox->SetProperty("model", GetModel(choiceset.choices)); 
				
		if (!choiceset.placeholder.empty())
		{
			uiComboBox->SetProperty("currentIndex", "-1");
			uiComboBox->SetProperty("displayText", "currentIndex === -1 ? '" + choiceset.placeholder + "' : currentText");
		}
		else if (choiceset.values.size() ==1)
		{
			std::string target = choiceset.values[0];
			auto index = std::find_if(choiceset.choices.begin(), choiceset.choices.end(), [target](const Checkbox& options) {
				return options.value == target;
				}) - choiceset.choices.begin();
			uiComboBox->SetProperty("currentIndex", std::to_string(index));
			uiComboBox->SetProperty("displayText", "currentText");
		}
		
		auto uiItemDelegate = std::make_shared<QmlTag>("ItemDelegate");
		uiItemDelegate->SetProperty("width", "parent.width");
		
		auto uiItemDelegate_Text = std::make_shared<QmlTag>("Text");
		uiItemDelegate_Text->SetProperty("text", "modelData.text");
		uiItemDelegate_Text->SetProperty("font", "parent.font");
		uiItemDelegate_Text->SetProperty("verticalAlignment", "Text.AlignVCenter");

		if (choiceset.choices[0].isWrap)
		{
			uiItemDelegate_Text->SetProperty("wrapMode", "Text.Wrap");
		}
		else
		{
			uiItemDelegate_Text->SetProperty("elide", "Text.ElideRight");
		}

		uiItemDelegate->SetProperty("contentItem", uiItemDelegate_Text->ToString());
				
		uiComboBox->SetProperty("delegate", uiItemDelegate->ToString());

		auto uiContentItem_Text = std::make_shared<QmlTag>("Text");
		uiContentItem_Text->SetProperty("text", "parent.displayText");
		uiContentItem_Text->SetProperty("font", "parent.font");
		uiContentItem_Text->SetProperty("verticalAlignment", "Text.AlignVCenter");
		uiContentItem_Text->SetProperty("leftPadding", "parent.font.pixelSize + parent.spacing");
		uiContentItem_Text->SetProperty("elide", "Text.ElideRight");
				
		uiComboBox->SetProperty("contentItem", uiContentItem_Text->ToString());
				
		return uiComboBox;
	}

	std::string AdaptiveCardQmlRenderer::GetModel(std::vector<Checkbox>& Choices)
	{
		std::ostringstream model;
		model << "[";
		for (const auto& choice : Choices)
		{
			model << "{ value: '" << choice.value << "', text: '" << choice.text << "'},\n";
		}
		model << "]";
		return model.str();
	}

	// Default values are specified by a comma separated string
	std::vector<std::string> Utils::ParseChoiceSetInputDefaultValues(const std::string& value)
	{
		std::vector<std::string> parsedValues;
		std::string element;
		std::stringstream ss(value);
		while (std::getline(ss, element, ','))
		{
			Utils::Trim(element);		
			if (!element.empty())
			{
				parsedValues.push_back(element);
			}
		}
		return parsedValues;
	}

	std::string AdaptiveCardQmlRenderer::GenerateButtonId(enum CheckBoxType ButtonType, int  ButtonNumber)
	{
		
		return "_" + std::to_string(ButtonType) + "_" + std::to_string(ButtonNumber);
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetButtonGroup(ChoiceSet choiceset)
	{
		auto uiColumn = std::make_shared<QmlTag>("Column");
	
		auto uiButtonGroup = std::make_shared<QmlTag>("ButtonGroup");
	
		uiButtonGroup->SetProperty("id", choiceset.id);
	
		if (choiceset.isMultiSelect)
		{
			uiButtonGroup->SetProperty("buttons", choiceset.id + "_checkbox.children");
			uiButtonGroup->SetProperty("exclusive", "false");
		}
		else
		{
			uiButtonGroup->SetProperty("buttons", choiceset.id + "_radio.children");
		}
	
		uiColumn->AddChild(uiButtonGroup);
	
		auto uiInnerColumn = std::make_shared<QmlTag>("ColumnLayout");
	
		if (choiceset.isMultiSelect)
		{
			uiInnerColumn->SetProperty("id", choiceset.id + "_checkbox");
		}
		else
		{
			uiInnerColumn->SetProperty("id", choiceset.id + "_radio");
		}
	
		// render as a series of buttons
		for (const auto& choice : choiceset.choices)
		{
			uiInnerColumn->AddChild(GetCheckBox(choice));
		}
	
		uiColumn->AddChild(uiInnerColumn);
		return uiColumn;
	}


	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetCheckBox(Checkbox checkbox)
	{
		std::shared_ptr<QmlTag> uiButton;

		if (checkbox.type == CheckBoxType::RadioButton)
		{
			uiButton = std::make_shared<QmlTag>("RadioButton");
		}
		else
		{
			uiButton = std::make_shared<QmlTag>("CheckBox");
		}

		if (checkbox.type == CheckBoxType::Toggle)
		{
			uiButton->SetProperty("readonly property string valueOn", "\"" + checkbox.valueOn + "\"");
			uiButton->SetProperty("readonly property string valueOff", "\"" + checkbox.valueOff + "\"");
		}

		uiButton->SetProperty("id", checkbox.id);
		uiButton->SetProperty("text", "\"" + checkbox.text + "\"");
		uiButton->SetProperty("width", "parent.width");
		uiButton->SetProperty("font.pixelSize", std::to_string(checkbox.fontSize));

		if (!checkbox.isVisible)
		{
			uiButton->SetProperty("visible", "false");
		}
		
		if (checkbox.isChecked)
		{
			uiButton->SetProperty("checked", "true");
		}
	
		auto uiOuterRectangle = std::make_shared<QmlTag>("Rectangle");
		uiOuterRectangle->SetProperty("width", "parent.font.pixelSize");
		uiOuterRectangle->SetProperty("height", "parent.font.pixelSize");
		uiOuterRectangle->SetProperty("y", "parent.topPadding + (parent.availableHeight - height) / 2");
		if (checkbox.type == CheckBoxType::RadioButton)
		{
			uiOuterRectangle->SetProperty("radius", "height/2"); 
		}
		else
		{
			uiOuterRectangle->SetProperty("radius", "3");
		}
		uiOuterRectangle->SetProperty("border.color", checkbox.id + ".checked ? '#0075FF' : '767676'");
	
		//To be replaced with image of checkmark.
		auto uiInnerRectangle = std::make_shared<QmlTag>("Rectangle");
		uiInnerRectangle->SetProperty("width", "parent.width/2");
		uiInnerRectangle->SetProperty("height", "parent.height/2");
		uiInnerRectangle->SetProperty("x", "width/2");
		uiInnerRectangle->SetProperty("y", "height/2");
		if (checkbox.type == CheckBoxType::RadioButton)
		{
			uiInnerRectangle->SetProperty("radius", "height/2");
		}
		else
		{
			uiInnerRectangle->SetProperty("radius", "2"); 
		}
		uiInnerRectangle->SetProperty("color", checkbox.id + ".down ? '#ffffff' : '#0075FF'");
		uiInnerRectangle->SetProperty("visible", checkbox.id + ".checked");
	
		uiOuterRectangle->AddChild(uiInnerRectangle);
	
		uiButton->SetProperty("indicator", uiOuterRectangle->ToString());
	
		auto uiText = std::make_shared<QmlTag>("Text");
		uiText->SetProperty("text", "parent.text");
		uiText->SetProperty("font", "parent.font");
		uiText->SetProperty("horizontalAlignment", "Text.AlignLeft");
		uiText->SetProperty("verticalAlignment", "Text.AlignVCenter");
		uiText->SetProperty("leftPadding", "parent.indicator.width + parent.spacing");
	
		if (checkbox.isWrap)
		{
			uiText->SetProperty("wrapMode", "Text.Wrap");
		}
		else
		{
			uiText->SetProperty("elide", "Text.ElideRight");
		}
	
		uiButton->SetProperty("contentItem", uiText->ToString());
	
		return uiButton;
	}
    
    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::DateInputRender(std::shared_ptr<AdaptiveCards::DateInput> input, std::shared_ptr<AdaptiveRenderContext> context)
    {
        auto uiDateInput = std::make_shared<QmlTag>("TextField");

        uiDateInput->SetProperty("id", input->GetId());
        uiDateInput->SetProperty("width", "parent.width");
        const int fontSize = context->GetConfig()->GetFontSize(AdaptiveCards::FontType::Default, AdaptiveCards::TextSize::Default);

        uiDateInput->SetProperty("font.family", "\"" + context->GetConfig()->GetFontFamily(AdaptiveCards::FontType::Default) + "\"");
        uiDateInput->SetProperty("font.pixelSize", std::to_string(fontSize));


        uiDateInput->SetProperty("placeholderText", Formatter() << (!input->GetPlaceholder().empty() ? "\"" + input->GetPlaceholder() + "\"" : "\"mm-dd-yyyy\""));

        if (!input->GetValue().empty())
        {
            uiDateInput->SetProperty("text", "\"" + Utils::GetDate(input->GetValue(), false) + "\"");
        }

        //TODO: Add stretch property

        if (!input->GetIsVisible())
        {
            uiDateInput->SetProperty("visible", "false");
        }

        uiDateInput->SetProperty("validator", "RegExpValidator { regExp: /^(0[0-9]|1[0-2])-(0?[0-9]|[12][0-9]|3[01])-(\\d{4})$/}");

        std::string calendar_box_id = input->GetId() + "_cal_box";

        uiDateInput->SetProperty("onFocusChanged", Formatter() << "{" << "if(focus==true) inputMask=\"00-00-0000;0\";" << "if(activeFocus === false){ z=0; if( " << calendar_box_id << ".visible === true){ " << calendar_box_id << ".visible=false}}} ");

        auto glowTag = std::make_shared<QmlTag>("Glow");
        glowTag->SetProperty("samples", "25");
        glowTag->SetProperty("color", "'skyblue'");

        auto backgroundTag = std::make_shared<QmlTag>("Rectangle");
        backgroundTag->SetProperty("radius", "5");
        //TODO: These color styling should come from css
        backgroundTag->SetProperty("color", Formatter() << input->GetId() << ".hovered ? 'lightgray' : 'white'");
        backgroundTag->SetProperty("border.color", Formatter() << input->GetId() << ".activeFocus? 'black' : 'grey'");
        backgroundTag->SetProperty("border.width", "1");
        backgroundTag->SetProperty("layer.enabled", Formatter() << input->GetId() << ".activeFocus ? true : false");
        backgroundTag->SetProperty("layer.effect", glowTag->ToString());
        uiDateInput->SetProperty("background", backgroundTag->ToString());

        auto imageTag = std::make_shared<QmlTag>("Image");
        imageTag->SetProperty("anchors.fill", "parent");
        imageTag->SetProperty("anchors.margins", "5");

        //Finding absolute Path at runtime
        std::string file_path = __FILE__;
        std::string dir_path = file_path.substr(0, file_path.rfind("\\"));
        dir_path.append("\\Images\\calendarIcon.png");
        std::replace(dir_path.begin(), dir_path.end(), '\\', '/');
        imageTag->SetProperty("source", "\"" + std::string("file:/") + dir_path + "\"");

        //Relative wrt main.qml not working
        //imageTag->SetProperty("source", "\"" + std::string("file:/../../Library/RendererQml/Images/calendarIcon.png") + "\"");


        auto mouseAreaTag = std::make_shared<QmlTag>("MouseArea");

        mouseAreaTag->AddChild(imageTag);
        mouseAreaTag->SetProperty("height", "parent.height");
        mouseAreaTag->SetProperty("width", "height");
        mouseAreaTag->SetProperty("anchors.right", "parent.right");
        mouseAreaTag->SetProperty("enabled", "true");

        std::string onClicked_value = "{ parent.focus=true; " + calendar_box_id + ".visible=!" + calendar_box_id + ".visible; parent.z=" + calendar_box_id + ".visible?1:0; }";
        mouseAreaTag->SetProperty("onClicked", onClicked_value);

        uiDateInput->AddChild(mouseAreaTag);

        auto calendarTag = std::make_shared<QmlTag>("Calendar");
        calendarTag->AddImports("import QtQuick.Controls 1.4");
        calendarTag->SetProperty("anchors.fill", "parent");
        calendarTag->SetProperty("minimumDate", !input->GetMin().empty() ? Utils::GetDate(input->GetMin(), true) : "new Date(1900,1,1)");
        calendarTag->SetProperty("maximumDate", !input->GetMax().empty() ? Utils::GetDate(input->GetMax(), true) : "new Date(2050,1,1)");
        calendarTag->SetProperty("onReleased", "{parent.visible=false; " + input->GetId() + ".text=selectedDate.toLocaleString(Qt.locale(\"en_US\"), \"MM-dd-yyyy\")}");

        auto calendarBoxTag = std::make_shared<QmlTag>("Rectangle");
        calendarBoxTag->SetProperty("id", calendar_box_id);
        calendarBoxTag->SetProperty("visible", "false");
        calendarBoxTag->SetProperty("anchors.left", "parent.left");
        calendarBoxTag->SetProperty("anchors.top", "parent.bottom");
        calendarBoxTag->SetProperty("width", "275");
        calendarBoxTag->SetProperty("height", "275");
        calendarBoxTag->SetProperty("Component.onCompleted", "{ Qt.createQmlObject('" + calendarTag->ToString() + "'," + calendar_box_id + ",'calendar')}");
        uiDateInput->AddChild(calendarBoxTag);

        return uiDateInput;
    }

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::FactSetRender(std::shared_ptr<AdaptiveCards::FactSet> factSet, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto uiFactSet = std::make_shared<QmlTag>("Column");

		if (!factSet->GetIsVisible())
		{
			uiFactSet->SetProperty("visible", "false");
		}

		for (const auto fact : factSet->GetFacts())
		{
			auto uiRow = std::make_shared<QmlTag>("RowLayout");

			auto factTitle = std::make_shared<AdaptiveCards::TextBlock>();

			factTitle->SetText(fact->GetTitle());
			factTitle->SetTextSize(context->GetConfig()->GetFactSet().title.size);
			factTitle->SetTextColor(context->GetConfig()->GetFactSet().title.color);
			factTitle->SetTextWeight(context->GetConfig()->GetFactSet().title.weight);
			factTitle->SetIsSubtle(context->GetConfig()->GetFactSet().title.isSubtle);
			factTitle->SetWrap(context->GetConfig()->GetFactSet().title.wrap);

			//TODO: cpp Object Model does not support max width.
			//factTitle->SetMaxWidth(context->GetConfig()->GetFactSet().title.maxWidth);

			auto uiTitle = context->Render(factTitle);

			//uiTitle->SetProperty("spacing", std::to_string(context->GetConfig()->GetFactSet().spacing));
			
			auto factValue = std::make_shared<AdaptiveCards::TextBlock>();

			factValue->SetText(fact->GetValue());
			factValue->SetTextSize(context->GetConfig()->GetFactSet().value.size);
			factValue->SetTextColor(context->GetConfig()->GetFactSet().value.color);
			factValue->SetTextWeight(context->GetConfig()->GetFactSet().value.weight);
			factValue->SetIsSubtle(context->GetConfig()->GetFactSet().value.isSubtle);
			factValue->SetWrap(context->GetConfig()->GetFactSet().value.wrap);
			// MaxWidth is not supported on the Value of FactSet. Do not set it.

			auto uiValue = context->Render(factValue);

			uiRow->AddChild(uiTitle);
			uiRow->AddChild(uiValue);
			uiFactSet->AddChild(uiRow);
		}

		return uiFactSet;
    }
  
	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ImageRender(std::shared_ptr<AdaptiveCards::Image> image, std::shared_ptr<AdaptiveRenderContext> context)
	{
		//TODO: Height(Stretch/Automatic)

		std::shared_ptr<QmlTag> maskTag;
		auto uiRectangle = std::make_shared<QmlTag>("Rectangle");
		auto uiImage = std::make_shared<QmlTag>("Image");

		std::string file_path = __FILE__;
		std::string dir_path = file_path.substr(0, file_path.rfind("\\"));
		dir_path.append("\\Images\\Cat.png");
		std::replace(dir_path.begin(), dir_path.end(), '\\', '/');

		if (image->GetId().empty())
		{
			image->SetId(Formatter() << "image_auto_" << ++imageCounter);
		}

		uiImage->SetProperty("id", image->GetId());
		uiImage->SetProperty("source", "\"" + std::string("file:/") + dir_path + "\"");
		uiImage->SetProperty("width", "parent.width");
		uiImage->SetProperty("fillMode", "Image.PreserveAspectFit");
		
		uiRectangle->SetProperty("height", Formatter() << image->GetId() << ".implicitHeight");
		
		if (!image->GetIsVisible())
		{
			uiRectangle->SetProperty("visible", "false");
		}

		if (image->GetPixelWidth() != 0 || image->GetPixelHeight() != 0)
		{
			if (image->GetPixelWidth() != 0)
			{
				uiRectangle->SetProperty("width",  Formatter() << "Math.min(" << image->GetPixelWidth() << ", parent.width)");
			}
			if (image->GetPixelHeight() != 0)
			{
				uiRectangle->SetProperty("height", Formatter() << image->GetPixelHeight());
				uiImage->SetProperty("height", "parent.height");

				if (image->GetPixelWidth() == 0)
				{
					uiImage->RemoveProperty("width");
					uiImage->SetProperty("fillMode", "height < implicitHeight ? Image.PreserveAspectFit : Image.NoOption");
					uiRectangle->SetProperty("width", Formatter() << image->GetId() << ".width");
				}
				else
				{
					uiImage->RemoveProperty("fillMode");
				}
			}
		}
		else
		{
			switch (image->GetImageSize())
			{
			case AdaptiveCards::ImageSize::None:
			case AdaptiveCards::ImageSize::Auto:
				uiRectangle->SetProperty("width", "parent.width");
				uiImage->RemoveProperty("fillMode");
				break;
			case AdaptiveCards::ImageSize::Small:
				uiRectangle->SetProperty("width", Formatter() << context->GetConfig()->GetImageSizes().smallSize);
				break;
			case AdaptiveCards::ImageSize::Medium:
				uiRectangle->SetProperty("width", Formatter() << context->GetConfig()->GetImageSizes().mediumSize);
				break;
			case AdaptiveCards::ImageSize::Large:
				uiRectangle->SetProperty("width", Formatter() << context->GetConfig()->GetImageSizes().largeSize);
				break;
			case AdaptiveCards::ImageSize::Stretch:
				uiRectangle->SetProperty("width", "parent.width");
				uiImage->RemoveProperty("fillMode");
				break;
			}
		}

		if (!image->GetBackgroundColor().empty())
		{
			uiRectangle->SetProperty("color", context->GetRGBColor(image->GetBackgroundColor()));
		}

		switch (image->GetHorizontalAlignment())
		{
		case AdaptiveCards::HorizontalAlignment::Center:
			uiRectangle->SetProperty("anchors.horizontalCenter", "parent.horizontalCenter");
			break;
		case AdaptiveCards::HorizontalAlignment::Right:
			uiRectangle->SetProperty("anchors.right", "parent.right");
			break;
		default:
			break;
		}

		//TODO:calculation to get oval object
		switch (image->GetImageStyle())
		{
		case AdaptiveCards::ImageStyle::Default:
			break;
		case AdaptiveCards::ImageStyle::Person:
			maskTag = std::make_shared<QmlTag>("OpacityMask");
			maskTag->SetProperty("maskSource", "parent");
			uiImage->SetProperty("layer.enabled", "true");
			uiImage->SetProperty("layer.effect", maskTag->ToString());
			uiRectangle->SetProperty("radius", "width/2");
			break;
		}

		uiRectangle->AddChild(uiImage);

		return uiRectangle;
	}

	std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::GetNewColumn(std::shared_ptr<AdaptiveCards::Container> container, std::shared_ptr<AdaptiveRenderContext> context)
	{
		const auto margin = std::to_string(context->GetConfig()->GetSpacing().paddingSpacing);
		const auto spacing = Utils::GetSpacing(context->GetConfig()->GetSpacing(), container->GetSpacing());

		std::shared_ptr<QmlTag> uiColumn = std::make_shared<QmlTag>("Column");

		if (container->GetPadding())
        {
			uiColumn->SetProperty("Layout.margins", margin);
		}

		uiColumn->SetProperty("Layout.fillWidth", "true");
		uiColumn->SetProperty("spacing", std::to_string(spacing));

		if (container->GetVerticalContentAlignment() == AdaptiveCards::VerticalContentAlignment::Top)
        {
			uiColumn->SetProperty("Layout.alignment", "Qt.AlignTop");
		}
		else if (container->GetVerticalContentAlignment() == AdaptiveCards::VerticalContentAlignment::Bottom)
        {
			uiColumn->SetProperty("Layout.alignment", "Qt.AlignBottom");
		}

		return uiColumn;
	}

	std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::ContainerRender(std::shared_ptr<AdaptiveCards::Container> container, std::shared_ptr<AdaptiveRenderContext> context)
	{
		const auto margin = context->GetConfig()->GetSpacing().paddingSpacing;
		const auto spacing = Utils::GetSpacing(context->GetConfig()->GetSpacing(), container->GetSpacing());

		if (container->GetId().empty())
		{
			container->SetId(Formatter() << "container_auto_" << ++containerCounter);
		}

		const auto id = container->GetId();

		std::shared_ptr<QmlTag> uiContainer;
		std::shared_ptr<QmlTag> uiColumnLayout;
		std::shared_ptr<QmlTag> uiColumn = GetNewColumn(container,context);

		uiContainer = std::make_shared<QmlTag>("Frame");
		uiColumnLayout = std::make_shared<QmlTag>("ColumnLayout");
		uiContainer->AddChild(uiColumnLayout);

		uiContainer->SetProperty("readonly property int minHeight", std::to_string(container->GetMinHeight()));

		uiContainer->SetProperty("id", id);
		uiColumnLayout->SetProperty("id", "clayout_" + id);

		uiColumnLayout->SetProperty("anchors.fill", "parent");

		uiContainer->SetProperty("implicitHeight", "(minHeight > clayout_" + id + ".implicitHeight) ? minHeight : clayout_" + id + ".implicitHeight");

		uiContainer->SetProperty("padding", "0");
		uiColumnLayout->SetProperty("spacing", std::to_string(spacing));

		//TODO : Stretch property.
		for (const auto& containerElement : container->GetItems())
		{
			auto uiContainerElement = context->Render(containerElement);
			if (uiContainerElement != nullptr)
			{
				uiColumn->AddChild(uiContainerElement);
			}
		}

		uiColumnLayout->AddChild(uiColumn);

		if (container->GetBleed() && container->GetCanBleed())
        {
			uiContainer->SetProperty("x", Formatter() << "-" << std::to_string(margin));
			uiContainer->SetProperty("width", "parent.width + " + std::to_string(2*margin));
		}
		else
        {
			uiContainer->SetProperty("width", "parent.width");
		}

		if (container->GetBackgroundImage())
        {
			auto url = container->GetBackgroundImage()->GetUrl();

			std::string file_path = __FILE__;
			std::string dir_path = file_path.substr(0, file_path.rfind("\\"));
			dir_path.append("\\Images\\sampleImage.jpg");
			std::replace(dir_path.begin(), dir_path.end(), '\\', '/');

			uiContainer->SetProperty("background", "Image { source: \"" + std::string("file:/") + dir_path + "\"}");
		}
		else if(container->GetStyle() != AdaptiveCards::ContainerStyle::None)
        {
			const auto color = context->GetConfig()->GetBackgroundColor(container->GetStyle());
			uiContainer->SetProperty("background", "Rectangle{anchors.fill:parent;border.width:0;color:\"" + color + "\";}");
		}
        else
        {
            uiContainer->SetProperty("background", "Rectangle{border.width : 0;}");
        }

		return uiContainer;
  }
  
	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::TimeInputRender(std::shared_ptr<AdaptiveCards::TimeInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
		//TODO: Fetch System Time Format 
		bool is12hour = true;

		auto uiTimeInput = std::make_shared<QmlTag>("TextField");
		std::string id = input->GetId();

		uiTimeInput->SetProperty("id", id);
		uiTimeInput->SetProperty("width", "parent.width");
		uiTimeInput->SetProperty("placeholderText", !input->GetPlaceholder().empty() ? input->GetPlaceholder() : "\"Select time\"");

		uiTimeInput->SetProperty("validator", "RegExpValidator { regExp: /^(--|[01][0-9|-]|2[0-3|-]):(--|[0-5][0-9|-])$/}");

		std::string value = input->GetValue();
		if (!input->GetValue().empty() && Utils::isValidTime(value))
		{
			std::string defaultTime = value;
			if (is12hour == true)
			{
				defaultTime = Utils::defaultTimeto12hour(defaultTime);
			}
			uiTimeInput->SetProperty("text", Formatter() << "\"" << defaultTime << "\"");
		}

		if (!input->GetIsVisible())
		{
			uiTimeInput->SetProperty("visibile", "false");
		}

		//TODO: Height Property, Spacing Property

		std::string listViewHours_id = id + "_hours";
		std::string listViewMin_id = id + "_min";
		std::string listViewtt_id = id + "_tt";
		std::string timeBox_id = id + "_timeBox";

		uiTimeInput->SetProperty("onFocusChanged", Formatter() << "{ if (focus==true) inputMask=\"xx:xx;-\";" << " if(activeFocus==false){ z=0;" << "if(" << timeBox_id << ".visible==true)" << timeBox_id << ".visible=false ;" << "}}");

		uiTimeInput->SetProperty("onTextChanged", Formatter() << "{" << listViewHours_id << ".currentIndex=parseInt(getText(0,2));" << listViewMin_id << ".currentIndex=parseInt(getText(3,5));" << "}");

		auto glowTag = std::make_shared<QmlTag>("Glow");
		glowTag->SetProperty("samples", "25");
		glowTag->SetProperty("color", "'skyblue'");

		auto backgroundTag = std::make_shared<QmlTag>("Rectangle");
		backgroundTag->SetProperty("radius", "5");
		//TODO: These color styling should come from css
		backgroundTag->SetProperty("color", Formatter() << input->GetId() << ".hovered ? 'lightgray' : 'white'");
		backgroundTag->SetProperty("border.color", Formatter() << input->GetId() << ".activeFocus? 'black' : 'grey'");
		backgroundTag->SetProperty("border.width", "1");
		backgroundTag->SetProperty("layer.enabled", Formatter() << input->GetId() << ".activeFocus ? true : false");
		backgroundTag->SetProperty("layer.effect", glowTag->ToString());
		uiTimeInput->SetProperty("background", backgroundTag->ToString());

		auto imageTag = std::make_shared<QmlTag>("Image");
		imageTag->SetProperty("anchors.fill", "parent");
		imageTag->SetProperty("anchors.margins", "5");

		//Finding absolute Path at runtime
		std::string file_path = __FILE__;
		std::string dir_path = file_path.substr(0, file_path.rfind("\\"));
		dir_path.append("\\Images\\clockIcon.png");
		std::replace(dir_path.begin(), dir_path.end(), '\\', '/');
		imageTag->SetProperty("source", "\"" + std::string("file:/") + dir_path + "\"");

		//Relative wrt main.qml not working
		//imageTag->SetProperty("source", "\"" + std::string("file:/../../Library/RendererQml/Images/calendarIcon.png") + "\"");

		auto mouseAreaTag = std::make_shared<QmlTag>("MouseArea");

		mouseAreaTag->AddChild(imageTag);
		mouseAreaTag->SetProperty("height", "parent.height");
		mouseAreaTag->SetProperty("width", "height");
		mouseAreaTag->SetProperty("anchors.right", "parent.right");
		mouseAreaTag->SetProperty("enabled", "true");

		mouseAreaTag->SetProperty("onClicked", Formatter() << "{" << id << ".forceActiveFocus();\n" << timeBox_id << ".visible=!" << timeBox_id << ".visible;\n" << "parent.z=" << timeBox_id << ".visible?1:0;\n" << listViewHours_id << ".currentIndex=parseInt(parent.getText(0,2));\n" << listViewMin_id << ".currentIndex=parseInt(parent.getText(3,5));\n" << "}");

		uiTimeInput->AddChild(mouseAreaTag);

		//Rectangle that contains the hours and min ListViews 
		auto timeBoxTag = std::make_shared<QmlTag>("Rectangle");
		timeBoxTag->SetProperty("id", timeBox_id);
		timeBoxTag->SetProperty("anchors.topMargin", "1");
		timeBoxTag->SetProperty("anchors.left", "parent.left");
		timeBoxTag->SetProperty("anchors.top", "parent.bottom");
		timeBoxTag->SetProperty("width", "105");
		timeBoxTag->SetProperty("height", "200");
		timeBoxTag->SetProperty("visible", "false");
		timeBoxTag->SetProperty("layer.enabled", "true");
		timeBoxTag->SetProperty("layer.effect", glowTag->ToString());

		//ListView for DropDown Selection
		std::map<std::string, std::map<std::string, std::string>> ListViewHoursProperties;
		std::map<std::string, std::map<std::string, std::string>> ListViewMinProperties;
		std::map<std::string, std::map<std::string, std::string>> ListViewttProperties;
		int hoursRange = 24;

		if (is12hour == true)
		{
			timeBoxTag->SetProperty("width", "155");
			uiTimeInput->SetProperty("validator", "RegExpValidator { regExp: /^(--|[01]-|0\\d|1[0-2]):(--|[0-5]-|[0-5]\\d)\\s(--|A-|AM|P-|PM)$/}");
			uiTimeInput->SetProperty("onFocusChanged", Formatter() << "{ if (focus==true) inputMask=\"xx:xx >xx;-\";" << " if(activeFocus==false){ z=0;" << "if(" << timeBox_id << ".visible==true)" << timeBox_id << ".visible=false ;" << "}}");
			uiTimeInput->SetProperty("onTextChanged", Formatter() << "{" << listViewHours_id << ".currentIndex=parseInt(getText(0,2))-1;" << listViewMin_id << ".currentIndex=parseInt(getText(3,5));"
				<< "var tt_index=3;" << "switch(getText(6,8)){ case 'PM':tt_index = 1; break;case 'AM':tt_index = 0; break;}" << listViewtt_id << ".currentIndex=tt_index;" << "}");
			mouseAreaTag->SetProperty("onClicked", Formatter() << "{" << id << ".forceActiveFocus();\n" << timeBox_id << ".visible=!" << timeBox_id << ".visible;\n" << "parent.z=" << timeBox_id << ".visible?1:0;\n" << listViewHours_id << ".currentIndex=parseInt(parent.getText(0,2))-1;\n" << listViewMin_id << ".currentIndex=parseInt(parent.getText(3,5));\n"
				<< "var tt_index=3;" << "switch(parent.getText(6,8)){ case 'PM':tt_index = 1; break;case 'AM':tt_index = 0; break;}" << listViewtt_id << ".currentIndex=tt_index;" << "}");


			ListViewHoursProperties["Text"].insert(std::pair<std::string, std::string>("text", "String(index+1).padStart(2, '0')"));
			ListViewHoursProperties["MouseArea"].insert(std::pair<std::string, std::string>("onClicked", Formatter() << "{" << listViewHours_id << ".currentIndex=index;" << "var x=String(index+1).padStart(2, '0') ;" << id << ".insert(0,x);" << "}"));

			hoursRange = 12;

			ListViewttProperties["ListView"].insert(std::pair<std::string, std::string>("anchors.right", "parent.right"));
			ListViewttProperties["ListView"].insert(std::pair<std::string, std::string>("model", "ListModel{ListElement { name: \"AM\"} ListElement { name: \"PM\"}}"));
			ListViewttProperties["Text"].insert(std::pair<std::string, std::string>("text", "model.name"));
			ListViewttProperties["MouseArea"].insert(std::pair<std::string, std::string>("onClicked", Formatter() << "{" << listViewtt_id << ".currentIndex=index;" << id << ".insert(6,model.name);" << "}"));

			auto listViewttTag = AdaptiveCardQmlRenderer::ListViewTagforTimeInput(id, listViewtt_id, ListViewttProperties);
			timeBoxTag->AddChild(listViewttTag);

		}

		ListViewHoursProperties["ListView"].insert(std::pair<std::string, std::string>("anchors.left", "parent.left"));
		ListViewHoursProperties["ListView"].insert(std::pair<std::string, std::string>("model", std::to_string(hoursRange)));
		ListViewHoursProperties["MouseArea"].insert(std::pair<std::string, std::string>("onClicked", Formatter() << "{" << listViewHours_id << ".currentIndex=index;" << "var x=String(index).padStart(2, '0') ;" << id << ".insert(0,x);" << "}"));

		auto ListViewHoursTag = AdaptiveCardQmlRenderer::ListViewTagforTimeInput(id, listViewHours_id, ListViewHoursProperties);

		ListViewMinProperties["ListView"].insert(std::pair<std::string, std::string>("anchors.left", listViewHours_id + ".right"));
		ListViewMinProperties["ListView"].insert(std::pair<std::string, std::string>("model", "60"));
		ListViewMinProperties["MouseArea"].insert(std::pair<std::string, std::string>("onClicked", Formatter() << "{" << listViewMin_id << ".currentIndex=index;" << "var x=String(index).padStart(2, '0') ;" << id << ".insert(2,x);" << "}"));

		auto ListViewMinTag = AdaptiveCardQmlRenderer::ListViewTagforTimeInput(id, listViewMin_id, ListViewMinProperties);

		timeBoxTag->AddChild(ListViewHoursTag);
		timeBoxTag->AddChild(ListViewMinTag);
		uiTimeInput->AddChild(timeBoxTag);

		return uiTimeInput;

	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ListViewTagforTimeInput(std::string& parent_id, std::string& listView_id, std::map < std::string, std::map<std::string, std::string>>& properties)
	{
		auto ListViewTag = std::make_shared<QmlTag>("ListView");
		ListViewTag->SetProperty("id", listView_id);

		//TODO:Avoid fixed values inside ListView
		ListViewTag->SetProperty("width", "45");
		ListViewTag->SetProperty("height", "parent.height-10");
		ListViewTag->SetProperty("anchors.margins", "5");
		ListViewTag->SetProperty("anchors.top", "parent.top");
		ListViewTag->SetProperty("flickableDirection", "Flickable.VerticalFlick");
		ListViewTag->SetProperty("boundsBehavior", "Flickable.StopAtBounds");
		ListViewTag->SetProperty("clip", "true");


		//Elements inside delegate: Rectangle{ Text{} MouseArea{} }
		std::string MouseArea_id = listView_id + "mouseArea";
		auto MouseAreaTag = std::make_shared<QmlTag>("MouseArea");
		MouseAreaTag->SetProperty("id", MouseArea_id);
		MouseAreaTag->SetProperty("anchors.fill", "parent");
		MouseAreaTag->SetProperty("enabled", "true");
		MouseAreaTag->SetProperty("hoverEnabled", "true");
		MouseAreaTag->SetProperty("onClicked", Formatter() << "{" << listView_id << ".currentIndex=index;" << "var x=String(index).padStart(2, '0') ;" << parent_id << ".insert(0,x);" << "}");

		auto TextTag = std::make_shared<QmlTag>("Text");
		TextTag->SetProperty("text", "String(index).padStart(2, '0')");
		TextTag->SetProperty("anchors.fill", "parent");
		TextTag->SetProperty("horizontalAlignment", "Text.AlignHCenter");
		TextTag->SetProperty("verticalAlignment", "Text.AlignVCenter");
		TextTag->SetProperty("color", Formatter() << listView_id << ".currentIndex==index ? \"white\" : \"black\"");

		auto delegateRectTag = std::make_shared<QmlTag>("Rectangle");
		delegateRectTag->SetProperty("width", "45");
		delegateRectTag->SetProperty("height", "45");
		delegateRectTag->SetProperty("color", Formatter() << listView_id << ".currentIndex==index ? \"blue\" : " << MouseArea_id << ".containsMouse?\"lightblue\":\"white\"");

		std::map<std::string, std::map<std::string, std::string>>::iterator outer_iterator;
		std::map<std::string, std::string>::iterator inner_iterator;
		
		for (outer_iterator = properties.begin(); outer_iterator != properties.end(); outer_iterator++)
		{
			std::shared_ptr<QmlTag> propertyTag;

			if (outer_iterator->first.compare("ListView") == 0)
			{
				propertyTag = ListViewTag;
			}

			else if (outer_iterator->first.compare("MouseArea") == 0)
			{
				propertyTag = MouseAreaTag;
			}

			else if (outer_iterator->first.compare("Text") == 0)
			{
				propertyTag = TextTag;
			}

			for (inner_iterator = outer_iterator->second.begin(); inner_iterator != outer_iterator->second.end(); inner_iterator++)
			{
				propertyTag->SetProperty(inner_iterator->first, inner_iterator->second);
			}
		}

		delegateRectTag->AddChild(MouseAreaTag);
		delegateRectTag->AddChild(TextTag);

		ListViewTag->SetProperty("delegate", delegateRectTag->ToString());

		return ListViewTag;
	}

	std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::ImageSetRender(std::shared_ptr<AdaptiveCards::ImageSet> imageSet, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto uiFlow = std::make_shared<QmlTag>("Flow");

		uiFlow->SetProperty("width", "parent.width");
		uiFlow->SetProperty("spacing", "10");

		if (!imageSet->GetIsVisible())
		{
			uiFlow->SetProperty("visible", "false");
		}

		for (auto& image : imageSet->GetImages())
		{
			if (imageSet->GetImageSize() != AdaptiveCards::ImageSize::None)
			{
				image->SetImageSize(imageSet->GetImageSize());
			}
			else if (image->GetImageSize() != AdaptiveCards::ImageSize::None)
			{
				image->SetImageSize(image->GetImageSize());
			}

			uiFlow->AddChild(context->Render(image));
		}

		return uiFlow;
	}
}
	
