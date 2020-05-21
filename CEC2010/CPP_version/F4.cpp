/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#include "F4.h"
#include <stdio.h>

/**
 * Single-group Shifted and m-rotated Elliptic Function
 *
 * as defined in "Benchmark Functions for the CEC'2010 Special Session
 * and Competition on Large-Scale Global Optimization" by Ke Tang,
 * Xiaodong Li, P. N. Suganthan, Zhenyu Yang, and Thomas Weise
 * published as technical report on January 8, 2010 at Nature Inspired
 * Computation and Applications Laboratory (NICAL), School of Computer
 * Science and Technology, University of Science and Technology of China,
 * Hefei, Anhui, China.
 */

F4::F4(RunParameter* runParam):Benchmarks(runParam){
	cout<<"F4 Class initialization"<<endl;
	dimension = runParam->dimension;
	m_havenextGaussian=0;
	Ovector = NULL;
	minX = -100;
	maxX = 100;
}

F4::~F4(){
 	delete[] Ovector;
 	delete[] Pvector;
 	delete[] RotMatrix;
	cout<<"F4 Class destroyed"<<endl;
}

double F4::compute(double*x){
  int    i;
  double result = 0.0;

  if(Ovector == NULL) {
    Ovector   = createShiftVector(dimension,minX,maxX);
	/*
	printf("\n\n\nO vector\n\n\n");
	for (i = 0; i<dimension; i++){
		printf("%lf\t",Ovector[i]);
	}
	*/

    Pvector   = createPermVector(dimension);
	/*
	printf("\n\n\nP vector\n\n\n");
	for (i = 0; i<dimension; i++){
		printf("%d\t",Pvector[i]);
	}
	*/

    RotMatrix = createRotMatrix1D(nonSeparableGroupSize);
	/*
	printf("\n\n\nRot Matrix\n\n\n");
	for (i = 0; i<nonSeparableGroupSize; i++){
		for (j=0; j<nonSeparableGroupSize; j++){
			printf("%lf\t",RotMatrix[i*nonSeparableGroupSize+j]);
		}
		printf("\n");
	}
	*/
  }

  for(i = 0; i < dimension; i++) {
    anotherz[i] = x[i] - Ovector[i];
  }

  for(i = 0; i < nonSeparableGroupSize; i++) {
    anotherz1[i] = anotherz[Pvector[i]];
  }

  for(i = nonSeparableGroupSize; i < dimension; i++) {
    anotherz2[i - nonSeparableGroupSize] = anotherz[Pvector[i]];
  }

  result = rot_elliptic(anotherz1,nonSeparableGroupSize) * 1e6 + elliptic(
    anotherz2,dimension - nonSeparableGroupSize);

  printf("Rotated Part = %1.16E\n", rot_elliptic(anotherz1,nonSeparableGroupSize) * 1e6);
  printf("Separable Part = %1.16E\n", elliptic(anotherz2,dimension - nonSeparableGroupSize));

  return(result);
}

double F4::compute(vector<double> x){
  int    i;
  double result = 0.0;

  if(Ovector == NULL) {
    Ovector   = createShiftVector(dimension,minX,maxX);
	/*
	printf("\n\n\nO vector\n\n\n");
	for (i = 0; i<dimension; i++){
		printf("%lf\t",Ovector[i]);
	}
	*/

    Pvector   = createPermVector(dimension);
	/*
	printf("\n\n\nP vector\n\n\n");
	for (i = 0; i<dimension; i++){
		printf("%d\t",Pvector[i]);
	}
	*/

    RotMatrix = createRotMatrix1D(nonSeparableGroupSize);
	/*
	printf("\n\n\nRot Matrix\n\n\n");
	for (i = 0; i<nonSeparableGroupSize; i++){
		for (j=0; j<nonSeparableGroupSize; j++){
			printf("%lf\t",RotMatrix[i*nonSeparableGroupSize+j]);
		}
		printf("\n");
	}
	*/
  }

  for(i = 0; i < dimension; i++) {
    anotherz[i] = x[i] - Ovector[i];
  }

  for(i = 0; i < nonSeparableGroupSize; i++) {
    anotherz1[i] = anotherz[Pvector[i]];
  }

  for(i = nonSeparableGroupSize; i < dimension; i++) {
    anotherz2[i - nonSeparableGroupSize] = anotherz[Pvector[i]];
  }

  result = rot_elliptic(anotherz1,nonSeparableGroupSize) * 1e6 + elliptic(
    anotherz2,dimension - nonSeparableGroupSize);

  printf("Rotated Part = %1.16E\n", rot_elliptic(anotherz1,nonSeparableGroupSize) * 1e6);
  printf("Separable Part = %1.16E\n", elliptic(anotherz2,dimension - nonSeparableGroupSize));

  return(result);
}
