#load "../BaseFix.csx"

using System.Linq;

#region И ещё говнинка

// Пазлы
GetOrig("gml_Object_obj_ch2_keyboardpuzzle_monologue_controller_Create_0");
AppendToEnd("gml_Object_obj_ch2_keyboardpuzzle_monologue_controller_Create_0", @"
    keys_symbols = stringsetloc(""DECEMBER"", ""obj_ch2_keyboard_cutscene_controller_slash_Create_0_gml_15_0"")
");

#endregion



#region Отрисовка доп. спрайтов в контроллере

string room_code = @"
if (room == room_dw_city_treasure)
{
    n = scr_marker(400, 174, scr_84_get_sprite(""spr_queen_poster""))
    n.depth = 899999
    n.image_index = 1
}
else if (room == room_dw_city_spamton_alley)
{
    n = scr_marker(240, 94, scr_84_get_sprite(""spr_queen_poster""))
    n.depth = 989999
    n.image_index = 1
    n = scr_marker(400, 94, scr_84_get_sprite(""spr_queen_poster""))
    n.depth = 989999
    n.image_index = 1
    n = scr_marker(800, 94, scr_84_get_sprite(""spr_queen_poster""))
    n.depth = 989999
    n.image_index = 2
}";
foreach (var room in jsonRooms)
{
    room_code += string.Format("if (room == {0}) {{\n", room.Key);

    foreach (var spr in jsonRooms[room.Key])
    {
        if (spr["type"] == "tile")
        {
            if (room.Key == "room_town_school")
            {
                room_code += $@"    
                var n = scr_marker_animated({spr["x"]}, {spr["y"]}, scr_84_get_sprite(""{spr["sprite"]}""), sprite_get_speed(scr_84_get_sprite(""{spr["sprite"]}"")))
                n.depth = {spr["depth"]}
                var arr = layer_get_all_elements(""{spr["layer"]}"")
                layer_tilemap_destroy(arr[array_length(arr) - 4])
                ";
            }
            else
            {
                room_code += $@"    
                var n = scr_marker_animated({spr["x"]}, {spr["y"]}, scr_84_get_sprite(""{spr["sprite"]}""), sprite_get_speed(scr_84_get_sprite(""{spr["sprite"]}"")))
                n.depth = {spr["depth"]} - 1
                ";
            }
        }
        if (spr["type"] == "sprite")
        {
            room_code += $@"
            var lay_id = layer_get_id(""{spr["layer"]}"")
            var back_id = layer_sprite_get_id(lay_id, ""{spr["spr_name"]}"");
            layer_sprite_change(back_id, scr_84_get_sprite(""{spr["sprite"]}""));
            ";
        }
        if (spr["type"] == "background")
        {
            room_code += $@"
            var lay_id = layer_get_id(""{spr["layer"]}"");
            var back_id = layer_background_get_id(lay_id);
            layer_background_sprite(back_id, scr_84_get_sprite(""{spr["sprite"]}""));
            ";
        }

        IncrementProgress();
        UpdateProgressValue(GetProgress());
    }

    room_code += "}\n";
}

AddNewEvent("obj_gamecontroller", EventType.Other, (uint)EventSubtypeOther.RoomStart, room_code);

#endregion



#region Буковы на кнопках


Dictionary <string, Dictionary<string, string>> insts_with_letters;

using (StreamReader r = new StreamReader(scriptFolder + "InstancesToLetters.json")) {
    string json = r.ReadToEnd();
    insts_with_letters = System.Text.Json.JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, string>>>(json);
}

foreach (var inst in Data.Rooms.ByName("room_dw_cyber_keyboard_puzzle_1").Layers.FirstOrDefault(x => x.LayerName.Content == "OBJECTS_MAIN").InstancesData.Instances) {
    if (insts_with_letters.ContainsKey(inst.InstanceID.ToString())) {
        inst.PreCreateCode = AddCreationCodeEntryForInstance(inst);
        GetOrig(inst.PreCreateCode.Name.Content);
        AppendToEnd(inst.PreCreateCode, $@"myString = string_char_at(scr_get_lang_string(""{insts_with_letters[inst.InstanceID.ToString()]["orig_letter"]}"", ""obj_ch2_keyboardpuzzle_tile_Create_0_gml_1_0""), {insts_with_letters[inst.InstanceID.ToString()]["num"]} + 1)");
    }
}

foreach (var inst in Data.Rooms.ByName("room_dw_cyber_keyboard_puzzle_2").Layers.FirstOrDefault(x => x.LayerName.Content == "OBJECTS_MAIN").InstancesData.Instances) {
    if (insts_with_letters.ContainsKey(inst.InstanceID.ToString())) {
        inst.PreCreateCode = AddCreationCodeEntryForInstance(inst);
        GetOrig(inst.PreCreateCode.Name.Content);
        AppendToEnd(inst.PreCreateCode, $@"myString = string_char_at(scr_get_lang_string(""{insts_with_letters[inst.InstanceID.ToString()]["orig_letter"]}"", ""obj_ch2_keyboardpuzzle_tile_Create_0_gml_2_0""), {insts_with_letters[inst.InstanceID.ToString()]["num"]} + 1)");
    }
}

foreach (var inst in Data.Rooms.ByName("room_dw_city_monologue").Layers.FirstOrDefault(x => x.LayerName.Content == "OBJECTS_MAIN").InstancesData.Instances) {
    if (insts_with_letters.ContainsKey(inst.InstanceID.ToString())) {
        inst.PreCreateCode = AddCreationCodeEntryForInstance(inst);
        GetOrig(inst.PreCreateCode.Name.Content);
        AppendToEnd(inst.PreCreateCode, $@"myString = string_char_at(obj_ch2_keyboardpuzzle_monologue_controller.keys_symbols, {insts_with_letters[inst.InstanceID.ToString()]["num"]} + 1)");
    }
}


#endregion


await SaveEntries();