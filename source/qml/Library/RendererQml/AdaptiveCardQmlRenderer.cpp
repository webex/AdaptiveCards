#include "AdaptiveCardQmlRenderer.h"
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

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::AdaptiveCardRender(std::shared_ptr<AdaptiveCards::AdaptiveCard> card, std::shared_ptr<AdaptiveRenderContext> context)
    {
        context->setDefaultIdName("defaultId");
        int margin = context->GetConfig()->GetSpacing().paddingSpacing;

        auto uiCard = std::make_shared<QmlTag>("Rectangle");
        uiCard->AddImports("import QtQuick 2.15");
        uiCard->AddImports("import QtQuick.Layouts 1.3");
        uiCard->AddImports("import QtQuick.Controls 2.15");
        uiCard->AddImports("import QtGraphicalEffects 1.15");

        //Custom QMl Module
        uiCard->AddImports("import CardQmlElements 1.0" );
        //Refers to the javascript file added to the qmldir
        auto javaScriptQualifier = "HeightWidthFunctions";
        context->setJavaScriptQualifier(javaScriptQualifier);

        uiCard->Property("id", "adaptiveCard");
        context->setCardRootId(uiCard->GetId());
        context->setCardRootElement(uiCard);
        uiCard->Property("readonly property int margins", std::to_string(margin));
        uiCard->AddFunctions("signal buttonClicked(var title, var type, var data)");
        uiCard->Property("implicitHeight", "adaptiveCardLayout.implicitHeight");
        uiCard->Property("Layout.fillWidth", "true");
        uiCard->Property("readonly property string bgColor", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));
        uiCard->Property("color", "bgColor");

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
        rectangle->Property("Layout.bottomMargin", "margins");
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

        AddContainerElements(bodyLayout, card->GetBody(), context);
        AddActions(bodyLayout, card->GetActions(), context);
        addSelectAction(uiCard, uiCard->GetId(), card->GetSelectAction(), context, hasBackgroundImage);

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

        bodyLayout->Property("onImplicitHeightChanged", Formatter() << "{" << context->getJavaScriptQualifier() << ".generateStretchHeight(children," << int(card->GetMinHeight()) - tempMargin << ")}");

        bodyLayout->Property("onImplicitWidthChanged", Formatter() << "{" << context->getJavaScriptQualifier() << ".generateStretchHeight(children," << int(card->GetMinHeight()) - tempMargin << ")}");

        if (card->GetMinHeight() > 0)
        {
            rectangle->Property("Layout.minimumHeight", std::to_string(card->GetMinHeight() - tempMargin));
        }

        //Add submit onclick event
        addSubmitActionButtonClickFunc(context);
        addShowCardLoaderComponents(context);
        addTextRunSelectActions(context);

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

    void AdaptiveCardQmlRenderer::AddActions(std::shared_ptr<QmlTag> uiContainer, const std::vector<std::shared_ptr<AdaptiveCards::BaseActionElement>>& actions, std::shared_ptr<AdaptiveRenderContext> context)
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
                        uiLoader->Property("x", "-margins");
                        uiLoader->Property("sourceComponent", componentId);
                        uiLoader->Property("visible", "false");
                        uiLoader->Property("width", Formatter() << context->getCardRootId() << ".width");
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

        auto uiTextBlock = std::make_shared<QmlTag>("TextBlock");
        std::string textType = textBlock->GetElementTypeString();
        std::string horizontalAlignment = AdaptiveCards::EnumHelpers::getHorizontalAlignmentEnum().toString(textBlock->GetHorizontalAlignment());

        uiTextBlock->Property("width", "parent.width");

        std::string text = TextUtils::ApplyTextFunctions(textBlock->GetText(), context->GetLang());
        text = Utils::HandleEscapeSequences(text);
        uiTextBlock->Property("text", text, true);

        uiTextBlock->Property("horizontalAlignment", Utils::GetHorizontalAlignment(horizontalAlignment));

        std::string color = context->GetColor(textBlock->GetTextColor(), textBlock->GetIsSubtle(), false);

        uiTextBlock->Property("color", color);

        uiTextBlock->Property("font.pixelSize", std::to_string(fontSize));

        uiTextBlock->Property("font.weight", Utils::GetWeight(textBlock->GetTextWeight()));

        if (!textBlock->GetId().empty())
        {
            const std::string origionalElementId = textBlock->GetId();
            std::string qml_id = Utils::ConvertToLowerIdValue(origionalElementId);
            if (Utils::hasNonAlphaNumeric(qml_id))
            {
                qml_id = Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter());   
            }
            textBlock->SetId(qml_id);
            uiTextBlock->Property("id", qml_id);
            context->AddToJsonQmlIdList(origionalElementId, qml_id);
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
    
        return uiTextBlock;

    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::TextInputRender(std::shared_ptr<AdaptiveCards::TextInput> input, std::shared_ptr<AdaptiveRenderContext> context)
    {
        const std::string origionalElementId = input->GetId();

        std::shared_ptr<QmlTag> uiTextInput;

        std::string qml_id = Utils::ConvertToLowerIdValue(input->GetId());
        if (Utils::hasNonAlphaNumeric(qml_id))
        {
            qml_id = Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter());   
        }
        input->SetId(qml_id);
        context->AddToJsonQmlIdList(origionalElementId, qml_id);

        if (input->GetIsMultiline())
        {
            uiTextInput = std::make_shared<QmlTag>("TextInputMulti");
            uiTextInput->Property("height", Formatter() << input->GetId() << ".visible ? 100 : 0");
            //uiTextInput->Property("textfont.pixelSize", std::to_string(context->GetConfig()->GetFontSize(AdaptiveSharedNamespace::FontType::Default, AdaptiveSharedNamespace::TextSize::Default)));
            
            if (input->GetMaxLength() > 0)
            {
                uiTextInput->Property("maxLength", std::to_string(input->GetMaxLength()));
            }
        }
        else
        {
            uiTextInput = std::make_shared<QmlTag>("TextInputSingle");

            if (input->GetMaxLength() > 0)
            {
                uiTextInput->Property("maximumLength", std::to_string(input->GetMaxLength()));
            }
        }

        uiTextInput->Property("id", qml_id);
        uiTextInput->Property("width", "parent.width");
        uiTextInput->Property("font.pixelSize", std::to_string(context->GetConfig()->GetFontSize(AdaptiveSharedNamespace::FontType::Default, AdaptiveSharedNamespace::TextSize::Default)));
        uiTextInput->Property("color", context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false));
        uiTextInput->Property("bgrcolor", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));

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
                //TODO: Remove Hardcoded color
                buttonElement->Property("textcolor", "black", true);
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
                    uiTextInput->Property("width", Formatter() << "parent.width - " << buttonElement->GetId() << ".width - " << uiContainer->GetId() << ".spacing");
                    uiContainer->AddChild(uiTextInput);
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

        return uiTextInput;
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::NumberInputRender(std::shared_ptr<AdaptiveCards::NumberInput> input, std::shared_ptr<AdaptiveRenderContext> context)
    {
        const std::string origionalElementId = input->GetId();

        std::string qml_id = Utils::ConvertToLowerIdValue(input->GetId());
        if (Utils::hasNonAlphaNumeric(qml_id))
        {
            qml_id = Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter());
        }
        input->SetId(qml_id);
        context->AddToJsonQmlIdList(origionalElementId, qml_id);
        
        auto uiNumberInput = std::make_shared<QmlTag>("NumberInput");
        uiNumberInput->Property("id", qml_id);
        uiNumberInput->Property("width", "parent.width");
        uiNumberInput->Property("bgrcolor", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));
        uiNumberInput->Property("textfont.pixelSize", std::to_string(context->GetConfig()->GetFontSize(AdaptiveSharedNamespace::FontType::Default, AdaptiveSharedNamespace::TextSize::Default)));
        uiNumberInput->Property("textcolor", context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false));

        if (!input->GetPlaceholder().empty())
        {
            uiNumberInput->Property("placeholderText", input->GetPlaceholder(), true);
        }
        
        if (input->GetValue() != std::nullopt)
        {
            uiNumberInput->Property("hasDefaultValue", "true");
            uiNumberInput->Property("defaultValue", Formatter() << input->GetValue());
        }
        else if(input->GetMin() == std::nullopt)
        {
            input->SetValue(0);
            uiNumberInput->Property("hasDefaultValue", "true");
            uiNumberInput->Property("defaultValue", std::to_string(0));
        }
        else
        {
            uiNumberInput->Property("hasDefaultValue", "false");
        }

        if (input->GetMin() == std::nullopt)
        {
            input->SetMin(INT_MIN);
        }
        if (input->GetMax() == std::nullopt)
        {
            input->SetMax(INT_MAX);
        }

        //Logic from Html renderer
        if ((input->GetMin() == input->GetMax() && input->GetMin() == 0) || input->GetMin() > input->GetMax())
        {
            input->SetMin(INT_MIN);
            input->SetMax(INT_MAX);
        }
        if (input->GetValue() < input->GetMin())
        {
            input->SetValue(input->GetMin());
            uiNumberInput->Property("defaultValue", Formatter() << input->GetMin());
        }
        if (input->GetValue() > input->GetMax())
        {
            input->SetValue(input->GetMax());
            uiNumberInput->Property("defaultValue", Formatter() << input->GetMax());
        }

        uiNumberInput->Property("from", Formatter() << input->GetMin());
        uiNumberInput->Property("to", Formatter() << input->GetMax());
        uiNumberInput->Property("value", Formatter() << input->GetValue());

        //TODO: Add stretch property

        if (!input->GetIsVisible())
        {
            uiNumberInput->Property("visible", "false");
        }
        
        context->addToInputElementList(origionalElementId, (qml_id + ".value"));

        return uiNumberInput;
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::RichTextBlockRender(std::shared_ptr<AdaptiveCards::RichTextBlock> richTextBlock, std::shared_ptr<AdaptiveRenderContext> context)
    {
        auto uiTextBlock = std::make_shared<QmlTag>("Text");
        std::string textType = richTextBlock->GetElementTypeString();
        std::string horizontalAlignment = AdaptiveCards::EnumHelpers::getHorizontalAlignmentEnum().toString(richTextBlock->GetHorizontalAlignment());

        if (!richTextBlock->GetId().empty())
        {
            const std::string origionalElementId = richTextBlock->GetId();
            std::string qml_id = Utils::ConvertToLowerIdValue(origionalElementId);
            if (Utils::hasNonAlphaNumeric(qml_id))
            {
                qml_id = Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter());
            }
            richTextBlock->SetId(qml_id);
            uiTextBlock->Property("id", qml_id);
            context->AddToJsonQmlIdList(origionalElementId, qml_id);
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
            uiTextRun.append("<a href='" + selectaction + "'>");
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

        std::string qml_id = Utils::ConvertToLowerIdValue(origionalElementId);
        if (Utils::hasNonAlphaNumeric(qml_id))
        {
            qml_id = Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter());
        }
        input->SetId(qml_id);
        context->AddToJsonQmlIdList(origionalElementId, qml_id);

        const auto valueOn = !input->GetValueOn().empty() ? input->GetValueOn() : "true";
        const auto valueOff = !input->GetValueOff().empty() ? input->GetValueOff() : "false";
        const bool isChecked = input->GetValue().compare(valueOn) == 0 ? true : false;

        //TODO: Add Height
        const auto checkbox = GetCheckBox(RendererQml::Checkbox(qml_id,
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

        std::string qml_id = Utils::ConvertToLowerIdValue(input->GetId());
        if (Utils::hasNonAlphaNumeric(qml_id))
        {
            qml_id = Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter());   
        }
        input->SetId(qml_id);
        context->AddToJsonQmlIdList(origionalElementId, qml_id);

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
            choices.emplace_back(RendererQml::Checkbox(GenerateChoiceSetButtonId(qml_id, type, ButtonNumber++),
                type,
                choice->GetTitle(),
                choice->GetValue(),
                isWrap,
                isVisible,
                isChecked));
        }

        RendererQml::ChoiceSet choiceSet(qml_id,
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
        const auto textColor = context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false);
        const auto backgroundColor = context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor);

        auto uiDropDown = std::make_shared<QmlTag>("DropDownMenu");
        uiDropDown->Property("id", choiceset.id);
        uiDropDown->Property("width", "parent.width");
        uiDropDown->Property("textcolor", textColor);
        uiDropDown->Property("model", GetModel(choiceset.choices));
        uiDropDown->Property("bgrcolor", backgroundColor);

        const int fontSize = context->GetConfig()->GetFontSize(AdaptiveCards::FontType::Default, AdaptiveCards::TextSize::Default);

        uiDropDown->Property("font.family", context->GetConfig()->GetFontFamily(AdaptiveCards::FontType::Default), true);
        uiDropDown->Property("font.pixelSize", std::to_string(fontSize));

        if (!choiceset.placeholder.empty())
        {
            uiDropDown->Property("currentIndex", "-1");
            uiDropDown->Property("displayText", "currentIndex === -1 ? '" + choiceset.placeholder + "' : currentText");
        }
        else if (choiceset.values.size() == 1)
        {
            const std::string target = choiceset.values[0];
            auto index = std::find_if(choiceset.choices.begin(), choiceset.choices.end(), [target](const Checkbox& options) {
                return options.value == target;
            }) - choiceset.choices.begin();
            uiDropDown->Property("currentIndex", std::to_string(index));
        }

        return uiDropDown;
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
        std::shared_ptr<RendererQml::QmlTag> uiElement;
        //ButtonRadio Element
        if (checkbox.type == CheckBoxType::RadioButton)
        {
            uiElement = std::make_shared<QmlTag>("ButtonRadio");
            uiElement->Property("value", Formatter() << "checked ? \"" << checkbox.value << "\" : \"\"");
            //Takes the width of the column having all the elements
            uiElement->Property("Layout.maximumWidth", "parent.parent.parent.width");
        }
        //ButtonCheckBox Element
        else
        {
            uiElement = std::make_shared<QmlTag>("ButtonCheckBox");
            if (checkbox.type == CheckBoxType::Toggle)
            {
                uiElement->Property("valueOn", checkbox.valueOn, true);
                uiElement->Property("valueOff", checkbox.valueOff, true);
                uiElement->Property("value", "checked ? valueOn : valueOff");
                uiElement->Property("width", "parent.width");
            }
            else
            {
                uiElement->Property("value", Formatter() << "checked ? \"" << checkbox.value << "\" : \"\"");
                uiElement->Property("Layout.maximumWidth", "parent.parent.parent.width");
            }
        }

        uiElement->Property("id", checkbox.id);
        uiElement->Property("text", checkbox.text, true);
        uiElement->Property("font.pixelSize", std::to_string(context->GetConfig()->GetFontSize(AdaptiveCards::FontType::Default, AdaptiveCards::TextSize::Default)));

        if (!checkbox.isVisible)
        {
            uiElement->Property("visible", "false");
        }

        if (checkbox.isChecked)
        {
            uiElement->Property("checked", "true");
        }

        uiElement->Property("textcolor", context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false));

        if (checkbox.isWrap)
        {
            uiElement->Property("wrapMode", "Text.Wrap");
        }

        return uiElement;
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::DateInputRender(std::shared_ptr<AdaptiveCards::DateInput> input, std::shared_ptr<AdaptiveRenderContext> context)
    {
        //TODO: ids which are qml keywords would result in undefined behaviour
        const std::string origionalElementId = input->GetId();
        std::string qml_id = Utils::ConvertToLowerIdValue(input->GetId());
        if (Utils::hasNonAlphaNumeric(qml_id))
        {
            qml_id = Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter());
        }
        input->SetId(qml_id);
        context->AddToJsonQmlIdList(origionalElementId, qml_id);

        auto uiDateInput = std::make_shared<QmlTag>("DateInput");
        uiDateInput->Property("id", qml_id);
        uiDateInput->Property("width", "parent.width");
        const int fontSize = context->GetConfig()->GetFontSize(AdaptiveCards::FontType::Default, AdaptiveCards::TextSize::Default);

        uiDateInput->Property("font.family", context->GetConfig()->GetFontFamily(AdaptiveCards::FontType::Default), true);
        uiDateInput->Property("font.pixelSize", std::to_string(fontSize));
        uiDateInput->Property("color", context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false));

        //TODO: Handle case when inputted date is not in yyyy-mm-dd
        uiDateInput->Property("selectedDate", input->GetValue(), true);
        
        //TODO: Add stretch property

        if (!input->GetIsVisible())
        {
            uiDateInput->Property("visible", "false");
        }

        uiDateInput->Property("bgrcolor", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));

        if (!input->GetMin().empty() && Utils::isValidDate(input->GetMin()))
        {
            uiDateInput->Property("minDate", Utils::GetDate(input->GetMin()));
        }

        if (!input->GetMax().empty() && Utils::isValidDate(input->GetMax()))
        {
            uiDateInput->Property("maxDate", Utils::GetDate(input->GetMax()));
        }

        if (!input->GetValue().empty() && Utils::isValidDate(input->GetValue()))
        {
            uiDateInput->Property("defaultDate", Utils::GetDate(input->GetValue()));
        }

        auto EnumDateFormat = Utils::GetSystemDateFormat();
        std::string StringDateFormat;
        std::string PlaceHolderTextFormat;
        switch (EnumDateFormat)
        {
            case RendererQml::DateFormat::ddmmyy:
            {
                StringDateFormat = "ddmmyy";
                PlaceHolderTextFormat = "dd/mmm/yyyy";
                break;
            }
            case RendererQml::DateFormat::yymmdd:
            {
                StringDateFormat = "yymmdd";
                PlaceHolderTextFormat = "yyyy/mmm/dd";
                break;
            }
            case RendererQml::DateFormat::yyddmm:
            {
                StringDateFormat = "yyddmm";
                PlaceHolderTextFormat = "yyyy/dd/mmm";
                break;
            }
            //default case: mmm/dd/yyyy
            default:
            {
                StringDateFormat = "mmddyy";
                PlaceHolderTextFormat = "mmm/dd/yyyy";
                break;
            }
        }

        uiDateInput->Property("dateFormat", StringDateFormat, true);
        uiDateInput->Property("placeholderText", Formatter() << (!input->GetPlaceholder().empty() ? input->GetPlaceholder() : "Select date") << " in " << PlaceHolderTextFormat, true);

        context->addToInputElementList(origionalElementId, (uiDateInput->GetId() + ".selectedDate"));

        return uiDateInput;
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::FactSetRender(std::shared_ptr<AdaptiveCards::FactSet> factSet, std::shared_ptr<AdaptiveRenderContext> context)
    {
        auto uiFactSet = std::make_shared<QmlTag>("GridLayout");

        if (!factSet->GetId().empty())
        {
            const std::string origionalElementId = factSet->GetId();
            std::string qml_id = Utils::ConvertToLowerIdValue(origionalElementId);
            if (Utils::hasNonAlphaNumeric(qml_id))
            {
                qml_id = Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter());
            }
            factSet->SetId(qml_id);
            uiFactSet->Property("id", qml_id);
            context->AddToJsonQmlIdList(origionalElementId, qml_id);
        }

        uiFactSet->Property("columns", "2");
        uiFactSet->Property("rows", std::to_string(factSet->GetFacts().size()));
        uiFactSet->Property("property int titleWidth", "0");
        uiFactSet->Property("property int minWidth", Formatter() << context->getJavaScriptQualifier() << ".getMinWidthFactSet(children, columnSpacing)");
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
            const std::string origionalElementId = image->GetId();
            std::string qml_id = Utils::ConvertToLowerIdValue(origionalElementId);
            if (Utils::hasNonAlphaNumeric(qml_id))
            {
                qml_id = Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter());
            }
            image->SetId(qml_id);
            context->AddToJsonQmlIdList(origionalElementId, image->GetId());
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
            maskTag = std::make_shared<QmlTag>("OpacityMask");
            maskSourceTag = std::make_shared<QmlTag>("Rectangle");
            maskSourceTag->Property("width", image->GetId() + ".width");
            maskSourceTag->Property("height", image->GetId() + ".height");
            maskSourceTag->Property("radius", image->GetId() + ".radius");
            maskTag->Property("maskSource", maskSourceTag->ToString());
            uiImage->Property("layer.enabled", "true");
            uiImage->Property("layer.effect", maskTag->ToString());
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

        std::string qml_id = Utils::ConvertToLowerIdValue(input->GetId());
        if (Utils::hasNonAlphaNumeric(qml_id))
        {
            qml_id = Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter());
        }
        input->SetId(qml_id);
        context->AddToJsonQmlIdList(origionalElementId, input->GetId());

        std::shared_ptr<RendererQml::QmlTag> uiTimeInput;
        if (is12hour)
        {
            uiTimeInput = std::make_shared<QmlTag>("TimeInput_12hour");
        }
        else
        {
            uiTimeInput = std::make_shared<QmlTag>("TimeInput_24hour");
        }
        const std::string id = input->GetId();
        const std::string value = input->GetValue();

        uiTimeInput->Property("id", id);
        uiTimeInput->Property("placeholderText", !input->GetPlaceholder().empty() ? input->GetPlaceholder() : "Select time", true);
        uiTimeInput->Property("color", context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false));
        uiTimeInput->Property("width", "parent.width");

        const int fontSize = context->GetConfig()->GetFontSize(AdaptiveCards::FontType::Default, AdaptiveCards::TextSize::Default);

        uiTimeInput->Property("font.family", context->GetConfig()->GetFontFamily(AdaptiveCards::FontType::Default), true);
        uiTimeInput->Property("font.pixelSize", std::to_string(fontSize));

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
            uiTimeInput->Property("selectedTime", defaultSelectedTime, true);
        }

        if (!input->GetIsVisible())
        {
            uiTimeInput->Property("visible", "false");
        }

        uiTimeInput->Property("bgrcolor", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));

        context->addToInputElementList(origionalElementId, (uiTimeInput->GetId() + ".selectedTime"));

        return uiTimeInput;
    }

    std::shared_ptr<QmlTag> RendererQml::AdaptiveCardQmlRenderer::ImageSetRender(std::shared_ptr<AdaptiveCards::ImageSet> imageSet, std::shared_ptr<AdaptiveRenderContext> context)
    {
        auto uiFlow = std::make_shared<QmlTag>("Flow");

        uiFlow->Property("width", "parent.width");
        uiFlow->Property("spacing", "10");

        if (!imageSet->GetId().empty())
        {
            std::string origionalElementId = imageSet->GetId();
            std::string qml_id = Utils::ConvertToLowerIdValue(origionalElementId);
            if (Utils::hasNonAlphaNumeric(qml_id))
            {
                imageSet->SetId(Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter()));
            }
            else
            {
                imageSet->SetId(Utils::ConvertToLowerIdValue(imageSet->GetId()));
            }
            uiFlow->Property("id", imageSet->GetId());
            context->AddToJsonQmlIdList(origionalElementId, imageSet->GetId());
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
            std::string origionalElementId = columnSet->GetId();
            std::string qml_id = Utils::ConvertToLowerIdValue(origionalElementId);
            if (Utils::hasNonAlphaNumeric(qml_id))
            {
                columnSet->SetId(Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter()));
            }
            else
            {
                columnSet->SetId(Utils::ConvertToLowerIdValue(columnSet->GetId()));
            }
            context->AddToJsonQmlIdList(origionalElementId, columnSet->GetId());
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

        uiFrame->Property("onWidthChanged", Formatter() << "{" << context->getJavaScriptQualifier() << ".generateStretchWidth( row_" << id << ".children, parent.width - (" << marginReleased << "))}");

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
            std::string origionalElementId = column->GetId();
            std::string qml_id = Utils::ConvertToLowerIdValue(origionalElementId);
            if (Utils::hasNonAlphaNumeric(qml_id))
            {
                column->SetId(Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter()));
            }
            else
            {
                column->SetId(Utils::ConvertToLowerIdValue(column->GetId()));
            }
            context->AddToJsonQmlIdList(origionalElementId, column->GetId());
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
            std::string origionalElementId = container->GetId();
            std::string qml_id = Utils::ConvertToLowerIdValue(origionalElementId);
            if (Utils::hasNonAlphaNumeric(qml_id))
            {
                container->SetId(Formatter() << context->getDefaultIdName() << "_" << std::to_string(context->getDefaultIdCounter()));
            }
            else
            {
                container->SetId(Utils::ConvertToLowerIdValue(container->GetId()));
            }
            container->SetId(Utils::ConvertToLowerIdValue(container->GetId()));
            context->AddToJsonQmlIdList(origionalElementId, container->GetId());
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
            uiContainer->Property("onMinHeightChanged", Formatter() << "{" << context->getJavaScriptQualifier() << ".generateStretchHeight( column_" << id << ".children," << stretchHeight << " )}");
        }
        else if (cardElement->GetElementTypeString() == "Column")
        {
            stretchHeight = Formatter() << "stretchMinHeight - " << tempMargin;
            uiContainer->Property("onStretchMinHeightChanged", Formatter() << "{" << context->getJavaScriptQualifier() << ".generateStretchHeight( column_" << id << ".children," << stretchHeight << " )}");
        }

        uiColumn->Property("onImplicitHeightChanged", Formatter() << "{" << context->getJavaScriptQualifier() << ".generateStretchHeight(children, " << id << "." << stretchHeight << " )}");

        uiColumn->Property("onImplicitWidthChanged", Formatter() << "{" << context->getJavaScriptQualifier() << ".generateStretchHeight(children, " << id << "." << stretchHeight << " )}");

        uiContainer->Property("property int minWidth", Formatter() << "{" << context->getJavaScriptQualifier() << ".getMinWidth( column_" << cardElement->GetId() << ".children) + " << 2 * tempWidth << "}");

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
        outerContainer->Property("width", "parent.width");

        if (!actionSet->GetIsVisible())
        {
            outerContainer->Property("visible", "false");
        }

        outerContainer->Property("property int minWidth", Formatter() << "{" << context->getJavaScriptQualifier() << ".getMinWidthActionSet( children[1].children," << context->GetConfig()->GetActions().buttonSpacing << ")}");

        auto actionsConfig = context->GetConfig()->GetActions();
        const auto oldActionAlignment = context->GetConfig()->GetActions().actionAlignment;

        actionsConfig.actionAlignment = (AdaptiveCards::ActionAlignment) actionSet->GetHorizontalAlignment();
        context->GetConfig()->SetActions(actionsConfig);

        AddActions(outerContainer, actionSet->GetActions(), context);

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
            
            auto buttonElement = std::make_shared<QmlTag>( isIconLeftOfTitle? "ActionButtonRow" : "ActionButtonColumn");

            buttonElement->Property("id", buttonId);

            if (isShowCardButton)
            {
                buttonElement->Property("isShowCard", "true");
                buttonElement->Property("showCard", "false");
            }

            //Add button icon
            if (!action->GetIconUrl().empty())
            {
                buttonElement->Property("hasIconUrl", "true");
                buttonElement->Property("imgSource", action->GetIconUrl(), true);
            }

            //Add content Text
            if (!action->GetTitle().empty())
            {
                buttonElement->Property("text", action->GetTitle(), true);
            }
            buttonElement->Property("textfont.pixelSize", Formatter() << fontSize);

            //TODO: Add border color and style: default/positive/destructive
            std::string overlayTagColor = context->GetColor(AdaptiveCards::ForegroundColor::Default, false, false);
            if (!Utils::IsNullOrWhitespace(action->GetStyle()) && !Utils::CaseInsensitiveCompare(action->GetStyle(), "default"))
            {
                if (Utils::CaseInsensitiveCompare(action->GetStyle(), "positive"))
                {
                    if (isShowCardButton)
                    {
                        buttonElement->Property("bgrborder.color", Formatter() << buttonId << ".showCard ? '#196323' : "<< buttonId << ".pressed ? '#196323' : '#1B8728'");
                        buttonElement->Property("bgrcolor", Formatter() << buttonId << ".showCard ? '#196323' : " << buttonId << ".pressed ? '#196323' : " << buttonId << ".hovered ? '#1B8728' : 'white'");
                        buttonElement->Property("textcolor", Formatter() << buttonId << ".showCard ? '#FFFFFF' : " << buttonId << ".hovered ? '#FFFFFF' : '#1B8728'");
                    }
                    else
                    {
                        buttonElement->Property("bgrborder.color", Formatter() << buttonId << ".pressed ? '#196323' : '#1B8728'");
                        buttonElement->Property("bgrcolor", Formatter() << buttonId << ".pressed ? '#196323' : " << buttonId << ".hovered ? '#1B8728' : 'white'");
                        buttonElement->Property("textcolor", Formatter() << buttonId << ".hovered ? '#FFFFFF' : '#1B8728'");
                    }
                }
                else if (Utils::CaseInsensitiveCompare(action->GetStyle(), "destructive"))
                {
                    if(isShowCardButton)
                    {
                        buttonElement->Property("bgrborder.color", Formatter() << buttonId << ".showCard ? '#A12C23' : " << buttonId << ".pressed ? '#A12C23' : '#D93829'");
                        buttonElement->Property("bgrcolor", Formatter() << buttonId << ".showCard ? '#A12C23' : " << buttonId << ".pressed ? '#A12C23' : " << buttonId << ".hovered ? '#D93829' : 'white'");
                        buttonElement->Property("textcolor", Formatter() << buttonId << ".showCard ? '#FFFFFF' : " << buttonId << ".hovered ? '#FFFFFF' : '#D93829'");
                    }
                    else
                    {
                        buttonElement->Property("bgrborder.color", Formatter() << buttonId << ".pressed ? '#A12C23' : '#D93829'");
                        buttonElement->Property("bgrcolor", Formatter() << buttonId << ".pressed ? '#A12C23' : " << buttonId << ".hovered ? '#D93829' : 'white'");
                        buttonElement->Property("textcolor", Formatter() << buttonId << ".hovered ? '#FFFFFF' : '#D93829'");
                    }
                }
                else
                {
                    if (isShowCardButton)
                    {
                        buttonElement->Property("bgrborder.color", Formatter() << buttonId << ".showCard ? '#0A5E7D' : " << buttonId << ".pressed ? '#0A5E7D' : '#007EA8'");
                        buttonElement->Property("bgrcolor", Formatter() << buttonId << ".showCard ? '#0A5E7D' : " << buttonId << ".pressed ? '#0A5E7D' : " << buttonId << ".hovered ? '#007EA8' : 'white'");
                        buttonElement->Property("textcolor", Formatter() << buttonId << ".showCard ? '#FFFFFF' : " << buttonId << ".hovered ? '#FFFFFF' : '#007EA8'");
                    }
                    else
                    {
                        buttonElement->Property("bgrborder.color", Formatter() << buttonId << ".pressed ? '#0A5E7D' : '#007EA8'");
                        buttonElement->Property("bgrcolor", Formatter() << buttonId << ".pressed ? '#0A5E7D' : " << buttonId << ".hovered ? '#007EA8' : 'white'");
                        buttonElement->Property("textcolor", Formatter() << buttonId << ".hovered ? '#FFFFFF' : '#007EA8'");
                    }
                }
            }
            else
            {
                if (isShowCardButton)
                {
                    buttonElement->Property("bgrborder.color", Formatter() << buttonId << ".showCard ? '#0A5E7D' : " << buttonId << ".pressed ? '#0A5E7D' : '#007EA8'");
                    buttonElement->Property("bgrcolor", Formatter() << buttonId << ".showCard ? '#0A5E7D' : " << buttonId << ".pressed ? '#0A5E7D' : " << buttonId << ".hovered ? '#007EA8' : 'white'");
                    buttonElement->Property("textcolor", Formatter() << buttonId << ".showCard ? '#FFFFFF' : " << buttonId << ".hovered ? '#FFFFFF' : '#007EA8'");
                }
                else
                {
                    buttonElement->Property("bgrborder.color", Formatter() << buttonId << ".pressed ? '#0A5E7D' : '#007EA8'");
                    buttonElement->Property("bgrcolor", Formatter() << buttonId << ".pressed ? '#0A5E7D' : " << buttonId << ".hovered ? '#007EA8' : 'white'");
                    buttonElement->Property("textcolor", Formatter() << buttonId << ".hovered ? '#FFFFFF' : '#007EA8'");
                }
            }

            std::string onClickedFunction;
            if (action->GetElementTypeString() == "Action.OpenUrl")
            {
                onClickedFunction = getActionOpenUrlClickFunc(std::dynamic_pointer_cast<AdaptiveCards::OpenUrlAction>(action), context);
            }
            else if (action->GetElementTypeString() == "Action.ShowCard")
            {
                context->addToShowCardButtonList(buttonElement, std::dynamic_pointer_cast<AdaptiveCards::ShowCardAction>(action));
            }
            else if (action->GetElementTypeString() == "Action.ToggleVisibility")
            {
                onClickedFunction = getActionToggleVisibilityClickFunc(std::dynamic_pointer_cast<AdaptiveCards::ToggleVisibilityAction>(action), context);
            }
            else if (action->GetElementTypeString() == "Action.Submit")
            {
                context->addToSubmitActionButtonList(buttonElement, std::dynamic_pointer_cast<AdaptiveCards::SubmitAction>(action));
            }
            else
            {
                onClickedFunction = "";
            }

            buttonElement->Property("onClicked", Formatter() << "{\n" << onClickedFunction << "}\n");
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
            buttonElement->Property("onClicked", Formatter() << "{\n" << onClickedFunction << "}\n");
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
            buttonElement->Property("onClicked", Formatter() << "{\n" << onClickedFunction << "}\n");
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

            auto uiCard = subContext->Render(componentElement.second->GetCard(), &AdaptiveCardRender);
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
                function << button->GetId() << ".clicked()\n}\n";
            }
        }

        function << "\n" << buttonElement->GetId() << "_loader.visible = " << buttonElement->GetId() << ".showCard";
        
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
                targetElementId = context->GetQmlId(targetElement->GetElementId());
                
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
}

