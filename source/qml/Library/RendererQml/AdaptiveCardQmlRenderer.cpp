#include "AdaptiveCardQmlRenderer.h"
#include "ImageDataURI.h"
#include "pch.h"

namespace RendererQml
{
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

	std::shared_ptr<RenderedQmlAdaptiveCard> AdaptiveCardQmlRenderer::RenderCard(std::shared_ptr<AdaptiveCards::AdaptiveCard> card)
	{
		std::shared_ptr<RenderedQmlAdaptiveCard> output;
		auto context = std::make_shared<AdaptiveRenderContext>(GetHostConfig(), GetElementRenderers());
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
        (*GetElementRenderers()).Set<AdaptiveCards::Media>(AdaptiveCardQmlRenderer::MediaRender);
        (*GetElementRenderers()).Set<AdaptiveCards::Container>(AdaptiveCardQmlRenderer::ContainerRender);
        (*GetElementRenderers()).Set<AdaptiveCards::Column>(AdaptiveCardQmlRenderer::ColumnRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ColumnSet>(AdaptiveCardQmlRenderer::ColumnSetRender);
        (*GetElementRenderers()).Set<AdaptiveCards::FactSet>(AdaptiveCardQmlRenderer::FactSetRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ImageSet>(AdaptiveCardQmlRenderer::ImageSetRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ActionSet>(AdaptiveCardQmlRenderer::ActionSetRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ChoiceSetInput>(AdaptiveCardQmlRenderer::ChoiceSetRender);
        (*GetElementRenderers()).Set<AdaptiveCards::TextInput>(AdaptiveCardQmlRenderer::TextInputRender);
        (*GetElementRenderers()).Set<AdaptiveCards::NumberInput>(AdaptiveCardQmlRenderer::NumberInputRender);
        (*GetElementRenderers()).Set<AdaptiveCards::DateInput>(AdaptiveCardQmlRenderer::DateInputRender);
        (*GetElementRenderers()).Set<AdaptiveCards::TimeInput>(AdaptiveCardQmlRenderer::TimeInputRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ToggleInput>(AdaptiveCardQmlRenderer::ToggleInputRender);
        (*GetElementRenderers()).Set<AdaptiveCards::OpenUrlAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ShowCardAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ToggleVisibilityAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);
        (*GetElementRenderers()).Set<AdaptiveCards::SubmitAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::AdaptiveCardRender(std::shared_ptr<AdaptiveCards::AdaptiveCard> card, std::shared_ptr<AdaptiveRenderContext> context, bool isChildCard)
    {
        context->setDefaultIdName("defaultId");
		int margin = context->GetConfig()->GetSpacing().paddingSpacing;

        auto uiCard = std::make_shared<QmlTag>("Rectangle");
        uiCard->AddImports("import QtQuick 2.15");
        uiCard->AddImports("import QtQuick.Layouts 1.3");
        uiCard->AddImports("import QtQuick.Controls 2.15");
        uiCard->Property("id", "adaptiveCard");
        context->setCardRootId(uiCard->GetId());
		context->setCardRootElement(uiCard);
		uiCard->Property("readonly property int margins", std::to_string(margin));
        uiCard->AddFunctions("signal buttonClicked(var title, var type, var data)");
		//1px extra height to accomodate the border of a showCard if present at the bottom
        uiCard->Property("implicitHeight", "adaptiveCardLayout.implicitHeight+1");
		uiCard->Property("Layout.fillWidth", "true");
		uiCard->Property("readonly property string bgColor", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));
		uiCard->Property("readonly property string inputElementsBorderColor", "'#CCCCCC'");
		uiCard->Property("color", "bgColor");
		uiCard->Property("border.color", isChildCard? " bgColor" : "'#B2B2B2'");

        const auto hasBackgroundImage = card->GetBackgroundImage() != nullptr;
		if (hasBackgroundImage)
		{
			auto uiFrame = std::make_shared<QmlTag>("Frame");
            uiFrame->Property("id", Formatter() << uiCard->GetId() << "_frame");
			uiFrame->Property("readonly property bool hasBackgroundImage", "true");
            uiFrame->Property("property var imgSource", card->GetBackgroundImage()->GetUrl(), true);
			uiFrame->Property("anchors.fill", "parent");
			uiFrame->Property("background", AdaptiveCardQmlRenderer::GetBackgroundImage(card->GetBackgroundImage(), context, "parent.imgSource")->ToString());
			uiCard->Property("clip", "true");
			uiCard->AddChild(uiFrame);
		}

		auto columnLayout = std::make_shared<QmlTag>("ColumnLayout");
		columnLayout->Property("id", "adaptiveCardLayout");
		columnLayout->Property("width", "parent.width");
		uiCard->AddChild(columnLayout);

		auto rectangle = std::make_shared<QmlTag>("Rectangle");
		rectangle->Property("id", "adaptiveCardRectangle");
		rectangle->Property("color", "'transparent'");
		rectangle->Property("Layout.topMargin", "margins");
		rectangle->Property("Layout.bottomMargin", "removeBottomMargin? 0 : margins");
		rectangle->Property("Layout.leftMargin", "margins");
		rectangle->Property("Layout.rightMargin", "margins");
		rectangle->Property("Layout.fillWidth", "true");
		rectangle->Property("Layout.preferredHeight", "40");
		rectangle->Property("Layout.minimumHeight", "1");

		columnLayout->AddChild(rectangle);

		//TODO: Add card vertical content alignment
        auto bodyLayout = std::make_shared<QmlTag>("Column");
        bodyLayout->Property("id", "bodyLayout");
        bodyLayout->Property("width", "parent.width");
        rectangle->Property("Layout.preferredHeight", "bodyLayout.height");
        rectangle->AddChild(bodyLayout);

		ValidateLastBodyElementIsShowCard(card->GetBody(), context);
		
		ValidateShowCardInActions(card->GetActions(), context);
		AddContainerElements(bodyLayout, card->GetBody(), context);
		AddActions(bodyLayout, card->GetActions(), context);
        addSelectAction(uiCard, uiCard->GetId(), card->GetSelectAction(), context, hasBackgroundImage);

		auto showCardsList = context->getShowCardsLoaderIdsList();
		auto removeBottomMarginValue = RemoveBottomMarginValue(showCardsList);
		rectangle->Property("property bool removeBottomMargin", removeBottomMarginValue);

		//Remove Top and Bottom Paddin if bleed for first and last element is true
		rectangle = applyVerticalBleed(bodyLayout, rectangle);

		int tempMargin = 0;

		if (rectangle->HasProperty("Layout.topMargin"))
		{
			tempMargin += margin;
		}

		if (rectangle->HasProperty("Layout.bottomMargin"))
		{
			tempMargin += margin;
		}

		bodyLayout->Property("onImplicitHeightChanged", Formatter() << "{" << context->getCardRootId() << ".generateStretchHeight(children," << int(card->GetMinHeight()) - tempMargin << ")}");

		bodyLayout->Property("onImplicitWidthChanged", Formatter() << "{" << context->getCardRootId() << ".generateStretchHeight(children," << int(card->GetMinHeight()) - tempMargin << ")}");

		if (card->GetMinHeight() > 0)
		{
			rectangle->Property("Layout.minimumHeight", std::to_string(card->GetMinHeight() - tempMargin));
		}

        //Add submit onclick event
        addSubmitActionButtonClickFunc(context);
        addShowCardLoaderComponents(context);
        addTextRunSelectActions(context);

		// Add height and width calculation function
        uiCard->AddFunctions(AdaptiveCardQmlRenderer::getStretchHeight());
        uiCard->AddFunctions(AdaptiveCardQmlRenderer::getStretchWidth());
        uiCard->AddFunctions(AdaptiveCardQmlRenderer::getMinWidth());
        uiCard->AddFunctions(AdaptiveCardQmlRenderer::getMinWidthActionSet());
		uiCard->AddFunctions(AdaptiveCardQmlRenderer::getMinWidthFactSet());
		return uiCard;
	}

    void AdaptiveCardQmlRenderer::AddContainerElements(std::shared_ptr<QmlTag> uiContainer, const std::vector<std::shared_ptr<AdaptiveCards::BaseCardElement>>& elements, std::shared_ptr<AdaptiveRenderContext> context)
    {
		for (const auto& cardElement : elements)
		{
			auto uiElement = context->Render(cardElement);

			if (uiElement != nullptr)
			{
				if (!uiContainer->GetChildren().empty())
				{
					AddSeparator(uiContainer, cardElement, context);
				}

				if (cardElement->GetHeight() == AdaptiveCards::HeightType::Stretch && cardElement->GetElementTypeString() != "Image")
				{
					uiElement->Property("readonly property bool stretch", "true");
				}

				uiContainer->AddChild(uiElement);
			}
		}
    }

    void AdaptiveCardQmlRenderer::AddActions(std::shared_ptr<QmlTag> uiContainer, const std::vector<std::shared_ptr<AdaptiveCards::BaseActionElement>>& actions, std::shared_ptr<AdaptiveRenderContext> context, bool removeBottomMargin)
    {
        if (context->GetConfig()->GetSupportsInteractivity())
        {
            if ((unsigned int)actions.size() == 0)
            {
                return;
            }

            std::shared_ptr<QmlTag> uiButtonStrip;
            auto actionsConfig = context->GetConfig()->GetActions();

            if (actionsConfig.actionsOrientation == AdaptiveCards::ActionsOrientation::Horizontal)
            {
                uiButtonStrip = std::make_shared<QmlTag>("Flow");
                uiButtonStrip->Property("width", "parent.width");
                uiButtonStrip->Property("spacing", std::to_string(actionsConfig.buttonSpacing));

                switch (actionsConfig.actionAlignment)
                {
                case AdaptiveCards::ActionAlignment::Right:
                    uiButtonStrip->Property("layoutDirection", "Qt.RightToLeft");
                    break;
                case AdaptiveCards::ActionAlignment::Center: //TODO: implement for centre alignment
                default:
                    uiButtonStrip->Property("layoutDirection", "Qt.LeftToRight");
                    break;
                }
            }
            else
            {
                //TODO: Implement AdaptiveCards::ActionsOrientation::Vertical
                uiButtonStrip = std::make_shared<QmlTag>("Column");
                uiButtonStrip->Property("width", "parent.width");
                uiButtonStrip->Property("spacing", std::to_string(actionsConfig.buttonSpacing));
            }

            const unsigned int maxActions = std::min<unsigned int>(actionsConfig.maxActions, (unsigned int)actions.size());
            // See if all actions have icons, otherwise force the icon placement to the left
            const auto oldConfigIconPlacement = actionsConfig.iconPlacement;
            bool allActionsHaveIcons = true;
            for (const auto& action : actions)
            {
                if (action->GetIconUrl().empty())
                {
                    allActionsHaveIcons = false;
                    break;
                }
            }

            if (!allActionsHaveIcons)
            {
                actionsConfig.iconPlacement = AdaptiveCards::IconPlacement::LeftOfTitle;
                context->GetConfig()->SetActions(actionsConfig);
            }

            // add separator and button set layout
            AddSeparator(uiContainer, std::make_shared<AdaptiveCards::Container>(), context);
            uiContainer->AddChild(uiButtonStrip);

            for (unsigned int i = 0; i < maxActions; i++)
            {
                // add actions buttons
                auto uiAction = context->Render(actions[i]);
                if (uiAction != nullptr)
                {
                    if (Utils::IsInstanceOfSmart<AdaptiveCards::ShowCardAction>(actions[i]))
                    {
                        // Add to loader source component list
						const std::string loaderId = uiAction->GetId() + "_loader";
                        const std::string componentId = uiAction->GetId() + "_component";
                        const auto showCardAction = std::dynamic_pointer_cast<AdaptiveCards::ShowCardAction>(actions[i]);
                        context->addToShowCardLoaderComponentList(componentId, showCardAction);

                        //Add show card loader to the parent container
                        AddSeparator(uiContainer, std::make_shared<AdaptiveCards::Container>(), context, true, loaderId);

						auto uiLoader = std::make_shared<QmlTag>("Loader");
                        uiLoader->Property("id", loaderId);
						//1px shift to avoid child card displaying over parent card's border
                        uiLoader->Property("x", "-margins + 1");
                        uiLoader->Property("sourceComponent", componentId);
                        uiLoader->Property("visible", "false");
						//2 px reduction in width to avoid child card displaying over parent card's border
						uiLoader->Property("width", Formatter() << uiContainer->GetProperty("id") << ".width + 2*margins - 2");
						uiLoader->Property("readonly property bool removeBottomMargin", removeBottomMargin ? "true" : "false");

						context->addToShowCardsLoaderIdsList(loaderId);
                        uiContainer->AddChild(uiLoader);
                    }

                    uiButtonStrip->AddChild(uiAction);
                }
            }

            // add show card click function
            addShowCardButtonClickFunc(context);

            // Restore the iconPlacement for the context.
            actionsConfig.iconPlacement = oldConfigIconPlacement;
        }
    }

    void AdaptiveCardQmlRenderer::addSelectAction(const std::shared_ptr<QmlTag>& parent, const std::string& rectId, const std::shared_ptr<AdaptiveCards::BaseActionElement>& selectAction, const std::shared_ptr<AdaptiveRenderContext>& context, const bool hasBackgroundImage)
    {
        if (context->GetConfig()->GetSupportsInteractivity() && selectAction != nullptr)
        {
            // SelectAction doesn't allow showCard actions
            if (Utils::IsInstanceOfSmart<AdaptiveCards::ShowCardAction>(selectAction))
            {
                context->AddWarning(AdaptiveWarning(Code::RenderException, "Inline ShowCard not supported for SelectAction"));
                return;
            }

            const auto parentColor = !parent->GetProperty("readonly property string bgColor").empty() ? parent->GetProperty("readonly property string bgColor") : "'transparent'";
            const auto hoverColor = context->GetRGBColor(context->GetConfig()->GetContainerStyles().emphasisPalette.backgroundColor);

            auto mouseArea = std::make_shared<QmlTag>("MouseArea");
            mouseArea->Property("anchors.fill", "parent");
            mouseArea->Property("acceptedButtons", "Qt.LeftButton");
            mouseArea->Property("hoverEnabled", "true");

            std::ostringstream onEntered;
            onEntered << "{" << rectId << ".color = " << hoverColor << ";";
            if (hasBackgroundImage)
            {
                onEntered << rectId << ".opacity = 0.5;";
            }
            onEntered << "}";
            mouseArea->Property("onEntered", onEntered.str());

            std::ostringstream onExited;
            onExited << "{" << rectId << ".color = " << parentColor << ";";
            if (hasBackgroundImage)
            {
                onExited << rectId << ".opacity = 1;";
            }
            onExited << "}";
            mouseArea->Property("onExited", onExited.str());

            std::string onClickedFunction;
            if (selectAction->GetElementTypeString() == "Action.OpenUrl")
            {
                onClickedFunction = getActionOpenUrlClickFunc(std::dynamic_pointer_cast<AdaptiveCards::OpenUrlAction>(selectAction), context);
            }
            else if (selectAction->GetElementTypeString() == "Action.Submit")
            {
                context->addToSubmitActionButtonList(mouseArea, std::dynamic_pointer_cast<AdaptiveCards::SubmitAction>(selectAction));
            }
            else
            {
                onClickedFunction = "";
            }
            mouseArea->Property("onClicked", Formatter() << "{\n" << onClickedFunction << "}");

            parent->AddChild(mouseArea);
        }
    }

    void AdaptiveCardQmlRenderer::addTextRunSelectActions(const std::shared_ptr<AdaptiveRenderContext>& context)
    {
        if (context->GetConfig()->GetSupportsInteractivity())
        {
            for (const auto& textRunElement : context->getTextRunSelectActionList())
            {
                std::ostringstream onLinkActivated;
                for (const auto& action : textRunElement.second)
                {
                    onLinkActivated << "if(link === '" << action.first << "'){\n";

                    if (action.second->GetElementTypeString() == "Action.OpenUrl")
                    {
                        onLinkActivated << getActionOpenUrlClickFunc(std::dynamic_pointer_cast<AdaptiveCards::OpenUrlAction>(action.second), context);
                    }
                    else if (action.second->GetElementTypeString() == "Action.Submit")
                    {
                        onLinkActivated << getActionSubmitClickFunc(std::dynamic_pointer_cast<AdaptiveCards::SubmitAction>(action.second), context);
                    }
                    onLinkActivated << "return;\n}\n";
                }
                textRunElement.first->Property("onLinkActivated", Formatter() << "{\n" << onLinkActivated.str() << "}");
            }
        }
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetComponent(const std::string& componentId, const std::shared_ptr<QmlTag>& uiCard)
    {
        auto uiComponent = std::make_shared<QmlTag>("Component");
        uiComponent->Property("id", componentId);

        const std::string layoutId = Formatter() << componentId << "_component_layout";
        std::string uiCard_string = uiCard->ToString();
        uiCard_string = Utils::Replace(uiCard_string, "\\", "\\\\");
        uiCard_string = Utils::Replace(uiCard_string, "\"", "\\\"");

        auto uiColumn = std::make_shared<QmlTag>("ColumnLayout");
        uiColumn->Property("id", layoutId);
        uiColumn->AddFunctions("property var card");
        uiColumn->Property("property string showCard", uiCard_string, true);
        uiColumn->Property("Component.onCompleted", "reload(showCard)");
        uiColumn->AddFunctions(Formatter() << "function reload(mCard)\n{\n");
        uiColumn->AddFunctions(Formatter() << "if (card)\n{ \ncard.destroy()\n }\n");
        uiColumn->AddFunctions(Formatter() << "card = Qt.createQmlObject(mCard, " << layoutId << ", 'card')\n");
        uiColumn->AddFunctions(Formatter() << "if (card)\n{ \ncard.buttonClicked.connect(adaptiveCard.buttonClicked)\n }\n}");

		uiComponent->AddChild(uiColumn);

		return uiComponent;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::TextBlockRender(std::shared_ptr<AdaptiveCards::TextBlock> textBlock, std::shared_ptr<AdaptiveRenderContext> context)
	{
		//LIMITATION: Elide and maximumLineCount property do not work for textFormat:Text.MarkdownText

		std::string fontFamily = context->GetConfig()->GetFontFamily(textBlock->GetFontType());
		int fontSize = context->GetConfig()->GetFontSize(textBlock->GetFontType(), textBlock->GetTextSize());

		auto uiTextBlock = std::make_shared<QmlTag>("Text");
		std::string textType = textBlock->GetElementTypeString();
		std::string horizontalAlignment = AdaptiveCards::EnumHelpers::getHorizontalAlignmentEnum().toString(textBlock->GetHorizontalAlignment());

		uiTextBlock->Property("width", "parent.width");

		//Does not work for Markdown text
		uiTextBlock->Property("elide", "Text.ElideRight");

		uiTextBlock->Property("clip", "true");
		uiTextBlock->Property("textFormat", "Text.MarkdownText");

		uiTextBlock->Property("horizontalAlignment", Utils::GetHorizontalAlignment(horizontalAlignment));

		std::string color = context->GetColor(textBlock->GetTextColor(), textBlock->GetIsSubtle(), false);

		uiTextBlock->Property("color", color);

		uiTextBlock->Property("font.pixelSize", std::to_string(fontSize));

		uiTextBlock->Property("font.weight", Utils::GetWeight(textBlock->GetTextWeight()));

		if (!textBlock->GetId().empty())
		{
            textBlock->SetId(context->ConvertToValidId(textBlock->GetId()));
			uiTextBlock->Property("id", textBlock->GetId());
		}

		if (!textBlock->GetIsVisible())
		{
			uiTextBlock->Property("visible", "false");
		}

		//Does not work for Markdown text
		if (textBlock->GetMaxLines() > 0)
		{
			uiTextBlock->Property("maximumLineCount", std::to_string(textBlock->GetMaxLines()));
		}

		if (textBlock->GetWrap())
		{
			uiTextBlock->Property("wrapMode", "Text.Wrap");
		}

		if (!fontFamily.empty())
		{
            uiTextBlock->Property("font.family", fontFamily, true);
        }

		std::string text = TextUtils::ApplyTextFunctions(textBlock->GetText(), context->GetLang());
		text = Utils::HandleEscapeSequences(text);

		const std::string linkColor = context->GetColor(AdaptiveCards::ForegroundColor::Accent, false, false);

		//CSS Property for underline, striketrhough,etc
		const std::string textDecoration = "none";
		text = Utils::MarkdownUrlToHtml(text, linkColor, textDecoration);
		
		uiTextBlock->Property("text", text, true);

		//MouseArea to Change Cursor on Hovering Links
		auto MouseAreaTag = GetTextBlockMouseArea();
		uiTextBlock->AddChild(MouseAreaTag);

		std::string onLinkActivatedFunction = Formatter() << "{"
			<< "adaptiveCard.buttonClicked(\"\", \"Action.OpenUrl\", link);"
			<< "console.log(link);"
			<< "}";
		uiTextBlock->Property("onLinkActivated", onLinkActivatedFunction);

		return uiTextBlock;

	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::TextInputRender(std::shared_ptr<AdaptiveCards::TextInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
        const std::string origionalElementId = input->GetId();

		std::shared_ptr<QmlTag> uiTextInput;
		std::shared_ptr<QmlTag> scrollViewTag;

        input->SetId(context->ConvertToValidId(input->GetId()));

		if (input->GetIsMultiline())
		{
			scrollViewTag = std::make_shared<QmlTag>("ScrollView");
			scrollViewTag->Property("width", "parent.width");
			scrollViewTag->Property("height", Formatter() << input->GetId() <<".visible ? 100 : 0");
			scrollViewTag->Property("ScrollBar.vertical.interactive", "true");

			uiTextInput = std::make_shared<QmlTag>("TextArea");
			uiTextInput->Property("id", input->GetId());
			uiTextInput->Property("wrapMode", "Text.Wrap");
			uiTextInput->Property("selectByMouse", "true");
			uiTextInput->Property("selectedTextColor", "'white'");
			uiTextInput->Property("padding", "10");
            uiTextInput->Property("color", context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false));
			uiTextInput->Property("leftPadding", "10");

			if (input->GetMaxLength() > 0)
			{
				uiTextInput->Property("onTextChanged", Formatter() << "remove(" << input->GetMaxLength() << ", length)");
			}

			scrollViewTag->AddChild(uiTextInput);
		}
		else
		{
			uiTextInput = std::make_shared<QmlTag>("TextField");
			uiTextInput->Property("id", input->GetId());
			uiTextInput->Property("width", "parent.width");
			uiTextInput->Property("selectByMouse", "true");
			uiTextInput->Property("selectedTextColor", "'white'");
            uiTextInput->Property("color", context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false));

			if (input->GetMaxLength() > 0)
			{
				uiTextInput->Property("maximumLength", std::to_string(input->GetMaxLength()));
			}
		}

		uiTextInput->Property("font.pixelSize", std::to_string(context->GetConfig()->GetFontSize(AdaptiveSharedNamespace::FontType::Default, AdaptiveSharedNamespace::TextSize::Default)));

		auto backgroundTag = std::make_shared<QmlTag>("Rectangle");
		backgroundTag->Property("radius", "5");
		//TODO: These color styling should come from css
        //TODO: Add hover effect
        backgroundTag->Property("color", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));
        backgroundTag->Property("border.color", Formatter() << input->GetId() << ".activeFocus? 'black' : inputElementsBorderColor");
		backgroundTag->Property("border.width", "1");
		uiTextInput->Property("background", backgroundTag->ToString());

		if (!input->GetValue().empty())
		{
			uiTextInput->Property("text", input->GetValue(), true);
		}

		if (!input->GetPlaceholder().empty())
		{
			uiTextInput->Property("placeholderText", input->GetPlaceholder(), true);
		}

		//TODO: Add stretch property

		if (!input->GetIsVisible())
		{
			uiTextInput->Property("visible", "false");
		}

        context->addToInputElementList(origionalElementId, (uiTextInput->GetId() + ".text"));

        // Add inline action mode
        if (context->GetConfig()->GetSupportsInteractivity() && input->GetInlineAction() != nullptr)
        {
            // ShowCard Inline Action Mode is not supported
            if (input->GetInlineAction()->GetElementType() == AdaptiveCards::ActionType::ShowCard &&
                context->GetConfig()->GetActions().showCard.actionMode == AdaptiveCards::ActionMode::Inline)
            {
                context->AddWarning(AdaptiveWarning(Code::RenderException, "Inline ShowCard not supported for InlineAction"));
            }
            else
            {
                auto uiContainer = std::make_shared<QmlTag>("Row");
                uiContainer->Property("id", Formatter() << input->GetId() << "_row");
                uiContainer->Property("spacing", "5");
                uiContainer->Property("width", "parent.width");
                const auto actionsConfig = context->GetConfig()->GetActions();

                auto buttonElement = context->Render(input->GetInlineAction());
                buttonElement->RemoveProperty("background");
                buttonElement->RemoveProperty("contentItem");

                // Append the icon to the button
                // NOTE: always using icon size since it's difficult
                // to match icon's height with text's height
                auto bgRectangle = std::make_shared<QmlTag>("Rectangle");
                bgRectangle->Property("id", Formatter() << buttonElement->GetId() << "_bg");
                bgRectangle->Property("anchors.fill", "parent");
                bgRectangle->Property("color", Formatter() << buttonElement->GetId() << ".pressed ? '#B4B6B8' : " << buttonElement->GetId() << ".hovered ? '#E6E8E8' : 'white'");
                buttonElement->Property("background", bgRectangle->ToString());

                if (!input->GetInlineAction()->GetIconUrl().empty())
                {
                    buttonElement->Property("height", std::to_string(actionsConfig.iconSize));
                    buttonElement->Property("width", std::to_string(actionsConfig.iconSize));

                    auto iconItem = std::make_shared<QmlTag>("Item");
                    iconItem->Property("anchors.fill", "parent");
                    auto iconImage = std::make_shared<QmlTag>("Image");
                    iconImage->Property("id", Formatter() << buttonElement->GetId() << "_img");
                    iconImage->Property("height", std::to_string(actionsConfig.iconSize));
                    iconImage->Property("width", std::to_string(actionsConfig.iconSize));
                    iconImage->Property("fillMode", "Image.PreserveAspectFit");
                    iconImage->Property("cache", "false");
                    iconImage->Property("source", Formatter() << buttonElement->GetId() + ".imgSource");
                    iconItem->AddChild(iconImage);
                    buttonElement->Property("contentItem", iconItem->ToString());
                }
                else
                {
                    buttonElement->Property("text", input->GetInlineAction()->GetTitle(), true);
                }

                if (input->GetIsMultiline())
                {
                    buttonElement->Property("anchors.bottom", "parent.bottom");
                    scrollViewTag->Property("width", Formatter() << "parent.width - " << buttonElement->GetId() << ".width - " << uiContainer->GetId() << ".spacing");
                    uiContainer->AddChild(scrollViewTag);
                }
                else
                {
                    uiTextInput->Property("width", Formatter() << "parent.width - " << buttonElement->GetId() << ".width - " << uiContainer->GetId() << ".spacing");
                    uiContainer->AddChild(uiTextInput);
                }
                uiContainer->AddChild(buttonElement);
                return uiContainer;
            }
        }

		if (input->GetIsMultiline())
		{
			return scrollViewTag;
		}

		return uiTextInput;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::NumberInputRender(std::shared_ptr<AdaptiveCards::NumberInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
        const std::string origionalElementId = input->GetId();
        input->SetId(context->ConvertToValidId(input->GetId()));
		const auto inputId = input->GetId();

		auto backgroundTag = std::make_shared<QmlTag>("Rectangle");
		backgroundTag->Property("radius", "5");
		//TODO: These color styling should come from css
        //TODO: Add hover effect
        backgroundTag->Property("color", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));

		backgroundTag->Property("border.color", Formatter() << inputId << "_contentItem" << ".activeFocus? 'black' : inputElementsBorderColor");

		auto contentItemTag = std::make_shared<QmlTag>("TextField");
		contentItemTag->Property("id", inputId + "_contentItem");
		contentItemTag->Property("font.pixelSize", std::to_string(context->GetConfig()->GetFontSize(AdaptiveSharedNamespace::FontType::Default, AdaptiveSharedNamespace::TextSize::Default)));
		contentItemTag->Property("anchors.left", "parent.left");
		contentItemTag->Property("selectByMouse", "true");
		contentItemTag->Property("selectedTextColor", "'white'");
		contentItemTag->Property("readOnly", Formatter() << "!" << inputId << ".editable");
		contentItemTag->Property("validator", Formatter() << inputId << ".validator");
		contentItemTag->Property("inputMethodHints", "Qt.ImhFormattedNumbersOnly");
		contentItemTag->Property("text", Formatter() << inputId << ".value");
		if (!input->GetPlaceholder().empty())
		{
			contentItemTag->Property("placeholderText", input->GetPlaceholder(), true);
		}

		auto textBackgroundTag = std::make_shared<QmlTag>("Rectangle");
		textBackgroundTag->Property("color", "'transparent'");
		contentItemTag->Property("background", textBackgroundTag->ToString());
		contentItemTag->Property("onEditingFinished", Formatter() << "{ if(text < " << inputId << ".from || text > " << inputId << ".to){\nremove(0,length)\nif(" << inputId << ".hasDefaultValue)\ninsert(0, " << inputId << ".defaultValue)\nelse\ninsert(0, " << inputId << ".from)\n}\n}");
        contentItemTag->Property("color", context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false));

		//Dummy indicator element to remove the default indicators of SpinBox
		auto upDummyTag = getDummyElementforNumberInput(true);

		auto upIndicatorTag = GetIconTag(context);
		upIndicatorTag->RemoveProperty("anchors.bottom");
		upIndicatorTag->Property("width", "20");
		upIndicatorTag->Property("height", "parent.height/2");
		upIndicatorTag->Property("horizontalPadding", "2");
		upIndicatorTag->Property("verticalPadding", "2");
		upIndicatorTag->Property("icon.width", "12");
		upIndicatorTag->Property("icon.height", "12");
		upIndicatorTag->Property("icon.source", RendererQml::arrow_up_12, true);
		upIndicatorTag->Property("onClicked", Formatter() << inputId << ".increase();");
		
		//Dummy indicator element to remove the default indicators of SpinBox
		auto downDummyTag = getDummyElementforNumberInput(false);

		auto downIndicatorTag = GetIconTag(context);
		downIndicatorTag->RemoveProperty("anchors.top");
		downIndicatorTag->Property("width", "20");
		downIndicatorTag->Property("height", "parent.height/2");
		downIndicatorTag->Property("horizontalPadding", "2");
		downIndicatorTag->Property("verticalPadding", "2");
		downIndicatorTag->Property("icon.width", "12");
		downIndicatorTag->Property("icon.height", "12");
		downIndicatorTag->Property("icon.source", RendererQml::arrow_down_12, true);
		downIndicatorTag->Property("onClicked", Formatter() << inputId << ".decrease();");

		auto doubleValidatorTag = std::make_shared<QmlTag>("DoubleValidator");

		auto uiNumberInput = std::make_shared<QmlTag>("SpinBox");
		uiNumberInput->Property("id", inputId);
		uiNumberInput->Property("width", "parent.width");
		uiNumberInput->Property("padding", "0");
		uiNumberInput->Property("stepSize", "1");
		uiNumberInput->Property("editable", "true");
		uiNumberInput->Property("validator", doubleValidatorTag->ToString());
		uiNumberInput->Property("valueFromText", "function(text, locale){\nreturn Number(text)\n}");

		if (input->GetValue() != std::nullopt)
		{
			uiNumberInput->Property("readonly property bool hasDefaultValue", "true");
			uiNumberInput->Property("readonly property int defaultValue", Formatter() << input->GetValue());
		}
		else if(input->GetMin() == std::nullopt)
		{
			input->SetValue(0);
			uiNumberInput->Property("readonly property bool hasDefaultValue", "true");
			uiNumberInput->Property("readonly property int defaultValue", std::to_string(0));
		}
		else
		{
			uiNumberInput->Property("readonly property bool hasDefaultValue", "false");
		}

		if (input->GetMin() == std::nullopt)
		{
			input->SetMin(INT_MIN);
		}
		if (input->GetMax() == std::nullopt)
		{
			input->SetMax(INT_MAX);
		}

		if ((input->GetMin() == input->GetMax() && input->GetMin() == 0) || input->GetMin() > input->GetMax())
		{
			input->SetMin(INT_MIN);
			input->SetMax(INT_MAX);
		}
		if (input->GetValue() < input->GetMin())
		{
			input->SetValue(input->GetMin());
			uiNumberInput->Property("readonly property int defaultValue", Formatter() << input->GetMin());
		}
		if (input->GetValue() > input->GetMax())
		{
			input->SetValue(input->GetMax());
			uiNumberInput->Property("readonly property int defaultValue", Formatter() << input->GetMax());
		}

		uiNumberInput->Property("from", Formatter() << input->GetMin());
		uiNumberInput->Property("to", Formatter() << input->GetMax());
		uiNumberInput->Property("value", Formatter() << input->GetValue());

		//TODO: Add stretch property

		if (!input->GetIsVisible())
		{
			uiNumberInput->Property("visible", "false");
		}

		uiNumberInput->Property("contentItem", contentItemTag->ToString());
		uiNumberInput->Property("background", backgroundTag->ToString());
		uiNumberInput->Property("up.indicator", upDummyTag->ToString());
		uiNumberInput->Property("down.indicator", downDummyTag->ToString());

		uiNumberInput->AddChild(upIndicatorTag);
		uiNumberInput->AddChild(downIndicatorTag);

        context->addToInputElementList(origionalElementId, (inputId + ".value"));

		return uiNumberInput;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::RichTextBlockRender(std::shared_ptr<AdaptiveCards::RichTextBlock> richTextBlock, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto uiTextBlock = std::make_shared<QmlTag>("Text");
		std::string textType = richTextBlock->GetElementTypeString();
		std::string horizontalAlignment = AdaptiveCards::EnumHelpers::getHorizontalAlignmentEnum().toString(richTextBlock->GetHorizontalAlignment());

		if (!richTextBlock->GetId().empty())
		{
			richTextBlock->SetId(context->ConvertToValidId(richTextBlock->GetId()));
			uiTextBlock->Property("id", richTextBlock->GetId());
		}

		uiTextBlock->Property("textFormat", "Text.RichText");
		uiTextBlock->Property("wrapMode", "Text.Wrap");
		uiTextBlock->Property("width", "parent.width");

		uiTextBlock->Property("horizontalAlignment", Utils::GetHorizontalAlignment(horizontalAlignment));
		std::string textrun_all = "";

		if (!richTextBlock->GetIsVisible())
		{
			uiTextBlock->Property("visible", "false");
		}

        std::map<std::string, std::shared_ptr<AdaptiveCards::BaseActionElement>> selectActionList;

		for (const auto& inlineRun : richTextBlock->GetInlines())
		{
			if (Utils::IsInstanceOfSmart<AdaptiveCards::TextRun>(inlineRun))
			{
                std::string selectActionId = "";
				auto textRun = std::dynamic_pointer_cast<AdaptiveCards::TextRun>(inlineRun);

                if (textRun->GetSelectAction() != nullptr)
                {
                    selectActionId = Formatter() << "selectaction_" << context->getSelectActionCounter();
                    selectActionList[selectActionId] = textRun->GetSelectAction();
                }

				textrun_all.append(TextRunRender(textRun, context, selectActionId));
			}
		}
		uiTextBlock->Property("text", textrun_all, true);

		//MouseArea to Change Cursor on Hovering Links
		auto MouseAreaTag = GetTextBlockMouseArea();
		uiTextBlock->AddChild(MouseAreaTag);

        context->addToTextRunSelectActionList(uiTextBlock, selectActionList);

		return uiTextBlock;
	}

	std::string AdaptiveCardQmlRenderer::TextRunRender(const std::shared_ptr<AdaptiveCards::TextRun>& textRun, const std::shared_ptr<AdaptiveRenderContext>& context, const std::string& selectaction)
	{
		const std::string fontFamily = context->GetConfig()->GetFontFamily(textRun->GetFontType());
		const int fontSize = context->GetConfig()->GetFontSize(textRun->GetFontType(), textRun->GetTextSize());
		const int weight = context->GetConfig()->GetFontWeight(textRun->GetFontType(), textRun->GetTextWeight());

		std::string uiTextRun = "<span style='";
		std::string textType = textRun->GetInlineTypeString();

		uiTextRun.append(Formatter() << "font-family:" << std::string("\\\"") << fontFamily << std::string("\\\"") << ";");

		std::string color = context->GetColor(textRun->GetTextColor(), textRun->GetIsSubtle(), false, false);
		uiTextRun.append(Formatter() << "color:" << color << ";");

		uiTextRun.append(Formatter() << "font-size:" << std::to_string(fontSize) << "px" << ";");

		uiTextRun.append(Formatter() << "font-weight:" << std::to_string(weight) << ";");

		if (textRun->GetHighlight())
		{
			uiTextRun.append(Formatter() << "background-color:" << context->GetColor(textRun->GetTextColor(), textRun->GetIsSubtle(), true, false) << ";");
		}

		if (textRun->GetItalic())
		{
			uiTextRun.append(Formatter() << "font-style:" << std::string("italic") << ";");
		}

		if (textRun->GetStrikethrough())
		{
			uiTextRun.append(Formatter() << "text-decoration:" << std::string("line-through") << ";");
		}

		uiTextRun.append("'>");

        if (textRun->GetSelectAction() != nullptr)
        {
			const std::string linkColor = context->GetColor(AdaptiveCards::ForegroundColor::Accent, false, false);
			//CSS Property for underline, striketrhough,etc
			std::string textDecoration = "none";
			const std::string styleString = Formatter() << "style=\\\"color:" << linkColor << ";" << "text-decoration:" << textDecoration << ";\\\"";

            uiTextRun.append(Formatter() << "<a href='" << selectaction << "'" << styleString << " >");
            std::string text = TextUtils::ApplyTextFunctions(textRun->GetText(), context->GetLang());
            text = Utils::HandleEscapeSequences(text);
            uiTextRun.append(text);
            uiTextRun.append("</a>");
        }
        else
        {
            std::string text = TextUtils::ApplyTextFunctions(textRun->GetText(), context->GetLang());
            text = Utils::HandleEscapeSequences(text);
            uiTextRun.append(text);
        }
		uiTextRun.append("</span>");

		return uiTextRun;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ToggleInputRender(std::shared_ptr<AdaptiveCards::ToggleInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
        const std::string origionalElementId = input->GetId();
        input->SetId(context->ConvertToValidId(input->GetId()));

		const auto valueOn = !input->GetValueOn().empty() ? input->GetValueOn() : "true";
		const auto valueOff = !input->GetValueOff().empty() ? input->GetValueOff() : "false";
		const bool isChecked = input->GetValue().compare(valueOn) == 0 ? true : false;

		//TODO: Add Height
		const auto checkbox = GetCheckBox(RendererQml::Checkbox(input->GetId(),
            CheckBoxType::Toggle,
			input->GetTitle(),
			input->GetValue(),
			valueOn,
			valueOff,
			input->GetWrap(),
			input->GetIsVisible(),
			isChecked), context);

        context->addToInputElementList(origionalElementId, (checkbox->GetId() + ".value"));
        return checkbox;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ChoiceSetRender(std::shared_ptr<AdaptiveCards::ChoiceSetInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
        const std::string origionalElementId = input->GetId();
        input->SetId(context->ConvertToValidId(input->GetId()));

		int ButtonNumber = 0;
		RendererQml::Checkboxes choices;
		const std::string id = input->GetId();
		enum CheckBoxType type = !input->GetIsMultiSelect() && input->GetChoiceSetStyle() == AdaptiveCards::ChoiceSetStyle::Compact ? ComboBox : input->GetIsMultiSelect() ? CheckBox : RadioButton;
		const bool isWrap = input->GetWrap();
		const bool isVisible = input->GetIsVisible();
		bool isChecked;

        std::shared_ptr<QmlTag> uiChoiceSet;
        const std::vector<std::string> parsedValues = Utils::splitString(input->GetValue(), ',');

		for (const auto& choice : input->GetChoices())
		{
			isChecked = (std::find(parsedValues.begin(), parsedValues.end(), choice->GetValue()) != parsedValues.end() && (input->GetIsMultiSelect() || parsedValues.size() == 1)) ? true : false;
			choices.emplace_back(RendererQml::Checkbox(GenerateChoiceSetButtonId(id, type, ButtonNumber++),
				type,
				choice->GetTitle(),
				choice->GetValue(),
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

		if (type == CheckBoxType::ComboBox)
		{
            uiChoiceSet = GetComboBox(choiceSet,context);
            context->addToInputElementList(origionalElementId, (uiChoiceSet->GetId() + ".currentValue"));
		}
		else
		{
            uiChoiceSet = GetButtonGroup(choiceSet, context);
            context->addToInputElementList(origionalElementId, (uiChoiceSet->GetId() + ".getSelectedValues()"));
		}

		return uiChoiceSet;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetComboBox(ChoiceSet choiceset, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto uiComboBox = std::make_shared<QmlTag>("ComboBox");
		const auto fontFamily = context->GetConfig()->GetFontFamily(AdaptiveCards::FontType::Default);
		const auto fontSize = context->GetConfig()->GetFontSize(AdaptiveCards::FontType::Default, AdaptiveCards::TextSize::Default);
		const auto textColor = context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false);
		const auto backgroundColor = context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor);

		//TODO: Make Padding uniform across all input elements
		//Padding for top, bottom and right
		const auto padding = context->GetConfig()->GetSpacing().smallSpacing;
		const auto leftPadding = 10;
		const int dropDownHeight = 250;

		uiComboBox->Property("id",choiceset.id);
		uiComboBox->Property("textRole", "'text'");
		uiComboBox->Property("valueRole", "'value'");
		uiComboBox->Property("width", "parent.width");
		uiComboBox->Property("height", "contentItem.contentHeight + 2*contentItem.padding < 30 ? 30 : contentItem.contentHeight + 2*contentItem.padding ");
		
        const std::string iconId = choiceset.id + "_icon";
		auto iconTag = GetIconTag(context);
        iconTag->Property("id", iconId);
        iconTag->Property("horizontalPadding", "9");
        iconTag->Property("verticalPadding", "9");
        iconTag->Property("icon.source", RendererQml::arrow_down_12, true);
        iconTag->Property("enabled", "false");
        iconTag->Property("icon.width", "12");
        iconTag->Property("icon.height", "12");

        uiComboBox->Property("indicator", iconTag->ToString());
		uiComboBox->Property("model", GetModel(choiceset.choices));

        auto backgroundTag = std::make_shared<QmlTag>("Rectangle");
        backgroundTag->Property("radius", "5");
        //TODO: These color styling should come from css
        backgroundTag->Property("color", backgroundColor);
        backgroundTag->Property("border.color", "inputElementsBorderColor");
        backgroundTag->Property("border.width", "1");
		uiComboBox->Property("background", backgroundTag->ToString());

		if (!choiceset.placeholder.empty())
		{
			uiComboBox->Property("currentIndex", "-1");
			uiComboBox->Property("displayText", "currentIndex === -1 ? '" + choiceset.placeholder + "' : currentText");
		}
		else if (choiceset.values.size() == 1)
		{
			const std::string target = choiceset.values[0];
			auto index = std::find_if(choiceset.choices.begin(), choiceset.choices.end(), [target](const Checkbox& options) {
				return options.value == target;
			}) - choiceset.choices.begin();
			//Assign index as 0 in case target does not exist
			index = (index > (signed int)(choiceset.choices.size() - 1) ? 0 : index);
			uiComboBox->Property("currentIndex", std::to_string(index));
			uiComboBox->Property("displayText", "currentText");
		}

		auto itemDelegateId = choiceset.id + "_itemDelegate";
		auto uiItemDelegate = std::make_shared<QmlTag>("ItemDelegate");
		uiItemDelegate->Property("id", itemDelegateId);
		uiItemDelegate->Property("width", "parent.width");
		uiItemDelegate->Property("verticalPadding", std::to_string(padding));
		uiItemDelegate->Property("horizontalPadding", std::to_string(padding));
		uiItemDelegate->Property("leftPadding", std::to_string(leftPadding));
		uiItemDelegate->Property("highlighted", "ListView.isCurrentItem");

        auto backgroundTagDelegate = std::make_shared<QmlTag>("Rectangle");
        //TODO: These color styling should come from css
        backgroundTagDelegate->Property("color", Formatter() << itemDelegateId << ".highlighted?" << context->GetColor(AdaptiveCards::ForegroundColor::Accent, false, false) << " : " << backgroundColor);
        uiItemDelegate->Property("background", backgroundTagDelegate->ToString());

		auto uiItemDelegate_Text = std::make_shared<QmlTag>("Text");
		uiItemDelegate_Text->Property("text", "modelData.text");
		uiItemDelegate_Text->Property("font.family", fontFamily, true);
		uiItemDelegate_Text->Property("font.pixelSize", std::to_string(fontSize));
		uiItemDelegate_Text->Property("textFormat", "Text.RichText");
		uiItemDelegate_Text->Property("verticalAlignment", "Text.AlignVCenter");
		uiItemDelegate_Text->Property("color", Formatter() << itemDelegateId << ".highlighted?" << "'white' : " << textColor);

		if (choiceset.choices[0].isWrap)
		{
			uiItemDelegate_Text->Property("wrapMode", "Text.Wrap");
		}
		else
		{
			uiItemDelegate_Text->Property("elide", "Text.ElideRight");
		}

		auto uiContentItem_Text = std::make_shared<QmlTag>("Text");
		uiContentItem_Text->Property("text", "parent.displayText");
		uiItemDelegate_Text->Property("font.family", fontFamily, true);
		uiContentItem_Text->Property("font.pixelSize", std::to_string(fontSize));
		uiContentItem_Text->Property("verticalAlignment", "Text.AlignVCenter");
		uiContentItem_Text->Property("padding", std::to_string(padding));
		uiContentItem_Text->Property("leftPadding", std::to_string(leftPadding));
		uiContentItem_Text->Property("elide", "Text.ElideRight");
		uiContentItem_Text->Property("color", textColor);

		uiComboBox->Property("contentItem", uiContentItem_Text->ToString());

		uiItemDelegate->Property("contentItem", uiItemDelegate_Text->ToString());

		uiComboBox->Property("delegate", uiItemDelegate->ToString());

		auto contentListViewId = choiceset.id + "_listView";
		auto contentListViewTag = std::make_shared<QmlTag>("ListView");
		contentListViewTag->Property("id", contentListViewId);
		contentListViewTag->Property("clip", "true");
		contentListViewTag->Property("model", Formatter() << choiceset.id << ".delegateModel");
		contentListViewTag->Property("currentIndex", Formatter() << choiceset.id << ".highlightedIndex");
		
		auto scrollBarTag = std::make_shared<QmlTag>("ScrollBar");
		scrollBarTag->Property("width", "10");
		scrollBarTag->Property("policy", Formatter() << contentListViewId << ".contentHeight > " << std::to_string(dropDownHeight) << "?" << "ScrollBar.AlwaysOn : ScrollBar.AsNeeded");

		contentListViewTag->Property("ScrollBar.vertical", scrollBarTag->ToString());

		auto popupBackgroundTag = std::make_shared<QmlTag>("Rectangle");
		popupBackgroundTag->Property("anchors.fill", "parent");
		popupBackgroundTag->Property("color", backgroundColor);
		popupBackgroundTag->Property("border.color", "inputElementsBorderColor");

		auto popupTag = std::make_shared<QmlTag>("Popup");
		popupTag->Property("y", Formatter() << choiceset.id << ".height-1");
		popupTag->Property("width", Formatter() << choiceset.id << ".width");
		popupTag->Property("horizontalPadding", "2");
		popupTag->Property("verticalPadding", "2");
		popupTag->Property("height", Formatter() << contentListViewId << ".contentHeight" << " > " << std::to_string(dropDownHeight) << " ? " << std::to_string(dropDownHeight) << ":" << contentListViewId << ".contentHeight");

		popupTag->Property("background", popupBackgroundTag->ToString());
		popupTag->Property("contentItem", contentListViewTag->ToString());

		uiComboBox->Property("popup", popupTag->ToString());

		return uiComboBox;
	}

	std::string AdaptiveCardQmlRenderer::GetModel(std::vector<Checkbox>& Choices)
	{
		std::ostringstream model;
		std::string choice_Text;
		std::string choice_Value;

		model << "[";
		for (const auto& choice : Choices)
		{
			choice_Text = choice.text;
			choice_Value = choice.value;
			model << "{ value: '" << Utils::HandleEscapeSequences(choice_Value) << "', text: '" << Utils::HandleEscapeSequences(choice_Text) << "'},\n";
		}
		model << "]";
		return model.str();
	}

	std::string AdaptiveCardQmlRenderer::GenerateChoiceSetButtonId(const std::string& parentId, enum CheckBoxType ButtonType, const int& ButtonNumber)
	{

		return parentId + "_" + std::to_string(ButtonType) + "_" + std::to_string(ButtonNumber);
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetButtonGroup(ChoiceSet choiceset, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto uiColumn = std::make_shared<QmlTag>("Column");
        uiColumn->Property("id", choiceset.id);

		auto uiButtonGroup = std::make_shared<QmlTag>("ButtonGroup");
		uiButtonGroup->Property("id", choiceset.id + "_btngrp");

		if (choiceset.isMultiSelect)
		{
			uiButtonGroup->Property("buttons", choiceset.id + "_checkbox.children");
			uiButtonGroup->Property("exclusive", "false");
		}
		else
		{
			uiButtonGroup->Property("buttons", choiceset.id + "_radio.children");
		}

		uiColumn->AddChild(uiButtonGroup);

		auto uiInnerColumn = std::make_shared<QmlTag>("ColumnLayout");

		if (choiceset.isMultiSelect)
		{
			uiInnerColumn->Property("id", choiceset.id + "_checkbox");
		}
		else
		{
			uiInnerColumn->Property("id", choiceset.id + "_radio");
		}

        // render as a series of buttons
        for (const auto& choice : choiceset.choices)
        {
            uiInnerColumn->AddChild(GetCheckBox(choice, context));
        }

		uiColumn->AddChild(uiInnerColumn);
        uiColumn->AddFunctions(getChoiceSetSelectedValuesFunc(uiButtonGroup, choiceset.isMultiSelect));
		return uiColumn;
	}

    const std::string AdaptiveCardQmlRenderer::getChoiceSetSelectedValuesFunc(const std::shared_ptr<QmlTag>& btnGroup, const bool isMultiselect)
    {
        std::ostringstream function;
        function << "function getSelectedValues(isMultiselect){\n";
        function << "var values = \"\";\n";
        if (isMultiselect)
        {
            function << "for (var i = 0; i < " << btnGroup->GetId() << ".buttons.length; ++i) {\n";
            function << "if(i !== 0 && " << btnGroup->GetId() << ".buttons[i].value !== \"\" && values !== \"\"){\n";
            function << "values += \",\";\n";
            function << "}\n";
            function << "values += " << btnGroup->GetId() << ".buttons[i].value;\n";
            function << "}\n";
        }
        else
        {
            function << "for (var i = 0; i < " << btnGroup->GetId() << ".buttons.length; ++i) {\n";
            function << "if(" << btnGroup->GetId() << ".buttons[i].value !== \"\"){\n";
            function << "values += " << btnGroup->GetId() << ".buttons[i].value;\n";
            function << "break;\n";
            function << "}\n}\n";
        }
        function << "return values;\n";
        function << "}\n";
        return function.str();
    }

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetCheckBox(Checkbox checkbox, std::shared_ptr<AdaptiveRenderContext> context)
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

        uiButton->Property("id", checkbox.id);

		if (checkbox.type == CheckBoxType::Toggle)
		{
			uiButton->Property("readonly property string valueOn", checkbox.valueOn, true);
			uiButton->Property("readonly property string valueOff", checkbox.valueOff, true);
            uiButton->Property("property string value", "checked ? valueOn : valueOff");
			uiButton->Property("width", "parent.width");
		}
        else
        {
            uiButton->Property("property string value", Formatter() << "checked ? \"" << checkbox.value << "\" : \"\"");
			uiButton->Property("Layout.maximumWidth", "parent.parent.parent.width");
        }

		uiButton->Property("text", checkbox.text, true);
		uiButton->Property("font.pixelSize", std::to_string(context->GetConfig()->GetFontSize(AdaptiveCards::FontType::Default, AdaptiveCards::TextSize::Default)));

		if (!checkbox.isVisible)
		{
			uiButton->Property("visible", "false");
		}

		if (checkbox.isChecked)
		{
			uiButton->Property("checked", "true");
		}

		auto uiOuterRectangle = std::make_shared<QmlTag>("Rectangle");
		uiOuterRectangle->Property("width", "parent.font.pixelSize");
		uiOuterRectangle->Property("height", "parent.font.pixelSize");
		uiOuterRectangle->Property("y", "parent.topPadding + (parent.availableHeight - height) / 2");
		if (checkbox.type == CheckBoxType::RadioButton)
		{
			uiOuterRectangle->Property("radius", "height/2");
		}
		else
		{
			uiOuterRectangle->Property("radius", "3");
		}

		auto highlightColor = context->GetColor(AdaptiveCards::ForegroundColor::Accent, false, false);
		uiOuterRectangle->Property("border.color", Formatter() << checkbox.id << ".checked ? " << highlightColor << ": '#b0b0b0'");
		uiOuterRectangle->Property("color", Formatter() << checkbox.id << ".checked ? " << highlightColor << " : '#ffffff'");

		std::shared_ptr<QmlTag> uiInnerSegment;

		if (checkbox.type == CheckBoxType::RadioButton)
		{
			uiInnerSegment = std::make_shared<QmlTag>("Rectangle");
			uiInnerSegment->Property("width", "parent.width/2");
			uiInnerSegment->Property("height", "parent.height/2");
			uiInnerSegment->Property("x", "width/2");
			uiInnerSegment->Property("y", "height/2");
			uiInnerSegment->Property("radius", "height/2");
			uiInnerSegment->Property("color", checkbox.id + ".checked ? '#ffffff' : 'defaultPalette.backgroundColor'");
			uiInnerSegment->Property("visible", checkbox.id + ".checked");
		}
		else
		{
			uiInnerSegment = std::make_shared<QmlTag>("Image");
			uiInnerSegment->Property("anchors.centerIn", "parent");
			uiInnerSegment->Property("width", "parent.width - 3");
			uiInnerSegment->Property("height", "parent.height - 3");
			uiInnerSegment->Property("visible", checkbox.id + ".checked");

			uiInnerSegment->Property("source", RendererQml::check_icon_12, true);
		}

		uiOuterRectangle->AddChild(uiInnerSegment);

		uiButton->Property("indicator", uiOuterRectangle->ToString());

		auto uiText = std::make_shared<QmlTag>("Text");
		uiText->Property("text", "parent.text");
		uiText->Property("font", "parent.font");
		uiText->Property("horizontalAlignment", "Text.AlignLeft");
		uiText->Property("verticalAlignment", "Text.AlignVCenter");
		uiText->Property("leftPadding", "parent.indicator.width + parent.spacing");
        uiText->Property("color", context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false));

		if (checkbox.isWrap)
		{
			uiText->Property("wrapMode", "Text.Wrap");
		}
		else
		{
			uiText->Property("elide", "Text.ElideRight");
		}

		uiButton->Property("contentItem", uiText->ToString());

		return uiButton;
	}

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::DateInputRender(std::shared_ptr<AdaptiveCards::DateInput> input, std::shared_ptr<AdaptiveRenderContext> context)
    {
        const std::string origionalElementId = input->GetId();
        input->SetId(context->ConvertToValidId(input->GetId()));

        auto uiTextFieldId = input->GetId() + "_text";
        auto uiTextField = std::make_shared<QmlTag>("TextField");
        uiTextField->Property("id", uiTextFieldId);
        uiTextField->Property("width", "parent.width");
        const int fontSize = context->GetConfig()->GetFontSize(AdaptiveCards::FontType::Default, AdaptiveCards::TextSize::Default);

        uiTextField->Property("font.family", context->GetConfig()->GetFontFamily(AdaptiveCards::FontType::Default), true);
        uiTextField->Property("font.pixelSize", std::to_string(fontSize));
        uiTextField->Property("selectByMouse", "true");
        uiTextField->Property("selectedTextColor", "'white'");
        uiTextField->Property("color", context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false));

        uiTextField->Property("property string selectedDate", input->GetValue(), true);
        uiTextField->AddFunctions(Formatter() << "signal " << "textChanged" << uiTextField->GetId() << "(var dateText)");

        //TODO: Add stretch property

        if (!input->GetIsVisible())
        {
            uiTextField->Property("visible", "false");
        }

        std::string calendar_box_id = input->GetId() + "_cal_box";

        auto backgroundTag = std::make_shared<QmlTag>("Rectangle");
        backgroundTag->Property("radius", "5");
        //TODO: These color styling should come from css
        backgroundTag->Property("color", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));
        backgroundTag->Property("border.color", Formatter() << uiTextFieldId << ".activeFocus? 'black' : inputElementsBorderColor");
        backgroundTag->Property("border.width", "1");
        uiTextField->Property("background", backgroundTag->ToString());

		//Clear Icon
		const std::string clearIconId = Formatter() << input->GetId() << "_clear" << "_icon";
		auto rowIconTag = GetRowWithClearIconTag(clearIconId, context);

		auto clearIconTag = rowIconTag->GetChildren().front();
		clearIconTag->Property("anchors.verticalCenter", "parent.verticalCenter");

		std::string clearIcon_visible_value = Formatter() << "(!" << uiTextFieldId << ".focus && " << uiTextFieldId << ".text !==\"\") || (" << uiTextFieldId << ".focus && " << uiTextFieldId << ".text !== " << "\"\\/\\/\")";
		clearIconTag->Property("visible", clearIcon_visible_value);
		
		std::string clearIcon_OnClicked_value = Formatter() << " { if(!" << uiTextFieldId << ".focus)" << "{"
			<< uiTextFieldId << ".forceActiveFocus();" << "}" << "\n"
			<< uiTextFieldId << ".clear();\n" << "}";
		clearIconTag->Property("onClicked", clearIcon_OnClicked_value);

		//Date Icon
        const std::string iconId = input->GetId() + "_icon";
        std::string onClicked_value = "{ " + uiTextFieldId + ".forceActiveFocus(); " + calendar_box_id + ".open();}";

        auto iconTag = GetIconTag(context);

		iconTag->RemoveProperty("anchors.top");
		iconTag->RemoveProperty("anchors.bottom");
		iconTag->RemoveProperty("anchors.right");
		iconTag->RemoveProperty("anchors.margins");

		iconTag->Property("id", iconId);
		iconTag->Property("width", "icon.width");
		iconTag->Property("height", "icon.height");
		iconTag->Property("horizontalPadding", "0");
		iconTag->Property("verticalPadding", "0");
		iconTag->Property("anchors.verticalCenter", "parent.verticalCenter");
        iconTag->Property("icon.source", RendererQml::calendar_icon_18, true);
        iconTag->Property("onClicked", onClicked_value);

		rowIconTag->AddChild(iconTag);
		
        auto calendarTag = std::make_shared<QmlTag>("Calendar");
        calendarTag->AddImports("import QtQuick.Controls 1.4");
        calendarTag->AddImports("import QtQuick 2.15");
        calendarTag->Property("anchors.fill", "parent");

        if (!input->GetMin().empty() && Utils::isValidDate(input->GetMin()))
        {
            calendarTag->Property("minimumDate", Utils::GetDate(input->GetMin()));
        }

        if (!input->GetMax().empty() && Utils::isValidDate(input->GetMax()))
        {
            calendarTag->Property("maximumDate", Utils::GetDate(input->GetMax()));
        }

        //Supporting function to handle the signal of the TextField
        calendarTag->AddFunctions(Formatter() << "function setCalendarDate(dateString)"
            << "{"
            << "var Months = {Jan: 0,Feb: 1,Mar: 2,Apr: 3,May: 4,Jun: 5,July: 6,Aug: 7,Sep: 8,Oct: 9,Nov: 10,Dec: 11};"
            << "var y=dateString.match(/\\\\d{4}/);"
            << "dateString=dateString.replace(y,\"\");"
            << "var m=dateString.match(/[a-zA-Z]{3}/);"
            << "var d=dateString.match(/\\\\d{2}/);"
            << "if (d!==null && m!==null && y!==null){selectedDate=new Date(y[0],Months[m[0]],d[0]) }"
            << "}");

        calendarTag->Property("Component.onCompleted", Formatter() << "{"
            << uiTextField->GetId() << "." << "textChanged" << uiTextField->GetId() << ".connect(setCalendarDate);"
            << uiTextField->GetId() << "." << "textChanged" << uiTextField->GetId() << "( " << uiTextField->GetId() << ".text)"
            << "}");

        auto calendarContentItemTag = std::make_shared<QmlTag>("Rectangle");
        calendarContentItemTag->Property("anchors.fill", "parent");
        calendarContentItemTag->Property("anchors.margins", "2");

        auto calendarBoxTag = std::make_shared<QmlTag>("Popup");
        calendarBoxTag->Property("id", calendar_box_id);
        calendarBoxTag->Property("y", Formatter() << uiTextFieldId << ".height-1");
        calendarBoxTag->Property("width", "300");
        calendarBoxTag->Property("height", "300");

        auto EnumDateFormat = Utils::GetSystemDateFormat();

        const auto dateSeparator = "\\/";
        const auto day_Regex = "([-0123]-|0\\d|[12]\\d|3[01])";
        const auto month_Regex = "(---|[JFMASOND]--|Ja-|Jan|Fe-|Feb|Ma-|Mar|Ap-|Apr|May|Ju-|Jun|Jul|Au-|Aug|Se-|Sep|Oc-|Oct|No-|Nov|De-|Dec)";
        const auto year_Regex = "(-{4}|\\d-{3}|\\d{2}-{2}|\\d{3}-|\\d{4})";

        //Default date format: MMM-dd-yyyy
        auto month_Text = "getText(0,3)";
        auto day_Text = "getText(4,6)";
        auto year_Text = "getText(7,11)";
        std::string DateRegex = Formatter() << "/^" << month_Regex << dateSeparator << day_Regex << dateSeparator << year_Regex << "$/";
        std::string StringDateFormat = Formatter() << "MMM" << dateSeparator << "dd" << dateSeparator << "yyyy";
        std::string inputMask = Formatter() << ">x<xx" << dateSeparator << "xx" << dateSeparator << "xxxx;-";

        switch (EnumDateFormat)
        {
        case RendererQml::DateFormat::ddmmyy:
        {
            StringDateFormat = Formatter() << "dd" << dateSeparator << "MMM" << dateSeparator << "yyyy";
            inputMask = Formatter() << "xx" << dateSeparator << ">x<xx" << dateSeparator << "xxxx;-";
            DateRegex = Formatter() << "/^" << day_Regex << dateSeparator << month_Regex << dateSeparator << year_Regex << "$/";

            day_Text = "getText(0,2)";
            month_Text = "getText(3,6)";
            year_Text = "getText(7,11)";
            break;
        }
        case RendererQml::DateFormat::yymmdd:
        {
            StringDateFormat = Formatter() << "yyyy" << dateSeparator << "MMM" << dateSeparator << "dd";
            inputMask = Formatter() << "xxxx" << dateSeparator << ">x<xx" << dateSeparator << "xx;-";
            DateRegex = Formatter() << "/^" << year_Regex << dateSeparator << month_Regex << dateSeparator << day_Regex << "$/";

            day_Text = "getText(9,11)";
            month_Text = "getText(5,8)";
            year_Text = "getText(0,4)";
            break;
        }
        case RendererQml::DateFormat::yyddmm:
        {
            StringDateFormat = Formatter() << "yyyy" << dateSeparator << "dd" << dateSeparator << "MMM";
            inputMask = Formatter() << "xxxx" << dateSeparator << "xx" << dateSeparator << ">x<xx;-";
            DateRegex = Formatter() << "/^" << year_Regex << dateSeparator << day_Regex << dateSeparator << month_Regex << "$/";

            day_Text = "getText(5,7)";
            month_Text = "getText(8,11)";
            year_Text = "getText(0,4)";
            break;
        }
        //Default case: mm-dd-yyyy
        default:
        {
            break;
        }
        }

        uiTextField->AddFunctions(Formatter() << "function setValidDate(dateString)"
            << "{"
            << "var Months = {Jan: 0,Feb: 1,Mar: 2,Apr: 3,May: 4,Jun: 5,July: 6,Aug: 7,Sep: 8,Oct: 9,Nov: 10,Dec: 11};"
            << "var d=new Date(" << year_Text << ","
            << "Months[" << month_Text << "]," << day_Text << ");"
            << "if( d.getFullYear().toString() === " << year_Text << "&& d.getMonth()===Months[" << month_Text << "] && d.getDate().toString()===" << day_Text << ")"
            << "{"
            << "selectedDate = d.toLocaleString(Qt.locale(\"en_US\"),\"yyyy-MM-dd\");"
            << "}"
            << "else { selectedDate = '' };"
            << "}");

        uiTextField->Property("onTextChanged", Formatter() << "{" << "textChanged" << uiTextField->GetId() << "(text);"
            << "setValidDate(text);"
            << "}");

        if (!input->GetValue().empty() && Utils::isValidDate(input->GetValue()))
        {
            uiTextField->Property("text", Formatter() << Utils::GetDate(input->GetValue()) << ".toLocaleString(Qt.locale(\"en_US\"),"
                << "\"" << StringDateFormat << "\""
                << ")");
        }

        uiTextField->Property("validator", Formatter() << "RegExpValidator { regExp: " << DateRegex << "}");
        uiTextField->Property("onFocusChanged", Formatter() << "{"
            << "if(focus===true) inputMask=\"" << inputMask << "\";"
            << "if(focus === false){ "
            << "if(text === \"" << std::string(dateSeparator) + std::string(dateSeparator) << "\"){ inputMask = \"\" ; } "
            << "}} ");
        calendarTag->Property("onReleased", Formatter() << "{" << calendar_box_id << ".close(); " << uiTextFieldId << ".text=selectedDate.toLocaleString(Qt.locale(\"en_US\"),"
            << "\"" << StringDateFormat << "\")}");

        calendarContentItemTag->Property("Component.onCompleted", "{ Qt.createQmlObject('" + calendarTag->ToString() + "', parent ,'calendar')}");
        calendarBoxTag->Property("contentItem", calendarContentItemTag->ToString());

        uiTextField->Property("placeholderText", Formatter() << (!input->GetPlaceholder().empty() ? input->GetPlaceholder() : "Select date") << " in " << Utils::ToLower(StringDateFormat), true);

        auto uiDateInput = std::make_shared<QmlTag>("ComboBox");
        uiDateInput->Property("id", input->GetId());
        uiDateInput->Property("width", "parent.width");
        uiDateInput->Property("background", uiTextField->ToString());
        uiDateInput->Property("popup", calendarBoxTag->ToString());
        uiDateInput->Property("indicator", rowIconTag->ToString());

        context->addToInputElementList(origionalElementId, (uiTextField->GetId() + ".selectedDate"));

        return uiDateInput;
    }

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::FactSetRender(std::shared_ptr<AdaptiveCards::FactSet> factSet, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto uiFactSet = std::make_shared<QmlTag>("GridLayout");

		if (!factSet->GetId().empty())
		{
			factSet->SetId(context->ConvertToValidId(factSet->GetId()));
			uiFactSet->Property("id", factSet->GetId());
		}

		uiFactSet->Property("columns", "2");
		uiFactSet->Property("rows", std::to_string(factSet->GetFacts().size()));
		uiFactSet->Property("property int titleWidth", "0");
		uiFactSet->Property("property int minWidth", Formatter() << context->getCardRootId() << ".getMinWidthFactSet(children, columnSpacing)");
		uiFactSet->AddFunctions("function setTitleWidth(item){	if (item.width > titleWidth){ titleWidth = item.width }}");

		if (!factSet->GetIsVisible())
		{
			uiFactSet->Property("visible", "false");
		}

		for (const auto fact : factSet->GetFacts())
		{
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
			uiTitle->Property("Layout.maximumWidth", std::to_string(context->GetConfig()->GetFactSet().title.maxWidth));
			uiTitle->Property("Component.onCompleted", "parent.setTitleWidth(this)");

			//uiTitle->Property("spacing", std::to_string(context->GetConfig()->GetFactSet().spacing));

			auto factValue = std::make_shared<AdaptiveCards::TextBlock>();

			factValue->SetText(fact->GetValue());
			factValue->SetTextSize(context->GetConfig()->GetFactSet().value.size);
			factValue->SetTextColor(context->GetConfig()->GetFactSet().value.color);
			factValue->SetTextWeight(context->GetConfig()->GetFactSet().value.weight);
			factValue->SetIsSubtle(context->GetConfig()->GetFactSet().value.isSubtle);
			factValue->SetWrap(context->GetConfig()->GetFactSet().value.wrap);
			// MaxWidth is not supported on the Value of FactSet. Do not set it.

			auto uiValue = context->Render(factValue);
			uiValue->Property("Layout.preferredWidth", "parent.parent.width - parent.titleWidth");

			uiFactSet->AddChild(uiTitle);
			uiFactSet->AddChild(uiValue);
		}

		return uiFactSet;
    }

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ImageRender(std::shared_ptr<AdaptiveCards::Image> image, std::shared_ptr<AdaptiveRenderContext> context)
	{
		//TODO: Height(Stretch/Automatic)

		std::shared_ptr<QmlTag> maskTag;
		std::shared_ptr<QmlTag> maskSourceTag;
		auto uiRectangle = std::make_shared<QmlTag>("Rectangle");
		auto uiImage = std::make_shared<QmlTag>("Image");

		if (image->GetId().empty())
		{
			image->SetId(Formatter() << "image_auto_" << context->getImageCounter());
		}
        else
        {
            image->SetId(context->ConvertToValidId(image->GetId()));
        }

		uiRectangle->Property("id", image->GetId());
		uiRectangle->Property("implicitHeight", "height");
        uiRectangle->Property("readonly property string bgColor", "'transparent'");
		uiImage->Property("id", Formatter() << image->GetId() << "_img");
		uiImage->Property("readonly property bool isImage", "true");
        uiImage->Property("cache", "false");
		uiImage->Property("source", image->GetUrl(), true);
		uiImage->Property("anchors.fill", "parent");
		uiImage->Property("visible", "parent.visible");

		if (!image->GetIsVisible())
		{
			uiRectangle->Property("visible", "false");
		}

		if (image->GetHeight() == AdaptiveCards::HeightType::Stretch && image->GetPixelHeight() == 0)
		{
			uiRectangle->Property("readonly property bool stretch", "true");
		}

		if (image->GetPixelWidth() != 0 || image->GetPixelHeight() != 0)
		{
			if (image->GetPixelWidth() != 0)
			{
				uiRectangle->Property("width", Formatter() << "parent.width != 0 ? Math.min(" << image->GetPixelWidth() << ", parent.width) : " << image->GetPixelWidth());

				if (image->GetPixelHeight() == 0)
				{
					uiRectangle->Property("height", Formatter() << image->GetId() << "_img.implicitHeight / " << image->GetId() << "_img.implicitWidth * width");
				}
			}
			if (image->GetPixelHeight() != 0)
			{
				uiRectangle->Property("height", Formatter() << image->GetPixelHeight());

				if (image->GetPixelWidth() == 0)
				{
					uiRectangle->Property("readonly property int aspectWidth", Formatter() << image->GetId() << "_img.implicitWidth / " << image->GetId() << "_img.implicitHeight * height");
					uiRectangle->Property("width", Formatter() << "parent.width != 0 ? Math.min(aspectWidth, parent.width) : aspectWidth");
				}
			}

			if (image->GetPixelWidth() != 0)
			{
				uiRectangle->Property("implicitWidth", std::to_string(image->GetPixelWidth()));
			}
			else
			{
				uiRectangle->Property("implicitWidth", "aspectWidth");
			}
		}
		else
		{
			switch (image->GetImageSize())
			{
			case AdaptiveCards::ImageSize::None:
			case AdaptiveCards::ImageSize::Auto:
				uiRectangle->Property("width", "parent.width");
				break;
			case AdaptiveCards::ImageSize::Small:
				uiRectangle->Property("width", Formatter() << context->GetConfig()->GetImageSizes().smallSize);
				break;
			case AdaptiveCards::ImageSize::Medium:
				uiRectangle->Property("width", Formatter() << context->GetConfig()->GetImageSizes().mediumSize);
				break;
			case AdaptiveCards::ImageSize::Large:
				uiRectangle->Property("width", Formatter() << context->GetConfig()->GetImageSizes().largeSize);
				break;
			case AdaptiveCards::ImageSize::Stretch:
				uiRectangle->Property("width", "parent.width");
				break;
			}

			uiRectangle->Property("height", Formatter() << image->GetId() << "_img.implicitHeight / " << image->GetId() << "_img.implicitWidth * width");

			if (image->GetImageSize() == AdaptiveCards::ImageSize::None)
			{
				uiRectangle->Property("implicitWidth", Formatter() << image->GetId() << "_img.implicitWidth");
			}
			else
			{
				uiRectangle->Property("implicitWidth", "width");
			}

		}

		if (!image->GetBackgroundColor().empty())
		{
            uiRectangle->Property("readonly property string bgColor", context->GetRGBColor(image->GetBackgroundColor()));
		}
        uiRectangle->Property("color", "bgColor");

		switch (image->GetHorizontalAlignment())
		{
		case AdaptiveCards::HorizontalAlignment::Center:
			uiRectangle->Property("anchors.horizontalCenter", "parent.horizontalCenter");
			break;
		case AdaptiveCards::HorizontalAlignment::Right:
			uiRectangle->Property("anchors.right", "parent.right");
			break;
		default:
			break;
		}

		switch (image->GetImageStyle())
		{
		case AdaptiveCards::ImageStyle::Default:
			break;
		case AdaptiveCards::ImageStyle::Person:
			uiRectangle->Property("radius", "width/2");
			break;
		}

		uiRectangle->AddChild(uiImage);

        addSelectAction(uiRectangle, uiRectangle->GetId(), image->GetSelectAction(), context);

		return uiRectangle;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::TimeInputRender(std::shared_ptr<AdaptiveCards::TimeInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
        const std::string origionalElementId = input->GetId();
		const bool is12hour = Utils::isSystemTime12Hour();

        input->SetId(context->ConvertToValidId(input->GetId()));

		auto uiTimeComboBox = std::make_shared<QmlTag>("ComboBox");
		uiTimeComboBox->Property("width", "parent.width");

		auto uiTimeInput = std::make_shared<QmlTag>("TextField");
		const std::string id = input->GetId();
        const std::string value = input->GetValue();
		const int fontSize = context->GetConfig()->GetFontSize(AdaptiveCards::FontType::Default, AdaptiveCards::TextSize::Default);

		uiTimeInput->Property("id", id);
		uiTimeInput->Property("font.family", context->GetConfig()->GetFontFamily(AdaptiveCards::FontType::Default), true);
		uiTimeInput->Property("font.pixelSize", std::to_string(fontSize));
		uiTimeInput->Property("selectByMouse", "true");
		uiTimeInput->Property("selectedTextColor", "'white'");
        uiTimeInput->Property("property string selectedTime", "", true);
		uiTimeInput->Property("width", "parent.width");
		uiTimeInput->Property("placeholderText", !input->GetPlaceholder().empty() ? input->GetPlaceholder() : "Select time", true);
        uiTimeInput->Property("color", context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false));

		uiTimeInput->Property("validator", "RegExpValidator { regExp: /^(--|[01][0-9|-]|2[0-3|-]):(--|[0-5][0-9|-])$/}");

		if (!input->GetValue().empty() && Utils::isValidTime(value))
		{
			std::string defaultTime = value;
            std::string defaultSelectedTime = value;
			if (is12hour == true)
			{
				defaultTime = Utils::defaultTimeto12hour(defaultTime);
                defaultSelectedTime = Utils::defaultTimeto24hour(defaultSelectedTime);
			}
            else
            {
                defaultTime = defaultSelectedTime = Utils::defaultTimeto24hour(defaultTime);
            }
			uiTimeInput->Property("text", defaultTime, true);
            uiTimeInput->Property("property string selectedTime", defaultSelectedTime, true);
		}

		if (!input->GetIsVisible())
		{
			uiTimeInput->Property("visible", "false");
		}

		//TODO: Height Property
		// Time Format: hh:mm tt -> 03:30 AM or hh:mm -> 15:30
		std::string listViewHours_id = id + "_hours";
		std::string listViewMin_id = id + "_min";
		std::string listViewtt_id = id + "_tt";
		std::string timePopup_id = id + "_timeBox";

		uiTimeInput->Property("onFocusChanged", Formatter() << "{ if (focus===true) inputMask=\"xx:xx;-\";"
			<< " if(focus===false){ " << "if(text===\":\") { inputMask=\"\" }" << "}}");

		uiTimeInput->Property("onTextChanged", Formatter() << "{" << listViewHours_id << ".currentIndex=parseInt(getText(0,2));" << listViewMin_id << ".currentIndex=parseInt(getText(3,5));" << "if(getText(0,2) === '--' || getText(3,5) === '--'){" << id << ".selectedTime ='';} else{" << id << ".selectedTime =" << id << ".text;}}");

		auto backgroundTag = std::make_shared<QmlTag>("Rectangle");
		backgroundTag->Property("radius", "5");
		//TODO: These color styling should come from css
        //TODO: Add hover effect
        backgroundTag->Property("color", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));
        backgroundTag->Property("border.color", Formatter() << input->GetId() << ".activeFocus? 'black' : inputElementsBorderColor");
		backgroundTag->Property("border.width", "1");
		uiTimeInput->Property("background", backgroundTag->ToString());

		//Clear Icon
		const std::string clearIconId = Formatter() << id << "_clear" << "_icon";
		auto rowIconTag = GetRowWithClearIconTag(clearIconId, context);

		auto clearIconTag = rowIconTag->GetChildren().front();
		clearIconTag->Property("anchors.verticalCenter", "parent.verticalCenter");

		std::string clearIcon_visible_value = Formatter() << "(!" << id << ".focus && " << id << ".text !==\"\") || (" << id << ".focus && " << id << ".text !== " << (is12hour? "\": \"" : "\":\"") << ")" ;
		clearIconTag->Property("visible", clearIcon_visible_value);

		std::string clearIcon_OnClicked_value = Formatter() << " { if(!" << id << ".focus)" << "{"
			<< id << ".forceActiveFocus();" << "}" << "\n"
			<< id << ".clear();\n" << "}";
		clearIconTag->Property("onClicked", clearIcon_OnClicked_value);

		//Time Icon
        const std::string iconId = id + "_icon";
        auto iconTag = GetIconTag(context);
		iconTag->RemoveProperty("anchors.top");
		iconTag->RemoveProperty("anchors.bottom");
		iconTag->RemoveProperty("anchors.right");
		iconTag->RemoveProperty("anchors.margins");

        iconTag->Property("id", iconId);
		iconTag->Property("width", "icon.width");
		iconTag->Property("height", "icon.height");
		iconTag->Property("horizontalPadding", "0");
		iconTag->Property("verticalPadding", "0");
		iconTag->Property("anchors.verticalCenter", "parent.verticalCenter");
        iconTag->Property("icon.source", RendererQml::clock_icon_18, true);
        iconTag->Property("onClicked", Formatter() << "{" << id << ".forceActiveFocus();\n" << timePopup_id << ".open();\n" << listViewHours_id << ".currentIndex=parseInt(" << id << ".getText(0,2));\n" << listViewMin_id << ".currentIndex=parseInt(" << id << ".getText(3,5));\n" << "}");

		//Row that contains both the icons
		rowIconTag->AddChild(iconTag);

		//Popup that contains the hours and min ListViews
		auto PopupBgrTag = std::make_shared<QmlTag>("Rectangle");
		PopupBgrTag->Property("anchors.fill", "parent");
		//TODO: Finalize color for popup
		PopupBgrTag->Property("border.color", "'grey'");

		auto timePopupTag = std::make_shared<QmlTag>("Popup");
		timePopupTag->Property("id", timePopup_id);
		timePopupTag->Property("width", "105");
		timePopupTag->Property("height", "200");
		timePopupTag->Property("y", Formatter() << id << ".height - 1");
		timePopupTag->Property("background", PopupBgrTag->ToString());

		auto timeBoxTag = std::make_shared<QmlTag>("Rectangle");
		timeBoxTag->Property("anchors.fill", "parent");
		timeBoxTag->Property("anchors.margins", "1");
		
		//ListView for DropDown Selection
		std::map<std::string, std::map<std::string, std::string>> ListViewHoursProperties;
		std::map<std::string, std::map<std::string, std::string>> ListViewMinProperties;
		std::map<std::string, std::map<std::string, std::string>> ListViewttProperties;
		int hoursRange = 24;

		if (is12hour == true)
		{
			timePopupTag->Property("width", "155");
			uiTimeInput->Property("validator", "RegExpValidator { regExp: /^(--|[01]-|0\\d|1[0-2]):(--|[0-5]-|[0-5]\\d)\\s(--|A-|AM|P-|PM)$/}");
			uiTimeInput->Property("onFocusChanged", Formatter() << "{ if (focus===true) inputMask=\"xx:xx >xx;-\";" <<
				" if(focus===false){ " << "if(text===\": \" ) { inputMask=\"\" }" << "}}");
			uiTimeInput->Property("onTextChanged", Formatter() << "{" << listViewHours_id << ".currentIndex=parseInt(getText(0,2))-1;" << listViewMin_id << ".currentIndex=parseInt(getText(3,5));"
				<< "var tt_index=3;var hh = getText(0,2);" << "switch(getText(6,8)){ case 'PM':tt_index = 1; if(parseInt(getText(0,2))!==12){hh=parseInt(getText(0,2))+12;} break;case 'AM':tt_index = 0; if(parseInt(getText(0,2))===12){hh=parseInt(getText(0,2))-12;} break;}" << listViewtt_id << ".currentIndex=tt_index;" << "if(getText(0,2) === '--' || getText(3,5) === '--' || getText(6,8) === '--'){" << id <<".selectedTime ='';} else{" << id <<".selectedTime = (hh === 0 ? '00' : hh) + ':' + getText(3,5);}}");
			iconTag->Property("onClicked", Formatter() << "{" << id << ".forceActiveFocus();\n" << timePopup_id << ".open();\n" << listViewHours_id << ".currentIndex=parseInt(" << id << ".getText(0,2))-1;\n" << listViewMin_id << ".currentIndex=parseInt(" << id << ".getText(3,5));\n"
				<< "var tt_index=3;" << "switch(" << id << ".getText(6,8)){ case 'PM':tt_index = 1; break;case 'AM':tt_index = 0; break;}" << listViewtt_id << ".currentIndex=tt_index;" << "}");


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
		timePopupTag->Property("contentItem", timeBoxTag->ToString());
		uiTimeComboBox->Property("indicator", rowIconTag->ToString());
		uiTimeComboBox->Property("popup", timePopupTag->ToString());
		uiTimeComboBox->Property("background", uiTimeInput->ToString());
		
        context->addToInputElementList(origionalElementId, (uiTimeInput->GetId() + ".selectedTime"));

		return uiTimeComboBox;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ListViewTagforTimeInput(const std::string& parent_id, const std::string& listView_id, std::map<std::string, std::map<std::string, std::string>>& properties)
	{
		auto ListViewTag = std::make_shared<QmlTag>("ListView");
		ListViewTag->Property("id", listView_id);

		//TODO:Avoid fixed values inside ListView
		ListViewTag->Property("width", "45");
		ListViewTag->Property("height", "parent.height-10");
		ListViewTag->Property("anchors.margins", "5");
		ListViewTag->Property("anchors.top", "parent.top");
		ListViewTag->Property("flickableDirection", "Flickable.VerticalFlick");
		ListViewTag->Property("boundsBehavior", "Flickable.StopAtBounds");
		ListViewTag->Property("clip", "true");


		//Elements inside delegate: Rectangle{ Text{} MouseArea{} }
		std::string MouseArea_id = listView_id + "mouseArea";
		auto MouseAreaTag = std::make_shared<QmlTag>("MouseArea");
		MouseAreaTag->Property("id", MouseArea_id);
		MouseAreaTag->Property("anchors.fill", "parent");
		MouseAreaTag->Property("enabled", "true");
		MouseAreaTag->Property("hoverEnabled", "true");
		MouseAreaTag->Property("onClicked", Formatter() << "{" << listView_id << ".currentIndex=index;" << "var x=String(index).padStart(2, '0') ;" << parent_id << ".insert(0,x);" << "}");

		auto TextTag = std::make_shared<QmlTag>("Text");
		TextTag->Property("text", "String(index).padStart(2, '0')");
		TextTag->Property("anchors.fill", "parent");
		TextTag->Property("horizontalAlignment", "Text.AlignHCenter");
		TextTag->Property("verticalAlignment", "Text.AlignVCenter");
		TextTag->Property("color", Formatter() << listView_id << ".currentIndex==index ? \"white\" : \"black\"");

		auto delegateRectTag = std::make_shared<QmlTag>("Rectangle");
		delegateRectTag->Property("width", "45");
		delegateRectTag->Property("height", "45");
		delegateRectTag->Property("color", Formatter() << listView_id << ".currentIndex==index ? \"blue\" : " << MouseArea_id << ".containsMouse?\"lightblue\":\"white\"");

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
				propertyTag->Property(inner_iterator->first, inner_iterator->second);
			}
		}

		delegateRectTag->AddChild(MouseAreaTag);
		delegateRectTag->AddChild(TextTag);

		ListViewTag->Property("delegate", delegateRectTag->ToString());

		return ListViewTag;
	}

	std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::ImageSetRender(std::shared_ptr<AdaptiveCards::ImageSet> imageSet, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto uiFlow = std::make_shared<QmlTag>("Flow");

		uiFlow->Property("width", "parent.width");
		uiFlow->Property("spacing", "10");

		if (!imageSet->GetId().empty())
		{
			imageSet->SetId(context->ConvertToValidId(imageSet->GetId()));
			uiFlow->Property("id", imageSet->GetId());
		}

		if (!imageSet->GetIsVisible())
		{
			uiFlow->Property("visible", "false");
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

	void AdaptiveCardQmlRenderer::AddSeparator(std::shared_ptr<QmlTag> uiContainer, std::shared_ptr<AdaptiveCards::BaseCardElement> adaptiveElement, std::shared_ptr<AdaptiveRenderContext> context, const bool isShowCard, const std::string loaderId)
	{
		//Returns only when seperator=false and spacing=none
		if (!adaptiveElement->GetSeparator() && adaptiveElement->GetSpacing() == AdaptiveCards::Spacing::None)
		{
			return;
		}

		int spacing = Utils::GetSpacing(context->GetConfig()->GetSpacing(), adaptiveElement->GetSpacing());

		AdaptiveCards::SeparatorConfig separator = context->GetConfig()->GetSeparator();

		auto uiSep = std::make_shared<QmlTag>("Rectangle");
		uiSep->Property("readonly property bool seperator","true");
		if (adaptiveElement->GetElementTypeString() == "Column")
		{
			uiSep->Property("width", std::to_string(spacing == 0 ? separator.lineThickness : spacing));
			uiSep->Property("height", "parent.height");
		}
		else
		{
			uiSep->Property("width", "parent.width");
			uiSep->Property("height", std::to_string(spacing == 0 ? separator.lineThickness : spacing));
		}

		uiSep->Property("color", "\"transparent\"");
		uiSep->Property("visible", adaptiveElement->GetIsVisible() ? "true" : "false");

		if (isShowCard)
		{
			uiSep->Property("visible", Formatter() << loaderId << ".visible" );
		}

		if (adaptiveElement->GetSeparator() && adaptiveElement->GetIsVisible())
		{
			auto uiLine = std::make_shared<QmlTag>("Rectangle");

			if (adaptiveElement->GetElementTypeString() == "Column")
			{
				uiLine->Property("width", std::to_string(separator.lineThickness));
				uiLine->Property("height", "parent.height");
			}
			else
			{
				uiLine->Property("width", "parent.width");
				uiLine->Property("height", std::to_string(separator.lineThickness));
			}

			uiLine->Property("anchors.centerIn", "parent");
			uiLine->Property("color", separator.lineColor, true);

			uiSep->AddChild(uiLine);
		}

		uiContainer->AddChild(uiSep);
	}

	std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::ColumnSetRender(std::shared_ptr<AdaptiveCards::ColumnSet> columnSet, std::shared_ptr<AdaptiveRenderContext> context)
	{
		const int margin = context->GetConfig()->GetSpacing().paddingSpacing;
		const int spacing = Utils::GetSpacing(context->GetConfig()->GetSpacing(), columnSet->GetSpacing());

		int marginReleased = 2*margin;

		const auto bleedLeft = int(AdaptiveCards::ContainerBleedDirection::BleedLeft);
		const auto bleedRight = int(AdaptiveCards::ContainerBleedDirection::BleedRight);

		if (columnSet->GetId().empty())
		{
			columnSet->SetId(Formatter() << "columnSet_auto_" << context->getColumnSetCounter());
		}
		else
		{
			columnSet->SetId(context->ConvertToValidId(columnSet->GetId()));
		}

		const auto id = columnSet->GetId();

		std::shared_ptr<QmlTag> uiFrame;
		std::shared_ptr<QmlTag> uiRowLayout;
		std::shared_ptr<QmlTag> uiRow;

		uiFrame = std::make_shared<QmlTag>("Frame");
		uiRowLayout = std::make_shared<QmlTag>("RowLayout");
		uiRow = std::make_shared<QmlTag>("Row");

		uiFrame->AddChild(uiRowLayout);
		uiRowLayout->AddChild(uiRow);

		if (columnSet->GetPadding())
		{
			uiRow->Property("Layout.topMargin", std::to_string(margin));
			uiRow->Property("Layout.bottomMargin", std::to_string(margin));
			uiRow->Property("Layout.leftMargin", std::to_string(margin));
			uiRow->Property("Layout.rightMargin", std::to_string(margin));
		}
		else
		{
			marginReleased -= (2 * margin);
		}

		switch (columnSet->GetHorizontalAlignment())
		{
			case AdaptiveCards::HorizontalAlignment::Right:
				uiRow->Property("Layout.alignment", "Qt.AlignRight");
				break;
			case AdaptiveCards::HorizontalAlignment::Center:
				uiRow->Property("Layout.alignment", "Qt.AlignHCenter");
				break;
			default:
				uiRow->Property("Layout.alignment", "Qt.AlignLeft");
				break;
		}

		uiFrame->Property("property int minHeight", std::to_string(columnSet->GetMinHeight()));
        uiFrame->Property("readonly property string bgColor", "'transparent'");

		uiFrame->Property("id", id);

		if (!columnSet->GetIsVisible())
		{
			uiFrame->Property("visible", "false");
		}

		uiRowLayout->Property("id", "rlayout_" + id);
		uiRow->Property("id", "row_" + id);

		uiRowLayout->Property("width", "parent.width");

		uiFrame->Property("implicitHeight", "getColumnSetHeight()");

		uiFrame->Property("padding", "0");

        auto backgroundRect = std::make_shared<QmlTag>("Rectangle");
        backgroundRect->Property("id", Formatter() << id << "_bgRect");

		if (columnSet->GetStyle() != AdaptiveCards::ContainerStyle::None)
		{
			const auto color = context->GetConfig()->GetBackgroundColor(columnSet->GetStyle());
            uiFrame->Property("readonly property string bgColor", color, true);
            backgroundRect->Property("border.width", "0");
		}
		else
		{
            backgroundRect->Property("border.width", "0");
		}
        backgroundRect->Property("color", "parent.bgColor");

        addSelectAction(uiFrame, backgroundRect->GetId(), columnSet->GetSelectAction(), context);
        uiFrame->Property("background", backgroundRect->ToString());

		uiFrame = addColumnSetElements(columnSet, uiFrame, context);

		for (int i = 0; i < uiRow->GetChildren().size(); i++)
		{
			auto uiElement = uiRow->GetChildren()[i];

			if (uiElement->HasProperty("readonly property int bleed"))
			{
				int bleedDirection = std::stoi(uiElement->GetProperty("readonly property int bleed"));

				if ((bleedDirection & bleedLeft) == bleedLeft)
				{
					marginReleased -= margin;
				}

				if ((bleedDirection & bleedRight) == bleedRight)
				{
					marginReleased -= margin;
				}
			}
		}

		if (columnSet->GetBleed() && columnSet->GetCanBleed() ||  uiFrame->HasProperty("readonly property int bleed"))
		{
			uiFrame = applyHorizontalBleed(columnSet, uiFrame, context);

			int bleedDirection = int(columnSet->GetBleedDirection());

			if ((bleedDirection & bleedLeft) == bleedLeft)
			{
				marginReleased -=  margin;
			}

			if ((bleedDirection & bleedRight) == bleedRight)
			{
				marginReleased -= margin;
			}
		}
		else
		{
			uiFrame->Property("width", "parent.width");
		}

		uiFrame->Property("onWidthChanged", Formatter() << "{" << context->getCardRootId() << ".generateStretchWidth( row_" << id << ".children, parent.width - (" << marginReleased << "))}");

		return uiFrame;
	}

	std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::ColumnRender(std::shared_ptr<AdaptiveCards::Column> column, std::shared_ptr<AdaptiveRenderContext> context)
	{
		const auto margin = context->GetConfig()->GetSpacing().paddingSpacing;
		const auto width = column->GetWidth();

		if (column->GetId().empty())
		{
			column->SetId(Formatter() << "column_auto_" << context->getColumnCounter());
		}
		else
		{
			column->SetId(context->ConvertToValidId(column->GetId()));
		}

		std::shared_ptr<QmlTag> uiContainer = GetNewContainer(column, context);

		if (!column->GetWidth().empty())
		{
			uiContainer->Property("property string widthProperty", Formatter() << "'" << column->GetWidth() << "'");
		}
		else
		{
			uiContainer->Property("property string widthProperty", "'stretch'");
		}

		if (!column->GetIsVisible())
		{
			uiContainer->Property("visible", "false");
		}

		return uiContainer;
	}

    std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::ContainerRender(std::shared_ptr<AdaptiveCards::Container> container, std::shared_ptr<AdaptiveRenderContext> context)
    {
        const auto margin = context->GetConfig()->GetSpacing().paddingSpacing;

        if (container->GetId().empty())
        {
            container->SetId(Formatter() << "container_auto_" << context->getContainerCounter());
        }
        else
        {
            container->SetId(context->ConvertToValidId(container->GetId()));
        }

        std::shared_ptr<QmlTag> uiContainer = GetNewContainer(container, context);

		uiContainer->Property("id", container->GetId());

		if (!container->GetIsVisible())
		{
			uiContainer->Property("visible", "false");
		}

        if (container->GetBleed() && container->GetCanBleed() || uiContainer->HasProperty("readonly property int bleed"))
        {
			uiContainer = applyHorizontalBleed(container, uiContainer,context);
        }
        else
        {
            uiContainer->Property("width", "parent.width");
        }

        return uiContainer;
    }

    template<typename CardElement>
    std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::GetNewColumn(CardElement cardElement, std::shared_ptr<AdaptiveRenderContext> context)
    {
        const auto spacing = Utils::GetSpacing(context->GetConfig()->GetSpacing(), cardElement->GetSpacing());

        std::shared_ptr<QmlTag> uiColumn = std::make_shared<QmlTag>("Column");

        uiColumn->Property("Layout.fillWidth", "true");
		uiColumn->Property("Layout.minimumHeight", "1");

        if (cardElement->GetVerticalContentAlignment() == AdaptiveCards::VerticalContentAlignment::Top)
        {
            uiColumn->Property("Layout.alignment", "Qt.AlignTop");
        }
        else if (cardElement->GetVerticalContentAlignment() == AdaptiveCards::VerticalContentAlignment::Bottom)
        {
            uiColumn->Property("Layout.alignment", "Qt.AlignBottom");
        }

        return uiColumn;
    }

    template<typename CardElement>
    inline std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::GetNewContainer(CardElement cardElement, std::shared_ptr<AdaptiveRenderContext> context)
    {
        const auto id = cardElement->GetId();
        const auto margin = context->GetConfig()->GetSpacing().paddingSpacing;
		const auto bodySize = cardElement->GetItems().size();

        std::shared_ptr<QmlTag> uiContainer;
        std::shared_ptr<QmlTag> uiColumnLayout;
        std::shared_ptr<QmlTag> uiColumn = GetNewColumn(cardElement, context);

        uiContainer = std::make_shared<QmlTag>("Frame");
        uiColumnLayout = std::make_shared<QmlTag>("ColumnLayout");
        uiContainer->AddChild(uiColumnLayout);

        uiContainer->Property("id", id);
        uiColumnLayout->Property("id", "clayout_" + id);
        uiColumn->Property("id", "column_" + id);

        uiColumnLayout->Property("anchors.fill", "parent");

        uiContainer->Property("padding", "0");
        uiContainer->Property("property int minHeight", Formatter() << cardElement->GetMinHeight());
        uiContainer->Property("implicitHeight", Formatter() << "Math.max(" << cardElement->GetMinHeight() << ", clayout_" << cardElement->GetId() << ".implicitHeight)");
        uiContainer->Property("readonly property string bgColor", "'transparent'");

        AddContainerElements(uiColumn, cardElement->GetItems(), context);

        uiColumnLayout->AddChild(uiColumn);

        auto backgroundRect = std::make_shared<QmlTag>("Rectangle");
        backgroundRect->Property("id", Formatter() << id << "_bgRect");
		backgroundRect->Property("clip", "true");

        const auto hasBackgroundImage = cardElement->GetBackgroundImage() != nullptr;
        if (hasBackgroundImage)
        {
            uiContainer->Property("readonly property bool hasBackgroundImage", "true");
            uiContainer->Property("property var imgSource", cardElement->GetBackgroundImage()->GetUrl(), true);
			auto backgroundImg = AdaptiveCardQmlRenderer::GetBackgroundImage(cardElement->GetBackgroundImage(), context, id + ".imgSource");
            backgroundRect->AddChild(backgroundImg);
        }
        else if (cardElement->GetStyle() != AdaptiveCards::ContainerStyle::None)
        {
            const auto color = context->GetConfig()->GetBackgroundColor(cardElement->GetStyle());
            uiContainer->Property("readonly property string bgColor", color, true);
            backgroundRect->Property("border.width", "0");
        }
        else
        {
            backgroundRect->Property("border.width", "0");
        }
        backgroundRect->Property("color", "parent.bgColor");

        addSelectAction(uiContainer, backgroundRect->GetId(), cardElement->GetSelectAction(), context, hasBackgroundImage);
        uiContainer->Property("background", backgroundRect->ToString());

        int tempMargin = 0;
		int tempWidth = 0;
        bool inheritsStyleFromParent = (cardElement->GetStyle() == AdaptiveCards::ContainerStyle::None);
        if (cardElement->GetPadding() && !inheritsStyleFromParent)
        {
			uiColumn->Property("Layout.topMargin", std::to_string(margin));
			uiColumn->Property("Layout.bottomMargin", std::to_string(margin));
			uiColumn->Property("Layout.leftMargin", std::to_string(margin));
			uiColumn->Property("Layout.rightMargin", std::to_string(margin));
            tempWidth = margin;
        }

		uiColumn = applyVerticalBleed(uiColumn, uiColumn);

		if (uiColumn->HasProperty("readonly property int bleed"))
		{
			const auto bleedProperty = uiColumn->GetProperty("readonly property int bleed");
			uiContainer->Property("readonly property int bleed", bleedProperty);
			uiColumn->RemoveProperty("readonly property int bleed");
		}

		if (uiColumn->HasProperty("Layout.topMargin"))
		{
			tempMargin += margin;
		}

		if (uiColumn->HasProperty("Layout.bottomMargin"))
		{
			tempMargin += margin;
		}

		std::string stretchHeight = "";

		if (cardElement->GetElementTypeString() == "Container")
		{
			stretchHeight = Formatter() << "minHeight - " << tempMargin;
			uiContainer->Property("onMinHeightChanged", Formatter() << "{" << context->getCardRootId() << ".generateStretchHeight( column_" << id << ".children," << stretchHeight << " )}");
		}
		else if (cardElement->GetElementTypeString() == "Column")
		{
			stretchHeight = Formatter() << "stretchMinHeight - " << tempMargin;
			uiContainer->Property("onStretchMinHeightChanged", Formatter() << "{" << context->getCardRootId() << ".generateStretchHeight( column_" << id << ".children," << stretchHeight << " )}");
		}

		uiColumn->Property("onImplicitHeightChanged", Formatter() << "{" << context->getCardRootId() << ".generateStretchHeight(children, " << id << "." << stretchHeight << " )}");

		uiColumn->Property("onImplicitWidthChanged", Formatter() << "{" << context->getCardRootId() << ".generateStretchHeight(children, " << id << "." << stretchHeight << " )}");

		uiContainer->Property("property int minWidth", Formatter() << "{" << context->getCardRootId() << ".getMinWidth( column_" << cardElement->GetId() << ".children) + " << 2 * tempWidth << "}");

		if (cardElement->GetElementTypeString() == "Column")
		{
			uiContainer->Property("implicitWidth", "minWidth");
		}

        return uiContainer;
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::MediaRender(std::shared_ptr<AdaptiveCards::Media> media, std::shared_ptr<AdaptiveRenderContext> context)
    {
        return std::make_shared<QmlTag>("Rectangle");
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ActionSetRender(std::shared_ptr<AdaptiveCards::ActionSet> actionSet, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto outerContainer = std::make_shared<QmlTag>("Column");

		if (actionSet->GetId().empty())
		{
			actionSet->SetId(Formatter() << "actionSet_auto_" << std::to_string(context->GetActionSetCounter()));
		}

		outerContainer->Property("id", actionSet->GetId());
		outerContainer->Property("width", "parent.width");

		if (!actionSet->GetIsVisible())
		{
			outerContainer->Property("visible", "false");
		}

		outerContainer->Property("property int minWidth", Formatter() << "{" << context->getCardRootId() << ".getMinWidthActionSet( children[1].children," << context->GetConfig()->GetActions().buttonSpacing << ")}");

		auto actionsConfig = context->GetConfig()->GetActions();
		const auto oldActionAlignment = context->GetConfig()->GetActions().actionAlignment;

		actionsConfig.actionAlignment = (AdaptiveCards::ActionAlignment) actionSet->GetHorizontalAlignment();
		context->GetConfig()->SetActions(actionsConfig);

		auto isLastActionSet = (context->getLastActionSetInternalId() == actionSet->GetInternalId());
		auto isShowCardInAction = context->isShowCardInAction();
		auto removeBottomMargin = (!isShowCardInAction && isLastActionSet);
		AddActions(outerContainer, actionSet->GetActions(), context, removeBottomMargin);

		actionsConfig.actionAlignment = oldActionAlignment;
		context->GetConfig()->SetActions(actionsConfig);

		return outerContainer;
	}

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::AdaptiveActionRender(std::shared_ptr<AdaptiveCards::BaseActionElement> action, std::shared_ptr<AdaptiveRenderContext> context)
    {
        if (context->GetConfig()->GetSupportsInteractivity())
        {
            const auto config = context->GetConfig();
            const auto actionsConfig = config->GetActions();
            const std::string buttonId = Formatter() << "button_auto_" << context->getButtonCounter();
            const auto fontSize = config->GetFontSize(AdaptiveSharedNamespace::FontType::Default, AdaptiveSharedNamespace::TextSize::Default);
            const bool isShowCardButton = Utils::IsInstanceOfSmart<AdaptiveCards::ShowCardAction>(action);
            const bool isIconLeftOfTitle = actionsConfig.iconPlacement == AdaptiveCards::IconPlacement::LeftOfTitle;

            auto buttonElement = std::make_shared<QmlTag>("Button");
            buttonElement->Property("id", buttonId);

            if (isShowCardButton)
            {
                buttonElement->Property("property bool showCard", "false");
            }

            //Add button background
            auto bgRectangle = std::make_shared<QmlTag>("Rectangle");
			const std::string bgRectangleId = Formatter() << buttonId << "_bg";
            bgRectangle->Property("id", bgRectangleId);
            bgRectangle->Property("anchors.fill", "parent");
            bgRectangle->Property("radius", Formatter() << buttonId << ".height / 2");
            bgRectangle->Property("border.width", "1");

            //Add button content item
            auto contentItem = std::make_shared<QmlTag>("Item");
            auto contentLayout = std::make_shared<QmlTag>(isIconLeftOfTitle ? "Row" : "Column");
            contentLayout->Property("id", Formatter() << buttonId << (isIconLeftOfTitle ? "_row" : "_col"));
            contentLayout->Property("spacing", "5");
            contentLayout->Property("leftPadding", "5");
            contentLayout->Property("rightPadding", "5");

            contentItem->AddChild(contentLayout);
            contentItem->Property("implicitHeight", Formatter() << contentLayout->GetId() << ".implicitHeight");
            contentItem->Property("implicitWidth", Formatter() << contentLayout->GetId() << ".implicitWidth");

            //Add button icon
            if (!action->GetIconUrl().empty())
            {
				buttonElement->Property("readonly property bool hasIconUrl", "true");
                buttonElement->Property("property var imgSource", action->GetIconUrl(), true);

                auto contentImage = std::make_shared<QmlTag>("Image");
                contentImage->Property("id", Formatter() << buttonId << "_img");
                contentImage->Property("cache", "false");
                contentImage->Property("height", Formatter() << fontSize);
                contentImage->Property("width", Formatter() << fontSize);
                contentImage->Property("fillMode", "Image.PreserveAspectFit");

                if (isIconLeftOfTitle)
                {
                    contentImage->Property("anchors.verticalCenter", "parent.verticalCenter");
                }
                else
                {
                    contentImage->Property("anchors.horizontalCenter", "parent.horizontalCenter");
                }

                contentImage->Property("source", Formatter() << buttonId << ".imgSource");

                contentLayout->AddChild(contentImage);
            }

            //Add content Text
            auto textLayout = std::make_shared<QmlTag>("Row");
            textLayout->Property("spacing", "5");

			const std::string contentTextId = buttonId + "_contentText";
            auto contentText = std::make_shared<QmlTag>("Text");
			contentText->Property("id", contentTextId);
            if (!action->GetTitle().empty())
            {
                contentText->Property("text", action->GetTitle(), true);
            }
            contentText->Property("font.pixelSize", Formatter() << fontSize);

            //TODO: Add border color and style: default/positive/destructive
            if (!Utils::IsNullOrWhitespace(action->GetStyle()) && !Utils::CaseInsensitiveCompare(action->GetStyle(), "default"))
            {
                if (Utils::CaseInsensitiveCompare(action->GetStyle(), "positive"))
                {
					if (isShowCardButton)
					{
						bgRectangle->Property("border.color", Formatter() << buttonId << ".showCard ? '#196323' : "<< buttonId << ".pressed ? '#196323' : '#1B8728'");
						bgRectangle->Property("color", Formatter() << buttonId << ".showCard ? '#196323' : " << buttonId << ".pressed ? '#196323' : " << buttonId << ".hovered ? '#1B8728' : 'white'");
						contentText->Property("color", Formatter() << buttonId << ".showCard ? '#FFFFFF' : " << buttonId << ".hovered ? '#FFFFFF' : '#1B8728'");
					}
					else
					{
						bgRectangle->Property("border.color", Formatter() << buttonId << ".pressed ? '#196323' : '#1B8728'");
						bgRectangle->Property("color", Formatter() << buttonId << ".pressed ? '#196323' : " << buttonId << ".hovered ? '#1B8728' : 'white'");
						contentText->Property("color", Formatter() << buttonId << ".hovered ? '#FFFFFF' : '#1B8728'");
					}
                }
                else if (Utils::CaseInsensitiveCompare(action->GetStyle(), "destructive"))
                {
					if(isShowCardButton)
					{
						bgRectangle->Property("border.color", Formatter() << buttonId << ".showCard ? '#A12C23' : " << buttonId << ".pressed ? '#A12C23' : '#D93829'");
						bgRectangle->Property("color", Formatter() << buttonId << ".showCard ? '#A12C23' : " << buttonId << ".pressed ? '#A12C23' : " << buttonId << ".hovered ? '#D93829' : 'white'");
						contentText->Property("color", Formatter() << buttonId << ".showCard ? '#FFFFFF' : " << buttonId << ".hovered ? '#FFFFFF' : '#D93829'");
					}
					else
					{
						bgRectangle->Property("border.color", Formatter() << buttonId << ".pressed ? '#A12C23' : '#D93829'");
						bgRectangle->Property("color", Formatter() << buttonId << ".pressed ? '#A12C23' : " << buttonId << ".hovered ? '#D93829' : 'white'");
						contentText->Property("color", Formatter() << buttonId << ".hovered ? '#FFFFFF' : '#D93829'");
					}
                }
                else
                {
					if (isShowCardButton)
					{
						bgRectangle->Property("border.color", Formatter() << buttonId << ".showCard ? '#0A5E7D' : " << buttonId << ".pressed ? '#0A5E7D' : '#007EA8'");
						bgRectangle->Property("color", Formatter() << buttonId << ".showCard ? '#0A5E7D' : " << buttonId << ".pressed ? '#0A5E7D' : " << buttonId << ".hovered ? '#007EA8' : 'white'");
						contentText->Property("color", Formatter() << buttonId << ".showCard ? '#FFFFFF' : " << buttonId << ".hovered ? '#FFFFFF' : '#007EA8'");
					}
					else
					{
						bgRectangle->Property("border.color", Formatter() << buttonId << ".pressed ? '#0A5E7D' : '#007EA8'");
						bgRectangle->Property("color", Formatter() << buttonId << ".pressed ? '#0A5E7D' : " << buttonId << ".hovered ? '#007EA8' : 'white'");
						contentText->Property("color", Formatter() << buttonId << ".hovered ? '#FFFFFF' : '#007EA8'");
					}
                }
            }
            else
            {
				if (isShowCardButton)
				{
					bgRectangle->Property("border.color", Formatter() << buttonId << ".showCard ? '#0A5E7D' : " << buttonId << ".pressed ? '#0A5E7D' : '#007EA8'");
					bgRectangle->Property("color", Formatter() << buttonId << ".showCard ? '#0A5E7D' : " << buttonId << ".pressed ? '#0A5E7D' : " << buttonId << ".hovered ? '#007EA8' : 'white'");
					contentText->Property("color", Formatter() << buttonId << ".showCard ? '#FFFFFF' : " << buttonId << ".hovered ? '#FFFFFF' : '#007EA8'");
				}
				else
				{
					bgRectangle->Property("border.color", Formatter() << buttonId << ".pressed ? '#0A5E7D' : '#007EA8'");
					bgRectangle->Property("color", Formatter() << buttonId << ".pressed ? '#0A5E7D' : " << buttonId << ".hovered ? '#007EA8' : 'white'");
					contentText->Property("color", Formatter() << buttonId << ".hovered ? '#FFFFFF' : '#007EA8'");
				}
            }

            textLayout->AddChild(contentText);
            buttonElement->Property("background", bgRectangle->ToString());

            if (isShowCardButton)
            {
                auto showCardIconBackground = std::make_shared<QmlTag>("Rectangle");
				showCardIconBackground->Property("anchors.fill", "parent");
				showCardIconBackground->Property("color", Formatter() << bgRectangleId << ".color");

                const std::string iconId = Formatter() << buttonId << "_icon";
				auto showCardIcon = GetIconTag(context);
                showCardIcon->Property("id", iconId);
				showCardIcon->RemoveProperty("anchors.right");
                showCardIcon->RemoveProperty("anchors.top");
				showCardIcon->RemoveProperty("anchors.bottom");
				showCardIcon->Property("width", Formatter() << contentTextId << ".font.pixelSize");
				showCardIcon->Property("height", Formatter() << contentTextId << ".font.pixelSize");
				showCardIcon->Property("anchors.verticalCenter", Formatter() << contentTextId << ".verticalCenter");
				showCardIcon->Property("horizontalPadding", "0");
				showCardIcon->Property("verticalPadding", "0");
				showCardIcon->Property("icon.color", Formatter() << contentTextId << ".color");
				showCardIcon->Property("icon.width", "12");
				showCardIcon->Property("icon.height", "12");
				showCardIcon->Property("icon.source", RendererQml::arrow_down_12, true);
				showCardIcon->Property("background", showCardIconBackground->ToString());
                showCardIcon->Property("onReleased", Formatter() << buttonId << ".released()");
                textLayout->AddChild(showCardIcon);
            }

            contentLayout->AddChild(textLayout);
            buttonElement->Property("contentItem", contentItem->ToString());

            std::string onReleasedFunction;
            if (action->GetElementTypeString() == "Action.OpenUrl")
            {
                onReleasedFunction = getActionOpenUrlClickFunc(std::dynamic_pointer_cast<AdaptiveCards::OpenUrlAction>(action), context);
            }
            else if (action->GetElementTypeString() == "Action.ShowCard")
            {
                context->addToShowCardButtonList(buttonElement, std::dynamic_pointer_cast<AdaptiveCards::ShowCardAction>(action));
            }
            else if (action->GetElementTypeString() == "Action.ToggleVisibility")
            {
                onReleasedFunction = getActionToggleVisibilityClickFunc(std::dynamic_pointer_cast<AdaptiveCards::ToggleVisibilityAction>(action), context);
            }
            else if (action->GetElementTypeString() == "Action.Submit")
            {
                context->addToSubmitActionButtonList(buttonElement, std::dynamic_pointer_cast<AdaptiveCards::SubmitAction>(action));
            }
            else
            {
                onReleasedFunction = "";
            }

            buttonElement->Property("onReleased", Formatter() << "{\n" << onReleasedFunction << "}\n");
            return buttonElement;
        }

        return nullptr;
    }

    void AdaptiveCardQmlRenderer::addSubmitActionButtonClickFunc(const std::shared_ptr<AdaptiveRenderContext>& context)
    {
        for (auto& element : context->getSubmitActionButtonList())
        {
            std::string onClickedFunction;
            const auto buttonElement = element.first;
            const auto action = element.second;

            onClickedFunction = getActionSubmitClickFunc(action, context);
            buttonElement->Property("onReleased", Formatter() << "{\n" << onClickedFunction << "}\n");
        }
    }

    void AdaptiveCardQmlRenderer::addShowCardButtonClickFunc(const std::shared_ptr<AdaptiveRenderContext>& context)
    {
        for (auto& element : context->getShowCardButtonList())
        {
            std::string onClickedFunction;
            const auto buttonElement = element.first;
            const auto action = element.second;

            onClickedFunction = getActionShowCardClickFunc(buttonElement, context);
            buttonElement->Property("onReleased", Formatter() << "{\n" << onClickedFunction << "}\n");
        }

        context->clearShowCardButtonList();
    }

    void AdaptiveCardQmlRenderer::addShowCardLoaderComponents(const std::shared_ptr<AdaptiveRenderContext>& context)
    {
        for (const auto& componentElement : context->getShowCardLoaderComponentList())
        {
            auto subContext = std::make_shared<AdaptiveRenderContext>(context->GetConfig(), context->GetElementRenderers());

            // Add parent input input elements to the child card
            for (const auto& inputElement : context->getInputElementList())
            {
                subContext->addToInputElementList(inputElement.first, inputElement.second);
            }

            auto uiCard = subContext->Render(componentElement.second->GetCard(), &AdaptiveCardRender, true);
            if (uiCard != nullptr)
            {
                //TODO: Remove these hardcoded colors once config settings are finalised
                const auto containerColor = context->GetRGBColor(context->GetConfig()->GetBackgroundColor(context->GetConfig()->GetActions().showCard.style));

                uiCard->Property("color", containerColor);

                // Add show card component to root element
                const auto showCardComponent = GetComponent(componentElement.first, uiCard);
                context->getCardRootElement()->AddChild(showCardComponent);
            }
        }
    }

    const std::string AdaptiveCardQmlRenderer::getActionOpenUrlClickFunc(const std::shared_ptr<AdaptiveCards::OpenUrlAction>& action, const std::shared_ptr<AdaptiveRenderContext>& context)
    {
        // Sample signal to emit on click
        //adaptiveCard.buttonClick(var title, var type, var data);
        //adaptiveCard.buttonClick("title", "Action.OpenUrl", "https://adaptivecards.io");
        std::ostringstream function;
        function << context->getCardRootId() << ".buttonClicked(\"" << action->GetTitle() << "\", \"" << action->GetElementTypeString() << "\", \"" << action->GetUrl() << "\");";
        function << "\nconsole.log(\"" << action->GetUrl() << "\");\n";

        return function.str();
    }

	const std::string AdaptiveCardQmlRenderer::getActionShowCardClickFunc(const std::shared_ptr<QmlTag>& buttonElement, const std::shared_ptr<AdaptiveRenderContext>& context)
	{
		std::ostringstream function;
		for (auto& element : context->getShowCardButtonList())
		{
			const auto button = element.first;
			const auto action = element.second;

			if (buttonElement->GetId() != button->GetId())
			{
				function << "if(" << button->GetId() << ".showCard)\n{\n";
				function << button->GetId() << ".released()\n}\n";
			}
		}

		function << "\n" << buttonElement->GetId() << ".showCard = !" << buttonElement->GetId() << ".showCard";
		function << "\n" << buttonElement->GetId() << "_loader.visible = " << buttonElement->GetId() << ".showCard";
		function << "\n" << buttonElement->GetId() << "_icon.icon.source = " << buttonElement->GetId() << ".showCard ? " << "\"" << RendererQml::arrow_up_12 << "\"" << ":" << "\"" << RendererQml::arrow_down_12 << "\"";
		return function.str();
	}

	const std::string AdaptiveCardQmlRenderer::getActionSubmitClickFunc(const std::shared_ptr<AdaptiveCards::SubmitAction>& action, const std::shared_ptr<AdaptiveRenderContext>& context)
    {
        // Sample signal to emit on click
        //adaptiveCard.buttonClick(var title, var type, var data);
        //adaptiveCard.buttonClick("title", "Action.Submit", "{"x":13,"firstName":"text1","lastName":"text2"}");
        std::ostringstream function;

        std::string submitDataJson = action->GetDataJson();
        submitDataJson = Utils::Trim(submitDataJson);

        function << "var paramJson = {};\n";

        if (!submitDataJson.empty() && submitDataJson != "null")
        {
            submitDataJson = Utils::Replace(submitDataJson, "\"", "\\\"");
            function << "var parmStr = \"" << submitDataJson << "\";\n";
            function << "paramJson = JSON.parse(parmStr);\n";
        }

        for(const auto& element : context->getInputElementList())
        {
            function << "paramJson[\"" << element.first << "\"] = " << element.second << ";\n";
        }

        function << "var paramslist = JSON.stringify(paramJson);\n";
        function << context->getCardRootId() << ".buttonClicked(\"" << action->GetTitle() << "\", \"" << action->GetElementTypeString() << "\", paramslist);\nconsole.log(paramslist);\n";

        return function.str();
    }

	const std::string AdaptiveCardQmlRenderer::getActionToggleVisibilityClickFunc(const std::shared_ptr<AdaptiveCards::ToggleVisibilityAction>& action, const std::shared_ptr<AdaptiveRenderContext>& context)
	{
		std::ostringstream function;

		for (const auto& targetElement : action->GetTargetElements())
		{
			std::string targetElementId;

			if (targetElement != nullptr)
			{
				targetElementId = context->ConvertToValidId(targetElement->GetElementId());

				switch (targetElement->GetIsVisible())
				{
				case AdaptiveCards::IsVisible::IsVisibleTrue:
					function << targetElementId << ".visible = true";
					break;
				case AdaptiveCards::IsVisible::IsVisibleFalse:
					function << targetElementId << ".visible = false";
					break;
				default:
					function << targetElementId << ".visible = !" << targetElementId << ".visible ";
				}
			}
			function << "\n";
		}

		return function.str();
  }

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetBackgroundImage(std::shared_ptr<AdaptiveCards::BackgroundImage> backgroundImage, std::shared_ptr<AdaptiveRenderContext> context, const std::string& imgSource)
	{
		auto uiImage = std::make_shared<QmlTag>("Image");
        uiImage->Property("cache", "false");
		uiImage->Property("source", imgSource);

		std::string horizontalAlignment = AdaptiveCards::EnumHelpers::getHorizontalAlignmentEnum().toString(backgroundImage->GetHorizontalAlignment());
		std::string verticalAlignment = AdaptiveCards::EnumHelpers::getVerticalAlignmentEnum().toString(backgroundImage->GetVerticalAlignment());

		switch (backgroundImage->GetFillMode())
		{
		case AdaptiveCards::ImageFillMode::Repeat:
			uiImage->Property("fillMode", "Image.Tile");
			uiImage->Property("horizontalAlignment", Utils::GetHorizontalAlignment(horizontalAlignment));
			uiImage->Property("verticalAlignment", Utils::GetVerticalAlignment(verticalAlignment));
			uiImage->Property("anchors.fill", "parent");
			break;
		case AdaptiveCards::ImageFillMode::RepeatHorizontally:
			uiImage->Property("width", "parent.width");
			uiImage->Property("height", "implicitHeight");
			uiImage->Property("fillMode", "Image.TileHorizontally");
			uiImage->Property("horizontalAlignment", "Qt.AlignLeft");
			uiImage->Property("anchors." + Utils::GetVerticalAnchors(verticalAlignment), "parent." + Utils::GetVerticalAnchors(verticalAlignment));
			break;
		case AdaptiveCards::ImageFillMode::RepeatVertically:
			uiImage->Property("width", "implicitWidth");
			uiImage->Property("height", "parent.height");
			uiImage->Property("fillMode", "Image.TileVertically");
			uiImage->Property("anchors." + Utils::GetHorizontalAnchors(horizontalAlignment), "parent." + Utils::GetHorizontalAnchors(horizontalAlignment));
			uiImage->Property("verticalAlignment", "Qt.AlignTop");
			break;
		case AdaptiveCards::ImageFillMode::Cover:
		default:
			uiImage->Property("fillMode", "Image.PreserveAspectCrop");
			uiImage->Property("verticalAlignment", Utils::GetVerticalAlignment(verticalAlignment));
			uiImage->Property("anchors.fill", "parent");
			break;
		}

		return uiImage;
	}

	template<typename CardElement>
	const std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::applyHorizontalBleed(CardElement cardElement, std::shared_ptr<QmlTag> uiContainer, std::shared_ptr<AdaptiveRenderContext> context)
	{
		const int margin = context->GetConfig()->GetSpacing().paddingSpacing;
		const auto bleedLeft = int(AdaptiveCards::ContainerBleedDirection::BleedLeft);
		const auto bleedRight = int(AdaptiveCards::ContainerBleedDirection::BleedRight);
		const auto bleedUp = int(AdaptiveCards::ContainerBleedDirection::BleedUp);
		const auto bleedDown = int(AdaptiveCards::ContainerBleedDirection::BleedDown);

		int bleedDirection = int(cardElement->GetBleedDirection());

		if (uiContainer->HasProperty("readonly property int bleed"))
		{
			bleedDirection |= std::stoi(uiContainer->GetProperty("readonly property int bleed"));
		}

		if ((bleedDirection & bleedUp) == bleedUp)
		{
			bleedDirection |= bleedUp;
			uiContainer->Property("readonly property int bleed", std::to_string(bleedDirection));
		}

		if ((bleedDirection & bleedDown) == bleedDown)
		{
			bleedDirection |= bleedDown;
			uiContainer->Property("readonly property int bleed", std::to_string(bleedDirection));
		}

		int marginsAdded = 0;
		if ((bleedDirection & bleedLeft) == bleedLeft)
		{
			marginsAdded += margin;
			uiContainer->Property("x", Formatter() << "-" << std::to_string(margin));
		}

		if ((bleedDirection & bleedRight) == bleedRight)
		{
			marginsAdded += margin;
		}

		uiContainer->Property("width", "parent.width + " + std::to_string(marginsAdded));

		return uiContainer;
	}

	const std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::applyVerticalBleed(std::shared_ptr<QmlTag> elementsParent, std::shared_ptr<QmlTag> source)
	{
		const auto bodySize = elementsParent->GetChildren().size();
		const auto bleedUp = int(AdaptiveCards::ContainerBleedDirection::BleedUp);
		const auto bleedDown = int(AdaptiveCards::ContainerBleedDirection::BleedDown);

		if (bodySize > 0)
		{
			int parentBleed = 0;
			for (int i = 0; i < bodySize; i++)
			{
				if (elementsParent->GetChildren()[i]->HasProperty("readonly property int bleed"))
				{
					const auto bleedDirection = std::stoi(elementsParent->GetChildren()[i]->GetProperty("readonly property int bleed"));

					if ((bleedDirection & bleedUp) == bleedUp && i == 0)
					{
						if (source->HasProperty("Layout.topMargin"))
						{
							source->RemoveProperty("Layout.topMargin");
						}
						else
						{
							parentBleed |= bleedUp;
						}
					}

					if ((bleedDirection & bleedDown) == bleedDown && i == bodySize - 1)
					{
						if (source->HasProperty("Layout.bottomMargin"))
						{
							source->RemoveProperty("Layout.bottomMargin");
						}
						else
						{
							parentBleed |= bleedDown;
						}
					}
				}
			}
			if (parentBleed != 0)
			{
				source->Property("readonly property int bleed", std::to_string(parentBleed));
			}
		}
		return source;
	}

	const std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::addColumnSetElements(std::shared_ptr<AdaptiveCards::ColumnSet> columnSet, std::shared_ptr<QmlTag> uiFrame, std::shared_ptr<AdaptiveRenderContext> context)
	{
		const int margin = context->GetConfig()->GetSpacing().paddingSpacing;
		const int no_of_columns = int(columnSet->GetColumns().size());
		auto columns = columnSet->GetColumns();
		std::string heightString = "";
		int bleedUpCount = 0;
		int bleedDownCount = 0;
		int bleedMargin = 0;
		int tempMargin = 0;
		int maxBleedMargin = 0;
		int minHeight = 0;

		const auto bleedLeft = int(AdaptiveCards::ContainerBleedDirection::BleedLeft);
		const auto bleedRight = int(AdaptiveCards::ContainerBleedDirection::BleedRight);
		const auto bleedUp = int(AdaptiveCards::ContainerBleedDirection::BleedUp);
		const auto bleedDown = int(AdaptiveCards::ContainerBleedDirection::BleedDown);

		std::shared_ptr<QmlTag> uiRowLayout = uiFrame->GetChildren()[0];
		std::shared_ptr<QmlTag> uiRow = uiRowLayout->GetChildren()[0];

		if (columnSet->GetPadding())
		{
			tempMargin = 2 * margin;
		}

		for (int i = 0; i < no_of_columns; i++)
		{
			auto cardElement = columns[i];

			auto uiElement = context->Render(cardElement);

			if (uiElement != nullptr)
			{
				if (!uiRow->GetChildren().empty())
				{
					AddSeparator(uiRow, cardElement, context);
				}

				uiRow->AddChild(uiElement);

				if (cardElement->GetBleed() && cardElement->GetCanBleed() || uiElement->HasProperty("readonly property int bleed"))
				{
					int bleedDirection = 0;

					if (uiElement->HasProperty("readonly property int bleed"))
					{
						bleedDirection |= std::stoi(uiElement->GetProperty("readonly property int bleed"));
					}

					if (cardElement->GetBleed() && cardElement->GetCanBleed())
					{
						bleedDirection |= int(cardElement->GetBleedDirection());
					}

					if ((bleedDirection & bleedLeft) == bleedLeft)
					{
						uiRow->RemoveProperty("Layout.leftMargin");
						if (!columnSet->GetPadding())
						{
							uiRowLayout->Property("x", Formatter() << "-" << margin);
						}
					}

					if ((bleedDirection & bleedRight) == bleedRight)
					{
						uiRow->RemoveProperty("Layout.rightMargin");
					}

					if ((bleedDirection & bleedUp) == bleedUp)
					{
						bleedUpCount++;
					}

					if ((bleedDirection & bleedDown) == bleedDown)
					{
						bleedDownCount++;
					}

					if (bleedDirection != 0)
					{
						uiElement->Property("readonly property int bleed", std::to_string(bleedDirection));
					}
				}

			}
		}

		int parentBleedDirection = 0;

		if (bleedUpCount == no_of_columns)
		{
			if (columnSet->GetPadding())
			{
				uiRow->RemoveProperty("Layout.topMargin");
				tempMargin -= margin;
			}
			else
			{
				parentBleedDirection |= bleedUp;
			}
		}

		if (bleedDownCount == no_of_columns)
		{
			if (columnSet->GetPadding())
			{
				uiRow->RemoveProperty("Layout.bottomMargin");
				tempMargin -= margin;
			}
			else
			{
				parentBleedDirection |= bleedDown;
			}
		}

		minHeight = std::max(minHeight, int(columnSet->GetMinHeight()) - tempMargin);

		auto uiElements = uiRow->GetChildren();

		for (int i = 0; i < uiElements.size(); i++)
		{
			if (!uiElements[i]->HasProperty("readonly property bool seperator"))
			{
				int bleedMargin = 0;
				if (uiElements[i]->HasProperty("readonly property int bleed"))
				{
					int bleedDirection = std::stoi(uiElements[i]->GetProperty("readonly property int bleed"));

					if ((bleedDirection & bleedUp) == bleedUp && bleedUpCount != no_of_columns)
					{
						uiElements[i]->Property("y", Formatter() << "-" << margin);
						bleedMargin += margin;

					}

					if ((bleedDirection & bleedDown) == bleedDown && bleedDownCount != no_of_columns)
					{
						bleedMargin += margin;
					}
				}

				minHeight = std::max(minHeight, std::stoi(uiElements[i]->GetProperty("property int minHeight")) + bleedMargin);

				uiElements[i]->Property("property int stretchMinHeight", Formatter() << "Math.max(" << uiFrame->GetId() << ".stretchMinHeight, implicitHeight - 1)");

				maxBleedMargin = std::max(bleedMargin, maxBleedMargin);
				uiElements[i]->Property("implicitHeight", Formatter() << columnSet->GetId() << ".getColumnHeight( " << uiElements[i]->HasProperty("readonly property int bleed") << " ) + " << bleedMargin);
				heightString += ("clayout_" + uiElements[i]->GetProperty("id") + ".implicitHeight - " + std::to_string(bleedMargin) + "," + uiElements[i]->GetProperty("id") + ".minHeight, ");
			}
			else
			{
				uiElements[i]->Property("height", Formatter() << columnSet->GetId() << ".getColumnHeight(false)");
			}
		}

		if (parentBleedDirection != 0)
		{
			uiFrame->Property("readonly property int bleed", std::to_string(parentBleedDirection));
		}

		uiFrame->Property("property int stretchMinHeight", std::to_string(minHeight));
		uiFrame->Property("onMinHeightChanged", Formatter() << "{ stretchMinHeight = Math.max(minHeight - " << tempMargin << ", stretchMinHeight)}");

		uiFrame->AddFunctions(Formatter() << "function getColumnSetHeight(){ var calculatedHeight = getColumnHeight(true);if(calculatedHeight >= minHeight - (" << (tempMargin) << ")){return calculatedHeight + (" << (tempMargin) << ")}else{return minHeight;}}");

		uiFrame->AddFunctions(Formatter() << "function getColumnHeight(bleed){var calculatedHeight =  Math.max(" << heightString.substr(0, heightString.size() - 2) << "); if(calculatedHeight < minHeight - (" << (tempMargin) << ")){return minHeight - (" << (tempMargin) << ")}else{if(calculatedHeight === 0 && !bleed){return calculatedHeight + " << maxBleedMargin << " }else{return calculatedHeight}}}");

		return uiFrame;
	}

	const std::string RendererQml::AdaptiveCardQmlRenderer::getStretchHeight()
	{
		std::string stretchHeightFunction =  R"(function generateStretchHeight(childrens,minHeight){
			var n = childrens.length
			var implicitHt = 0;
			var stretchCount = 0;
			var stretchMinHeight = 0;
			for(var i=0;i<childrens.length;i++)
			{
				if(typeof childrens[i].seperator !== 'undefined')
				{
					implicitHt += childrens[i].height;
					stretchMinHeight += childrens[i].height;
				}
				else
				{
					implicitHt += childrens[i].implicitHeight;
					if(typeof childrens[i].stretch !== 'undefined')
					{
						stretchCount++;
					}
					else
					{
						stretchMinHeight += childrens[i].implicitHeight;
					}
				}
			}
			stretchMinHeight = (minHeight - stretchMinHeight)/stretchCount
			for(i=0;(i<childrens.length);i++)
			{
				if(typeof childrens[i].seperator === 'undefined')
				{
					if(typeof childrens[i].stretch !== 'undefined' && typeof childrens[i].minHeight !== 'undefined')
					{
						childrens[i].minHeight = Math.max(childrens[i].minHeight,stretchMinHeight)
					}
				}
			}
			if(stretchCount > 0 && implicitHt < minHeight)
			{
				var stretctHeight = (minHeight - implicitHt)/stretchCount
				for(i=0;i<childrens.length;i++)
				{
					if(typeof childrens[i].seperator === 'undefined')
					{
						if(typeof childrens[i].stretch !== 'undefined')
						{
							childrens[i].height = childrens[i].implicitHeight + stretctHeight
						}
					}
				}
			}
			else
			{
				for(i=0;i<childrens.length;i++)
				{
					if(typeof childrens[i].seperator === 'undefined')
					{
						if(typeof childrens[i].stretch !== 'undefined')
						{
							childrens[i].height = childrens[i].implicitHeight
						}
					}
				}
			}
		})";

		stretchHeightFunction.erase(std::remove(stretchHeightFunction.begin(), stretchHeightFunction.end(), '\t'), stretchHeightFunction.end());

		return stretchHeightFunction;
	}

	const std::string RendererQml::AdaptiveCardQmlRenderer::getStretchWidth()
	{
		std::string stretchWidthFunction =  R"(function generateStretchWidth(childrens,width){
			var implicitWid = 0
			var autoWid = 0
			var autoCount = 0
			var weightSum = 0
			var stretchCount = 0
			var weightPresent = 0
			for(var i=0;i<childrens.length;i++)
			{
				if(typeof childrens[i].seperator !== 'undefined')
				{
					implicitWid += childrens[i].width
				}
				else
				{
					if(childrens[i].widthProperty.endsWith("px"))
					{
						childrens[i].width = parseInt(childrens[i].widthProperty.slice(0,-2))
						implicitWid += childrens[i].width
					}
					else
					{
						if(childrens[i].widthProperty === "auto")
						{
							autoCount++
						}
						else if(childrens[i].widthProperty === "stretch")
						{
							stretchCount++
							implicitWid += 50;
						}
						else
						{
							weightPresent = 1
							weightSum += parseInt(childrens[i].widthProperty)
						}
					}
				}
			}
			autoWid = (width - implicitWid)/(weightPresent + autoCount)
			var flags = new Array(childrens.length).fill(0)
			for(i=0;i<childrens.length;i++)
			{
				if(typeof childrens[i].seperator === 'undefined')
				{
					if(childrens[i].widthProperty === "auto")
					{
						if(childrens[i].minWidth < autoWid)
						{
							childrens[i].width = childrens[i].minWidth
							implicitWid += childrens[i].width
							flags[i] = 1;
							autoCount--;
							autoWid = (width - implicitWid)/(weightPresent + autoCount)
						}
					}
				}
			}
			for(i=0;i<childrens.length;i++)
			{
				if(typeof childrens[i].seperator === 'undefined')
				{
					if(childrens[i].widthProperty === "auto")
					{
						if(flags[i] === 0)
						{
							childrens[i].width = autoWid
							implicitWid += childrens[i].width
						}
					}
					else if(childrens[i].widthProperty !== "stretch" && !childrens[i].widthProperty.endsWith("px"))
					{
						if(weightSum !== 0)
						{
							childrens[i].width = ((parseInt(childrens[i].widthProperty)/weightSum) * autoWid)
							implicitWid += childrens[i].width
						}
					}
				}
			}
			var stretchWidth = (width - implicitWid)/stretchCount
			for(i=0;i<childrens.length;i++)
			{
				if(typeof childrens[i].seperator === 'undefined')
				{
					if(childrens[i].widthProperty === 'stretch')
					{
						childrens[i].width = 50+stretchWidth
					}
				}
			}
		})";

		stretchWidthFunction.erase(std::remove(stretchWidthFunction.begin(), stretchWidthFunction.end(), '\t'), stretchWidthFunction.end());

		return stretchWidthFunction;
	}

	const std::string RendererQml::AdaptiveCardQmlRenderer::getMinWidth()
	{
		std::string minWidthFunction =  R"(function getMinWidth(childrens){
			var min = 0
			for(var j =0;j<childrens.length;j++)
			{
				if(typeof childrens[j].minWidth === 'undefined')
				{
					min = Math.max(min,Math.ceil(childrens[j].implicitWidth))
				}
				else
				{
					min = Math.max(min,Math.ceil(childrens[j].minWidth))
				}
			}
			return min
		})";

		minWidthFunction.erase(std::remove(minWidthFunction.begin(), minWidthFunction.end(), '\t'), minWidthFunction.end());

		return minWidthFunction;
	}

	const std::string RendererQml::AdaptiveCardQmlRenderer::getMinWidthActionSet()
	{
		std::string minWidthActionSet =  R"(function getMinWidthActionSet(childrens,spacing){
			var min = 0
			for(var j =0;j<childrens.length;j++)
			{
				min += Math.ceil(childrens[j].implicitWidth)
			}
			min += ((childrens.length - 1)*spacing)
			return min
		})";

		minWidthActionSet.erase(std::remove(minWidthActionSet.begin(), minWidthActionSet.end(), '\t'), minWidthActionSet.end());

		return minWidthActionSet;
	}

