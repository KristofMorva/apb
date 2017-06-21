#pragma once

#include <sstream>
#include <vector>

namespace SKCommon
{
	bool strContains(std::string&, char);
	void splitStr(std::string&, std::vector<std::string>&, char);
	bool startsWith(std::string&, std::string&);
}