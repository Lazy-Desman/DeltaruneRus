function c_msgsetloc(argument0, argument1, argument2) //gml_Script_c_msgsetloc
{
    var msg_index = argument0
    var english = argument1
    var localized_string_id = argument2
    var str = english
    str = scr_get_lang_string(str, localized_string_id)
    c_msgset(msg_index, str)
}

