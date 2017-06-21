#include "Main.h"

int main(int argc, char* argv[])
{
	int apb_port;
	if (argc == 1) apb_port = 7425;
	else if (argc == 2)
	{
		int port = atoi(argv[1]);
		if (port > 1000 && port <= 65535) apb_port = port;
		else
		{
			std::cout << argv[1] << " is not a valid port." << std::endl;
			std::cout << "Press ENTER to quit." << std::endl;
			std::cin.get();
			return 0;
		}
	}
	else
	{
		std::cout << "Invalid number of arguments." << std::endl;
		std::cout << "Usage: APBServer [port]" << std::endl;
		std::cout << "Press ENTER to quit." << std::endl;
		std::cin.get();
		return 0;
	}
	
	SKUDP::init();

	if ((apb = SKUDP::setup(apb_port)) == BADSOCKET)
	{
		errorLog("Setup() failed for apb");
		return 1;
	}
	
	std::cout << "[INFO] APB running on port " << apb_port << std::endl;
	
	db = new Database("apb.db");
	
	SKUDP::receive(apb, BUFLEN, received, NULL);
	
	db->close();
	
	return 0;
}

void received(SKUDP::SOCKET& socket, char* RecvBuf, sockaddr_in& SenderAddr, void* state)
{
	char* packet = RecvBuf + 1;
	std::cout << "[RECEIVED] " << packet << std::endl;
	
	if (RecvBuf[0] == 0x12) db->query(packet);
	else sendPacket(SenderAddr, db->query(packet).c_str());
}

void sendPacket(sockaddr_in& recvAddr, const char* buf)
{
	if (!SKUDP::send(apb, recvAddr, buf))
	{
		errorLog("SendPacket() failed");
		return;
	}
	std::cout << "[SENT] " << buf << std::endl;
}

void errorLog(const char* err)
{
	std::cout << "[ERROR] " << err << std::endl;
}