/*
  CEC17 Test Function Suite for Single Objective Optimization- Bound constraints 
  Noor Awad (email: noor0029@e.ntu.edu.sg) 
  Last update on 29_6_2017
*/

Please put cec17_func.cpp and input_data folder with your algorithm in the same folder. Set this folder as the current path.
1. run the following command in Matlab window:
   mex cec17_func.cpp -DWINDOWS
2. Then you can use the test functions as the following example:
   f = cec17_func(x,func_num); 
   here x is a D*pop_size matrix.
3. main.m is an example test code with PSO algorithm.

