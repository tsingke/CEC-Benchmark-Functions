/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#ifndef _F15_H
#define _F15_H

#include "Benchmarks.h"

class F15:public Benchmarks{
protected:
public:
	F15(RunParameter* runParam);
	double compute(double* x) ;
	double compute(vector<double> x) ;
	~F15();
};

#endif
