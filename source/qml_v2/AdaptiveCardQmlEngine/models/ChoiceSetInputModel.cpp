#include "ChoiceSetInputModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"

ChoiceSetInputModel::ChoiceSetInputModel(std::shared_ptr<AdaptiveCards::ChoiceSetInput> choiceSetInputModel, QObject* parent) :
    QObject(parent)

{
}

ChoiceSetInputModel::~ChoiceSetInputModel()
{
}
