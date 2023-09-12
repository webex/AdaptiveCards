// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
#include "pch.h"
#include "WebexData.h"
#include "ParseContext.h"
#include "ParseUtil.h"

using namespace AdaptiveCards;

WebexData::WebexData()
{
}

std::string WebexData::Serialize() const
{
    return ParseUtil::JsonToString(SerializeToJsonValue());
}

Json::Value WebexData::SerializeToJsonValue() const
{
    Json::Value root;
    root[AdaptiveCardSchemaKeyToString(AdaptiveCardSchemaKey::CardWidth)] = CardWidthToString(GetCardWidth());
    return root;
}

// Indicates non-default values have been set. If false, serialization can be safely skipped.
bool WebexData::ShouldSerialize() const
{
    return (m_cardWidth != CardWidth::Auto);
}

std::shared_ptr<WebexData> WebexData::Deserialize(ParseContext& context, const Json::Value& json)
{
    auto webexData = std::make_shared<WebexData>();
    if (json.isNull())
    {
        return webexData;
    }
    CardWidth cardWidth = ParseUtil::GetEnumValue<CardWidth>(json, AdaptiveCardSchemaKey::CardWidth, CardWidth::Auto, CardWidthFromString);
    webexData->SetCardWidth(cardWidth);

    return webexData;
}

std::shared_ptr<WebexData> WebexData::DeserializeFromString(ParseContext& context, const std::string& jsonString)
{
    return WebexData::Deserialize(context, ParseUtil::GetJsonValueFromString(jsonString));
}

// value is present if and only if "rtl" property is explicitly set
CardWidth WebexData::GetCardWidth() const
{
    return m_cardWidth;
}

void WebexData::SetCardWidth(const CardWidth value)
{
    m_cardWidth = value;
}

