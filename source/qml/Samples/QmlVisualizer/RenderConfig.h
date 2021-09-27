#pragma once
#include<memory>
#include<string>

class InputTextConfig {

public:
	static std::shared_ptr<InputTextConfig> getInputTextConfig(bool isDark);

	bool isDark;
	std::string height;
	std::string leftPadding;
	std::string rightPadding;
	std::string radius;
};

class RenderConfig
{
public:
	RenderConfig(bool isDark);

	bool isDark;
	std::shared_ptr<InputTextConfig> textInputConfig;
};


