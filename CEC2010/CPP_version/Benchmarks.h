/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#ifndef _BENCHMARKS_H
#define _BENCHMARKS_H

#include <cstdlib>
#include <cmath>
#include "RunParameter.h"

#define PI (3.141592653589793238462643383279)
#define E  (2.718281828459045235360287471352)
#define L(i) ((int64_t)i)
#define D(i) ((double)i)

class Benchmarks{
protected:
	int next(int bits);
	int nextInt(int n);
	double nextDouble();
	double nextGaussian();
	double* createShiftVector(int dim, double min,double max);
	int* createPermVector(int dim);
	double** createRotMatrix(int dim);
	double* createRotMatrix1D(int dim);
	double** createMultiRotateMatrix1D(int dim, int num);

	double* lookupprepare(int dim);

	// Basic mathematical functions' declaration
	double* multiply(double*vector, double*matrix,int dim);
	double elliptic(double*x,int dim);
	double elliptic(double*x, int dim, int k);
	double rastrigin(double*x,int dim);
	double rastrigin(double *x, int dim, int k); 
	double ackley(double*x,int dim);
	double ackley(double*x,int dim, int k);
	double rot_elliptic(double*x,int dim);
	double rot_elliptic(double*x,int dim, int k, double *lookup);
	double rot_rastrigin(double*x,int dim);
	double rot_rastrigin(double *x,int dim,int k);
	double rot_ackley(double*x,int dim);
	double rot_ackley(double*x,int dim,int k);
	double schwefel(double*x,int dim);
	double schwefel(double*x,int dim, int k);
	double sphere(double*x,int dim);
	double sphere(double*x,int dim, int k);
	double rosenbrock(double*x,int dim);
	double rosenbrock(double*x,int dim, int k);

	int dimension;
	int nonSeparableGroupSize;
	int64_t functionInitRandomSeed;
	int64_t M;
	int64_t A;
	int64_t m_seed;
	int64_t MASK;
	double m_nextGaussian;
	bool  m_havenextGaussian;
	bool setOvectorToZero;

	double *Ovector;
	int*    Pvector;
	double* RotMatrix;
	double** MultiRotMatrix1D;

	double* anotherz;
	double* anotherz1;
	double* anotherz2;

	// domain of decision variables
	int minX;
	int maxX;
public:
	Benchmarks(RunParameter* runParam);
	virtual ~Benchmarks();
	virtual double compute(double* x){return 0;};
	virtual double compute(vector<double> x){return 0;};
	
	int getMinX();
	int getMaxX();
};

#endif
