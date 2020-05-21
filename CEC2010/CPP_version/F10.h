/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#ifndef _F10_H
#define _F10_H

#include "Benchmarks.h"

class F10:public Benchmarks{
protected:
public:
	F10(RunParameter* runParam);
	double compute(double* x) ;
	double compute(vector<double> x) ;
	~F10();
};

#endif
