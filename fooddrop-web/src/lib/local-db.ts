import Dexie, { type Table } from "dexie";
import type { GroceryRecipe, GrocerySelection } from "@/features/grocery/aggregate-grocery";
import type { TimerClock } from "@/features/timers/timer-math";

export interface StoredTimer extends TimerClock {
  id: string;
  label: string;
  /** Set once the done-alert has fired, so a reload does not ring again. */
  alertedAt: number | null;
}

/** Client-only persistence (IndexedDB). Holds the user's own recipe ids and timers, nothing sensitive. */
class FoodDropLocalDb extends Dexie {
  grocerySelections!: Table<GrocerySelection, string>;
  /** Snapshot of each selected recipe's ingredients so the list still works offline. */
  groceryRecipes!: Table<GroceryRecipe, string>;
  groceryChecked!: Table<{ key: string }, string>;
  timers!: Table<StoredTimer, string>;

  constructor() {
    super("fooddrop");
    this.version(1).stores({
      grocerySelections: "recipeId",
      groceryRecipes: "id",
      groceryChecked: "key",
      timers: "id",
    });
  }
}

let instance: FoodDropLocalDb | null = null;

/** Lazy so importing a store during SSR never touches IndexedDB. */
export function localDb(): FoodDropLocalDb {
  instance ??= new FoodDropLocalDb();
  return instance;
}

/** Sign-out: the next user must not inherit this browser's grocery list or timers. */
export async function wipeLocalData(): Promise<void> {
  const db = localDb();
  await Promise.all([db.grocerySelections.clear(), db.groceryRecipes.clear(), db.groceryChecked.clear(), db.timers.clear()]);
}

/**
 * IndexedDB can be blocked (private mode, storage pressure). The in-memory store keeps working, so a
 * failed write is logged instead of breaking the screen.
 */
export async function persist(write: () => Promise<unknown>): Promise<void> {
  try {
    await write();
  } catch (error) {
    console.error("Local storage write failed", error);
  }
}
