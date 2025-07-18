global.debug = 0;
global.is_console = scr_is_switch_os() || os_type == os_ps4 || os_type == os_ps5;

if (!variable_global_exists("bgm") || !audio_exists(global.bgm))
    global.bgm = -4;

scr_init_localization();
scr_init();
_current_state = UnknownEnum.Value_0;
_chapter_in_progress = 0;
_chapter_completed = 0;
_target_chapter = -1;
_restart_room = false;
_launch_data = scr_init_launch_parameters();
_pending_titles = [];
_pending_title = -4;

init = function()
{
    var max_chapter = UnknownEnum.Value_7;
    var max_available_chapter = UnknownEnum.Value_4;
    _current_state = UnknownEnum.Value_1;
    
    for (var i = 0; i < max_available_chapter; i++)
    {
        var chapter = i + 1;
        
        if (scr_chapter_save_file_exists(chapter) && !scr_completed_chapter_any_slot(chapter))
            _chapter_in_progress = chapter;
    }
    
    if (_chapter_in_progress > 0)
        _current_state = UnknownEnum.Value_2;
    
    for (var i = 0; i < max_available_chapter; i++)
    {
        var chapter = i + 1;
        
        if (scr_completed_chapter_any_slot(chapter))
            _chapter_completed = chapter;
    }
    
    if (_chapter_completed > 0)
    {
        _current_state = UnknownEnum.Value_3;
        
        if (_chapter_completed >= max_available_chapter)
            _current_state = UnknownEnum.Value_4;
    }
    
    if (!is_original_launcher(_launch_data))
        _current_state = UnknownEnum.Value_4;
    
    change_state(_current_state);
};

change_state = function(arg0, arg1)
{
    _current_state = arg0;
    
    switch (_current_state)
    {
        case UnknownEnum.Value_4:
            with (obj_screen_start)
                clean_up();
            
            start_bgm();
            create_select_screen();
            break;
        
        case UnknownEnum.Value_1:
            stop_bgm();
            create_start_screen();
            break;
        
        case UnknownEnum.Value_2:
            stop_bgm();
            create_continue_screen();
            break;
        
        case UnknownEnum.Value_3:
            stop_bgm();
            create_start_next_screen();
            break;
        
        case UnknownEnum.Value_5:
            with (obj_screen_start)
                clean_up();
            
            _pending_titles = arg1;
            
            if (scr_is_switch_os())
            {
                if (array_length(_pending_titles) > 1)
                    _load_type = UnknownEnum.Value_1;
            }
            
            if (_load_type == UnknownEnum.Value_0)
            {
                _pending_title = _pending_titles[0];
                var adjusted_list = [];
                
                for (var i = 0; i < array_length(_pending_titles); i++)
                {
                    if (_pending_titles[i] == _pending_title)
                        continue;
                    
                    adjusted_list[array_length(adjusted_list)] = _pending_titles[i];
                }
                
                _pending_titles = adjusted_list;
                create_load_prompt_screen(_pending_title.title);
            }
            else
            {
                create_load_prompt_multiple_screen(_pending_titles);
            }
            break;
        
        case UnknownEnum.Value_6:
            with (obj_screen_start)
                clean_up();
            
            create_load_deny_confirm_screen();
            break;
        
        case UnknownEnum.Value_0:
            with (obj_screen_start)
                clean_up();
            
            break;
    }
};

create_start_screen = function()
{
    var start_text = scr_get_lang_string("Would you like to start from Chapter 1?", "gml_Object_obj_CHAPTER_SELECT_Create_0_0");
    var yes_text = scr_get_lang_string("Yes", "gml_Object_obj_CHAPTER_SELECT_Create_0_1");
    var no_text = scr_get_lang_string("No", "gml_Object_obj_CHAPTER_SELECT_Create_0_2");
    var language_config_text = scr_get_lang_string("Language", "obj_lang_settings_0_0");
    var choices = [new create_choice(yes_text, UnknownEnum.Value_0), new create_choice(no_text, UnknownEnum.Value_1), new create_choice(language_config_text, UnknownEnum.Value_2)];
    var start_screen = instance_create(0, 0, obj_screen_start);
    start_screen.init(id, start_text, choices, -26, -40);
    start_screen.adjust_choices_x();
    start_screen.fade_in();
};

