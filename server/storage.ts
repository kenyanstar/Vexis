import { users, userPreferences, browsingHistory, bookmarks, bookmarkFolders, downloads } from "../shared/schema";
import { type User, type InsertUser, type UserPreference, type InsertUserPreference, 
  type BrowsingHistory, type InsertBrowsingHistory, type Bookmark, type InsertBookmark, 
  type BookmarkFolder, type InsertBookmarkFolder, type Download, type InsertDownload } from "../shared/schema";
import { db } from "./db";
import { eq, and, desc, asc } from "drizzle-orm";

// Interface for our storage operations
export interface IStorage {
  // User operations
  getUser(id: number): Promise<User | undefined>;
  getUserByUsername(username: string): Promise<User | undefined>;
  getUserByEmail(email: string): Promise<User | undefined>;
  createUser(insertUser: InsertUser): Promise<User>;
  updateUser(id: number, userData: Partial<InsertUser>): Promise<User>;
  deleteUser(id: number): Promise<boolean>;

  // User preferences operations
  getUserPreferences(userId: number): Promise<UserPreference | undefined>;
  createUserPreferences(insertPreferences: InsertUserPreference): Promise<UserPreference>;
  updateUserPreferences(userId: number, prefData: Partial<InsertUserPreference>): Promise<UserPreference>;

  // Browsing history operations
  getBrowsingHistory(userId: number, limit?: number): Promise<BrowsingHistory[]>;
  addHistoryEntry(insertEntry: InsertBrowsingHistory): Promise<BrowsingHistory>;
  deleteHistoryEntry(id: number): Promise<boolean>;
  clearBrowsingHistory(userId: number): Promise<boolean>;

  // Bookmark operations
  getBookmarks(userId: number, folderId?: number): Promise<Bookmark[]>;
  getBookmark(id: number): Promise<Bookmark | undefined>;
  createBookmark(insertBookmark: InsertBookmark): Promise<Bookmark>;
  updateBookmark(id: number, bookmarkData: Partial<InsertBookmark>): Promise<Bookmark>;
  deleteBookmark(id: number): Promise<boolean>;

  // Bookmark folder operations
  getBookmarkFolders(userId: number, parentFolderId?: number): Promise<BookmarkFolder[]>;
  getBookmarkFolder(id: number): Promise<BookmarkFolder | undefined>;
  createBookmarkFolder(insertFolder: InsertBookmarkFolder): Promise<BookmarkFolder>;
  updateBookmarkFolder(id: number, folderData: Partial<InsertBookmarkFolder>): Promise<BookmarkFolder>;
  deleteBookmarkFolder(id: number): Promise<boolean>;

  // Download operations
  getDownloads(userId: number): Promise<Download[]>;
  getDownload(id: number): Promise<Download | undefined>;
  createDownload(insertDownload: InsertDownload): Promise<Download>;
  updateDownload(id: number, downloadData: Partial<InsertDownload>): Promise<Download>;
  deleteDownload(id: number): Promise<boolean>;
}

// Implementation using the database
export class DatabaseStorage implements IStorage {
  // User operations
  async getUser(id: number): Promise<User | undefined> {
    const [user] = await db.select().from(users).where(eq(users.id, id));
    return user;
  }

  async getUserByUsername(username: string): Promise<User | undefined> {
    const [user] = await db.select().from(users).where(eq(users.username, username));
    return user;
  }

  async getUserByEmail(email: string): Promise<User | undefined> {
    const [user] = await db.select().from(users).where(eq(users.email, email));
    return user;
  }

  async createUser(insertUser: InsertUser): Promise<User> {
    const [user] = await db.insert(users).values(insertUser).returning();
    return user;
  }

  async updateUser(id: number, userData: Partial<InsertUser>): Promise<User> {
    const [updatedUser] = await db
      .update(users)
      .set({ ...userData, updatedAt: new Date() })
      .where(eq(users.id, id))
      .returning();
    return updatedUser;
  }

  async deleteUser(id: number): Promise<boolean> {
    const result = await db.delete(users).where(eq(users.id, id));
    return true; // Postgres doesn't return deleted rows count easily, so we assume success
  }

  // User preferences operations
  async getUserPreferences(userId: number): Promise<UserPreference | undefined> {
    const [prefs] = await db.select().from(userPreferences).where(eq(userPreferences.userId, userId));
    return prefs;
  }

  async createUserPreferences(insertPreferences: InsertUserPreference): Promise<UserPreference> {
    const [prefs] = await db.insert(userPreferences).values(insertPreferences).returning();
    return prefs;
  }

  async updateUserPreferences(userId: number, prefData: Partial<InsertUserPreference>): Promise<UserPreference> {
    const [existingPrefs] = await db.select().from(userPreferences).where(eq(userPreferences.userId, userId));
    
    if (existingPrefs) {
      // Update existing preferences
      const [updatedPrefs] = await db
        .update(userPreferences)
        .set({ ...prefData, lastSyncedAt: new Date() })
        .where(eq(userPreferences.id, existingPrefs.id))
        .returning();
      return updatedPrefs;
    } else {
      // Create new preferences if they don't exist
      return this.createUserPreferences({ 
        userId, 
        ...prefData, 
        lastSyncedAt: new Date() 
      } as InsertUserPreference);
    }
  }

