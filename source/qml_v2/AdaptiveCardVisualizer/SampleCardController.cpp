#include "SampleCardController.h"

SampleCardController::SampleCardController(QObject *parent)
	: QObject(parent)
{
	mSampleCardListModel = new SampleCardListModel(this);
}

SampleCardController::~SampleCardController()
{

}
