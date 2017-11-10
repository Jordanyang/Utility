/*
该头文件的主要功能是进行准确的计时
用法如下：
在需要计时的代码前定义MyTimer对象t1,并设置开始计时，即t.start();
在代码结尾加上t.stop()。获得计时时间间隔为t.elapse()。单位为毫秒:ms
*/
#pragma once
#ifndef _MY_TIMER
#define  _MY_TIMER
#include <iostream>        
#include <sys/time.h>        //gettimeofday()
#include <stdio.h>
#include<unistd.h> 
class MyTimer
{
private:
	struct timeval tpstart, tpend;
	double timeuse;
public:

	MyTimer()
	{
		timeuse=0;
	}

	inline void start()
	{
		gettimeofday(&tpstart, NULL);
	}

	inline void stop()
	{
		gettimeofday(&tpend, NULL);
	}

	inline double elapse()
	{
		return timeuse=1000*(tpend.tv_sec - tpstart.tv_sec) + (tpend.tv_usec - tpstart.tv_usec)*0.001;//注意，秒的读数和微秒的读数都应计算在内
		return timeuse;
		
	}

};
#endif