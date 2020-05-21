/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#include "F6.h"
#include <stdio.h>

/**
 * Single-group Shifted and m-rotated Ackley¡¯s Function
 *
 * as defined in "Benchmark Functions for the CEC'2010 Special Session
 * and Competition on Large-Scale Global Optimization" by Ke Tang,
 * Xiaodong Li, P. N. Suganthan, Zhenyu Yang, and Thomas Weise
 * published as technical report on January 8, 2010 at Nature Inspired
 * Computation and Applications Laboratory (NICAL), School of Computer
 * Science and Technology, University of Science and Technology of China,
 * Hefei, Anhui, China.
 */

F6::F6(RunParameter* runParam):Benchmarks(runParam){
	cout<<"F6 Class initialization"<<endl;
	dimension = runParam->dimension;
	m_havenextGaussian=0;
	Ovector = NULL;
	minX = -32;
	maxX = 32;
}

F6::~F6(){
	delete[] Ovector;
	delete[] Pvector;
	delete[] RotMatrix;
	cout<<"F6 Class destroyed"<<endl;
}

double F6::compute(double*x){
	int    m = nonSeparableGroupSize;
	int    i;
	double result;

	if(Ovector == NULL) {
		Ovector   = createShiftVector(dimension,minX,maxX);
		Pvector   = createPermVector(dimension);
		RotMatrix = createRotMatrix1D(nonSeparableGroupSize);
	}

	for(i = 0; i < dimension; i++) {
		anotherz[i] = x[i] - Ovector[i];
	}

	for(i = 0; i < m; i++) {
		anotherz1[i] = anotherz[Pvector[i]];
	}

	for(i = m; i < dimension; i++) {
		anotherz2[i - m] = anotherz[Pvector[i]];
	}

	result = rot_ackley(anotherz1,m) * 1e6 + ackley(anotherz2,dimension - m);
	return(result);
}

double F6::compute(vector<double> x){
	int    m = nonSeparableGroupSize;
	int    i;
	double result;

	if(Ovector == NULL) {
		Ovector   = createShiftVector(dimension,minX,maxX);
		Pvector   = createPermVector(dimension);
		RotMatrix = createRotMatrix1D(nonSeparableGroupSize);
	}

	for(i = 0; i < dimension; i++) {
		anotherz[i] = x[i] - Ovector[i];
	}

	for(i = 0; i < m; i++) {
		anotherz1[i] = anotherz[Pvector[i]];
	}

	for(i = m; i < dimension; i++) {
		anotherz2[i - m] = anotherz[Pvector[i]];
	}

	result = rot_ackley(anotherz1,m) * 1e6 + ackley(anotherz2,dimension - m);
	return(result);
}
