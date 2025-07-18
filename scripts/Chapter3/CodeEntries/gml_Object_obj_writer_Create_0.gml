skipme = 0;
forcebutton1 = 0;
textsound = snd_text;
charline = get_lang_setting("charline_base", 33);
charline_face = get_lang_setting("charline_face", 26);
originalcharline = charline;
hspace = 8;
vspace = 18;
limit_by_width = get_lang_setting("limit_by_width", 0);
f = 1;

if (global.darkzone == 1)
    f = 2;

rate = 1;
mycolor = c_white;
myfont = scr_84_get_font("main");
textalpha = 1;
textalphagain = 0;
fadeonend = 0;
shake = 0;
special = 0;
shadcolor = 7328275;
skippable = 1;
automash_timer = 0;

if (global.flag[6] == 1)
    skippable = 0;

prevent_mash_buffer = 0;
scr_texttype();

max_string_width_base = charline * hspace;
max_string_width_face = ((charline_face * hspace) - 2);
max_string_width = max_string_width_base;

formattext = true;
autoaster = 1;
drawaster = 1;
pos = 2;
lineno = 0;
aster = 0;
halt = 0;
reachedend = 0;
xcolor = c_black;
wxskip = 0;
msgno = 0;
first_alarm = 0;
firstnoise = 0;
noiseskip = 0;
formatted = 0;
colorchange = 0;
fontchange = 0;
sound_played = 0;
sound_timer = 0;
sound_count = 0;
reachedend_sound = 259;
reachedend_sound_played = 0;
reachedend_sound_play = 0;
jpspecial = 0;
jpused = 0;
writingx = x;
writingy = y;
dialoguer = 0;
smallface = 505050;
faced = 0;
facedever = 0;
facer = 0;
siner = 0;
specfade = 1;
autocenter = 0;
miniface_current_pos = -1;
miniface_pos = 0;
miniface_drawn = 0;

for (i = 0; i < 7; i += 1)
{
    specx[i] = i * 6;
    specy[i] = i * 6;
}

for (i = 0; i < 9; i++)
    object_made[i] = 0;

additional_sprites = []
additional_sounds = []

mystring = global.msg[0];

for (j = 0; j < 100; j += 1)
    nstring[j] = global.msg[j];

length = string_length(mystring);
alarm[0] = rate;

if (rate < 3)
    alarm[2] = 1;
else
    scr_textsound();