create_continue_screen = function()
{
    var continue_text = scr_get_lang_string("Continue from Chapter ", "gml_Object_obj_CHAPTER_SELECT_Create_0_3") + string(_chapter_in_progress) + scr_get_lang_string("?", "gml_Object_obj_CHAPTER_SELECT_Create_0_4");
    var yes_text = scr_get_lang_string("Yes", "gml_Object_obj_CHAPTER_SELECT_Create_0_1");
    var no_text = scr_get_lang_string("No", "gml_Object_obj_CHAPTER_SELECT_Create_0_2");
    var language_config_text = scr_get_lang_string("Language", "obj_lang_settings_0_0");
    var choices = [new create_choice(yes_text, UnknownEnum.Value_0), new create_choice(no_text, UnknownEnum.Value_1), new create_choice(language_config_text, UnknownEnum.Value_2)];
    var start_screen = instance_create(0, 0, obj_screen_start);
    start_screen.init(id, continue_text, choices, -26, -40);
    start_screen.adjust_choices_x();
    start_screen.fade_in();
};

create_start_next_screen = function()
{
    var continue_text = scr_get_lang_string("Chapter ", "gml_Object_obj_CHAPTER_SELECT_Create_0_5") + string(_chapter_completed) + scr_get_lang_string(" was completed.", "gml_Object_obj_CHAPTER_SELECT_Create_0_6");
    var play_next_text = string(scr_get_lang_string("Play Chapter {0}", "gml_Object_obj_CHAPTER_SELECT_Create_0_7"), string(_chapter_completed + 1));
    var chapter_select_text = scr_get_lang_string("Chapter Select", "gml_Object_obj_CHAPTER_SELECT_Create_0_8");
    var choices = [new create_choice(play_next_text, UnknownEnum.Value_0), new create_choice(chapter_select_text, UnknownEnum.Value_1)];
    var start_screen = instance_create(0, 0, obj_screen_start);
    start_screen.init(id, continue_text, choices, -26, 0);
    start_screen.adjust_choices_x();
    start_screen.fade_in();
};

create_select_screen = function()
{
    var select_screen = instance_create(0, 0, obj_screen_select);
    select_screen.init(id);
    select_screen.fade_in();
};

create_load_prompt_screen = function(arg0)
{
    var load_text = scr_get_app_title(arg0) + scr_get_lang_string("Save Data found.\nImport this Save Data?\n(This will only be asked once.)", "gml_Object_obj_CHAPTER_SELECT_Create_0_9");
    
    var yes_text = scr_get_lang_string("Yes", "gml_Object_obj_CHAPTER_SELECT_Create_0_1");
    var no_text = scr_get_lang_string("No", "gml_Object_obj_CHAPTER_SELECT_Create_0_2");
    var choices = [new create_choice(yes_text, UnknownEnum.Value_0), new create_choice(no_text, UnknownEnum.Value_1)];
    var choice_offset = -26;
    var start_screen = instance_create(0, 0, obj_screen_start);
    start_screen.init(id, load_text, choices, choice_offset);
    start_screen.fade_in();
};

create_load_deny_confirm_screen = function()
{
    var deny_text = scr_get_lang_string("Proceed without importing?", "gml_Object_obj_CHAPTER_SELECT_Create_0_10");
    var yes_text = scr_get_lang_string("Yes", "gml_Object_obj_CHAPTER_SELECT_Create_0_1");
    var no_text = scr_get_lang_string("No", "gml_Object_obj_CHAPTER_SELECT_Create_0_2");
    var choices = [new create_choice(yes_text, UnknownEnum.Value_0), new create_choice(no_text, UnknownEnum.Value_1)];
    var choice_offset = -26;
    var start_screen = instance_create(0, 0, obj_screen_start);
    start_screen.init(id, deny_text, choices, choice_offset);
    start_screen.fade_in();
};

