#include "NumberInputModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"

NumberInputModel::NumberInputModel(std::shared_ptr<AdaptiveCards::NumberInput> numberInput, QObject* parent) :
    QObject(parent)
{
}
NumberInputModel::~NumberInputModel()
{
}
