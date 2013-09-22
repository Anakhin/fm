-- coding: utf-8

AddCommand("test", "scripts/selftest", "far", "lua")

AddToMenu ("e", "5. Self-test", nil, "scripts/selftest", "far", "lua")
AddToMenu ("e", ":sep:User scripts")
AddToMenu ("e", "URLs", nil, "scripts/presets", "url")
AddToMenu ("e", "Credit Card numbers", nil, "scripts/presets", "creditcard")
