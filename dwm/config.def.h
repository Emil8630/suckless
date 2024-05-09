/* Constants */
#define TERMINAL "alacritty"
#define BROWSER "librewolf"
#include <X11/XF86keysym.h>
/* appearance */
static const unsigned int borderpx  = 4;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int gappih    = 10;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 10;       /* vert inner gap between windows */
static const unsigned int gappoh    = 10;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 10;       /* vert outer gap between windows and screen edge */
static const int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int horizpadbar        = 1;        /* horizontal padding for statusbar */
static const int vertpadbar         = 5;        /* vertical padding for statusbar */
static const char *fonts[]          = { "JetBrainsMono Nerd Font:size=10" };
/*static char script[]                = "/home/less/dwm";*/
static char normbgcolor[]           = "#0f100f";
static char normbordercolor[]       = "#545862";
static char normfgcolor[]           = "#c8cac2";
static char selfgcolor[]            = "#c8cac2";
static char selbordercolor[]        = "#c8cac2";
static char selbgcolor[]            = "#1b1b1b";

static char *colors[][3] = {
       /*               fg           bg           border   */
       [SchemeNorm] = { normfgcolor, normbgcolor, normbordercolor },
       [SchemeSel]  = { selfgcolor,  selbgcolor,  selbordercolor  },
};

typedef struct {
	const char *name;
	const void *cmd;
} Sp;
const char *spcmd1[] = {"alacritty", "-n", "spterm", "-g", "144x41", NULL };
const char *spcmd2[] = {"alacritty", "-n", "ranger", "-g", "144x41", "-e", "ranger", NULL };
static Sp scratchpads[] = {
	/* name          cmd  */
	{"spterm",    spcmd1},
	{"ranger",    spcmd2},
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };
static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
    { "Gimp",         NULL,         NULL,       0,              1,           -1 },
    { "mpv",          NULL,         NULL,       0,              1,           -1 },
    { "Bitwarden",    NULL,         NULL,       0,              1,           -1 },
    { "floatterm",    NULL,         NULL,       0,              1,           -1 },
    { "Galculator",   NULL,         NULL,       0,              1,           -1 },
    { "Gcolor3",      NULL,         NULL,       0,              1,           -1 },
    { "Lxappearance", NULL,         NULL,       0,              1,           -1 },
    { "Nitrogen",     NULL,         NULL,       0,              1,           -1 },
    { "Nsxiv",        NULL,         NULL,       0,              1,           -1 },
    { "Pavucontrol",  NULL,         NULL,       0,              1,           -1 },
    { "qt5ct",        NULL,         NULL,       0,              1,           -1 },
    { "qt6ct",        NULL,         NULL,       0,              1,           -1 },
    { "kdenlive",     NULL,         NULL,       0,              1,           -1 },
    { "Nm-connection-editor",     NULL,         NULL,       0,              1,           -1 },
	{ NULL,       "spterm",     NULL,       SPTAG(0),       1,           -1 },
	{ NULL,       "ranger",     NULL,       SPTAG(1),       1,           -1 },
    { "firefox", "Toolkit", "Picture-in-Picture", 0,        1,           -1},
    { NULL, "alacritty", NULL, 0, 1, -1},
    { "alacritty", NULL, NULL, 1 << 1, False, -1 },

};

/* layout(s) */
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

#define STATUSBAR "dwmblocks"

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *termcmd2[]  = { "alacritty", NULL };
static const char *browser[] = { "librewolf", NULL };
static const char *mail[] = {"thunderbird", NULL };
static const char *dmenucmd[] = { "dmenu_run", "-p", "run", "-i", NULL };
static const char *rofi[]  = { "rofi_applauncher", NULL };

/* Hardware keys for volume and brightness */
#include <X11/XF86keysym.h>
static const char *mutevol[]            = { "~/github/suckless/volume.sh", "--toggle",  NULL };
static const char *mutemic[]            = { "~/github/suckless/volume.sh", "--toggle-mic",  NULL      };
static const char *upvol[]              = { "~/github/suckless/volume.sh", "--inc",   NULL };
static const char *downvol[]            = { "~/github/suckless/volume.sh", "--dec",       NULL };
static const char *upbl[]               = { "~/github/suckless/brightness.sh", "--inc",    NULL };
static const char *downbl[]             = { "~/github/suckless/brightness.sh", "--dec",  NULL };


