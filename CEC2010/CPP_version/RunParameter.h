/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#ifndef _RUNPARAMETER_H
#define _RUNPARAMETER_H

#include <vector>
#include <fstream>
#include <string>
#include <cstring>
#include <cstdlib>
#include <iostream>

using namespace std;

class RunParameter{
public:
	// Dimension of problems
	unsigned dimension;

	// the amount of independent run
	unsigned numOfRun;

	// initial population size
	unsigned NP;

	// initial Group Size
	unsigned initialGroupSize;


	// Sampling interval for plotting the convergence curve
	unsigned samplingInterval;

	// initialized random seed
	int initRandomSeed;

	// group size for non-separable part of function
	unsigned nonSeparableGroupSize;
	// Fitness check point
	vector<unsigned> fitnessCheckPoint;

	// the IDes of benchmark functions to be tested in the experiment
	vector<unsigned> functionToRun;

	// default constructor
	RunParameter();

	// default destructor
	~RunParameter();

};
#endif
