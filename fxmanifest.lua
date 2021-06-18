fx_version "adamant"

game "gta5"

author "PetitsPieds"

description "Teleport made by PetitsPieds"

version '1.0.0'

client_script {
    "config.lua",
    "client/main.lua",
}

server_script {
    "config.lua",
    "server/main.lua",
}

exports {
    "TeleportPlayer",
}