#include "DateInputModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"

DateInputModel::DateInputModel(std::shared_ptr<AdaptiveCards::DateInput> datrInput, QObject* parent) :
	QObject(parent)
{
}

DateInputModel::~DateInputModel()
{
}

