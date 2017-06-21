#include "SKCommon.h"

bool SKCommon::strContains(std::string& str, char c)
{
	return str.find(c) != std::string::npos;
}

void SKCommon::splitStr(std::string& str, std::vector<std::string>& res, char del)
{
	std::stringstream ss(str);
	std::string item;
	while (std::getline(ss, item, del))
	{
		res.push_back(item);
	}
}

bool SKCommon::startsWith(std::string& str, std::string& start)
{
	return str.substr(0, (start).length()) == start;
}