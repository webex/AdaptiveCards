#include "TimeInputModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"

TimeInputModel::TimeInputModel(std::shared_ptr<AdaptiveCards::TimeInput> input, QObject* parent) :
	QObject(parent)
{
}

TimeInputModel::~TimeInputModel()
{}
