/*
��ͷ�ļ�����Ҫ�����ǽ���׼ȷ�ļ�ʱ
�÷����£�
����Ҫ��ʱ�Ĵ���ǰ����MyTimer����t1,�����ÿ�ʼ��ʱ����t.start();
�ڴ����β����t.stop()����ü�ʱʱ����Ϊt.elapse()����λΪ����:ms
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
		return timeuse=1000*(tpend.tv_sec - tpstart.tv_sec) + (tpend.tv_usec - tpstart.tv_usec)*0.001;//ע�⣬��Ķ�����΢��Ķ�����Ӧ��������
		return timeuse;
		
	}

};
#endif