trigger_event = function(arg0, arg1)
{
    var event_name = arg0;
    var event_value = arg1;
    
    switch (_current_state)
    {
        case UnknownEnum.Value_0:
            if (arg0 == "init_complete")
                init();
            else if (arg0 == "load_prompt")
                change_state(UnknownEnum.Value_5, arg1);
            
            break;
        
        case UnknownEnum.Value_5:
            if (event_value == UnknownEnum.Value_0)
            {
                global.savedata = _pending_title.save_data;
                _restart_room = true;
                change_state(UnknownEnum.Value_0);
                
                with (obj_init_console)
                    convert_loaded_file();
            }
            else if (array_length(_pending_titles) > 0)
            {
                change_state(UnknownEnum.Value_0);
                trigger_event("load_prompt", _pending_titles);
            }
            else
            {
                change_state(UnknownEnum.Value_6);
            }
            
            break;
        
        case UnknownEnum.Value_6:
            if (event_value == UnknownEnum.Value_0)
            {
                _restart_room = true;
                change_state(UnknownEnum.Value_0);
                
                with (obj_init_console)
                    create_new_save_file();
            }
            else
            {
                room_restart();
            }
            
            break;
        
        case UnknownEnum.Value_1:
            if (event_value == UnknownEnum.Value_0)
            {
                _target_chapter = UnknownEnum.Value_1;
                show_transition();
            }
            else if (event_value == UnknownEnum.Value_1)
            {
                change_state(UnknownEnum.Value_4);
            }
            else if (event_value == UnknownEnum.Value_2)
            {
                toggle_language();
            }
            
            break;
        
        case UnknownEnum.Value_2:
            if (event_value == UnknownEnum.Value_0)
            {
                _target_chapter = _chapter_in_progress;
                show_transition();
            }
            else if (event_value == UnknownEnum.Value_1)
            {
                change_state(UnknownEnum.Value_4);
            }
            else if (event_value == UnknownEnum.Value_2)
            {
                toggle_language();
            }
            
            break;
        
        case UnknownEnum.Value_3:
            if (event_value == UnknownEnum.Value_0)
            {
                _target_chapter = _chapter_completed + 1;
                show_transition();
            }
            else
            {
                change_state(UnknownEnum.Value_4);
            }
            
            break;
        
        case UnknownEnum.Value_4:
            if (event_name == "launch_game")
            {
                _target_chapter = event_value;
                show_transition();
            }
            else if (event_value == UnknownEnum.Value_4)
            {
                quit();
            }
            else if (event_value == UnknownEnum.Value_5)
            {
                toggle_language();
            }
            
            break;
    }
};

show_transition = function()
{
    if (instance_exists(obj_screen_transition))
        exit;
    
    if (global.bgm != -4)
        audio_sound_gain(global.bgm, 0, 500);
    
    var sound_file = get_chapter_confirm_sound(_target_chapter);
    var volume = 1;
    
    if (_target_chapter == 3)
        volume = 0.7;
    
    audio_play_sound(sound_file, 50, 0, volume);
    var delay = round(audio_sound_length(sound_file) * room_speed);
    var transition = instance_create(0, 0, obj_screen_transition);
    transition.init(id, _target_chapter, delay);
    transition.start(launch_game);
};

launch_game = function(arg0)
{
    audio_stop_all();
    var chapstring = string(_target_chapter);
    show_debug_message("Attempting to launch Chapter " + string(arg0));
    var parameters = get_chapter_switch_parameters();
    
    if (scr_is_switch_os())
    {
        game_change("rom:/chapter" + chapstring + "_switch/", parameters);
    }
    else
    {
        switch (os_type)
        {
            case os_windows:
                game_change("/chapter" + chapstring + "_windows", "-game data.win" + parameters);
                break;
            
            case os_ps4:
                game_change("", "-game /app0/games/chapter" + chapstring + "_ps4/game.win" + parameters);
                break;
            
            case os_ps5:
                game_change("", "-game /app0/games/chapter" + chapstring + "_ps5/game.win" + parameters);
                break;
            
            case os_macosx:
                game_change("chapter" + chapstring + "_mac", parameters);
                break;
        }
    }
};

quit = function()
{
    game_end();
};

toggle_language = function()
{
    instance_create_depth(0, 0, 0, asset_get_index("obj_lang_settings"));
};

start_bgm = function()
{
    if (global.bgm == -4 || !audio_is_playing(global.bgm))
        global.bgm = audio_play_sound(AUDIO_DRONE, 15, 1);
};

stop_bgm = function()
{
    if (global.bgm != -4)
    {
        audio_stop_sound(global.bgm);
        global.bgm = -4;
    }
};

if (global.is_console)
{
    var console_init = instance_create(0, 0, obj_init_console);
    console_init.init(id, _launch_data);
}
else
{
    var pc_init = instance_create(0, 0, obj_init_pc);
    pc_init.init(id, _launch_data);
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_3,
    Value_4,
    Value_5,
    Value_6,
    Value_7
}
