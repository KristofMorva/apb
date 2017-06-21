#include "Database.h"

Database::Database(char* filename)
{
	database = NULL;
	open(filename);
}

bool Database::open(char* filename)
{
	return sqlite3_open(filename, &database) == SQLITE_OK;
}

std::string Database::query(char* query)
{
	sqlite3_stmt *statement;
	std::string response;
	int code = sqlite3_prepare_v2(database, query, -1, &statement, 0);
	
	if (code == SQLITE_OK)
	{
		int cols = sqlite3_column_count(statement);
		int result;
		for (int i = 0;;++i)
		{
			result = sqlite3_step(statement);
			
			if (result == SQLITE_ROW)
			{
				response += 0x1E;
				for (int col = 0; col < cols; ++col)
				{
					if (col) response += 0x1F;
					const void* str = sqlite3_column_text(statement, col);
					response += str ? (char*)str : "";
				}
			}
			else break;
		}
		
		sqlite3_finalize(statement);
	}
	else
	{
		std::cout << "[SQL ERROR] " << sqlite3_errmsg(database) << std::endl;
	}
	
	return response;
}

void Database::close()
{
	sqlite3_close(database);
}