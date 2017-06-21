#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <map>

using namespace std;

bool isVar(const char c)
{
	return c >= '0' && c <= '9' || c >= 'a' && c <= 'z';
}

int main(int argc, char* argv[])
{
	cout << "APB Mod: Glass break FX generator" << endl << endl;
	ifstream f("glass.txt");
	if (f.is_open())
	{
		map<string, float> to;
		cout << "Width: ";
		cin >> to["w2"];
		cout << "Height: ";
		cin >> to["h2"];
		to["w"] = to["w2"] / 2;
		to["h"] = to["h2"] / 2;
		to["sw"] = to["w"] - 5;
		to["sh"] = to["h"] - 5;
		to["sw2"] = to["sw"] * 2;
		to["sh2"] = to["sh"] * 2;
		to["smoke"] = min(to["h"], to["w"]) * 1.6f;
		to["large"] = min(to["h"], to["w"]) / 25;
		to["huge"] = to["large"] * 2;
		stringstream ss;
		ss << f.rdbuf();
		f.close();
		string s = ss.str();
		size_t n = s.size();
		for (size_t i = 0; i < n; ++i)
		{
			if (s[i] == '%')
			{
				size_t j = i;
				string x = "";
				while (++i < n && isVar(s[i])) { x += s[i]; };
				string t = to_string(to[x]);
				s.replace(j, x.size() + 1, t);
				i += t.size() - (x.size() + 1);
			}
		}
		ofstream g("glass_break_" + to_string((int)to["w2"]) + "_" + to_string((int)to["h2"]) + ".efx");
		if (g.is_open())
		{
			g << s;
			g.close();
		}
		else
		{
			cout << "ERROR: Can't write fx file";
			getchar();
		}
		cout << endl;
		f.close();
	}
	else
	{
		cout << "ERROR: glass.txt not found";
		getchar();
	}
}