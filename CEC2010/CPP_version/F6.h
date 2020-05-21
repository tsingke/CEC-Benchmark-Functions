/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#ifndef _F6_H
#define _F6_H

#include "Benchmarks.h"

class F6:public Benchmarks{
protected:
public:
	F6(RunParameter* runParam);
	double compute(double* x) ;
	double compute(vector<double> x) ;
	~F6();
};

#endif
