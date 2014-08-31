// NOT USED CURRENTLY!

// Unset array item by element
unsetArrayItem(array, value, sort)
{
	if (array.size <= 1)
		return [];

	if (!isDefined(sort))
		sort = true;

	found = false;
	for (i = 0; i < array.size; i++)
	{
		if (found)
		{
			array[i - 1] = array[i];
		}
		else if (array[i] == value)
		{
			if (!sort)
			{
				array[i] = array[array.size - 1];
			}
			found = true;
		}
	}
	array[array.size - 1] = undefined;
	return array;
}

// Unset array item by index
unsetArrayItemIndex(array, id, sort)
{
	if (array.size <= 1)
		return [];

	if (!isDefined(sort))
		sort = true;

	if (id != array.size - 1)
	{
		if (!sort)
		{
			array[id] = array[array.size - 1];
		}
		else
		{
			for (i = id; i < array.size - 1; i++)
			{
				array[i] = array[i + 1];
			}
		}
	}
	array[array.size - 1] = undefined;
	return array;
}

// Close every menus
closeMenus()
{
	self closeMenu();
	self closeInGameMenu();
}