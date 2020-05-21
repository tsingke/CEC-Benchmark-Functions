/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#ifndef _F1_H
#define _F1_H

#include "Benchmarks.h"

class F1:public Benchmarks{
public:
	F1(RunParameter* runParam);
	double compute(double* x) ;
	double compute(vector<double> x) ;
	~F1();
};
#endif
