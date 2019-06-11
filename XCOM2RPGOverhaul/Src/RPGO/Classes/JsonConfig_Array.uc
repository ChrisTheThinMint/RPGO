//-----------------------------------------------------------
//	Class:	JsonConfig_Array
//	Author: Musashi
//	
//-----------------------------------------------------------
class JsonConfig_Array extends Object;

var protectedwrite array<string> ArrayValue;

public function SetArrayValue(array<string> StringArray)
{
	ArrayValue =  StringArray;
}

public function array<string> GetArrayValue()
{
	return ArrayValue;
}

public function string ToString()
{
	return Join(ArrayValue, ", ");
}

public function Serialize(out JsonObject JsonObject, string PropertyName)
{
	if (ArrayValue.Length > 0)
	{
		JSonObject.SetStringValue(PropertyName, Join(ArrayValue, ", "));
	}
}

public function bool Deserialize(out JSonObject Data, string PropertyName)
{
	local string UnserializedArrayValue;
	
	UnserializedArrayValue = Data.GetStringValue(PropertyName);
	if (UnserializedArrayValue != "")
	{
		ArrayValue = SplitString(Repl(Repl(UnserializedArrayValue, " ", ""), "	", ""), ",", true);
		return true;
	}

	return false;
}

function static string Join(array<string> StringArray, optional string Delimiter = ",", optional bool bIgnoreBlanks = true)
{
	local string Result;

	JoinArray(StringArray, Result, Delimiter, bIgnoreBlanks);

	return Result;
}

