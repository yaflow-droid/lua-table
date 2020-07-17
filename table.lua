function table:createArray(n, val)
  -- Creates an table of size n
  --
  -- :param n: number of elements in the new table
  -- :param val: either a fixed value or a function that takes the index and outputs the value
  -- :type n: Number
  -- :type val: Any (non Nil)
  -- 
  -- :return: generated table
  -- :rtype: Table
	if not (type(val) == "function") then
		local list = {};
		for i=1,n do
			list[i] = val
		end
		return list;
	end
	
	function __func(i, ...)
		return i;
	end
	local func = val or __func;
	local list = {};
	
	for i=1,n do
		list[i] = func(i, n, list);
	end
	return list;
end

function table:getn(list)
  -- returns the length of a table containing no nil values
  --
  -- :param list: the table to get the length of. indexes are the default one and no nil values are stored
  -- :type n: Table
  --
  -- :return: the length of the table (its max value)
  -- :rtype: Number
	local i = 1;
	while not (list[i] == nil) do
		i = i+1;
	end
	return i - 1;
end

function table:remove(list, n)
  -- Removes the value at the index n 
  --
  -- :param list: table to remove the item from
  -- :param n: index of the element to remove
  -- :type table: Table
  -- :type n: Number
  --
  -- :return: if the operation was successful or not
  -- :rtype: Boolean
	if n < 0 or n > table:getn(list) then
		return false
	end
	list[n] = nil;
	n = n+1;
	while not (list[n] == nil) do
		if n > 1 then
			list[n - 1] = list[n];
		end
		n = n + 1;
	end
	list[n - 1] = nil;
	return true
end

function table:insert(list, n, val)
  -- Inserts val at index n in the list
  --
  -- :param list: list to insert the element in
  -- :param n: index of the new value
  -- :param val: the added value
  -- :type table: Table
  -- :type n: Number
  -- :type val: Any (Non nil)
  --
  -- :return: success of the operation
  -- :rtype: Boolean
	if n > table:getn(list) then
		return false;
	end
	for i=table:getn(list),n,-1 do
		list[i + 1] = list[i];
	end
	list[n] = val or nil;
	return true;
end

function table:append(list, val)
  -- Appends val to the end of the list
  --
  -- :param list: table to append to
  -- :param val: either a fixed value or a function that takes the index and outputs the value
  -- :type list: Table
  -- :type val: Any (Non nil)
  --
  -- :return: success of the operation
  -- :rtype: Boolean
	list[table:getn(list) + 1] = val or nil;
	return true
end

function table:foreach(list, func)
  -- Applies the function foreach to every elements of the list
  -- 
  -- :param list: table to apply the function to
  -- :param func: function that is presented like this:
  --    :param1: value at one index
  --    :param2: current index @optional
  --    :param3: list @optional
  -- :type list: Table
  -- :type func: function
  --    :param1: Any (Non Nil)
  --    :param2: Number
  --    :param3: Table
  -- :return: nil
  -- :rtype: nil  
	for i=1,table:getn(list) do
		func(list[i], i, list);
	end
end

function table:map(list, func)
  -- Maps the function on the list
  -- 
  -- :param list: table to map the function to
  -- :param func: function that is presented like this:
  --    :param1: value at one index
  --    :param2: current index @optional
  --    :param3: list @optional
  --    :return: Any
  -- :type list: Table
  -- :type func: function
  --    :param1: Any (Non Nil)
  --    :param2: Number
  --    :param3: Table
  --    :rtype: Any (Non Nil)
  -- :return: new table
  -- :rtype: Table
	local _list = table:createArray(table:getn(list), 0);
	for i=1,table:getn(list) do
		_list[i] = func(list[i], i, list);
	end
	return _list;
end

function table:find(list, func)
  -- Returns the first value for which func returns true
  -- 
  -- :param list: table to map the function to
  -- :param func: function that is presented like this:
  --    :param1: value at one index
  --    :param2: current index @optional
  --    :param3: list @optional
  --    :return: if the value is found or not
  -- :type list: Table
  -- :type func: function
  --    :param1: Any (Non Nil)
  --    :param2: Number
  --    :param3: Table
  --    :rtype: Boolean
  -- :return: the first value in the list that func(val, i, table) returns true for
  -- :rtype: Any (Non Nil)
	local i = 1;
	while not func(list[i], i, list) and not (list[i] == nil) do
		i = i + 1;
	end
	if list[i] == nil then
		return -1;
	else
		return i;
	end
end

function table:reduce(list, func, acc)
  -- Reduces the list into the accumulator using the function
  -- the return value of the function gets fed into the acc value of the next
  -- 
  -- :param list: table to reduce
  -- :param func: function that is presented like this:
  --    :param1: accumulator
  --    :param2: value at one index
  --    :param3: current index @optional
  --    :param4: list @optional
  --    :return: Any
  -- :type list: Table
  -- :type func: function
  --    :param1: Any
  --    :param2: Any (Non Nil)
  --    :param3: Number
  --    :param4: Table
  --    :rtype: Any
  -- :return: final value of the accumulator
  -- :rtype: Any
	for i = 1, table:getn(list) do
		acc = func(acc, list[i], i, list);
	end
	return acc;
end

function table:findall(list, func)
  -- Finds all the value that make the func output true
  -- 
  -- :param list: table to find values in
  -- :param func: function that is presented like this:
  --    :param1: value at one index
  --    :param2: current index @optional
  --    :param3: list @optional
  --    :return: Any
  -- :type list: Table
  -- :type func: function
  --    :param1: Any (Non Nil)
  --    :param2: Number
  --    :param3: Table
  --    :rtype: Any (Non Nil)
  -- :return: new table with all the values that are true
  -- :rtype: Table
	function add(acc, val, i, list)
		if func(val, i, list) then
			table:append(acc, val);
		end
		return acc;
	end
	
	return table:reduce(_list, add, {});
end
