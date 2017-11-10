#include <iostream>
#include<fstream>
#include<vector>
#include<string>
#include <Eigen/Dense>
#include"MyTime.h"
using namespace Eigen;
using namespace std;
#define NUM_SIZE 15000
void save_to_text(std::string filename, std::vector<double> &p);
/* void test(MatrixXd &m,MatrixXd &v)
{
	MatrixXd r = m*v;
} */
int main()
{
	
	MyTimer t;
	vector<double> mytime;
	int ar_num=150;
	MatrixXd v = MatrixXd::Random(NUM_SIZE, NUM_SIZE);
	MatrixXd r;
	v = (v + MatrixXd::Constant(NUM_SIZE, NUM_SIZE, 2.1)) * 60;
	for(int i=0;i<100;i++)
	{
		MatrixXd m = MatrixXd::Random(ar_num*(i+1), NUM_SIZE);
	    m = (m + MatrixXd::Constant(ar_num*(i+1), NUM_SIZE, 1.2)) * 50;
	    t.start();
	    r = m*v;
	    t.stop();
		mytime.push_back(t.elapse());
	}
	save_to_text("cpuTime.txt", mytime);
	return 0;
}
void save_to_text(std::string filename, std::vector<double> &p)
{
	using namespace std;
	fstream outfile;
	string tempfilenanme = filename;
	outfile.open(tempfilenanme, ios::out | ios::trunc);
	for (auto i = 0; i < p.size(); i++)
		outfile << p[i] << "\r"<<endl;
	outfile.close();
}	