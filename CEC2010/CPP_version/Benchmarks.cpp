/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#include "Benchmarks.h"

Benchmarks::Benchmarks(RunParameter* runParam){
	cout<<"Benchmarks Class initialization"<<endl;
	dimension = runParam->dimension;		
	nonSeparableGroupSize = runParam->nonSeparableGroupSize;
	MASK = ((L(1)) << (L(48))) - (L(1));
	m_havenextGaussian = false;

	if (dimension<nonSeparableGroupSize){
		cerr<<"ERROR: In configuration file, dimension is smaller than the non-separable part"<<endl;
		exit(-1);
	}

	// allocate the memory
	anotherz = new double[dimension];
	anotherz1= new double[nonSeparableGroupSize];
	anotherz2= new double[dimension - nonSeparableGroupSize];

	// Runtime Parameters setting
	setOvectorToZero = false;

	functionInitRandomSeed = L(runParam->initRandomSeed);
	m_seed= functionInitRandomSeed;
	M  = 0x5DEECE66D;
	A  = 0xB;

	minX = -100;
	maxX = 100;
}

Benchmarks::~Benchmarks(){
	delete[] anotherz;
	delete[] anotherz1;
	delete[] anotherz2;
	cout<<"Benchmarks Class Destroyed"<<endl;
}

int Benchmarks::next(int bits) {
	int64_t s;
	int64_t result;
	m_seed = s = (((m_seed * M) + A) & MASK);
	result = (s >> (L(48 - bits)));
	return((int)result);
}

int Benchmarks::nextInt(int n) {
	int bits, val;

	if ((n & (-n)) == n) {
		return((int) ((n * L(next(31))) >> L(31)));
	}

	do {
		bits = next(31);
		val  = bits % n;
	} while (bits - val + (n - 1) < 0);

	return(val);
}

double Benchmarks::nextDouble(){
	return ((((L(next(26))) <<
					(L(27))) + (L(next(27)))) / (double) ((L(1)) << (L(53))));
}

double Benchmarks::nextGaussian(){
	double multiplier, v1, v2, s;

	if (m_havenextGaussian) {
		m_havenextGaussian = false;
		return(m_nextGaussian) ;
	}

	do {
		v1 = ((D(2.0) * nextDouble()) - D(1.0));
		v2 = ((D(2.0) * nextDouble()) - D(1.0));
		s  = ((v1 * v1) + (v2 * v2));
	} while ((s >= D(1.0)) || (s <= D(0.0)));

	multiplier = sqrt(D(-2.0) * log(s) / s);
	m_nextGaussian    = (v2 * multiplier);
	m_havenextGaussian = true;
	return (v1 * multiplier);
}

double* Benchmarks::createShiftVector(int dim, double min,double max) {

	double* d;
	double  hw, middle;
	double  s;
	int     i;
	hw     = (D(0.5) * (max - min));
	middle = (min + hw);
	d      = (double*)malloc(sizeof(double) * dim);

//	printf("middle = %1.20E\n",middle);
//	printf("hw = %1.20E\n",hw);

	for (i = (dim - 1); i >= 0; i--) {
		if (setOvectorToZero == true){
			d[i] = 0;
		}else{
			do {
				double tempGauss = nextGaussian();
				s = (middle + (tempGauss * hw));
				//				printf("nextGaussian = %1.20E\n",tempGauss);
				/*
				   s = (middle + (nextGaussian() * hw));
				   */
			} while ((s < min) || (s > max));
			d[i] = s;
//			printf("shift vector = %1.20E\n", d[i]);
		}
	}
	return(d);
}

int* Benchmarks::createPermVector(int dim){
	int* d;
	int  i, j, k, t;
	d = (int*)malloc(sizeof(int) * dim);

	for (i = (dim - 1); i >= 0; i--) {
		d[i] = i;
	}

	for (i = (dim << 3); i >= 0; i--) {
		j = nextInt(dim);

		do {
			k = nextInt(dim);
		} while (k == j);

		t    = d[j];
		d[j] = d[k];
		d[k] = t;
	}

	return(d);
}

