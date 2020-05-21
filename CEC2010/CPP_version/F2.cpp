/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#include "F2.h"

/**
 * Shifted Rastrigin's Function
 *
 * as defined in "Benchmark Functions for the CEC'2010 Special Session
 * and Competition on Large-Scale Global Optimization" by Ke Tang,
 * Xiaodong Li, P. N. Suganthan, Zhenyu Yang, and Thomas Weise
 * published as technical report on January 8, 2010 at Nature Inspired
 * Computation and Applications Laboratory (NICAL), School of Computer
 * Science and Technology, University of Science and Technology of China,
 * Hefei, Anhui, China.
 */

F2::F2(RunParameter* runParam):Benchmarks(runParam){
	cout<<"F2 Class initialization"<<endl;
	dimension = runParam->dimension;
	m_havenextGaussian=0;
	Ovector = NULL;
	minX = -5;
	maxX = 5;
}

F2::~F2(){
 	delete[] Ovector;
	cout<<"F2 Class destroyed"<<endl;
}


double F2::compute(double* x){
  int    i;
  double result;

  if(Ovector == NULL) {
    Ovector = createShiftVector(dimension,minX,maxX);
  }

  for(i = 0; i < dimension; i++) {
    anotherz[i] = x[i] - Ovector[i];
  }

  result = rastrigin(anotherz,dimension);
  return(result);
}

double F2::compute(vector<double> x){
  int    i;
  double result;

  if(Ovector == NULL) {
    Ovector = createShiftVector(dimension,minX,maxX);
  }

  for(i = 0; i < dimension; i++) {
    anotherz[i] = x[i] - Ovector[i];
  }

  result = rastrigin(anotherz,dimension);
  return(result);
}
