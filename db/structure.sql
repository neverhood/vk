CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "vk_id" integer NOT NULL, "token" varchar(255), "wall_post_enabled" boolean DEFAULT 'f', "name" varchar(255) NOT NULL, "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "index_users_on_vk_id" ON "users" ("vk_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20130423172624');
