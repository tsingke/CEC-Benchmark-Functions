/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#ifndef _F5_H
#define _F5_H

#include "Benchmarks.h"

class F5:public Benchmarks{
protected:
public:
	F5(RunParameter* runParam);
	double compute(double* x) ;
	double compute(vector<double> x) ;
	~F5();
};

#endif
