-- Test trees for the e2e tests (see tests/e2e/constants.ts). The Freiburg tree
-- data has no planting year, so no real tree is a baby or senior tree.
-- Must run as the database owner: a trigger on `trees` refreshes materialized
-- views, which the service role is not allowed to do.
INSERT INTO public.trees (id, lat, lng, geom, art_dtsch, art_bot, gattung_deutsch, gattung, pflanzjahr)
VALUES
	('e2e-baby-tree', '47.9959', '7.8494', 'SRID=4326;POINT(7.8494 47.9959)', 'Resista Ulme ''Rebona''', 'Ulmus Resista (R) ''Rebona''', 'ULME', 'ULMUS', 2023),
	('e2e-senior-tree', '47.9965', '7.8502', 'SRID=4326;POINT(7.8502 47.9965)', 'Spitz-Ahorn ''Almira''', 'Acer platanoides ''Almira''', 'AHORN', 'ACER', 1994)
ON CONFLICT (id) DO NOTHING;
