/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#include "F11.h"
#include <stdio.h>

/**
 * D/2m-group Shifted and m-rotated Ackley¡¯s Function
 *
 * as defined in "Benchmark Functions for the CEC'2010 Special Session
 * and Competition on Large-Scale Global Optimization" by Ke Tang,
 * Xiaodong Li, P. N. Suganthan, Zhenyu Yang, and Thomas Weise
 * published as technical report on January 8, 2010 at Nature Inspired
 * Computation and Applications Laboratory (NICAL), School of Computer
 * Science and Technology, University of Science and Technology of China,
 * Hefei, Anhui, China.
 */

F11::F11(RunParameter* runParam):Benchmarks(runParam){
	cout<<"F11 Class initialization"<<endl;
	dimension = runParam->dimension;
	m_havenextGaussian=0;
	Ovector = NULL;
	minX = -32;
	maxX = 32;
}

F11::~F11(){
	delete[] Ovector;
	delete[] Pvector;
	// delete 2D array
	int i;
	for(i=0;i<dimension/(2*nonSeparableGroupSize);i++){
		delete[] MultiRotMatrix1D[i];
	}
	delete[] MultiRotMatrix1D;
	cout<<"F11 Class destroyed"<<endl;
}

double F11::compute(double*x){
	int i,k;
	double result=0.0;

	if(Ovector==NULL)
	{
		Ovector=createShiftVector(dimension,minX,maxX);
		Pvector=createPermVector(dimension);
		MultiRotMatrix1D=createMultiRotateMatrix1D(nonSeparableGroupSize,dimension/(2*nonSeparableGroupSize));
	}

	for(i=0;i<dimension;i++)
	{
		anotherz[i]=x[i]-Ovector[i];
	}

	for(k=1;k<=dimension/(2*nonSeparableGroupSize);k++)
	{
		result+=rot_ackley(anotherz,nonSeparableGroupSize,k);

	}
	printf("Rot Ackley = %1.16E\n", result);

	double sepSum = ackley(anotherz,dimension,2);
	printf("Separable Ackley = %1.16E\n", sepSum);

	result+=sepSum;
	return(result);
}


double F11::compute(vector<double> x){
	int i,k;
	double result=0.0;

	if(Ovector==NULL)
	{
		Ovector=createShiftVector(dimension,minX,maxX);
		Pvector=createPermVector(dimension);
		MultiRotMatrix1D=createMultiRotateMatrix1D(nonSeparableGroupSize,dimension/(2*nonSeparableGroupSize));
	}

	for(i=0;i<dimension;i++)
	{
		anotherz[i]=x[i]-Ovector[i];
	}

	for(k=1;k<=dimension/(2*nonSeparableGroupSize);k++)
	{
		result+=rot_ackley(anotherz,nonSeparableGroupSize,k);

	}
	printf("Rot Ackley = %1.16E\n", result);

	double sepSum = ackley(anotherz,dimension,2);
	printf("Separable Ackley = %1.16E\n", sepSum);

	result+=sepSum;
	return(result);
}