  // Browsing history operations
  async getBrowsingHistory(userId: number, limit: number = 100): Promise<BrowsingHistory[]> {
    return db
      .select()
      .from(browsingHistory)
      .where(eq(browsingHistory.userId, userId))
      .orderBy(desc(browsingHistory.visitedAt))
      .limit(limit);
  }

  async addHistoryEntry(insertEntry: InsertBrowsingHistory): Promise<BrowsingHistory> {
    const [entry] = await db.insert(browsingHistory).values(insertEntry).returning();
    return entry;
  }

  async deleteHistoryEntry(id: number): Promise<boolean> {
    await db.delete(browsingHistory).where(eq(browsingHistory.id, id));
    return true;
  }

  async clearBrowsingHistory(userId: number): Promise<boolean> {
    await db.delete(browsingHistory).where(eq(browsingHistory.userId, userId));
    return true;
  }

  // Bookmark operations
  async getBookmarks(userId: number, folderId?: number): Promise<Bookmark[]> {
    if (folderId !== undefined) {
      return db
        .select()
        .from(bookmarks)
        .where(
          and(
            eq(bookmarks.userId, userId),
            eq(bookmarks.folderId, folderId)
          )
        )
        .orderBy(asc(bookmarks.title));
    } else {
      return db
        .select()
        .from(bookmarks)
        .where(eq(bookmarks.userId, userId))
        .orderBy(asc(bookmarks.title));
    }
  }

  async getBookmark(id: number): Promise<Bookmark | undefined> {
    const [bookmark] = await db.select().from(bookmarks).where(eq(bookmarks.id, id));
    return bookmark;
  }

  async createBookmark(insertBookmark: InsertBookmark): Promise<Bookmark> {
    const [bookmark] = await db.insert(bookmarks).values(insertBookmark).returning();
    return bookmark;
  }

  async updateBookmark(id: number, bookmarkData: Partial<InsertBookmark>): Promise<Bookmark> {
    const [updatedBookmark] = await db
      .update(bookmarks)
      .set(bookmarkData)
      .where(eq(bookmarks.id, id))
      .returning();
    return updatedBookmark;
  }

  async deleteBookmark(id: number): Promise<boolean> {
    await db.delete(bookmarks).where(eq(bookmarks.id, id));
    return true;
  }

  // Bookmark folder operations
  async getBookmarkFolders(userId: number, parentFolderId?: number): Promise<BookmarkFolder[]> {
    if (parentFolderId !== undefined) {
      return db
        .select()
        .from(bookmarkFolders)
        .where(
          and(
            eq(bookmarkFolders.userId, userId),
            eq(bookmarkFolders.parentFolderId, parentFolderId)
          )
        )
        .orderBy(asc(bookmarkFolders.name));
    } else {
      return db
        .select()
        .from(bookmarkFolders)
        .where(
          and(
            eq(bookmarkFolders.userId, userId),
            eq(bookmarkFolders.parentFolderId, null)
          )
        )
        .orderBy(asc(bookmarkFolders.name));
    }
  }

  async getBookmarkFolder(id: number): Promise<BookmarkFolder | undefined> {
    const [folder] = await db.select().from(bookmarkFolders).where(eq(bookmarkFolders.id, id));
    return folder;
  }

  async createBookmarkFolder(insertFolder: InsertBookmarkFolder): Promise<BookmarkFolder> {
    const [folder] = await db.insert(bookmarkFolders).values(insertFolder).returning();
    return folder;
  }

  async updateBookmarkFolder(id: number, folderData: Partial<InsertBookmarkFolder>): Promise<BookmarkFolder> {
    const [updatedFolder] = await db
      .update(bookmarkFolders)
      .set(folderData)
      .where(eq(bookmarkFolders.id, id))
      .returning();
    return updatedFolder;
  }

  async deleteBookmarkFolder(id: number): Promise<boolean> {
    await db.delete(bookmarkFolders).where(eq(bookmarkFolders.id, id));
    return true;
  }

  // Download operations
  async getDownloads(userId: number): Promise<Download[]> {
    return db
      .select()
      .from(downloads)
      .where(eq(downloads.userId, userId))
      .orderBy(desc(downloads.startedAt));
  }

  async getDownload(id: number): Promise<Download | undefined> {
    const [download] = await db.select().from(downloads).where(eq(downloads.id, id));
    return download;
  }

  async createDownload(insertDownload: InsertDownload): Promise<Download> {
    const [download] = await db.insert(downloads).values(insertDownload).returning();
    return download;
  }

  async updateDownload(id: number, downloadData: Partial<InsertDownload>): Promise<Download> {
    const [updatedDownload] = await db
      .update(downloads)
      .set(downloadData)
      .where(eq(downloads.id, id))
      .returning();
    return updatedDownload;
  }

  async deleteDownload(id: number): Promise<boolean> {
    await db.delete(downloads).where(eq(downloads.id, id));
    return true;
  }
}

// Create a singleton instance for use throughout the app
export const storage = new DatabaseStorage();