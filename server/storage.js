const { 
  users, 
  userPreferences, 
  browsingHistory, 
  bookmarks, 
  bookmarkFolders, 
  downloads 
} = require("../shared/schema.js");
const { db } = require("./db.js");
const { eq, and, desc, asc } = require("drizzle-orm");

// Implementation using the database
class DatabaseStorage {
  // User operations
  async getUser(id) {
    const [user] = await db.select().from(users).where(eq(users.id, id));
    return user;
  }

  async getUserByUsername(username) {
    const [user] = await db.select().from(users).where(eq(users.username, username));
    return user;
  }

  async getUserByEmail(email) {
    const [user] = await db.select().from(users).where(eq(users.email, email));
    return user;
  }

  async createUser(insertUser) {
    const [user] = await db.insert(users).values(insertUser).returning();
    return user;
  }

  async updateUser(id, userData) {
    const [updatedUser] = await db
      .update(users)
      .set({ ...userData, updatedAt: new Date() })
      .where(eq(users.id, id))
      .returning();
    return updatedUser;
  }

  async deleteUser(id) {
    const result = await db.delete(users).where(eq(users.id, id));
    return true; // Postgres doesn't return deleted rows count easily, so we assume success
  }

  // User preferences operations
  async getUserPreferences(userId) {
    const [prefs] = await db.select().from(userPreferences).where(eq(userPreferences.userId, userId));
    return prefs;
  }

  async createUserPreferences(insertPreferences) {
    const [prefs] = await db.insert(userPreferences).values(insertPreferences).returning();
    return prefs;
  }

  async updateUserPreferences(userId, prefData) {
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
      });
    }
  }

  // Browsing history operations
  async getBrowsingHistory(userId, limit = 100) {
    return db
      .select()
      .from(browsingHistory)
      .where(eq(browsingHistory.userId, userId))
      .orderBy(desc(browsingHistory.visitedAt))
      .limit(limit);
  }

  async addHistoryEntry(insertEntry) {
    const [entry] = await db.insert(browsingHistory).values(insertEntry).returning();
    return entry;
  }

  async deleteHistoryEntry(id) {
    await db.delete(browsingHistory).where(eq(browsingHistory.id, id));
    return true;
  }

  async clearBrowsingHistory(userId) {
    await db.delete(browsingHistory).where(eq(browsingHistory.userId, userId));
    return true;
  }

  // Bookmark operations
  async getBookmarks(userId, folderId) {
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

  async getBookmark(id) {
    const [bookmark] = await db.select().from(bookmarks).where(eq(bookmarks.id, id));
    return bookmark;
  }

  async createBookmark(insertBookmark) {
    const [bookmark] = await db.insert(bookmarks).values(insertBookmark).returning();
    return bookmark;
  }

  async updateBookmark(id, bookmarkData) {
    const [updatedBookmark] = await db
      .update(bookmarks)
      .set(bookmarkData)
      .where(eq(bookmarks.id, id))
      .returning();
    return updatedBookmark;
  }

  async deleteBookmark(id) {
    await db.delete(bookmarks).where(eq(bookmarks.id, id));
    return true;
  }

  // Bookmark folder operations
  async getBookmarkFolders(userId, parentFolderId) {
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

  async getBookmarkFolder(id) {
    const [folder] = await db.select().from(bookmarkFolders).where(eq(bookmarkFolders.id, id));
    return folder;
  }

  async createBookmarkFolder(insertFolder) {
    const [folder] = await db.insert(bookmarkFolders).values(insertFolder).returning();
    return folder;
  }

  async updateBookmarkFolder(id, folderData) {
    const [updatedFolder] = await db
      .update(bookmarkFolders)
      .set(folderData)
      .where(eq(bookmarkFolders.id, id))
      .returning();
    return updatedFolder;
  }

  async deleteBookmarkFolder(id) {
    await db.delete(bookmarkFolders).where(eq(bookmarkFolders.id, id));
    return true;
  }

  // Download operations
  async getDownloads(userId) {
    return db
      .select()
      .from(downloads)
      .where(eq(downloads.userId, userId))
      .orderBy(desc(downloads.startedAt));
  }

  async getDownload(id) {
    const [download] = await db.select().from(downloads).where(eq(downloads.id, id));
    return download;
  }

  async createDownload(insertDownload) {
    const [download] = await db.insert(downloads).values(insertDownload).returning();
    return download;
  }

  async updateDownload(id, downloadData) {
    const [updatedDownload] = await db
      .update(downloads)
      .set(downloadData)
      .where(eq(downloads.id, id))
      .returning();
    return updatedDownload;
  }

  async deleteDownload(id) {
    await db.delete(downloads).where(eq(downloads.id, id));
    return true;
  }
}

// Create a singleton instance for use throughout the app
const storage = new DatabaseStorage();

module.exports = {
  storage
};