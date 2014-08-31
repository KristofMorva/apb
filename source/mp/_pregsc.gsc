&ADMIN_COLOR = 1;
&ADMIN_PLAYERS = 2;
&ADMIN_SPEC = 4;
&ADMIN_BUGS = 8;

inline unsetArrayItem(array, value)
{{
	__c = array.size;
	if (__c > 1)
	{
		for (i = 0; i < __c; i++)
		{
			if (array[i] == value)
			{
				last = __c - 1;
				if (i < last)
					array[i] = array[last];

				array[last] = undefined;
				break;
			}
		}
	}
	else
	{
		array = [];
	}
}}

inline unsetArrayItemOrdered(array, value)
{{
	__c = array.size;
	if (__c > 1)
	{
		for (i = 0; i < __c; i++)
		{
			if (array[i] == value)
			{
				last = __c - 1;
				if (i < last)
				{
					while (i < last)
					{
						array[i] = array[i + 1];
						i++;
					}
				}

				array[last] = undefined;
				break;
			}
		}
	}
	else
	{
		array = [];
	}
}}

inline unsetArrayItemIndex(array, value)
{{
	__c = array.size - 1;

	if (value != __c)
		array[value] = array[__c];

	array[__c] = undefined;
}}

inline unsetArrayItemIndexOrdered(array, value)
{{
	__c = array.size - 1;

	if (value == __c)
	{
		array[value] = undefined;
	}
	else
	{
		for (__i = __c; __i < __c; __i++)
		{
			array[__i] = array[__i + 1];
		}
	}
}}