/*
 * Copyright (c) 2011 Wenxiang Chen 
 * http://cs-chen.net
 * chenwx.ustc@gmail.com
 *
 * GNU LESSER GENERAL PUBLIC LICENSE (Version 2.1, February 1999)
 */

#include "RunParameter.h"

// default constructor
RunParameter::RunParameter(){
//	cout<<"Class RunParameter Initialization"<<endl;

//	cout<<"Read from File configFile, and load the parameters' settings"<<endl;
	ifstream configFile("configure.ini");
	string tempStr;
	char* strArray;

	if (configFile.is_open()){
		while(configFile.good()){
			getline(configFile, tempStr);
			/*
			   cout<<tempStr.c_str()<<endl;
			   cout<<"String Size = "<<tempStr.size()<<endl;
			   cout<<"---------------------"<<endl;
			   */
			string::iterator strIter = tempStr.begin();

			if (*strIter!='#' && tempStr.size()!=0){
//				cout<<"Not Comment Line"<<endl;
				// if current line is not comment
				strArray = strtok(const_cast<char *>(tempStr.c_str()), " ");
				bool init = false;
				string confType;
				while (strArray!=NULL){
//					cout<<"Str is not NULL"<<endl;

					if (init == true){
//						cout<<"confType = "<<confType.c_str()<<endl;
						if (strcmp(confType.c_str(), "dimension")==0){
							dimension = atoi (strArray);
						}else if (strcmp(confType.c_str(), "functionToRun")==0){
							functionToRun.push_back(atoi (strArray));
						}else if (strcmp(confType.c_str(), "numOfRun")==0){
							numOfRun = atoi (strArray);
						}else if (strcmp(confType.c_str(), "numberofPopulation")==0){
							NP = atoi(strArray);
						}else if (strcmp(confType.c_str(), "initialGroupSize")==0){
							initialGroupSize = atoi (strArray);
						}else if (strcmp(confType.c_str(), "fitnessCheckPoint")==0){
//							cout<<"Check point = "<<atoi (strArray)<<endl;
//							cout<<"Check point = "<<strtod(strArray)<<endl;
							fitnessCheckPoint.push_back(atoi (strArray));
//							fitnessCheckPoint.push_back(strtod(strArray));
						}else if (strcmp(confType.c_str(), "samplingInterval")==0){
							samplingInterval = atoi (strArray);
						}else if (strcmp(confType.c_str(), "initRandomSeed")==0){
							initRandomSeed = atoi (strArray);
						}else if (strcmp(confType.c_str(), "nonSeparableGroupSize")==0){
							nonSeparableGroupSize = atoi (strArray);
						}else {
							cerr<<"Configuration Parameter not found: "<<strArray<<endl;
							exit(-1);
						}

					}else{
						init = true;	
						confType = strArray;
					}
					strArray = strtok(NULL, " ");
				}
			}
		}
	}else{
		cout<<"Fail to open configFile.ini file"<<endl;
		configFile.close();
	}
}

// default destructor
RunParameter::~RunParameter() {
	functionToRun.clear();
	fitnessCheckPoint.clear();
//	cout<<"Class RunParameter Destroyed"<<endl;
} 
