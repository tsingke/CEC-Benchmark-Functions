/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#include "F7.h"
#include <stdio.h>

/**
 * Single-group Shifted m-dimensional Schwefel¡¯s Problem 1.2
 *
 * as defined in "Benchmark Functions for the CEC'2010 Special Session
 * and Competition on Large-Scale Global Optimization" by Ke Tang,
 * Xiaodong Li, P. N. Suganthan, Zhenyu Yang, and Thomas Weise
 * published as technical report on January 8, 2010 at Nature Inspired
 * Computation and Applications Laboratory (NICAL), School of Computer
 * Science and Technology, University of Science and Technology of China,
 * Hefei, Anhui, China.
 */

F7::F7(RunParameter* runParam):Benchmarks(runParam){
	cout<<"F7 Class initialization"<<endl;
	dimension = runParam->dimension;
	m_havenextGaussian=0;
	Ovector = NULL;
	minX = -100;
	maxX = 100;
}

F7::~F7(){
	delete[] Ovector;
	delete[] Pvector;
	cout<<"F7 Class destroyed"<<endl;
}


double F7::compute(double*x){
  int    m = nonSeparableGroupSize;
  int    i;
  double result;

  if(Ovector == NULL) {
    Ovector = createShiftVector(dimension,minX,maxX);
    Pvector = createPermVector(dimension);
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

  result = schwefel(anotherz1,m) * 1e6 + sphere(anotherz2,dimension - m);
  return(result);
}

double F7::compute(vector<double> x){
  int    m = nonSeparableGroupSize;
  int    i;
  double result;

  if(Ovector == NULL) {
    Ovector = createShiftVector(dimension,minX,maxX);
    Pvector = createPermVector(dimension);
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

  result = schwefel(anotherz1,m) * 1e6 + sphere(anotherz2,dimension - m);
  return(result);
}
