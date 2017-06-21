#include <string>
#include <vector>
#include <iostream>
#include <sqlite3.h>

class Database
{
public:
	Database(char* filename);
	
	bool open(char* filename);
	std::string query(char* query);
	void close();
	
private:
	sqlite3 *database;
};