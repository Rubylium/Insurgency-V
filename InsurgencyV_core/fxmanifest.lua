fx_version 'adamant'
games { 'gta5' };

client_scripts {
    "src/client/RMenu.lua",
    "src/client/menu/RageUI.lua",
    "src/client/menu/Menu.lua",
    "src/client/menu/MenuController.lua",

    "src/client/components/*.lua",

    "src/client/menu/elements/*.lua",

    "src/client/menu/items/*.lua",

    "src/client/menu/panels/*.lua",

    "src/client/menu/windows/*.lua",

}

client_scripts {
    'client/*.lua',
    'client/class/*.lua',
    'client/class/subclass/*.lua',
    'client/init/*.lua',
    'client/points/*.lua',
}


server_scripts {
    "capture.lua",
}