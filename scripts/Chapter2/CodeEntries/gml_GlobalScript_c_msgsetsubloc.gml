var args;
function c_msgsetsubloc() //gml_Script_c_msgsetsubloc
{
    var len = argument_count
    for (var i = 0; i < len; i++)
        args[i] = argument[i]
    var msg_index = argument[0]
    var format_string = argument[1]
    var localized_format_string_id = argument[(len - 1)]
    format_string = scr_get_lang_string(format_string, localized_format_string_id)
    format_string = get_numeric_str(format_string, localized_format_string_id, args[2])
    var str = substringargs(format_string, 2, args)
    c_msgset(msg_index, str)
}

