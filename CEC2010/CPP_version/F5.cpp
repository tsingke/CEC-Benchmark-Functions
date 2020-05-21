/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#include "F5.h"
#include <stdio.h>

/**
 * Single-group Shifted and m-rotated Rastrigin¡¯s Function
 *
 * as defined in "Benchmark Functions for the CEC'2010 Special Session
 * and Competition on Large-Scale Global Optimization" by Ke Tang,
 * Xiaodong Li, P. N. Suganthan, Zhenyu Yang, and Thomas Weise
 * published as technical report on January 8, 2010 at Nature Inspired
 * Computation and Applications Laboratory (NICAL), School of Computer
 * Science and Technology, University of Science and Technology of China,
 * Hefei, Anhui, China.
 */

F5::F5(RunParameter* runParam):Benchmarks(runParam){
	cout<<"F5 Class initialization"<<endl;
	dimension = runParam->dimension;
	m_havenextGaussian=0;
	Ovector = NULL;
	minX = -5;
	maxX = 5;
}

F5::~F5(){
 	delete[] Ovector;
 	delete[] Pvector;
 	delete[] RotMatrix;
	cout<<"F5 Class destroyed"<<endl;
}

double F5::compute(double*x){
  int    i;
  double result = 0.0;

  if(Ovector == NULL) {
    Ovector   = createShiftVector(dimension,minX,maxX);
    Pvector   = createPermVector(dimension);
    RotMatrix = createRotMatrix1D(nonSeparableGroupSize);
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

  result =
    rot_rastrigin(anotherz1,nonSeparableGroupSize) * 1.0e6 + rastrigin(
      anotherz2,dimension - nonSeparableGroupSize);
  return(result);
}

double F5::compute(vector<double> x){ 
  int    i;
  double result = 0.0;

  if(Ovector == NULL) {
    Ovector   = createShiftVector(dimension,minX,maxX);
    Pvector   = createPermVector(dimension);
    RotMatrix = createRotMatrix1D(nonSeparableGroupSize);
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

  result =
    rot_rastrigin(anotherz1,nonSeparableGroupSize) * 1.0e6 + rastrigin(
      anotherz2,dimension - nonSeparableGroupSize);
  return(result);
}
