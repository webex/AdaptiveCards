#include "AdaptiveCardQmlRenderer.h"
#include "ImageDataURI.h"
#include "pch.h"
#include "DateInputRender.h"
#include "TextInputRender.h"
#include "TimeInputRender.h"
#include "ChoiceSetRender.h"
#include "ToggleInputRender.h"
#include "NumberInputRender.h"

namespace RendererQml
{
	AdaptiveCardQmlRenderer::AdaptiveCardQmlRenderer()
		: AdaptiveCardQmlRenderer(std::make_shared<AdaptiveCards::HostConfig>(), std::make_shared<AdaptiveCardRenderConfig>())
	{
	}

	AdaptiveCardQmlRenderer::AdaptiveCardQmlRenderer(std::shared_ptr<AdaptiveCards::HostConfig> hostConfig, std::shared_ptr<AdaptiveCardRenderConfig> renderConfig)
		: AdaptiveCardsRendererBase(AdaptiveCards::SemanticVersion("1.2"))
	{
		SetObjectTypes();
		SetHostConfig(hostConfig);
		SetRenderConfig(renderConfig);
	}

	CardDetails AdaptiveCardQmlRenderer::RenderCard(std::shared_ptr<AdaptiveCards::AdaptiveCard> card, const int contentIndex)
	{
		std::shared_ptr<RenderedQmlAdaptiveCard> output;
		auto context = std::make_shared<AdaptiveRenderContext>(GetHostConfig(), GetElementRenderers(), GetRenderConfig());
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

		return CardDetails(*output, context->getContentIndex(), context->getHeightEstimate());
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
        auto cardConfig = context->GetRenderConfig()->getCardConfig();
        context->setDefaultIdName("defaultId");
		int margin = context->GetConfig()->GetSpacing().paddingSpacing;
        auto uiCard = std::make_shared<QmlTag>("Rectangle");
        uiCard->AddImports("import QtQuick 2.15");
        uiCard->AddImports("import QtQuick.Layouts 1.3");
        uiCard->AddImports("import QtQuick.Controls 2.15");
        uiCard->AddImports("import QtGraphicalEffects 1.15");
        uiCard->AddImports("import AdaptiveCards 1.0");
        uiCard->AddImports("import \"AdaptiveCardUtils.js\" as AdaptiveCardUtils");
        uiCard->Property("id", "adaptiveCard");
        context->setCardRootId(uiCard->GetId());
		context->setCardRootElement(uiCard);
		uiCard->Property("readonly property int margins", std::to_string(margin));
        uiCard->AddFunctions("signal buttonClicked(var title, var type, var data)");
        uiCard->AddFunctions("signal sendCardHeight(var cardHeight)");
        uiCard->AddFunctions("signal openContextMenu(var globalPos, string selectedText, string link)");
        uiCard->AddFunctions("signal textEditFocussed(var textEdit)");
        uiCard->AddFunctions("signal setFocusBackOnClose(var element)");
        uiCard->AddFunctions("signal showToolTipifNeeded(var link, var point)");
		//1px extra height to accomodate the border of a showCard if present at the bottom
        uiCard->Property("implicitHeight", "adaptiveCardLayout.implicitHeight");
		uiCard->Property("Layout.fillWidth", "true");
		uiCard->Property("readonly property string bgColor", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));
		uiCard->Property("color", "bgColor");
		uiCard->Property("border.color", isChildCard? " bgColor" : context->GetHexColor(cardConfig.cardBorderColor));
        uiCard->AddFunctions("MouseArea{anchors.fill: parent;onPressed: {adaptiveCard.nextItemInFocusChain().forceActiveFocus(); mouse.accepted = true;}}");
        uiCard->Property("radius", Formatter() << (isChildCard ? 0 : cardConfig.cardRadius));

        const auto hasBackgroundImage = card->GetBackgroundImage() != nullptr;
		if (hasBackgroundImage)
		{
			auto uiFrame = std::make_shared<QmlTag>("Frame");
            uiFrame->Property("id", Formatter() << uiCard->GetId() << "_frame");
			uiFrame->Property("readonly property bool hasBackgroundImage", "true");
            uiFrame->Property("property var imgSource", GetImagePath(context, card->GetBackgroundImage()->GetUrl()), true);
			uiFrame->Property("anchors.fill", "parent");
			uiFrame->Property("background", AdaptiveCardQmlRenderer::GetBackgroundImage(card->GetBackgroundImage(), context, "parent.imgSource")->ToString());
			uiCard->Property("clip", "true");
            uiCard->Property("layer.enabled", "true");
            uiCard->Property("layer.effect", GetOpacityMask(uiCard->GetId())->ToString());
			uiCard->AddChild(uiFrame);
		}

		auto columnLayout = std::make_shared<QmlTag>("ColumnLayout");
		columnLayout->Property("id", "adaptiveCardLayout");
		columnLayout->Property("width", "parent.width");

		auto rectangle = std::make_shared<QmlTag>("Rectangle");
		rectangle->Property("id", "adaptiveCardRectangle");
		rectangle->Property("color", "'transparent'");
		rectangle->Property("Layout.topMargin", "margins");
		rectangle->Property("Layout.bottomMargin", "removeBottomMargin? 1 : margins");
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
        addSelectAction(uiCard, uiCard->GetId(), card->GetSelectAction(), context, "Adaptive Card", hasBackgroundImage);

        uiCard->AddChild(columnLayout);

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

        if ((!rectangle->HasProperty("Layout.topMargin") || !rectangle->HasProperty("Layout.bottomMargin")) && !isChildCard)
        {
            uiCard->Property("clip", "true");
            uiCard->Property("layer.enabled", "true");
            uiCard->Property("layer.effect", GetOpacityMask(uiCard->GetId())->ToString());

            if (!rectangle->HasProperty("Layout.topMargin"))
            {
                rectangle->Property("Layout.topMargin", "1");
            }

            if (!rectangle->HasProperty("Layout.bottomMargin"))
            {
                rectangle->Property("Layout.bottomMargin", "1");
            }
        }

        int cardMinHeight = (int(card->GetMinHeight()) - tempMargin > 0 ) ? (int(card->GetMinHeight()) - tempMargin) : 0;

        if (!isChildCard)
        {
            auto clipRectangle = std::make_shared<QmlTag>("Rectangle");
            clipRectangle->Property("id", "clipRectangle");
            clipRectangle->Property("anchors.fill", "parent");
            clipRectangle->Property("clip", "true");
            clipRectangle->Property("radius", Formatter() << cardConfig.cardRadius);
            clipRectangle->Property("border.color", context->GetHexColor(cardConfig.cardBorderColor));
            clipRectangle->Property("border.width", "1");
            clipRectangle->Property("color", "'transparent'");
            clipRectangle->Property("z", "1");
            uiCard->AddChild(clipRectangle);

            uiCard->Property("activeFocusOnTab", "true");
            clipRectangle->Property("activeFocusOnTab", "true");
            uiCard->Property("Keys.onBacktabPressed", "{event.accepted = true}");
            clipRectangle->Property("Keys.onTabPressed", "{event.accepted = true}");
            clipRectangle->Property("Accessible.name", "To go out of Adaptive Card press escape", true);

            const auto isChildCardString = isChildCard ? "true" : "false";
            bodyLayout->Property("onImplicitHeightChanged", Formatter() << "{"
                << "AdaptiveCardUtils.generateStretchHeight(children, " << cardMinHeight << "); "
                << "var cardHeight = AdaptiveCardUtils.getCardHeight(" << bodyLayout->GetId() << ".children);"
                << context->getCardRootId() << ".sendCardHeight(cardHeight + 2 * " << context->getCardRootId() << ".margins);"
                << "}");
        }
        else
        {
            bodyLayout->Property("onImplicitHeightChanged", Formatter() << "{AdaptiveCardUtils.generateStretchHeight(children," << cardMinHeight << ")}");
        }

		bodyLayout->Property("onImplicitHeightChanged", Formatter() << "{AdaptiveCardUtils.generateStretchHeight(children," << cardMinHeight << ")}");

		bodyLayout->Property("onImplicitWidthChanged", Formatter() << "{AdaptiveCardUtils.generateStretchHeight(children," << cardMinHeight << ")}");

		if (card->GetMinHeight() > 0)
		{
			rectangle->Property("Layout.minimumHeight", std::to_string(cardMinHeight));
		}

        //Add submit onclick event
        addSubmitActionButtonClickFunc(context);
        addShowCardLoaderComponents(context);
        addTextRunSelectActions(context);

        uiCard->Property("property var requiredElements", "[]");
        auto requiredElementsList = context->getRequiredInputElementsIdList();

