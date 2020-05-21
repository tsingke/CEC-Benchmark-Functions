/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#include "F8.h"
#include <stdio.h>

/**
 * Single-group Shifted m-dimensional Rosenbrock¡¯s Function
 *
 * as defined in "Benchmark Functions for the CEC'2010 Special Session
 * and Competition on Large-Scale Global Optimization" by Ke Tang,
 * Xiaodong Li, P. N. Suganthan, Zhenyu Yang, and Thomas Weise
 * published as technical report on January 8, 2010 at Nature Inspired
 * Computation and Applications Laboratory (NICAL), School of Computer
 * Science and Technology, University of Science and Technology of China,
 * Hefei, Anhui, China.
 */

F8::F8(RunParameter* runParam):Benchmarks(runParam){
	cout<<"F8 Class initialization"<<endl;
	dimension = runParam->dimension;
	m_havenextGaussian=0;
	Ovector = NULL;
	minX = -100;
	maxX = 100;
}

F8::~F8(){
	delete[] Ovector;
	delete[] Pvector;
	cout<<"F8 Class destroyed"<<endl;
}

double F8::compute(double* x){
	int    m = nonSeparableGroupSize;
	int    i;
	double result;

	if(Ovector == NULL) {
		Ovector = createShiftVector(dimension,minX,maxX-1);

		printf("\n\n\nO vector\n\n\n");
		for (i = 0; i<dimension; i++){
			printf("%f\t",Ovector[i]);
		}

		Pvector = createPermVector(dimension);
		/*
		printf("\n\n\nP vector\n\n\n");
		for (i = 0; i<dimension; i++){
			printf("%d\t",Pvector[i]);
		}
		*/
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
	result = rosenbrock(anotherz1,m) * 1e6 + sphere(anotherz2,dimension - m);

	printf("Rosenbrock Part = %1.16E\n", rosenbrock(anotherz1,m) * 1e6);
	printf("Sphere Part = %1.16E\n", sphere(anotherz2,dimension - m));

	return(result);
}


double F8::compute(vector<double> x){
	int    m = nonSeparableGroupSize;
	int    i;
	double result;

	if(Ovector == NULL) {
		Ovector = createShiftVector(dimension,minX,maxX-1);

		printf("\n\n\nO vector\n\n\n");
		for (i = 0; i<dimension; i++){
			printf("%f\t",Ovector[i]);
		}

		Pvector = createPermVector(dimension);
		/*
		printf("\n\n\nP vector\n\n\n");
		for (i = 0; i<dimension; i++){
			printf("%d\t",Pvector[i]);
		}
		*/
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
	result = rosenbrock(anotherz1,m) * 1e6 + sphere(anotherz2,dimension - m);

	printf("Rosenbrock Part = %1.16E\n", rosenbrock(anotherz1,m) * 1e6);
	printf("Sphere Part = %1.16E\n", sphere(anotherz2,dimension - m));

	return(result);
}
