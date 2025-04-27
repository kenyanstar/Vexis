const { pgTable, serial, text, varchar, integer, timestamp, boolean } = require('drizzle-orm/pg-core');
const { relations } = require('drizzle-orm');

// Users table
const users = pgTable('users', {
  id: serial('id').primaryKey(),
  username: varchar('username', { length: 100 }).notNull().unique(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  passwordHash: text('password_hash').notNull(),
  displayName: varchar('display_name', { length: 100 }),
  biometricEnabled: boolean('biometric_enabled').default(false),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

// User preferences table
const userPreferences = pgTable('user_preferences', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  darkMode: boolean('dark_mode').default(true),
  turboModeEnabled: boolean('turbo_mode_enabled').default(false),
  superTurboModeEnabled: boolean('super_turbo_mode_enabled').default(false),
  dataSavedInBytes: integer('data_saved_in_bytes').default(0),
  lastSyncedAt: timestamp('last_synced_at').defaultNow(),
});

// Browsing history table
const browsingHistory = pgTable('browsing_history', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  url: text('url').notNull(),
  title: text('title'),
  visitedAt: timestamp('visited_at').defaultNow().notNull(),
  faviconUrl: text('favicon_url'),
});

// Bookmarks table
const bookmarks = pgTable('bookmarks', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  folderId: integer('folder_id').references(() => bookmarkFolders.id, { onDelete: 'set null' }),
  url: text('url').notNull(),
  title: text('title').notNull(),
  faviconUrl: text('favicon_url'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
});

// Bookmark folders table
const bookmarkFolders = pgTable('bookmark_folders', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  parentFolderId: integer('parent_folder_id').references(() => bookmarkFolders.id, { onDelete: 'set null' }),
  name: varchar('name', { length: 100 }).notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull(),
});

// Downloads table
const downloads = pgTable('downloads', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  url: text('url').notNull(),
  filename: text('filename').notNull(),
  fileSize: integer('file_size'),
  mimeType: varchar('mime_type', { length: 100 }),
  status: varchar('status', { length: 20 }).notNull().default('in_progress'),
  startedAt: timestamp('started_at').defaultNow().notNull(),
  completedAt: timestamp('completed_at'),
});

// Define relations
const usersRelations = relations(users, ({ many }) => ({
  preferences: many(userPreferences),
  history: many(browsingHistory),
  bookmarks: many(bookmarks),
  bookmarkFolders: many(bookmarkFolders),
  downloads: many(downloads),
}));

const bookmarksRelations = relations(bookmarks, ({ one }) => ({
  user: one(users, {
    fields: [bookmarks.userId],
    references: [users.id],
  }),
  folder: one(bookmarkFolders, {
    fields: [bookmarks.folderId],
    references: [bookmarkFolders.id],
  }),
}));

const bookmarkFoldersRelations = relations(bookmarkFolders, ({ one, many }) => ({
  user: one(users, {
    fields: [bookmarkFolders.userId],
    references: [users.id],
  }),
  parentFolder: one(bookmarkFolders, {
    fields: [bookmarkFolders.parentFolderId],
    references: [bookmarkFolders.id],
  }),
  childFolders: many(bookmarkFolders),
  bookmarks: many(bookmarks),
}));

// Export everything
module.exports = {
  users,
  userPreferences,
  browsingHistory,
  bookmarks,
  bookmarkFolders,
  downloads,
  usersRelations,
  bookmarksRelations,
  bookmarkFoldersRelations
};