//Create a random rotation matrix
double** Benchmarks::createRotMatrix(int dim){
	double** m;
	int      i, j, k;
	double   dp, t;
	m = (double**)malloc(sizeof(double*) * dim);

	for(i = 0; i < dim; i++) {
		m[i] = (double*)malloc(sizeof(double) * dim);
	}

loop:

	for (;;) {
		for (i = (dim - 1); i >= 0; i--) {
			for (j = (dim - 1); j >= 0; j--) {
				m[i][j] = nextGaussian();
			}
		}

		// main loop of gram/schmidt
		for (i = (dim - 1); i >= 0; i--) {
			for (j = (dim - 1); j > i; j--) {
				// dot product
				dp = 0;

				for (k = (dim - 1); k >= 0; k--) {
					dp += (m[i][k] * m[j][k]);
				}

				// subtract
				for (k = (dim - 1); k >= 0; k--) {
					m[i][k] -= (dp * m[j][k]);
				}
			}

			// normalize
			dp = 0;

			for (k = (dim - 1); k >= 0; k--) {
				t   = m[i][k];
				dp += (t * t);
			}

			// linear dependency -> restart
			if (dp <= 0) {
				goto loop;
			}

			dp = (1 / sqrt(dp));

			for (k = (dim - 1); k >= 0; k--) {
				m[i][k] *= dp;
			}
		}

		return(m) ;
	}
}

/**
 * Create a random rotation matrix
 */
double* Benchmarks::createRotMatrix1D(int dim){
	double** a;
	double*  b;
	int      i, j, k;
	a = createRotMatrix(dim);
	b = (double*)malloc(sizeof(double) * (dim * dim));
	k = 0;

	for (i = 0; i < dim; i++) {
		for (j = 0; j < dim; j++) {
			b[k++] = a[i][j];
		}
	}

	// release the memory that previously allocated for storing a 2D array
	for(i=0;i<dim;i++){
		delete []a[i];
	}
	delete[] a;

	return(b);
}

/*
 * create several 1-D rotation matrix randomly
 */
double** Benchmarks::createMultiRotateMatrix1D(int dim, int num){
	double** a;
	int i;

	/*  allocate storage for an array of pointers */
	a =(double **) malloc(num * sizeof(double *));

	/* for each pointer, allocate storage for an array of ints */
	for (i = 0; i < num; i++) {
		a[i] = createRotMatrix1D(dim);
	}

	return (a);
}

double* Benchmarks::lookupprepare(int dim) {

	double pownum;
	int    i;
	double* lookup;
	i         = (dim - 1);
	pownum    = (1.0 / i);
	lookup    = (double*)malloc(dim * sizeof(double));
	lookup[i] = 1.0e6;
	lookup[0] = 1.0;

	for (--i; i > 0; i--) {
		lookup[i] = pow(1.0e6, i * pownum);
	}
	return lookup;
}

/* 
 * Basic Mathematical Functions' Implementation
 */
// elliptic function for F1 ~ F8
double Benchmarks::elliptic(double*x,int dim) {
	double result = 0.0;
	int    i;
	double * lookup = lookupprepare(dim);

	for(i = dim - 1; i >= 0; i--) {
		result += lookup[i] * x[i] * x[i];
	}

	delete[] lookup;
	return(result);
}

// elliptic function for F9 ~ 
double Benchmarks::elliptic(double*x, int dim, int k) {
	double result = 0.0;
	int    i;
	double * lookup = lookupprepare(dim/2);

	for(i=dim/k-1;i>=0;i--)
	{
		result+=lookup[i]*x[Pvector[dim/k+i]]*x[Pvector[dim/k+i]];
	}

	delete[] lookup;
	return(result);
}