	const std::string RendererQml::AdaptiveCardQmlRenderer::getMinWidthFactSet()
	{
		std::string minWidthFactSet =  R"(function getMinWidthFactSet(childrens, spacing){
			var min = 0
			for(var j=0;j<childrens.length;j+=2)
			{
				min = Math.max(min,childrens[j].implicitWidth + childrens[j+1].implicitWidth + spacing)
			}
			return min;
		})";

		minWidthFactSet.erase(std::remove(minWidthFactSet.begin(), minWidthFactSet.end(), '\t'), minWidthFactSet.end());

		return minWidthFactSet;
	}

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetIconTag(std::shared_ptr<AdaptiveRenderContext> context)
    {
        auto iconBackgroundTag = std::make_shared<QmlTag>("Rectangle");
        iconBackgroundTag->Property("color", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));
        iconBackgroundTag->Property("width", "parent.width");
        iconBackgroundTag->Property("height", "parent.height");

        auto iconTag = std::make_shared<QmlTag>("Button");
        iconTag->Property("background", iconBackgroundTag->ToString());
        iconTag->Property("width", "30");
        iconTag->Property("anchors.top", "parent.top");
        iconTag->Property("anchors.bottom", "parent.bottom");
        iconTag->Property("anchors.right", "parent.right");
        iconTag->Property("anchors.margins", "2");
        iconTag->Property("horizontalPadding", "4");
        iconTag->Property("verticalPadding", "4");
        iconTag->Property("icon.width", "18");
        iconTag->Property("icon.height", "18");
        iconTag->Property("focusPolicy", "Qt.NoFocus");
        iconTag->Property("icon.color", context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false));
        return iconTag;
    }

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetTextBlockMouseArea()
	{
		auto MouseAreaTag = std::make_shared<QmlTag>("MouseArea");
		MouseAreaTag->Property("anchors.fill", "parent");
		MouseAreaTag->Property("cursorShape", "parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor");
		MouseAreaTag->Property("acceptedButtons", "Qt.NoButton");

		return MouseAreaTag;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::getDummyElementforNumberInput(bool isTop)
	{
		auto DummyTag = std::make_shared<QmlTag>("Rectangle");
		DummyTag->Property("width", "2");
		DummyTag->Property("height", "2");
		DummyTag->Property("anchors.right", "parent.right");

		if (isTop)
		{
			DummyTag->Property("anchors.top", "parent.top");
		}
		else
		{
			DummyTag->Property("anchors.bottom", "parent.bottom");
		}
		DummyTag->Property("anchors.margins", "5");
		DummyTag->Property("color", "'transparent'");
		DummyTag->Property("z", "-1");

		return DummyTag;
	}

	void AdaptiveCardQmlRenderer::ValidateLastBodyElementIsShowCard(const std::vector<std::shared_ptr<AdaptiveCards::BaseCardElement>>& bodyElements, std::shared_ptr<AdaptiveRenderContext> context)
	{
		if (bodyElements.empty())
		{
			return;
		}
		auto cardElement = bodyElements.back();

		auto cardElementType = cardElement->GetElementType();

		if (cardElementType == AdaptiveSharedNamespace::CardElementType::ActionSet)
		{
			auto ActionSetPtr = std::dynamic_pointer_cast<AdaptiveCards::ActionSet> (cardElement);
			auto listOfActions = ActionSetPtr->GetActions();

			for (const auto& action : listOfActions)
			{
				if (Utils::IsInstanceOfSmart<AdaptiveCards::ShowCardAction>(action))
				{
					context->setLastActionSetInternalId(ActionSetPtr->GetInternalId());
					context->setIsShowCardLastBodyElement(true);
					return;
				}
			}
		}
	}

	void AdaptiveCardQmlRenderer::ValidateShowCardInActions(const std::vector<std::shared_ptr<AdaptiveCards::BaseActionElement>>& actions, std::shared_ptr<AdaptiveRenderContext> context)
	{
		for (const auto& action : actions)
		{
			if (Utils::IsInstanceOfSmart<AdaptiveCards::ShowCardAction>(action))
			{
				context->setIsShowCardInAction(true);
				return;
			}
		}
	}

	const std::string AdaptiveCardQmlRenderer::RemoveBottomMarginValue(std::vector<std::string> showCardsList)
	{
		std::string value = "";

		for (auto id : showCardsList)
		{
			value.append(Formatter() << "(" << id << ".visible && " << id << ".removeBottomMargin) || ");
		}

		if (value == "")
		{
			value = "false";
		}
		else
		{
			value.erase(value.length() - 3);
		}

		return value;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetRowWithClearIconTag(const std::string& id, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto clearIconTag = GetIconTag(context);
		clearIconTag->RemoveProperty("anchors.top");
		clearIconTag->RemoveProperty("anchors.bottom");
		clearIconTag->RemoveProperty("anchors.right");
		clearIconTag->RemoveProperty("anchors.margins");
		
		clearIconTag->Property("id", id);
		clearIconTag->Property("width", "icon.width");
		clearIconTag->Property("height", "icon.height");
		clearIconTag->Property("horizontalPadding", "0");
		clearIconTag->Property("verticalPadding", "0");
		clearIconTag->Property("icon.source", RendererQml::clear_icon_18, true);
		clearIconTag->Property("anchors.verticalCenter", "parent.verticalCenter");

		auto iconsRowTag = std::make_shared<QmlTag>("Row");
		iconsRowTag->Property("anchors.top", "parent.top");
		iconsRowTag->Property("anchors.bottom", "parent.bottom");
		iconsRowTag->Property("anchors.right", "parent.right");
		iconsRowTag->Property("anchors.margins", "2");
		iconsRowTag->Property("padding", "2");
		iconsRowTag->Property("rightPadding", "5");
		iconsRowTag->Property("spacing", "10");
		iconsRowTag->AddChild(clearIconTag);

		return iconsRowTag;
	}
}
