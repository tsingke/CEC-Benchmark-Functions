/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#ifndef _F11_H
#define _F11_H

#include "Benchmarks.h"

class F11:public Benchmarks{
protected:
public:
	F11(RunParameter* runParam);
	double compute(double* x) ;
	double compute(vector<double> x) ;
	~F11();
};

#endif