// rastrigin function for F1~F8
double Benchmarks::rastrigin(double*x,int dim){
	double sum = 0;
	int    i;

	for(i = dim - 1; i >= 0; i--) {
		sum += x[i] * x[i] - 10.0 * cos(2 * PI * x[i]) + 10.0;
	}

	return(sum);
}

// rastrigin function for F9 ~
double Benchmarks::rastrigin(double *x, int dim, int k)
{
	double result=0.0;
	int i;
	for(i=dim/k-1;i>=0;i--)
	{
		result+=x[Pvector[dim/k+i]]*x[Pvector[dim/k+i]]-10.0*cos(2*PI*x[Pvector[dim/k+i]])+10.0;
	}
	return(result);
}

// ackley function for single group non-separable 
double Benchmarks::ackley(double*x,int dim){
	double sum1 = 0.0;
	double sum2 = 0.0;
	double sum;
	int    i;

	for(i = dim - 1; i >= 0; i--) {
		sum1 += (x[i] * x[i]);
		sum2 += cos(2.0 * PI * x[i]);
	}

	sum = -20.0 * exp(-0.2 * sqrt(sum1 / dim)) - exp(sum2 / dim) + 20.0 + E;
	return(sum);
}

// ackley function for m-group non-separable 
double Benchmarks::ackley(double *x, int dim, int k)
{
	double sum1=0.0;
	double sum2=0.0;
	double result=0.0;
	int i;

	for(i=dim/k-1;i>=0;i--)
	{
		sum1+=x[Pvector[dim/k+i]]*x[Pvector[dim/k+i]];
		sum2+=cos(2.0*PI*x[Pvector[dim/k+i]]);
	}

	result=-20.0*exp(-0.2*sqrt(sum1/(dim/k)))-exp(sum2/(dim/k))+20.0+E;

	return(result);
}

double* Benchmarks::multiply(double*vector, double*matrix,int dim){
	int    i,j;
	double*result = (double*)malloc(sizeof(double) * dim);

	for(i = dim - 1; i >= 0; i--) {
		result[i] = 0;

		for(j = dim - 1; j >= 0; j--) {
			result[i] += vector[j] * matrix[dim * j + i];
		}
	}

	return(result);
}

// Rotated Elliptic Function for F1 ~ F8
double Benchmarks::rot_elliptic(double*x,int dim){
	double result = 0.0;
	double *z = multiply(x,RotMatrix,dim);
	double *lookupTable = lookupprepare(dim);

	result = elliptic(z,dim);

	delete[] z;
	delete[] lookupTable;
	return(result);
}

// Rotated Elliptic Function for F9 ~
double Benchmarks::rot_elliptic(double*x,int dim, int k, double *lookup){
	double result=0.0;

	int i,j;
	for(i=dim-1;i>=0;i--)
	{
		anotherz1[i]=0;
		for(j=dim-1;j>=0;j--)
		{
			anotherz1[i]+=x[Pvector[(k-1)*dim+j]]*MultiRotMatrix1D[k-1][dim*j+i];
		}
	}
	for(i=dim-1;i>=0;i--)
	{
		result+=lookup[i]*anotherz1[i]*anotherz1[i];
	}
	return(result);
}

// Rotated Rastrigin Function for F1~F8
double Benchmarks::rot_rastrigin(double*x,int dim){
	double result = 0.0;
	double*z      = multiply(x,RotMatrix,dim);
	result = rastrigin(z,dim);

	delete[] z;
	return(result);
}

// Rotated Rastrigin Function for F9 ~
double Benchmarks::rot_rastrigin(double *x,int dim,int k)
{
	double result=0.0;

	int i,j;
	for(i=dim-1;i>=0;i--)
	{
		anotherz1[i]=0;
		for(j=dim-1;j>=0;j--)
		{
			anotherz1[i]+=x[Pvector[(k-1)*dim+j]]*MultiRotMatrix1D[k-1][dim*j+i];
		}
	}

	for(i=dim-1;i>=0;i--)
	{
		result+=anotherz1[i]*anotherz1[i]-10.0*cos(2*PI*anotherz1[i])+10.0;
	}
	return(result);
}

