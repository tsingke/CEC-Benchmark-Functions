/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#ifndef _F8_H
#define _F8_H

#include "Benchmarks.h"

class F8:public Benchmarks{
protected:
public:
	F8(RunParameter* runParam);
	double compute(double* x) ;
	double compute(vector<double> x) ;
	~F8();
};

#endif
