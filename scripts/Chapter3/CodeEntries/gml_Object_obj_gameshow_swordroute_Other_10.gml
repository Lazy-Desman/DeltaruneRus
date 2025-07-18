if (drawui)
{
    draw_set_color(c_black);
    ossafe_fill_rectangle(128, 32, 511, 63);
    draw_set_color(c_white);
    
    if (i_ex(lilkris))
    {

        draw_set_font(scr_84_get_font("8bit"));
        draw_text(132, 48, stringsetloc("HP", "obj_gameshow_swordroute_slash_Other_10_gml_1_0"));
        var hp = lilkris.myhealth;
        var maxhp = lilkris.maxhealth;
        hp = clamp(hp, 0, maxhp);
        var absolutemaxhp = 32;
        var maxbarsize = 110 + (30 * (lilkris.swordlv - 1));
        var barfill = hp / absolutemaxhp;
        
        if (barfill > 1)
            barfill = 1;
        
        draw_sprite_ext(spr_whitepx, 0, 166, 48, (maxhp / absolutemaxhp) * maxbarsize, 14, 0, c_white, 0.25);
        draw_sprite_ext(spr_whitepx, 0, 166, 48, barfill * maxbarsize, 14, 0, c_white, 1);
        
        if (global.flag[1055] >= 1 && global.flag[1055] < 2)
            draw_sprite_ext(spr_board_ui_icekey, 0, 412, 46, 2, 2, 0, c_white, 1);
        
        if (global.flag[1055] > 2 && global.flag[1055] < 5)
            draw_sprite_ext(spr_board_ui_icekey, 1, 412, 46, 2, 2, 0, c_white, 1);
        
        if (lilkris.sword == true)
        {
            var _level = lilkris.swordlv;
            var xp = lilkris.xp;
            var maxxp = lilkris.xptolevel;
            maxbarsize = 66;
            var barsize = round(((xp / maxxp) * maxbarsize) / 2) * 2;
            barsize = clamp(barsize, 0, maxbarsize);
            
            if (_level < 4)
            {
                draw_set_halign(fa_right)
                draw_text(326, 48, stringsetsubloc("LV~1", string(_level), "obj_gameshow_swordroute_slash_Other_10_gml_2_0"));
                draw_set_halign(fa_left)
            }
            else
            {
                draw_set_halign(fa_right)
                draw_text(326, 48, stringsetloc("MAX", "obj_gameshow_swordroute_slash_Other_10_gml_3_0"));
                barsize = maxbarsize;
                draw_set_halign(fa_left)
            }
            
            draw_sprite_ext(spr_whitepx, 0, 328, 48, maxbarsize, 14, 0, c_white, 0.25);
            draw_sprite_ext(spr_whitepx, 0, 328, 48, barsize, 14, 0, c_white, 1);
            var lv = min(lilkris.swordlv, 4);
            
            for (var i = 0; i < lv; i++)
                draw_sprite_ext(spr_board_ui_sword, 0, 492 - (20 * i), 46, 2, 2, 0, c_white, 1);
            
            if (debugdraw)
            {
                draw_set_font(scr_84_get_font("small"));
                draw_set_color(c_white);
                draw_text_outline(camerax() + board_tilex(0) + 160, cameray() + board_tiley(0), "XP=" + string(lilkris.xp));
                draw_text_outline(camerax() + board_tilex(0) + 160, cameray() + board_tiley(0) + 8, "XPtolevel=" + string(lilkris.xptolevel));
            }
        }
    }
}
