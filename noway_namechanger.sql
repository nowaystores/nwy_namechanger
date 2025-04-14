-- NOWAY NAME CHANGER - SQL INIT
-- Adds a column to track the last time a player changed their name.
-- Only needs to be run once.

ALTER TABLE `users` ADD COLUMN `last_namechange` DATETIME DEFAULT NULL;