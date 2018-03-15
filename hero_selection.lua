function Think()
  if (GetGameMode() == GAMEMODE_1V1MID) then
    -- Team radiant
  	SelectHero(2, "npc_dota_hero_nevermore");
  	SelectHero(3, "npc_dota_hero_crystal_maiden");
  	SelectHero(4, "npc_dota_hero_crystal_maiden");
  	SelectHero(5, "npc_dota_hero_crystal_maiden");
  	SelectHero(6, "npc_dota_hero_crystal_maiden");

    -- Team dire
  	SelectHero(7, "npc_dota_hero_nevermore");
  	SelectHero(8, "npc_dota_hero_crystal_maiden");
  	SelectHero(9, "npc_dota_hero_crystal_maiden");
  	SelectHero(10, "npc_dota_hero_crystal_maiden");
  	SelectHero(11, "npc_dota_hero_crystal_maiden");
  end
end
