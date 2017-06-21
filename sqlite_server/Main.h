#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <sstream>
#include <string>
#include <map>
#include <algorithm>
#include <vector>

#include "SKUDP.h"
#include "SKCommon.h"
#include "Database.h"

#define BUFLEN 8096

Database* db;
SKUDP::SOCKET apb;
int apb_port;

int main(int, char*[]);
void received(SKUDP::SOCKET&, char*, sockaddr_in&, void*);
void sendPacket(sockaddr_in&, const char*);
void errorLog(const char*);