#include "movestack.c"
static const Key keys[] = {
    /* modifier                     key             function        argument */
    { MODKEY,                       XK_d,           spawn,       {.v = dmenucmd } },
    { MODKEY,                       XK_Return,      spawn,       {.v = termcmd2 } },
    { MODKEY,                       XK_r,           spawn,       {.v = rofi } },
    { MODKEY|ShiftMask,             XK_w,           spawn,       {.v = browser } },
    { MODKEY|ShiftMask,             XK_t,           spawn,       SHCMD("mullvad-exclude thorium-browser") },
    { MODKEY|ShiftMask,             XK_m,           spawn,       {.v = mail } },
/*    { MODKEY,                       XK_b,           togglebar,      {0} },*/
    { ALTKEY,                       XK_Tab,         view, {0} },
/*    { MODKEY,                       XK_s,           hidewin, {0} }, // Hide window
    { MODKEY|ShiftMask,             XK_s,           restorewin, {0} }, // Restore window*/
    { MODKEY,                       XK_j,           focusstack,     {.i = +1 } },
    { MODKEY,                       XK_k,           focusstack,     {.i = -1 } },
    { MODKEY,                       XK_Prior,       incnmaster,     {.i = +1 } },
    { MODKEY,                       XK_Next,        incnmaster,     {.i = -1 } },
    { MODKEY,                       XK_h,           setmfact,       {.f = -0.05} },
    { MODKEY,                       XK_l,           setmfact,       {.f = +0.05} },
    { MODKEY|ShiftMask,             XK_j,           movestack,      {.i = +1 } },
    { MODKEY|ShiftMask,             XK_k,           movestack,      {.i = -1 } },
    { MODKEY,                       XK_plus,        incrgaps,       {.i = +5 } },
    { MODKEY,                       XK_minus,       incrgaps,       {.i = -5 } },
    { MODKEY|ShiftMask,             XK_plus,        incrigaps,      {.i = +5 } },
    { MODKEY|ShiftMask,             XK_minus,       incrigaps,      {.i = -5 } },
    { MODKEY|ControlMask,           XK_plus,        incrogaps,      {.i = +5 } },
    { MODKEY|ControlMask,           XK_minus,       incrogaps,      {.i = -5 } },
    { MODKEY,                       XK_g,           togglegaps,     {0} },
    { MODKEY|ShiftMask,             XK_g,           defaultgaps,    {0} },
    { MODKEY,                       XK_c,           killclient,     {0} },
    { MODKEY,                       XK_Escape,      spawn, SHCMD("xkill") }, // xkill
    { MODKEY,                       XK_space,       setlayout,      {0} },
    { MODKEY|ShiftMask,             XK_space,       togglefloating, {0} },
    { MODKEY,                       XK_f,           togglefullscr,  {0} },
    TAGKEYS(                        XK_1,                           0)
    TAGKEYS(                        XK_2,                           1)
    TAGKEYS(                        XK_3,                           2)
    TAGKEYS(                        XK_4,                           3)
    TAGKEYS(                        XK_5,                           4)
    TAGKEYS(                        XK_6,                           5)
    TAGKEYS(                        XK_7,                           6)
    TAGKEYS(                        XK_8,                           7)
    TAGKEYS(                        XK_9,                           8)
    { MODKEY|ControlMask,           XK_q,           quit,           {0} },
    { MODKEY|ShiftMask,             XK_r,           quit,           {1} },
         // Hardware Keys -----------
    { 0,                        XF86XK_AudioMute,           spawn, {.v = mutevol } },
    { 0,                        XF86XK_AudioMicMute,        spawn, {.v = mutemic } },
    { 0,                        XF86XK_AudioLowerVolume,    spawn, {.v = downvol } },
    { 0,                        XF86XK_AudioRaiseVolume,    spawn, {.v = upvol   } },
    { 0,                        XF86XK_MonBrightnessUp,     spawn, {.v = upbl   } },
    { 0,                        XF86XK_MonBrightnessDown,   spawn, {.v = downbl   } },

    /* Other bindings*/
    { MODKEY,                       XK_F1,          spawn,       SHCMD("nsxiv-wall") },
    { MODKEY,                       XK_n,           spawn,       SHCMD("dmenu_network") },
/*    { MODKEY,                       XK_l,           spawn,       SHCMD("betterlockscreen --lock blur") },*/
    { MODKEY|ShiftMask,             XK_l,           spawn,       SHCMD("slock -m 'The screen is locked.'") },
    { MODKEY|ShiftMask,             XK_f,           spawn,       SHCMD("thunar") },
    { MODKEY,                       XK_p,           spawn,       SHCMD("sh ~/github/suckless/colorpicker.sh") },
    { MODKEY,                       XK_e,           spawn,       SHCMD("sh ~/github/suckless/dmenuemoji.sh") },
    { MODKEY,                       XK_v,           spawn,       SHCMD("sh ~/github/suckless/clip.sh") },
    { MODKEY,                       XK_b,           spawn,       SHCMD("xdotool type $(grep -v '^#' ~/github/suckless/.bookmarks | dmenu -i -l 50 | cut -d' ' -f1)") },
    { MODKEY,                       XK_x,           spawn,       SHCMD("sh ~/github/suckless/power.sh") },
    { MODKEY|ALTKEY,                XK_d,           spawn,       SHCMD("sh ~/github/suckless/dictionary.sh") },
    { MODKEY|ALTKEY,                XK_n,           spawn,       SHCMD("sh ~/github/suckless/notes.sh") },
    { MODKEY,                       XK_n,           spawn,       SHCMD("sh ~/github/suckless/networkmanager.sh") },
    { MODKEY|ShiftMask,             XK_c,           spawn,       SHCMD("sh ~/github/suckless/calculator.sh") },
    { MODKEY|ShiftMask,             XK_u,           spawn,       SHCMD("sh ~/github/suckless/umount.sh") },
    { MODKEY|ShiftMask,             XK_m,           spawn,       SHCMD("sh ~/github/suckless/mount.sh") },
    { MODKEY,                       XK_m,           spawn,       SHCMD("sh ~/github/suckless/mullvad-exclude.sh") },
    { MODKEY|ShiftMask,             XK_n,           spawn,       SHCMD(TERMINAL " -c floatterm -g 144x41  -e nvim ~/Documents/.vimwiki/notes.md") },
    { MODKEY,                       XK_Print,       spawn,       SHCMD("flameshot gui") },

};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button1,        sigstatusbar,   {.i = 1} },
	{ ClkStatusText,        0,              Button2,        sigstatusbar,   {.i = 2} },
	{ ClkStatusText,        0,              Button3,        sigstatusbar,   {.i = 3} },
    { ClkStatusText,        0,              Button4,        sigstatusbar,   {.i = 4} },
	{ ClkStatusText,        0,              Button5,        sigstatusbar,   {.i = 5} },
	{ ClkStatusText,        ShiftMask,      Button1,        sigstatusbar,   {.i = 6} },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

