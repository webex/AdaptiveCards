#pragma once
#include<memory>
#include<string>

//Common Properties for all Input Elements
class InputFieldConfig
{
	public:
		InputFieldConfig(bool isDark);

		bool isDark;
		std::string height;
		std::string leftPadding;
		std::string rightPadding;
		std::string radius;
};

//Specific Properties for InputText
class InputTextConfig:InputFieldConfig
{

public:
	InputTextConfig(bool isDark);

	std::string multiLineTextHeight;
};

//Holds references to all elements
class RenderConfig
{
public:
	RenderConfig(bool isDark);

	bool isDark;
	std::shared_ptr<InputTextConfig> textInputConfig;
};