// rotated ackley function for single group non-separable
double Benchmarks::rot_ackley(double*x,int dim){
	double result = 0.0;
	double*z      = multiply(x,RotMatrix,dim);
	result = ackley(z,dim);
	delete[] z;
	return(result);
}

// rotated ackley function for m group non-separable
double Benchmarks::rot_ackley(double *x,int dim,int k)
{
	double result=0.0;
	double sum1=0.0;
	double sum2=0.0;

	int i,j;
	for(i=dim-1;i>=0;i--)
	{
		anotherz1[i]=0;
		for(j=dim-1;j>=0;j--)
		{
			anotherz1[i]+=x[Pvector[(k-1)*dim+j]]*MultiRotMatrix1D[k-1][dim*j+i];
		}
	}
	for(i=dim-1;i>=0;i--)
	{
		sum1+=anotherz1[i]*anotherz1[i];
		sum2+=cos(2.0*PI*anotherz1[i]);
	}
	result=-20.0*exp(-0.2*sqrt(sum1/dim))-exp(sum2/dim)+20.0+E;
	return(result);
}

// for single group non-separable function
double Benchmarks::sphere(double*x,int dim){
	double sum = 0;
	int    i;

	for(i = dim - 1; i >= 0; i--) {
		sum += pow(x[i],2);
	}

	return(sum);
}

// for m groups non-separable function
double Benchmarks::sphere(double*x,int dim, int k){
	double result=0.0;
	int i;

//	cout<<"partial sum of sphere function ="<<endl;
	for(i=dim/k-1;i>=0;i--)
	{
		result+=x[Pvector[dim/k+i]]*x[Pvector[dim/k+i]];
//		printf("x = %1.16E\t", x[Pvector[dim/k+i]]);
//		printf("partial sum = %1.16E\t", result);
	}

	return(result);
}

// for single group non-separable function
double Benchmarks::schwefel(double*x,int dim){
	int    j;
	double s1 = 0;
	double s2 = 0;

	for (j = 0; j < dim; j++) {
		s1 += x[j];
		s2 += (s1 * s1);
	}

	return(s2);
}

// for m groups non-separable function
double Benchmarks::schwefel(double*x,int dim, int k){
	double sum1=0.0;
	double sum2=0.0;
	int i;
	for(i=0;i<dim;i++)
	{
		sum1+=x[Pvector[(k-1)*dim+i]];
		sum2+=sum1*sum1;
	}
	return(sum2);
}

// single group non-separable function
double Benchmarks::rosenbrock(double*x,int dim){
	int    j;
	double oz,t;
	double s = 0.0;
	j = dim - 1;

	for (--j; j >= 0; j--) {
		oz = x[j + 1];
		t  = ((x[j] * x[j]) - oz);
		s += (100.0 * t * t);
		t  = (x[j] - 1.0);
		s += (t * t);
	}
	return(s);
}

// m groups non-separable function
double Benchmarks::rosenbrock(double*x,int dim, int k){
	int j;
	double oz,t;
	double result=0.0;
	j=dim-1;
	for (--j; j >= 0; j--) {
		oz = x[Pvector[(k-1)*dim+j+1]];
		t = ((x[Pvector[(k-1)*dim+j]] * x[Pvector[(k-1)*dim+j]]) - oz);
		result += (100.0 * t * t);
		t = (x[Pvector[(k-1)*dim+j]] - 1.0);
		result += (t * t);
	}
	return(result);
}

int Benchmarks::getMinX(){
	return minX;
}
	
int Benchmarks::getMaxX(){
	return maxX;
}
