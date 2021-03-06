#pragma once

#include <iostream>
#include <cstring>

#ifdef WIN32
#include <WS2tcpip.h>
#include <WinSock2.h>
#pragma comment(lib, "Ws2_32.lib")
#else
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#endif

namespace SKUDP
{
#ifdef WIN32
	#define BADSOCKET NULL
	typedef SOCKET SOCKET;
#else
	#define BADSOCKET -1
	#define INVALID_SOCKET -1
	#define SOCKET_ERROR -1
	typedef int SOCKET;
#endif

	bool init();
	std::string ntop(in_addr&);
	SOCKET setup(unsigned short);
	bool send(SOCKET&, sockaddr_in&, const char*);
	void receive(SOCKET&, int, void(*)(SOCKET&, char*, sockaddr_in&, void*), void*);
};