        if (context->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() && !requiredElementsList.empty())
        {
            std::string requiredElements = "[";
            for (const auto& element : requiredElementsList)
            {
                requiredElements += element;
                requiredElements += ((element == *requiredElementsList.rbegin()) ? "]" : ",");
            }
            uiCard->Property("property var requiredElements", requiredElements);
        }

        uiCard->Property("property var submitElements", "({})");
        auto submitElementsList = context->getInputElementList();

        if (!submitElementsList.empty())
        {
            std::string submitElements = "{";
            for (const auto& element : submitElementsList)
            {
                submitElements += (Formatter() << "\"" << element.first << "\" : " << element.second);
                submitElements += ((element == *submitElementsList.rbegin()) ? "}" : ",");
            }
            uiCard->Property("property var submitElements", submitElements);
        }

		return uiCard;
	}

    void AdaptiveCardQmlRenderer::AddContainerElements(std::shared_ptr<QmlTag> uiContainer, const std::vector<std::shared_ptr<AdaptiveCards::BaseCardElement>>& elements, std::shared_ptr<AdaptiveRenderContext> context)
    {
		for (const auto& cardElement : elements)
		{
            try {
                auto uiElement = context->Render(cardElement);

                if (uiElement != nullptr)
                {
                    if (!uiContainer->GetChildren().empty())
                    {
                        AddSeparator(uiContainer, cardElement, context, uiElement->GetId());
                    }

                    if (cardElement->GetHeight() == AdaptiveCards::HeightType::Stretch && cardElement->GetElementTypeString() != "Image")
                    {
                        uiElement->Property("readonly property bool stretch", "true");
                    }

                    uiContainer->AddChild(uiElement);
                }
            }
            catch (const std::exception& e) {
                context->AddWarning(AdaptiveWarning(Code::RenderException, e.what()));
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
                uiButtonStrip = std::make_shared<QmlTag>("AddActionRender");
                uiButtonStrip->Property("_spacing", Formatter() << actionsConfig.buttonSpacing);
                uiButtonStrip->Property("_layoutDirection", actionsConfig.actionAlignment == AdaptiveCards::ActionAlignment::Right ? "'Qt.RightToLeft'" : "'Qt.LeftToRight'");
            }
            else
            {
                //TODO: Implement AdaptiveCards::ActionsOrientation::Vertical
                uiButtonStrip = std::make_shared<QmlTag>("AddActionRenderVertical");
                uiButtonStrip->Property("width", "parent.width");
                uiButtonStrip->Property("_spacing", std::to_string(actionsConfig.buttonSpacing));
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

            std::ostringstream rectangleElements;
            std::ostringstream actionElements;
            std::shared_ptr<QmlTag> uiRectangle;
            std::ostringstream actionsModel;
            uiButtonStrip->Property("adaptiveCard", Formatter() << "adaptiveCard");
            actionsModel << "ListModel {Component.onCompleted : { ";
            for (unsigned int i = 0; i < maxActions; i++)
            {
                actionsModel << "append({";
                // add actions buttons
                const auto action = actions[i];
                const auto buttonIndex = context->getButtonCounter();
                if (actionsConfig.actionAlignment == AdaptiveCards::ActionAlignment::Center)
                {
                    rectangleElements << (i == 0 ? "[" : "") << "button_auto_" << buttonIndex << "_rectangle" << (i == maxActions - 1 ? "]" : ",");
                    actionElements << (i == 0 ? "[" : "") << "button_auto_" << buttonIndex << (i == maxActions - 1 ? "]" : ",");
                    actionsModel << "_isactionAlignmentCenter: " <<  "true" << ", \n";

                }
                else {
                    actionsModel << "_isactionAlignmentCenter: " <<  "false" << ", \n";
                }
                
                if (context->GetConfig()->GetSupportsInteractivity())
                {
                   auto buttonElement = std::make_shared<QmlTag>("AdaptiveActionRender");

                    if (!Utils::IsNullOrWhitespace(action->GetStyle()) && !Utils::CaseInsensitiveCompare(action->GetStyle(), "default"))
                    {
                        if (Utils::CaseInsensitiveCompare(action->GetStyle(), "positive"))
                        {
                            actionsModel << "buttonConfigType: \"positiveColorConfig\", \n";
                        }
                        else if (Utils::CaseInsensitiveCompare(action->GetStyle(), "destructive"))
                        {
                            actionsModel << "buttonConfigType: \"destructiveColorConfig\", \n";
                        }
                        else
                        {
                            actionsModel << "buttonConfigType: \"primaryColorConfig\", \n";
                        }
                    }
                    else
                    {
                        actionsModel << "buttonConfigType: \"primaryColorConfig\", \n";
                    }

                    actionsModel << "isIconLeftOfTitle: " << (context->GetConfig()->GetActions().iconPlacement == AdaptiveCards::IconPlacement::LeftOfTitle ? "true" : "false") << ", \n";
                    actionsModel << "escapedTitle: "  << "\"" << Utils::getBackQuoteEscapedString(action->GetTitle()) << "\", \n";
                    actionsModel << "_id: " << "\"button_auto_" << buttonIndex << "\", \n";
                    actionsModel << "_buttonId: " << "\"button_auto_" << buttonIndex << "_rectangle" << "\", \n";
                    const bool isShowCardButton = Utils::IsInstanceOfSmart<AdaptiveCards::ShowCardAction>(action);
                    if (isShowCardButton)
                    {
                        actionsModel << "isShowCardButton: " << "true" << ", \n";
                        actionsModel << "iconSource: " << "\"" << RendererQml::arrow_down_12 << "\", \n";
                    }
                    else {
                        actionsModel << "isShowCardButton: " << "false" << ", \n";
                        actionsModel << "iconSource: " << "\"" << "\", \n";
                    }
                    
                    actionsModel << "isActionSubmit: " << (action->GetElementTypeString() == "Action.Submit" ? "true" : "false") << ", \n";
                    actionsModel << "isActionOpenUrl: " << (action->GetElementTypeString() == "Action.OpenUrl" ? "true" : "false") << ", \n";
                    if (action->GetElementTypeString() == "Action.ToggleVisibility") {
                        actionsModel << "isActionToggleVisibility: " << "true" << ", \n";
                    }
                    else {
                        actionsModel << "isActionToggleVisibility: " << "false" << ", \n";
                    }

                    if (!action->GetIconUrl().empty())
                    {
                        actionsModel << "hasIconUrl: " << "true" << ", \n";
                        actionsModel << "imgSource: " << "\"" << GetImagePath(context, action->GetIconUrl()) << "\" , \n";
                    }
                    else {
                        actionsModel << "hasIconUrl: " << "false" << ", \n";
                        actionsModel << "imgSource: " << "\"" <<  "\" , \n";

                    }
                    std::string onReleasedFunction;
                    std::string selectActionId = "";
                    if (action->GetElementTypeString() == "Action.OpenUrl")
                    {
                        auto openUrlAction = std::dynamic_pointer_cast<AdaptiveCards::OpenUrlAction>(action);
                        selectActionId = openUrlAction->GetUrl();
                        actionsModel << "paramStr: " << "\"" << "\", \n";
                        actionsModel << "toggleVisibilityTarget: " << "\"" << "\", \n";

                    }
                    else if (action->GetElementTypeString() == "Action.ShowCard")
                    {
                        context->addToShowCardButtonList(buttonElement, std::dynamic_pointer_cast<AdaptiveCards::ShowCardAction>(action));
                        actionsModel << "paramStr: " << "\"" << "\", \n";
                        actionsModel << "toggleVisibilityTarget: " << "\"" << "\", \n";
                    }
                    else if (action->GetElementTypeString() == "Action.ToggleVisibility")
                    {
                        auto toggleVisibilityAction = std::dynamic_pointer_cast<AdaptiveCards::ToggleVisibilityAction>(action);
                        selectActionId = toggleVisibilityAction->GetElementTypeString();
                        actionsModel << "toggleVisibilityTarget: "  << "\"" << getActionToggleVisibilityObject(toggleVisibilityAction, context) << " \" , \n";
                        actionsModel << "paramStr: " << "\"" << "\", \n";
                    }
                    else if (action->GetElementTypeString() == "Action.Submit")
                    {
                        auto submitAction = std::dynamic_pointer_cast<AdaptiveCards::SubmitAction>(action);
                        selectActionId = submitAction->GetElementTypeString();
                        std::string submitDataJson = submitAction->GetDataJson();
                        //submitDataJson = Utils::Trim(submitDataJson);
                        
                        submitDataJson.erase(std::remove(submitDataJson.begin(), submitDataJson.end(), '"'), submitDataJson.end());
                        actionsModel << "paramStr: \""  << submitDataJson << "\", \n";
                        actionsModel << "toggleVisibilityTarget: " << "\"" << "\", \n";
                    }
                    
                    actionsModel << "is1_3Enabled: " << (context->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() == true ? "true" : "false") << ", \n";
                    
                    actionsModel << "selectActionId: " << "\"" << selectActionId << "\"" << ", \n";

                }

                actionsModel << " });";

                /*
                auto uiAction = context->Render(actions[i]);
                if (uiAction != nullptr)
                {
                    if (Utils::IsInstanceOfSmart<AdaptiveCards::ShowCardAction>(actions[i]))
                    {
                        // Add to loader source component list
						const std::string loaderId = uiAction->GetId() + "_loader";
                        const std::string componentId = uiAction->GetId() + "_component";
                        const auto showCardAction = std::dynamic_pointer_cast<AdaptiveCards::ShowCardAction>(actions[i]);
                        context->addToShowCardLoaderComponentList(uiAction->GetId(), showCardAction);

                        //Add show card loader to the parent container
                        AddSeparator(uiContainer, std::make_shared<AdaptiveCards::Container>(), context, std::string(), true, loaderId);

						auto uiLoader = std::make_shared<QmlTag>("Loader");
                        uiLoader->Property("id", loaderId);
						//1px shift to avoid child card displaying over parent card's border
                        uiLoader->Property("x", "-margins + 1");
                        uiLoader->Property("sourceComponent", componentId);
                        uiLoader->Property("visible", "false");
						//2 px reduction in width to avoid child card displaying over parent card's border
						uiLoader->Property("width", Formatter() << uiContainer->GetProperty("id") << ".width + 2*margins - 2");
						uiLoader->Property("readonly property bool removeBottomMargin", removeBottomMargin ? "true" : "false");

                        if (removeBottomMargin)
                        {
                            context->addToLastShowCardComponentIdsList(componentId);
                        }

						context->addToShowCardsLoaderIdsList(loaderId);
                        uiContainer->AddChild(uiLoader);
                    }

                    uiButtonStrip->AddChild(actionsConfig.actionAlignment == AdaptiveCards::ActionAlignment::Center ? uiRectangle : uiAction);
                }
                */
            }
            actionsModel << "} }";
            uiButtonStrip->Property("actionButtonModel", actionsModel.str());

            if (actionsConfig.actionAlignment == AdaptiveCards::ActionAlignment::Center)
            {
                uiButtonStrip->Property("property var rectangleElements", rectangleElements.str());
                uiButtonStrip->Property("property var actionElements", actionElements.str());
                uiButtonStrip->Property("onWidthChanged", "AdaptiveCardUtils.horizontalAlignActionSet(this, actionElements, rectangleElements)");
                uiButtonStrip->Property("onImplicitWidthChanged", "AdaptiveCardUtils.horizontalAlignActionSet(this, actionElements, rectangleElements)");
                uiButtonStrip->Property("Component.onCompleted", "AdaptiveCardUtils.horizontalAlignActionSet(this, actionElements, rectangleElements)");
            }

            // add show card click function
            addShowCardButtonClickFunc(context);

            // Restore the iconPlacement for the context.
            actionsConfig.iconPlacement = oldConfigIconPlacement;
        }
    }

    void AdaptiveCardQmlRenderer::addSelectAction(const std::shared_ptr<QmlTag>& parent, const std::string& rectId, const std::shared_ptr<AdaptiveCards::BaseActionElement>& selectAction, const std::shared_ptr<AdaptiveRenderContext>& context, const std::string parentName, const bool hasBackgroundImage)
    {
        if (context->GetConfig()->GetSupportsInteractivity() && selectAction != nullptr)
        {
            // SelectAction doesn't allow showCard actions
            if (Utils::IsInstanceOfSmart<AdaptiveCards::ShowCardAction>(selectAction))
            {
                context->AddWarning(AdaptiveWarning(Code::RenderException, "Inline ShowCard not supported for SelectAction"));
                return;
            }

            std::string mouseAreaId = Formatter() << parent->GetId() << "_selectAction_mouseArea";
            const auto parentColor = !parent->GetProperty("readonly property string bgColor").empty() ? parent->GetProperty("readonly property string bgColor") : "'transparent'";
            const auto hoverColor = context->GetRGBColor(context->GetConfig()->GetContainerStyles().emphasisPalette.backgroundColor);

            auto mouseArea = std::make_shared<QmlTag>("MouseArea");
            mouseArea->Property("anchors.fill", "parent");
            mouseArea->Property("acceptedButtons", "Qt.LeftButton");
            mouseArea->Property("hoverEnabled", "true");
            mouseArea->Property("id", mouseAreaId);

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
                mouseArea->Property("onClicked", Formatter() << "{\n" << onClickedFunction << "}");
            }
            else if (selectAction->GetElementTypeString() == "Action.ToggleVisibility")
            {
                onClickedFunction = getActionToggleVisibilityClickFunc(std::dynamic_pointer_cast<AdaptiveCards::ToggleVisibilityAction>(selectAction), context);
                mouseArea->Property("onClicked", Formatter() << "{\n" << onClickedFunction << "}");
            }
            else if (selectAction->GetElementTypeString() == "Action.Submit")
            {
                context->addToSubmitActionButtonList(mouseArea, std::dynamic_pointer_cast<AdaptiveCards::SubmitAction>(selectAction));
            }
            else
            {
                onClickedFunction = "";
            }
            mouseArea->Property("Keys.onPressed", Formatter() << "{if (event.key === Qt.Key_Return || event.key === Qt.Key_Space){ " << mouseAreaId << ".clicked( " << mouseAreaId << ".mouseX)}}");
            mouseArea->Property("activeFocusOnTab", "true");
            mouseArea->Property("z", "1");
            mouseArea->Property("onActiveFocusChanged", Formatter() << "{ if (activeFocus){ " << mouseAreaId << ".entered();}else{ " << mouseAreaId << ".exited();}}");
            mouseArea->Property("Accessible.name", Formatter() << parentName << selectAction->GetElementTypeString(), true);

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
                        onLinkActivated << getActionSubmitClickFunc(std::dynamic_pointer_cast<AdaptiveCards::SubmitAction>(action.second), context, textRunElement.first->GetElement());
                    }
                    onLinkActivated << "return;\n}\n";
                }
                textRunElement.first->Property("onLinkActivated", Formatter() << "{\n" << onLinkActivated.str() << "}");
            }
        }
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetComponent(const std::string& loaderId, const std::shared_ptr<QmlTag>& uiCard)
    {
        auto uiComponent = std::make_shared<QmlTag>("Component");
        const auto componentId = loaderId + "_component";
        uiComponent->Property("id", componentId);

        const std::string layoutId = Formatter() << componentId << "_component_layout";
        std::string uiCard_string = uiCard->ToString();
        uiCard_string = Utils::Replace(uiCard_string, "\\", "\\\\");
        uiCard_string = Utils::Replace(uiCard_string, "\"", "\\\"");

        auto uiColumn = std::make_shared<QmlTag>("ColumnLayout");
        uiColumn->Property("id", layoutId);
        uiColumn->AddFunctions("property var card");
        uiColumn->Property("property string showCard", uiCard_string, true);
        uiColumn->Property("property bool loaderVisible", RendererQml::Formatter() << loaderId << ".visible");
        uiColumn->Property("onLoaderVisibleChanged", "reload(showCard)");

        std::ostringstream reloadFunction;
        reloadFunction << "function reload(mCard)\n{\n";
        reloadFunction << "if(loaderVisible && !card){\n";
        reloadFunction << "card = Qt.createQmlObject(mCard, " << layoutId << ", 'card')\n";
        reloadFunction << "if (card)\n{ \ncard.buttonClicked.connect(adaptiveCard.buttonClicked);"
            "card.openContextMenu.connect(adaptiveCard.openContextMenu);"
            "card.textEditFocussed.connect(adaptiveCard.textEditFocussed);"
            "card.setFocusBackOnClose.connect(adaptiveCard.setFocusBackOnClose);card.showToolTipifNeeded.connect(adaptiveCard.showToolTipifNeeded);}}}";

        uiColumn->AddFunctions(reloadFunction.str());
		uiComponent->AddChild(uiColumn);

		return uiComponent;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::TextBlockRender(std::shared_ptr<AdaptiveCards::TextBlock> textBlock, std::shared_ptr<AdaptiveRenderContext> context)
	{
        // LIMITATION: Elide and maximumLineCount property do not work for textFormat:Text.RichText
        auto cardConfig = context->GetRenderConfig()->getCardConfig();
        std::string fontFamily = context->GetConfig()->GetFontFamily(textBlock->GetFontType());
        int fontSize = context->GetConfig()->GetFontSize(textBlock->GetFontType(), textBlock->GetTextSize());
        std::string horizontalAlignment = AdaptiveCards::EnumHelpers::getHorizontalAlignmentEnum().toString(textBlock->GetHorizontalAlignment());
        std::string color = context->GetColor(textBlock->GetTextColor(), textBlock->GetIsSubtle(), false);

        if (!textBlock->GetId().empty())
        {
            textBlock->SetId(context->ConvertToValidId(textBlock->GetId()));
        }
        else
        {
            textBlock->SetId(Formatter() << "text_block" << context->getTextBlockCounter());
        }

        auto uiTextBlock = std::make_shared<QmlTag>("TextBlockRender");
        uiTextBlock->Property("id", textBlock->GetId());
        uiTextBlock->Property("_adaptiveCard", "adaptiveCard");
        uiTextBlock->Property("_width", "parent.width");
        uiTextBlock->Property("_horizontalAlignment", horizontalAlignment, true);
        uiTextBlock->Property("_color", color);
        uiTextBlock->Property("_pixelSize", std::to_string(fontSize));
        uiTextBlock->Property("_fontWeight", Utils::GetWeightString(textBlock->GetTextWeight()), true);
        uiTextBlock->Property("_visible", (textBlock->GetIsVisible() && !textBlock->GetText().empty()) ? "true" : "false");
        uiTextBlock->Property("_wrapMode", textBlock->GetWrap() ? "true" : "false");
        uiTextBlock->Property("_fontFamily", fontFamily, true);
        uiTextBlock->Property("_selectionColor ", Formatter() << context->GetHexColor(cardConfig.textHighlightBackground));

        std::string text = ParseMarkdownString(textBlock->GetText(), context);
        context->addHeightEstimate(context->getEstimatedTextHeight(text));

        uiTextBlock->Property("_text", text, true);

        return uiTextBlock;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::TextInputRender(std::shared_ptr<AdaptiveCards::TextInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
        auto textInputElement = std::make_shared<TextInputElement>(input, context);
        return textInputElement->getQmlTag();
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::NumberInputRender(std::shared_ptr<AdaptiveCards::NumberInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
        auto numberInputElement = std::make_shared<NumberInputElement>(input, context);
        return numberInputElement->getQmlTag();
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::RichTextBlockRender(std::shared_ptr<AdaptiveCards::RichTextBlock> richTextBlock, std::shared_ptr<AdaptiveRenderContext> context)
	{
        if (richTextBlock->GetInlines().empty())
        {
            return NULL;
        }
        auto cardConfig = context->GetRenderConfig()->getCardConfig();
        std::string textType = richTextBlock->GetElementTypeString();
        std::string horizontalAlignment = AdaptiveCards::EnumHelpers::getHorizontalAlignmentEnum().toString(richTextBlock->GetHorizontalAlignment());

        if (!richTextBlock->GetId().empty())
        {
            richTextBlock->SetId(context->ConvertToValidId(richTextBlock->GetId()));
        }
        else
        {
            richTextBlock->SetId(Formatter() << "rich_text_block" << context->getTextBlockCounter());
        }

        auto uiTextBlock = std::make_shared<QmlTag>("RichTextBlockRender");
        uiTextBlock->Property("id", richTextBlock->GetId());
        uiTextBlock->Property("_adaptiveCard", "adaptiveCard");
        uiTextBlock->Property("_width", "parent.width");
        uiTextBlock->Property("_horizontalAlignment", horizontalAlignment, true);
        uiTextBlock->Property("_visible", richTextBlock->GetIsVisible() ? "true" : "false");
        uiTextBlock->Property("_selectionColor ", Formatter() << context->GetHexColor(cardConfig.textHighlightBackground));
        uiTextBlock->Property("_is1_3Enabled", context->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() ? "true" : "false");

        std::string textrun_all = "";
        std::ostringstream toggleVisibilityElements;

        toggleVisibilityElements << "({";
        bool isFirstElement = true;

        for (const auto& inlineRun : richTextBlock->GetInlines())
        {
            if (Utils::IsInstanceOfSmart<AdaptiveCards::TextRun>(inlineRun))
            {
                std::string selectActionId = "";
                auto textRun = std::dynamic_pointer_cast<AdaptiveCards::TextRun>(inlineRun);

                if (textRun->GetSelectAction() != nullptr)
                {
                    if (textRun->GetSelectAction()->GetElementTypeString() == "Action.Submit")
                    {
                        auto submitAction = std::dynamic_pointer_cast<AdaptiveCards::SubmitAction>(textRun->GetSelectAction());
                        selectActionId = submitAction->GetElementTypeString();
                        std::string submitDataJson = submitAction->GetDataJson();
                        submitDataJson = Utils::Trim(submitDataJson);
                        uiTextBlock->Property("_paramStr", Formatter() << "String.raw`" << Utils::getBackQuoteEscapedString(submitDataJson) << "`");
                    }
                    else if (textRun->GetSelectAction()->GetElementTypeString() == "Action.OpenUrl")
                    {
                        auto openUrlAction = std::dynamic_pointer_cast<AdaptiveCards::OpenUrlAction>(textRun->GetSelectAction());
                        selectActionId = openUrlAction->GetUrl();
                    }
                    else if (textRun->GetSelectAction()->GetElementTypeString() == "Action.ToggleVisibility")
                    {
                        auto toggleVisibilityAction = std::dynamic_pointer_cast<AdaptiveCards::ToggleVisibilityAction>(textRun->GetSelectAction());
                        selectActionId = Formatter() << "textRunToggleVisibility_" << context->getSelectActionCounter();
                        toggleVisibilityElements << (isFirstElement ? "" : ", ") << selectActionId << " : " << getActionToggleVisibilityObject(toggleVisibilityAction, context);
                        isFirstElement = false;
                    }
                }

                textrun_all.append(TextRunRender(textRun, context, selectActionId));
            }
        }
        toggleVisibilityElements << "})";
        uiTextBlock->Property("_toggleVisibilityTarget", toggleVisibilityElements.str());
        uiTextBlock->Property("_text", textrun_all, true);
        context->addHeightEstimate(context->getEstimatedTextHeight(textrun_all));

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

        if (textRun->GetUnderline() && context->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
        {
            uiTextRun.append(Formatter() << "text-decoration:" << std::string("underline") << ";");
        }

		if (textRun->GetStrikethrough())
		{
			uiTextRun.append(Formatter() << "text-decoration:" << std::string("line-through") << ";");
		}

		uiTextRun.append("'>");

        std::string text = TextUtils::ApplyTextFunctions(textRun->GetText(), context->GetLang());
        text = Utils::HandleEscapeSequences(text);
        const std::string linkColor = context->GetColor(AdaptiveCards::ForegroundColor::Accent, false, false);
        //CSS Property for underline, striketrhough,etc
        std::string textDecoration = "none";

        text = Utils::FormatHtmlUrl(text, linkColor, textDecoration);

        if (textRun->GetSelectAction() != nullptr)
        {
			const std::string styleString = Formatter() << "style=\\\"color:" << linkColor << ";" << "text-decoration:" << textDecoration << ";\\\"";
            uiTextRun.append(Formatter() << "<a href='" << selectaction << "'" << styleString << " >");
            uiTextRun.append(text);
            uiTextRun.append("</a>");
        }
        else
        {
            uiTextRun.append(text);
        }
		uiTextRun.append("</span>");

		return uiTextRun;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ToggleInputRender(std::shared_ptr<AdaptiveCards::ToggleInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
        auto toggleInputElement = std::make_shared<ToggleInputElement>(input, context);
        return toggleInputElement->getQmlTag();
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ChoiceSetRender(std::shared_ptr<AdaptiveCards::ChoiceSetInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
        auto choiceSetElement = std::make_shared<ChoiceSetElement>(input, context);
        return choiceSetElement->getQmlTag();
	}

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::DateInputRender(std::shared_ptr<AdaptiveCards::DateInput> input, std::shared_ptr<AdaptiveRenderContext> context)
    {
        auto dateInputElement = std::make_shared<DateInputElement>(input, context);
        return dateInputElement->getQmlTag();
    }

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::FactSetRender(std::shared_ptr<AdaptiveCards::FactSet> factSet, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto uiFactSet = std::make_shared<QmlTag>("GridLayout");

		if (!factSet->GetId().empty())
		{
			factSet->SetId(context->ConvertToValidId(factSet->GetId()));
			uiFactSet->Property("id", factSet->GetId());
		}
        else
        {
            uiFactSet->Property("id", Formatter() << "fact_set_auto" << context->getFactSetCounter());
        }

		uiFactSet->Property("columns", "2");
		uiFactSet->Property("rows", std::to_string(factSet->GetFacts().size()));
		uiFactSet->Property("height", "implicitHeight");
		uiFactSet->Property("property int titleWidth", "0");
		uiFactSet->Property("property int minWidth", Formatter() << "AdaptiveCardUtils.getMinWidthFactSet(children, columnSpacing)");
		uiFactSet->AddFunctions("function setTitleWidth(item){	if (item.width > titleWidth){ titleWidth = item.width }}");

		if (!factSet->GetIsVisible())
		{
			uiFactSet->Property("visible", "false");
		}

        const int currentHeight = context->getHeightEstimate();
        int estimatedFactSetHeight = 0;
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
			uiTitle->Property("Layout.fillHeight", "true");
            uiTitle->Property("visible", "true");
            if (fact->GetTitle().empty())
            {
                uiTitle->Property("activeFocusOnTab", "false");
            }

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
			uiValue->Property("Layout.fillHeight", "true");
            uiValue->Property("visible", "true");
            if (fact->GetValue().empty())
            {
                uiValue->Property("activeFocusOnTab", "false");
            }

			uiFactSet->AddChild(uiTitle);
			uiFactSet->AddChild(uiValue);
            estimatedFactSetHeight += context->getEstimatedTextHeight(fact->GetTitle() + fact->GetValue());
		}
        context->setHeightEstimate(currentHeight + estimatedFactSetHeight);

        auto parentRectangle = std::make_shared<QmlTag>("Rectangle");
        parentRectangle->Property("implicitHeight", Formatter() << uiFactSet->GetId() << ".height");
        parentRectangle->Property("width", "parent.width");
        parentRectangle->Property("color", "transparent", true);
        parentRectangle->Property("clip", "true");

		return uiFactSet;
    }

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ImageRender(std::shared_ptr<AdaptiveCards::Image> image, std::shared_ptr<AdaptiveRenderContext> context)
	{
        // TODO: Height(Stretch/Automatic)

        std::shared_ptr<QmlTag> maskTag;
        std::shared_ptr<QmlTag> maskSourceTag;
        auto uiImage = std::make_shared<QmlTag>("ImageRender");

        if (image->GetId().empty())
        {
            image->SetId(Formatter() << "image_auto_" << context->getImageCounter());
        }
        else
        {
            image->SetId(context->ConvertToValidId(image->GetId()));
        }

        uiImage->Property("id", image->GetId());
        uiImage->Property("_adaptiveCard", "adaptiveCard");
        uiImage->Property("_bgColorRect", "'transparent'");
        uiImage->Property("_isImage", "true");
        uiImage->Property("_sourceImage", GetImagePath(context, image->GetUrl()), true);
        uiImage->Property("_visibleRect", image->GetIsVisible() ? "true" : "false");
        uiImage->Property("_actionHoverColor", context->GetRGBColor(context->GetConfig()->GetContainerStyles().emphasisPalette.backgroundColor));

        int imageHeightEstimate = 0;
        if (image->GetPixelWidth() != 0 || image->GetPixelHeight() != 0)
        {
            if (image->GetPixelWidth() != 0)
            {
                uiImage->Property("_imageWidth", Formatter() << image->GetPixelWidth());
                imageHeightEstimate = image->GetPixelWidth();
            }
            if (image->GetPixelHeight() != 0)
            {
                uiImage->Property("height", Formatter() << image->GetPixelHeight());

                if (image->GetPixelWidth() == 0)
                {
                    uiImage->Property("_imageWidth", Formatter() << "aspectWidth");
                }
                imageHeightEstimate = image->GetPixelHeight();
            }

            if (image->GetPixelWidth() != 0)
            {
                uiImage->Property("implicitWidth", std::to_string(image->GetPixelWidth()));
            }
            else
            {
                uiImage->Property("implicitWidth", "aspectWidth");
            }
        }
        else
        {
            int imageWidth = 0;
            switch (image->GetImageSize())
            {
            case AdaptiveCards::ImageSize::None:
            case AdaptiveCards::ImageSize::Auto:
            case AdaptiveCards::ImageSize::Stretch:
                uiImage->Property("width", "parent.width");
                break;
            case AdaptiveCards::ImageSize::Small:
                imageWidth = context->GetConfig()->GetImageSizes().smallSize;
                uiImage->Property("_imageWidth", Formatter() << imageWidth);
                break;
            case AdaptiveCards::ImageSize::Medium:
                imageWidth = context->GetConfig()->GetImageSizes().mediumSize;
                uiImage->Property("_imageWidth", Formatter() << imageWidth);
                break;
            case AdaptiveCards::ImageSize::Large:
                imageWidth = context->GetConfig()->GetImageSizes().largeSize;
                uiImage->Property("_imageWidth", Formatter() << imageWidth);
                break;
            }
            imageHeightEstimate = (imageWidth == 0 ? context->GetConfig()->GetImageSizes().smallSize : imageWidth);

            if (image->GetImageSize() != AdaptiveCards::ImageSize::None)
            {
                uiImage->Property("implicitWidth", "width");
            }
        }
        context->addHeightEstimate(imageHeightEstimate);

        if (!image->GetBackgroundColor().empty())
        {
            uiImage->Property("_bgColorRect", context->GetRGBColor(image->GetBackgroundColor()));
        }

        switch (image->GetHorizontalAlignment())
        {
        case AdaptiveCards::HorizontalAlignment::Center:
            uiImage->Property("_anchorCenter", "true");
            break;
        case AdaptiveCards::HorizontalAlignment::Right:
            uiImage->Property("_anchorRight", "true");
            break;
        default:
            break;
        }

        switch (image->GetImageStyle())
        {
        case AdaptiveCards::ImageStyle::Default:
            break;
        case AdaptiveCards::ImageStyle::Person:
            uiImage->Property("_radius", "width/2");
            uiImage->Property("layer.enabled", "true");
            break;
        }

        if (image->GetSelectAction() != nullptr)
        {
            uiImage->Property("_hoverEnabled", "true");
            std::string selectActionId = "";

            if (image->GetSelectAction()->GetElementTypeString() == "Action.Submit")
            {
                auto submitAction = std::dynamic_pointer_cast<AdaptiveCards::SubmitAction>(image->GetSelectAction());
                selectActionId = submitAction->GetElementTypeString();
                std::string submitDataJson = submitAction->GetDataJson();
                submitDataJson = Utils::Trim(submitDataJson);
                uiImage->Property("_paramStr", Formatter() << "String.raw`" << Utils::getBackQuoteEscapedString(submitDataJson) << "`");
            }
            else if (image->GetSelectAction()->GetElementTypeString() == "Action.OpenUrl")
            {
                auto openUrlAction = std::dynamic_pointer_cast<AdaptiveCards::OpenUrlAction>(image->GetSelectAction());
                selectActionId = openUrlAction->GetUrl();
            }
            else if (image->GetSelectAction()->GetElementTypeString() == "Action.ToggleVisibility")
            {
                auto toggleVisibilityAction = std::dynamic_pointer_cast<AdaptiveCards::ToggleVisibilityAction>(image->GetSelectAction());
                selectActionId = toggleVisibilityAction->GetElementTypeString();
                uiImage->Property("_toggleVisibilityTarget", getActionToggleVisibilityObject(toggleVisibilityAction, context));
            }
            uiImage->Property("_selectActionId", Formatter() << "String.raw`" << selectActionId << "`");
        }

        return uiImage;
	}

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::TimeInputRender(std::shared_ptr<AdaptiveCards::TimeInput> input, std::shared_ptr<AdaptiveRenderContext> context)
    {
        auto timeInputElement = std::make_shared<TimeInputElement>(input, context);
        return timeInputElement->getQmlTag();
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

    void AdaptiveCardQmlRenderer::AddSeparator(std::shared_ptr<QmlTag> uiContainer, std::shared_ptr<AdaptiveCards::BaseCardElement> adaptiveElement, std::shared_ptr<AdaptiveRenderContext> context, std::string linkElementId, const bool isShowCard, const std::string loaderId)
	{
        //Returns only when seperator=false and spacing=none
        if (!adaptiveElement->GetSeparator() && adaptiveElement->GetSpacing() == AdaptiveCards::Spacing::None)
        {
            return;
        }

        int spacing = Utils::GetSpacing(context->GetConfig()->GetSpacing(), adaptiveElement->GetSpacing());
        AdaptiveCards::SeparatorConfig separator = context->GetConfig()->GetSeparator();

        auto uiSep = std::make_shared<QmlTag>("SeparatorRender");
        uiSep->Property("_isColElement", adaptiveElement->GetElementTypeString() == "Column" ? "true" : "false");
        uiSep->Property("_height", std::to_string(spacing == 0 ? separator.lineThickness : spacing));
        context->addHeightEstimate(adaptiveElement->GetElementTypeString() == "Column" ? 0 : spacing);

        if (!linkElementId.empty())
        {
            uiSep->Property("_linkedElement", linkElementId);
        }

        if (isShowCard)
        {
            uiSep->Property("_visible", Formatter() << loaderId << ".visible");
        }
        else
        {
            uiSep->Property("_visible", adaptiveElement->GetIsVisible() ? "true" : "false");
        }
        if (adaptiveElement->GetSeparator() && adaptiveElement->GetIsVisible())
        {
            uiSep->Property("_lineVisible", "true");
            uiSep->Property("_lineThickness", std::to_string(separator.lineThickness));
            uiSep->Property("_lineColor", separator.lineColor, true);
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

        addSelectAction(uiFrame, backgroundRect->GetId(), columnSet->GetSelectAction(), context, columnSet->GetElementTypeString());
        uiFrame->Property("background", backgroundRect->ToString());

        int currentHeight = context->getHeightEstimate();
        uiRowLayout->AddChild(uiRow);
        uiFrame->AddChild(uiRowLayout);
		uiFrame = addColumnSetElements(columnSet, uiFrame, uiRowLayout, uiRow, context);

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

		uiFrame->Property("onWidthChanged", Formatter() << "{ AdaptiveCardUtils.generateStretchWidth( row_" << id << ".children, parent.width - (" << marginReleased << "))}");

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
        int currentHeight = context->getHeightEstimate();

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

        int estimatedContainerHeight = std::max(context->getHeightEstimate() - currentHeight, int(container->GetMinHeight()));
        context->setHeightEstimate(currentHeight + estimatedContainerHeight);

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
            uiContainer->Property("property var imgSource", GetImagePath(context, cardElement->GetBackgroundImage()->GetUrl()), true);
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

        addSelectAction(uiContainer, backgroundRect->GetId(), cardElement->GetSelectAction(), context, cardElement->GetElementTypeString(), hasBackgroundImage);
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
			uiContainer->Property("onMinHeightChanged", Formatter() << "{ AdaptiveCardUtils.generateStretchHeight( column_" << id << ".children," << stretchHeight << " )}");
		}
		else if (cardElement->GetElementTypeString() == "Column")
		{
			stretchHeight = Formatter() << "stretchMinHeight - " << tempMargin;
			uiContainer->Property("property int stretchMinHeight", "0");
			uiContainer->Property("onStretchMinHeightChanged", Formatter() << "{ AdaptiveCardUtils.generateStretchHeight( column_" << id << ".children," << stretchHeight << " )}");
		}

		uiColumn->Property("onImplicitHeightChanged", Formatter() << "{ AdaptiveCardUtils.generateStretchHeight(children, " << id << "." << stretchHeight << " )}");

		uiColumn->Property("onImplicitWidthChanged", Formatter() << "{ AdaptiveCardUtils.generateStretchHeight(children, " << id << "." << stretchHeight << " )}");

		uiContainer->Property("property int minWidth", Formatter() << "{ AdaptiveCardUtils.getMinWidth( column_" << cardElement->GetId() << ".children) + " << 2 * tempWidth << "}");

		if (cardElement->GetElementTypeString() == "Column")
		{
			uiContainer->Property("implicitWidth", "minWidth");
		}

        uiContainer->AddChild(uiColumnLayout);

        return uiContainer;
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::MediaRender(std::shared_ptr<AdaptiveCards::Media> media, std::shared_ptr<AdaptiveRenderContext> context)
    {
        return std::make_shared<QmlTag>("Rectangle");
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ActionSetRender(std::shared_ptr<AdaptiveCards::ActionSet> actionSet, std::shared_ptr<AdaptiveRenderContext> context)
	{
        auto actionSetConfig = context->GetRenderConfig()->getActionButtonsConfig();
		auto outerContainer = std::make_shared<QmlTag>("Column");

		if (actionSet->GetId().empty())
		{
			actionSet->SetId(Formatter() << "actionSet_auto_" << std::to_string(context->GetActionSetCounter()));
		}

		outerContainer->Property("id", context->ConvertToValidId(actionSet->GetId()));
		outerContainer->Property("width", "parent.width");

		if (!actionSet->GetIsVisible())
		{
			outerContainer->Property("visible", "false");
		}

		outerContainer->Property("property int minWidth", Formatter() << "{ AdaptiveCardUtils.getMinWidthActionSet( children[1].children," << context->GetConfig()->GetActions().buttonSpacing << ")}");

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
        context->addHeightEstimate(actionSetConfig.primaryColorConfig.buttonHeight);

		return outerContainer;
	}

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::AdaptiveActionRender(std::shared_ptr<AdaptiveCards::BaseActionElement> action, std::shared_ptr<AdaptiveRenderContext> context)
    {
        if (context->GetConfig()->GetSupportsInteractivity())
        {
            auto buttonElement = std::make_shared<QmlTag>("AdaptiveActionRender");

            if (!Utils::IsNullOrWhitespace(action->GetStyle()) && !Utils::CaseInsensitiveCompare(action->GetStyle(), "default"))
            {
                if (Utils::CaseInsensitiveCompare(action->GetStyle(), "positive"))
                {
                    buttonElement->Property("_buttonConfigType",  "'positiveColorConfig'");
                }
                else if (Utils::CaseInsensitiveCompare(action->GetStyle(), "destructive"))
                {
                    buttonElement->Property("_buttonConfigType",  "'destructiveColorConfig'");
                }
                else
                {
                    buttonElement->Property("_buttonConfigType",  "'primaryColorConfig'");
                }
            }
            else
            {
                buttonElement->Property("_buttonConfigType",  "'primaryColorConfig'");
            }

            buttonElement->Property("_isIconLeftOfTitle", context->GetConfig()->GetActions().iconPlacement == AdaptiveCards::IconPlacement::LeftOfTitle ? "true" : "false");
            buttonElement->Property("_escapedTitle", RendererQml::Formatter() << "String.raw`" << Utils::getBackQuoteEscapedString(action->GetTitle()) << "`");
            buttonElement->Property("id", Formatter() << "button_auto_" << context->getButtonCounter());
            const bool isShowCardButton = Utils::IsInstanceOfSmart<AdaptiveCards::ShowCardAction>(action);
            if (isShowCardButton)
            {
                buttonElement->Property("_isShowCardButton", "true");
                buttonElement->Property("_iconSource", RendererQml::arrow_down_12, true);
            }
            buttonElement->Property("_isActionSubmit", action->GetElementTypeString() == "Action.Submit" ? "true" : "false");
            buttonElement->Property("_isActionOpenUrl", action->GetElementTypeString() == "Action.OpenUrl" ? "true" : "false");

            if (action->GetElementTypeString() == "Action.ToggleVisibility") {
                buttonElement->Property("_isActionToggleVisibility", "true");
            }
            else {
                buttonElement->Property("_isActionToggleVisibility", "false");
            }

            if (!action->GetIconUrl().empty())
            {
                buttonElement->Property("_hasIconUrl", "true");
                buttonElement->Property("_imgSource", GetImagePath(context, action->GetIconUrl()), true);
            }
            std::string onReleasedFunction;
            std::string selectActionId = "";
            if (action->GetElementTypeString() == "Action.OpenUrl")
            {
                auto openUrlAction = std::dynamic_pointer_cast<AdaptiveCards::OpenUrlAction>(action);
                selectActionId = openUrlAction->GetUrl();

            }
            else if (action->GetElementTypeString() == "Action.ShowCard")
            {
                context->addToShowCardButtonList(buttonElement, std::dynamic_pointer_cast<AdaptiveCards::ShowCardAction>(action));
            }
            else if (action->GetElementTypeString() == "Action.ToggleVisibility")
            {
                auto toggleVisibilityAction = std::dynamic_pointer_cast<AdaptiveCards::ToggleVisibilityAction>(action);
                selectActionId = toggleVisibilityAction->GetElementTypeString();
                buttonElement->Property("_toggleVisibilityTarget", getActionToggleVisibilityObject(toggleVisibilityAction, context));
            }
            else if (action->GetElementTypeString() == "Action.Submit")
            {
                auto submitAction = std::dynamic_pointer_cast<AdaptiveCards::SubmitAction>(action);
                selectActionId = submitAction->GetElementTypeString();
                std::string submitDataJson = submitAction->GetDataJson();
                submitDataJson = Utils::Trim(submitDataJson);
                buttonElement->Property("_paramStr", Formatter() << "String.raw`" << Utils::getBackQuoteEscapedString(submitDataJson) << "`");
            }
            buttonElement->Property("_is1_3Enabled", context->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() == true ? "true" : "false");
            //buttonElement->Property("_adaptiveCard", "adaptiveCard");
            buttonElement->Property("_selectActionId", Formatter() << "String.raw`" << selectActionId << "`");

            return buttonElement;
        }
        return nullptr;

    }

    void AdaptiveCardQmlRenderer::addSubmitActionButtonClickFunc(const std::shared_ptr<AdaptiveRenderContext>& context)
    {
        for (auto& element : context->getSubmitActionButtonList())
        {
            std::string onReleasedFunction;
            const auto buttonElement = element.first;
            const auto action = element.second;

            onReleasedFunction = getActionSubmitClickFunc(action, context, buttonElement->GetElement());
            buttonElement->Property((buttonElement->GetElement() == "MouseArea" ? "onClicked" : "onReleased"), Formatter() << "{\n" << onReleasedFunction << "}\n");
        }
    }

    void AdaptiveCardQmlRenderer::addShowCardButtonClickFunc(const std::shared_ptr<AdaptiveRenderContext>& context)
    {
        for (auto& element : context->getShowCardButtonList())
        {
            std::string onReleasedFunction;
            const auto buttonElement = element.first;
            const auto action = element.second;

            onReleasedFunction = getActionShowCardClickFunc(buttonElement, context);
            buttonElement->Property("onReleased", Formatter() << "{\n" << onReleasedFunction << "}\n");
        }

        context->clearShowCardButtonList();
    }

    void AdaptiveCardQmlRenderer::addShowCardLoaderComponents(const std::shared_ptr<AdaptiveRenderContext>& context)
    {
        for (const auto& componentElement : context->getShowCardLoaderComponentList())
        {
            std::string componentId = componentElement.first + "_component";
            auto subContext = std::make_shared<AdaptiveRenderContext>(context->GetConfig(), context->GetElementRenderers(), context->GetRenderConfig());
            subContext->setContentIndex(context->getContentIndex());

            // Add parent input input elements to the child card
            for (const auto& inputElement : context->getInputElementList())
            {
                subContext->addToInputElementList(inputElement.first, inputElement.second);
            }

            // Add parent required input input elements to the child card
            for (const auto& inputElement : context->getRequiredInputElementsIdList())
            {
                subContext->addToRequiredInputElementsIdList(inputElement);
            }

            auto uiCard = subContext->Render(componentElement.second->GetCard(), &AdaptiveCardRender, true);
            if (uiCard != nullptr)
            {
                //TODO: Remove these hardcoded colors once config settings are finalised
                const auto containerColor = context->GetRGBColor(context->GetConfig()->GetBackgroundColor(context->GetConfig()->GetActions().showCard.style));

                uiCard->Property("color", containerColor);

                const auto lastShowCards = context->getLastShowCardComponentIdsList();
                auto cardConfig = context->GetRenderConfig()->getCardConfig();
                if (std::find(lastShowCards.begin(), lastShowCards.end(), componentId) != lastShowCards.end())
                {
                    uiCard->Property("radius", Formatter() << cardConfig.cardRadius);
                    uiCard = AddCornerRectangles(uiCard, cardConfig.cardRadius);
                }

                // Add show card component to root element
                const auto showCardComponent = GetComponent(componentElement.first, uiCard);
                context->getCardRootElement()->AddChild(showCardComponent);
            }

            context->setContentIndex(subContext->getContentIndex());
        }
    }

    const std::string AdaptiveCardQmlRenderer::getActionOpenUrlClickFunc(const std::shared_ptr<AdaptiveCards::OpenUrlAction>& action, const std::shared_ptr<AdaptiveRenderContext>& context)
    {
        // Sample signal to emit on click
        //adaptiveCard.buttonClick(var title, var type, var data);
        //adaptiveCard.buttonClick("title", "Action.OpenUrl", "https://adaptivecards.io");
        std::ostringstream function;
        function << context->getCardRootId() << ".buttonClicked(String.raw`" << Utils::getBackQuoteEscapedString(action->GetTitle()) << "`, \"" << action->GetElementTypeString() << "\", \"" << action->GetUrl() << "\");\n";
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

	const std::string AdaptiveCardQmlRenderer::getActionSubmitClickFunc(const std::shared_ptr<AdaptiveCards::SubmitAction>& action, const std::shared_ptr<AdaptiveRenderContext>& context, std::string elementType)
    {
        // Sample signal to emit on click
        //adaptiveCard.buttonClick(var title, var type, var data);
        //adaptiveCard.buttonClick("title", "Action.Submit", "{"x":13,"firstName":"text1","lastName":"text2"}");
        std::ostringstream function;

        std::string submitDataJson = action->GetDataJson();
        submitDataJson = Utils::Trim(submitDataJson);

        function << "var paramJson = {};\n";

        function << (elementType == "Button" ? "if (!isButtonDisabled) \n{\n" : "");

        if (!submitDataJson.empty() && submitDataJson != "null")
        {
            if (submitDataJson.front() == '{' && submitDataJson.back() == '}')
            {
                function << "var parmStr = String.raw`" << Utils::getBackQuoteEscapedString(submitDataJson) << "`;";
                function << "paramJson = JSON.parse(parmStr);\n";
            }
            else
            {
                function << "paramJson[\"data\"] = " << submitDataJson << ";\n";
            }
        }


        if (context->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
        {
            if (action->GetAssociatedInputs() == AdaptiveCards::AssociatedInputs::Auto)
            {
                std::string requiredElements = "var requiredElements = [";
                std::string lastElement = context->getRequiredInputElementsIdList().size() > 0 ? *(context->getRequiredInputElementsIdList().rbegin()) : "";

                for (const auto& element : context->getRequiredInputElementsIdList())
                {
                    requiredElements += element;
                    if (element != lastElement)
                    {
                        requiredElements += ",";
                    }
                }

                requiredElements += "];";

                function << requiredElements << "var firstElement = undefined; var isNotSubmittable = false;";
                function << "for(var i=0;i<requiredElements.length;i++){"
                    "requiredElements[i].showErrorMessage = requiredElements[i].validate();"
                    "isNotSubmittable |= requiredElements[i].showErrorMessage;"
                    "if (firstElement === undefined && requiredElements[i].showErrorMessage  && requiredElements[i].visible){"
                    "firstElement = requiredElements[i];"
                    "}}";

                function << "if(isNotSubmittable){"
                    "if(firstElement !== undefined){"
                    "if(firstElement.isButtonGroup !== undefined){"
                        "firstElement.focusFirstButton();"
                    "}else {"
                        "firstElement.forceActiveFocus();"
                    "}}"
                    "}else{";

                for (const auto& element : context->getInputElementList())
                {
                    function << "paramJson[\"" << element.first << "\"] = " << element.second << ";\n";
                }
            }
        }
        else
        {
            for (const auto& element : context->getInputElementList())
            {
                function << "paramJson[\"" << element.first << "\"] = " << element.second << ";\n";
            }
        }

        function << "var paramslist = JSON.stringify(paramJson);\n";
        function << context->getCardRootId() << ".buttonClicked(String.raw`" << Utils::getBackQuoteEscapedString(action->GetTitle()) << "`, \"" << action->GetElementTypeString() << "\", paramslist);\n";
        function << (elementType == "Button" ? "isButtonDisabled = true;}" : "");

        if (context->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() && action->GetAssociatedInputs() == AdaptiveCards::AssociatedInputs::Auto)
        {
            function << "}";
        }

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

    const std::string AdaptiveCardQmlRenderer::getActionToggleVisibilityObject(const std::shared_ptr<AdaptiveCards::ToggleVisibilityAction>& toggleVisibilityAction, const std::shared_ptr<AdaptiveRenderContext>& context)
    {
        std::ostringstream targetElements;
        targetElements << "[";
        for (const auto& targetElement : toggleVisibilityAction->GetTargetElements())
        {
            std::string targetElementId;
            bool isLastELement = (targetElement == *(toggleVisibilityAction->GetTargetElements().rbegin()));

            if (targetElement != nullptr)
            {
                targetElementId = context->ConvertToValidId(targetElement->GetElementId());
                std::ostringstream targetElementValues;
                targetElementValues << "{";
                targetElementValues << "element : " << targetElementId << ", ";

                switch (targetElement->GetIsVisible())
                {
                case AdaptiveCards::IsVisible::IsVisibleTrue:
                    targetElementValues << "value : true";
                    break;
                case AdaptiveCards::IsVisible::IsVisibleFalse:
                    targetElementValues << "value : false";
                    break;
                default:
                    targetElementValues << "value : null";
                }
                targetElementValues << "}";
                targetElements << targetElementValues.str() << (isLastELement ? "" : ", ");
            }
        }

        targetElements << "]";
        return targetElements.str();
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
			uiImage->Property("verticalAlignment", Utils::GetVerticalAlignment(verticalAlignment));
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

	const std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::addColumnSetElements(std::shared_ptr<AdaptiveCards::ColumnSet> columnSet, std::shared_ptr<QmlTag> uiFrame, std::shared_ptr<QmlTag> uiRowLayout, std::shared_ptr<QmlTag> uiRow, std::shared_ptr<AdaptiveRenderContext> context)
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

		if (columnSet->GetPadding())
		{
			tempMargin = 2 * margin;
		}

        int currentHeight = context->getHeightEstimate();
        int estimatedColumnSetHeight = int(columnSet->GetMinHeight());

		for (int i = 0; i < no_of_columns; i++)
		{
			auto cardElement = columns[i];

			auto uiElement = context->Render(cardElement);

			if (uiElement != nullptr)
			{
				if (!uiRow->GetChildren().empty())
				{
					AddSeparator(uiRow, cardElement, context, uiElement->GetId());
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
            estimatedColumnSetHeight = std::max(estimatedColumnSetHeight, context->getHeightEstimate() - currentHeight);
            estimatedColumnSetHeight = std::max(estimatedColumnSetHeight, int(columns[i]->GetMinHeight()));
            context->setHeightEstimate(currentHeight);
		}
        context->setHeightEstimate(currentHeight + estimatedColumnSetHeight);

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
            if (uiElements[i]->GetElement() != "SeparatorRender")
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

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::GetTextBlockMouseArea(std::string id, bool isButton)
	{
		auto MouseAreaTag = std::make_shared<QmlTag>("MouseArea");
		MouseAreaTag->Property("anchors.fill", "parent");
        MouseAreaTag->Property("hoverEnabled", "true");
        MouseAreaTag->Property("preventStealing", "true");
        MouseAreaTag->Property("id", Formatter() << id << "_mouseArea");
        MouseAreaTag->Property("cursorShape", "parent.hoveredLink ? Qt.PointingHandCursor : Qt.IBeamCursor;");
        MouseAreaTag->Property("acceptedButtons", "Qt.RightButton | Qt.LeftButton");

        std::string buttonClickFunction = "";
        if (isButton)
        {
            buttonClickFunction = Formatter() << "if (!parent.linkAt(mouse.x, mouse.y)) { " << id << ".onButtonClicked();}";
        }

        std::string onPressed = Formatter() << "onPressed : {"
            << "mouse.accepted = false;"
            << "const mouseGlobal = mapToGlobal(mouseX, mouseY);"
            << "const posAtMessage = mapToItem(adaptiveCard, mouse.x, mouse.y);"
            << "if (mouse.button === Qt.RightButton){"
            << "openContextMenu(mouseGlobal, " << id << ".selectedText, parent.linkAt(mouse.x, mouse.y));mouse.accepted = true;}"
            << "else if (mouse.button === Qt.LeftButton){"
            << "parent.cursorPosition = parent.positionAt(posAtMessage.x, posAtMessage.y);"
            << "parent.forceActiveFocus();"
            << (isButton ? buttonClickFunction : "") << "}}";

        std::string onPositionChanged = Formatter() << "onPositionChanged : {"
            << "const mouseGlobal = mapToGlobal(mouse.x, mouse.y);"
            << "if (mouse.buttons & Qt.LeftButton)parent.moveCursorSelection(parent.positionAt(mouse.x, mouse.y));"
            << "var link = parent.linkAt(mouse.x, mouse.y);"
            << "adaptiveCard.showToolTipifNeeded(link, mouseGlobal);"
            << "if (link){cursorShape = Qt.PointingHandCursor;}"
            << "else{cursorShape = Qt.IBeamCursor;}"
            << "mouse.accepted = true;}";

        MouseAreaTag->AddFunctions(onPressed);
        MouseAreaTag->AddFunctions(onPositionChanged);

		return MouseAreaTag;
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

    std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::GetClearIconButton(std::shared_ptr<AdaptiveRenderContext> context)
    {
        auto iconConfig = context->GetRenderConfig()->getInputTextConfig();

        auto backgroundTag = std::make_shared<QmlTag>("Rectangle");
        backgroundTag->Property("color", "'transparent'");

        auto clearIcon = GetIconTag(context);

        clearIcon->RemoveProperty("anchors.bottom");
        clearIcon->RemoveProperty("anchors.top");
        clearIcon->RemoveProperty("anchors.left");
        clearIcon->RemoveProperty("focusPolicy");
        clearIcon->Property("anchors.verticalCenter", "parent.verticalCenter");
        clearIcon->Property("anchors.margins", Formatter() << iconConfig.clearIconHorizontalPadding);
        clearIcon->Property("width", Formatter() << iconConfig.clearIconSize);
        clearIcon->Property("horizontalPadding", "0");
        clearIcon->Property("verticalPadding", "0");
        clearIcon->Property("icon.width", Formatter() << iconConfig.clearIconSize);
        clearIcon->Property("icon.height", Formatter() << iconConfig.clearIconSize);
        clearIcon->Property("icon.color", Formatter() << "activeFocus ? " << context->GetHexColor(iconConfig.clearIconColorOnFocus) << " : " << context->GetHexColor(iconConfig.clearIconColorNormal));
        clearIcon->Property("icon.source", RendererQml::cancel_icon_10, true);
        clearIcon->Property("background", backgroundTag->ToString());
        clearIcon->Property("Keys.onReturnPressed", "onClicked()");

        return clearIcon;
    }

    const std::string RendererQml::AdaptiveCardQmlRenderer::GetImagePath(std::shared_ptr<AdaptiveRenderContext> context, const std::string url)
    {
        if (url.rfind("data:image", 0) == 0)
        {
            return url;
        }

        auto contentNumber = context->getContentIndex();
        context->incrementContentIndex();
        const std::string imageName = Formatter() << contentNumber << ".jpg";
        std::string file_path = __FILE__;
        std::string dir_path = file_path.substr(0, file_path.rfind("\\Library"));
        dir_path.append("\\Samples\\QmlVisualizer\\Images\\" + imageName);
        std::replace(dir_path.begin(), dir_path.end(), '\\', '/');
        dir_path = std::string("file:/") + dir_path;
        return dir_path;
    }

    std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::AddCornerRectangles(std::shared_ptr<QmlTag> uiCard, int rectangleSize)
    {
        auto leftRectangle = std::make_shared<QmlTag>("Rectangle");
        auto rightRectangle = std::make_shared<QmlTag>("Rectangle");

        leftRectangle->Property("color", Formatter() << uiCard->GetId() << ".color");
        leftRectangle->Property("width", Formatter() << rectangleSize);
        leftRectangle->Property("height", Formatter() << rectangleSize);
        leftRectangle->Property("x", Formatter() << uiCard->GetId() << ".x + 1");
        leftRectangle->Property("y", Formatter() << uiCard->GetId() << ".y + 1");

        rightRectangle->Property("color", Formatter() << uiCard->GetId() << ".color");
        rightRectangle->Property("width", Formatter() << rectangleSize);
        rightRectangle->Property("height", Formatter() << rectangleSize);
        rightRectangle->Property("x", Formatter() << uiCard->GetId() << ".width - 1 - " << rectangleSize);
        rightRectangle->Property("y", Formatter() << uiCard->GetId() << ".y + 1");

        uiCard->AddChild(leftRectangle);
        uiCard->AddChild(rightRectangle);

        return uiCard;
    }

    std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::GetStretchRectangle(std::shared_ptr<QmlTag> element)
    {
        auto stretchRectangle = std::make_shared<QmlTag>("Rectangle");
        stretchRectangle->Property("height", "parent.height");
        stretchRectangle->Property("width", "parent.width");
        stretchRectangle->Property("color", "transparent", true);
        stretchRectangle->AddChild(element);

        return stretchRectangle;
    }

    std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::GetOpacityMask(std::string parentId)
    {
        auto opacityMask = std::make_shared<QmlTag>("OpacityMask");

        auto rectangle = std::make_shared<QmlTag>("Rectangle");
        rectangle->Property("x", Formatter() << parentId << ".x");
        rectangle->Property("y", Formatter() << parentId << ".y");
        rectangle->Property("width", Formatter() << parentId << ".width");
        rectangle->Property("height", Formatter() << parentId << ".height");
        rectangle->Property("radius", Formatter() << parentId << ".radius");

        opacityMask->Property("maskSource", rectangle->ToString());
        opacityMask->Property("readonly property bool isOpacityMask", "true");
        return opacityMask;
    }

    std::string RendererQml::AdaptiveCardQmlRenderer::ParseMarkdownString(std::string text, std::shared_ptr<AdaptiveRenderContext> context)
    {
        std::string parsedText = RendererQml::TextUtils::ApplyTextFunctions(text, context->GetLang());

        auto markdownParser = std::make_shared<AdaptiveSharedNamespace::MarkDownParser>(parsedText);
        parsedText = markdownParser->TransformToHtml();
        parsedText = RendererQml::Utils::HandleEscapeSequences(parsedText);

        const std::string linkColor = context->GetColor(AdaptiveCards::ForegroundColor::Accent, false, false);
        const std::string textDecoration = "none";
        parsedText = RendererQml::Utils::FormatHtmlUrl(parsedText, linkColor, textDecoration);
        return parsedText;
    }
}
