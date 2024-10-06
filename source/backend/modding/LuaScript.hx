package backend.modding;

import llua.Lua.Lua_helper;
import llua.*;
import flixel.FlxBasic;

class LuaScript extends FlxBasic
{
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;

	var lua:State;

    public function new(file:String) {
        super();

        lua = LuaL.newstate();
		LuaL.openlibs(lua);
		Lua.init_callbacks(lua);

		try
		{
			var result:Dynamic = LuaL.dofile(lua, file);
			var resultStr:String = Lua.tostring(lua, result);
			if (resultStr != null && result != 0)
			{
				trace('lua error!!! ' + resultStr);
				Lib.application.window.alert(resultStr, "Error!");
				lua = null;
				return;
			}
		}
		catch (e)
		{
			trace(e.message);
			Lib.application.window.alert(e.message, "Error!");
			return;
		}

		trace('Script Loaded Succesfully: $file');
    }

    function add_callback(name:String, eventToDo:Dynamic)
		return Lua_helper.add_callback(lua, name, eventToDo);

    function set_variable(name:String, value:Dynamic)
    {
        if(lua == null) {
			return;
		}

		Convert.toLua(lua, value);
		Lua.setglobal(lua, name);
    }

    // Friday Night Funkin' Psych Engine Code
	public function call(event:String, args:Array<Dynamic>):Dynamic
    {
        if (lua == null)
        {
            return Function_Continue;
        }

        Lua.getglobal(lua, event);

        for (arg in args)
        {
            Convert.toLua(lua, arg);
        }

        var result:Null<Int> = Lua.pcall(lua, args.length, 1, 0);
        if (result != null && resultIsAllowed(lua, result))
        {
            if (Lua.type(lua, -1) == Lua.LUA_TSTRING)
            {
                var error:String = Lua.tostring(lua, -1);
                if (error == 'attempt to call a nil value')
                { // Makes it ignore warnings and not break stuff if you didn't put the functions on your lua file
                    return Function_Continue;
                }
            }
            var conv:Dynamic = Convert.fromLua(lua, result);
            return conv;
        }
        return Function_Continue;
    }

    function resultIsAllowed(leLua:State, leResult:Null<Int>)
    { // Makes it ignore warnings
        switch (Lua.type(leLua, leResult))
        {
            case Lua.LUA_TNIL | Lua.LUA_TBOOLEAN | Lua.LUA_TNUMBER | Lua.LUA_TSTRING | Lua.LUA_TTABLE:
                return true;
        }
        return false;
    }
}