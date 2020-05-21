/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#include "F9.h"
#include <stdio.h>

/**
 * D/2m-group Shifted and m-rotated Elliptic Function
 *
 * as defined in "Benchmark Functions for the CEC'2010 Special Session
 * and Competition on Large-Scale Global Optimization" by Ke Tang,
 * Xiaodong Li, P. N. Suganthan, Zhenyu Yang, and Thomas Weise
 * published as technical report on January 8, 2010 at Nature Inspired
 * Computation and Applications Laboratory (NICAL), School of Computer
 * Science and Technology, University of Science and Technology of China,
 * Hefei, Anhui, China.
 */

F9::F9(RunParameter* runParam):Benchmarks(runParam){
	cout<<"F9 Class initialization"<<endl;
	dimension = runParam->dimension;
	m_havenextGaussian=0;
	Ovector = NULL;
	minX = -100;
	maxX = 100;
}

F9::~F9(){
	delete[] Ovector;
	delete[] Pvector;
	// delete 2D array
	int i;
	for(i=0;i<dimension/(2*nonSeparableGroupSize);i++){
		delete[] MultiRotMatrix1D[i];
	}
	delete[] MultiRotMatrix1D;
	cout<<"F9 Class destroyed"<<endl;
}

double F9::compute(double*x){
	int i,k;
	double result=0.0;
	double* lookup;

	if(Ovector==NULL){
		Ovector=createShiftVector(dimension,minX,maxX);
		Pvector=createPermVector(dimension);
		MultiRotMatrix1D=createMultiRotateMatrix1D(nonSeparableGroupSize,dimension/(2*nonSeparableGroupSize));

		/* 
		 * print the multi rotated matrix 
		printf("\n\n\n print the multi rotated matrix\n\n\n");
		for (k = 0; k<dimension/(2*nonSeparableGroupSize); k++){
		printf("\n matrix %d: \n", k+1);
			for (i = 0; i<nonSeparableGroupSize*nonSeparableGroupSize; i++){
				printf("%1.20E\t", MultiRotMatrix1D[k][i]);
			}
		}
		 */
	}

	for(i=0;i<dimension;i++){
		anotherz[i]=x[i]-Ovector[i];
	}

	lookup = lookupprepare(nonSeparableGroupSize);
	for(k=1;k<=dimension/(2*nonSeparableGroupSize);k++){
		result+=rot_elliptic(anotherz,nonSeparableGroupSize,k,lookup);
	}
	delete[] lookup;

	printf("Rotated Part = %1.20E\n", result);

	result+=elliptic(anotherz, dimension, 2);
	return(result);
}

double F9::compute(vector<double> x){
	int i,k;
	double result=0.0;
	double* lookup;

	if(Ovector==NULL){
		Ovector=createShiftVector(dimension,minX,maxX);
		Pvector=createPermVector(dimension);
		MultiRotMatrix1D=createMultiRotateMatrix1D(nonSeparableGroupSize,dimension/(2*nonSeparableGroupSize));

		/* 
		 * print the multi rotated matrix 
		printf("\n\n\n print the multi rotated matrix\n\n\n");
		for (k = 0; k<dimension/(2*nonSeparableGroupSize); k++){
		printf("\n matrix %d: \n", k+1);
			for (i = 0; i<nonSeparableGroupSize*nonSeparableGroupSize; i++){
				printf("%1.20E\t", MultiRotMatrix1D[k][i]);
			}
		}
		 */
	}

	for(i=0;i<dimension;i++){
		anotherz[i]=x[i]-Ovector[i];
	}

	lookup = lookupprepare(nonSeparableGroupSize);
	for(k=1;k<=dimension/(2*nonSeparableGroupSize);k++){
		result+=rot_elliptic(anotherz,nonSeparableGroupSize,k,lookup);
	}
	delete[] lookup;

	printf("Rotated Part = %1.20E\n", result);

	result+=elliptic(anotherz, dimension, 2);
	return(result);
}
