#pragma once

#include <QObject>
#include "SampleCardListModel.h"

class SampleCardController  : public QObject
{
    Q_OBJECT
    Q_PROPERTY(SampleCardListModel* cardListModel MEMBER mSampleCardListModel CONSTANT)

public:
	explicit SampleCardController(QObject *parent = nullptr);
	~SampleCardController();
		
private:
	SampleCardListModel* mSampleCardListModel;

};
