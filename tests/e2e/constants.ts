/** Password used for every test account; satisfies the app's password rules. */
export const defaultPassword = '123qwe!"§QWE';

/** Prefix for generated usernames (see `createAccountCredentials`). */
export const defaultUsername = "username";

/** localStorage key of the persisted zustand splash store. */
export const splashStoreKey = "splash-store";

/**
 * Test trees from `seed-test-trees.sql` (run it once against the local DB).
 * The Freiburg tree data has no planting year, so no real tree is a baby or
 * senior tree.
 */
export const babyTreeId = "e2e-baby-tree";

/** Spitz-Ahorn 'Almira', planted 1994 - old enough to be waterable. */
export const seniorTreeId = "e2e-senior-tree";
export const seniorTreeName = "Spitz-Ahorn 'Almira'";
