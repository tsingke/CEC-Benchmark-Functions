/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#include "F12.h"
#include <stdio.h>

/**
 * D/2m-group Shifted m-dimensional Schwefel¡¯s Problem 1.2
 *
 * as defined in "Benchmark Functions for the CEC'2010 Special Session
 * and Competition on Large-Scale Global Optimization" by Ke Tang,
 * Xiaodong Li, P. N. Suganthan, Zhenyu Yang, and Thomas Weise
 * published as technical report on January 8, 2010 at Nature Inspired
 * Computation and Applications Laboratory (NICAL), School of Computer
 * Science and Technology, University of Science and Technology of China,
 * Hefei, Anhui, China.
 */

F12::F12(RunParameter* runParam):Benchmarks(runParam){
	cout<<"F12 Class initialization"<<endl;
	dimension = runParam->dimension;
	m_havenextGaussian=0;
	Ovector = NULL;
	minX = -100;
	maxX = 100;
}

F12::~F12(){
	delete[] Ovector;
	delete[] Pvector;
	cout<<"F12 Class destroyed"<<endl;
}

double F12::compute(double*x){
	int i,k;
	double result=0.0;
	if(Ovector==NULL)
	{
		Ovector=createShiftVector(dimension,minX,maxX);
		Pvector=createPermVector(dimension);
	}
	for(i=0;i<dimension;i++)
	{
		anotherz[i]=x[i]-Ovector[i];
	}
	for(k=1;k<=dimension/(2*nonSeparableGroupSize);k++)
	{
		result+=schwefel(anotherz,nonSeparableGroupSize,k);

	}
	result+=sphere(anotherz,dimension, 2);
	return(result);
}

double F12::compute(vector<double> x){
	int i,k;
	double result=0.0;
	if(Ovector==NULL)
	{
		Ovector=createShiftVector(dimension,minX,maxX);
		Pvector=createPermVector(dimension);
	}
	for(i=0;i<dimension;i++)
	{
		anotherz[i]=x[i]-Ovector[i];
	}
	for(k=1;k<=dimension/(2*nonSeparableGroupSize);k++)
	{
		result+=schwefel(anotherz,nonSeparableGroupSize,k);

	}
	result+=sphere(anotherz,dimension, 2);
	return(result);
}

