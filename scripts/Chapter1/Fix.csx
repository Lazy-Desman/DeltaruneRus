#load "../BaseFix.csx"



#region Отрисовка доп. спрайтов в контроллере

string room_code = @"
if (room == room_cc_5f) {
    if (scr_84_get_sprite(""bg_rurus_shop"") != bg_rurus_shop) {
        n = scr_marker(380, 600, scr_84_get_sprite(""bg_rurus_shop""))
        n.depth = 949999
        var arr = layer_get_all_elements(""Compatibility_Tiles_Depth_950000"")
        layer_tilemap_destroy(arr[array_length(arr) - 2])
    }
}";
foreach (var room in jsonRooms) {
    room_code += string.Format("if (room == {0}) {{\n", room.Key);

    foreach (var spr in jsonRooms[room.Key]) {
        if (spr["type"] == "tile") {
            if (room.Key == "room_town_school") {
                room_code += $@"    
                var n = scr_marker({spr["x"]}, {spr["y"]}, scr_84_get_sprite(""{spr["sprite"]}""))
                n.depth = {spr["depth"]}
                var arr = layer_get_all_elements(""{spr["layer"]}"")
                layer_tilemap_destroy(arr[array_length(arr) - 4])
                ";
            } else {
                room_code += $@"    
                var n = scr_marker({spr["x"]}, {spr["y"]}, scr_84_get_sprite(""{spr["sprite"]}""))
                n.depth = {spr["depth"]} - 1
                ";
            }
        }
        if (spr["type"] == "sprite") {
            room_code += $@"
            var lay_id = layer_get_id(""{spr["layer"]}"")
            var back_id = layer_sprite_get_id(lay_id, ""{spr["spr_name"]}"");
            layer_sprite_change(back_id, scr_84_get_sprite(""{spr["sprite"]}""));
            ";
        }
        if (spr["type"] == "background") {
            room_code += $@"
            var lay_id = layer_get_id(""{spr["layer"]}"");
            var back_id = layer_background_get_id(lay_id);
            layer_background_sprite(back_id, scr_84_get_sprite(""{spr["sprite"]}""));
            ";
        }
    }

    room_code += "}\n";
}

AddNewEvent("obj_gamecontroller", EventType.Other, (uint)EventSubtypeOther.RoomStart, room_code);

#endregion

#region Всякая говнинка

// Ставим obj_gamecontroller перед obj_initializer2
var room = Data.Rooms.ByName("ROOM_INITIALIZE");

foreach (var layer in room.Layers)
{
    if (layer.LayerName.Content == "Compatibility_Instances_Depth_0")
    {
        for (var i = 0; i < layer.InstancesData.Instances.Count; i++)
        {
            var inst = layer.InstancesData.Instances[i];
            if (inst.ObjectDefinition.Name.Content == "obj_gamecontroller")
            {
                (layer.InstancesData.Instances[0].InstanceID, layer.InstancesData.Instances[i].InstanceID) = (layer.InstancesData.Instances[i].InstanceID, layer.InstancesData.Instances[0].InstanceID);
                (layer.InstancesData.Instances[0], layer.InstancesData.Instances[i]) = (layer.InstancesData.Instances[i], layer.InstancesData.Instances[0]);
            }
        }
    }
}

for (var i = 0; i < room.GameObjects.Count; i++)
{
    if (room.GameObjects[i].ObjectDefinition.Name.Content == "obj_gamecontroller")
    {
        (room.GameObjects[i], room.GameObjects[0]) = (room.GameObjects[0], room.GameObjects[i]);
    }
}

#endregion



await SaveEntries();