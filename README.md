# SOMOS MAS - API
**Seed database with new users**

---

For seeding new users to the database, first we need to seed user's roles, which are admin and client.
Execute these commands to seed your database.

- Creates Admin Role(id:1) and Client Role(id:2)

 - ```rails db:seed:roles_seeds```

- Creates 4 Admin Users and 4 Client Users
 - ```rails db:seed:users_seeds```

**The email format for admin users is:**

- AdminUser0@somos-mas.org
- AdminUser1@somos-mas.org
- ...
- AdminUser**n**@somos-mas.org

**For clients, the format is very similar: **

- ClientUser0@somos-mas.org
- ClientUser0@somos-mas.org
- ...
- ClientUser**n**@somos-mas.org

*Password for all the users created this way is **12345678***