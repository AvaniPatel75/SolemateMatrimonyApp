import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class MyDataBase {
  static Database? _database;

  MyDataBase._privateConstructor();
  static final MyDataBase instance = MyDataBase._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'LoggedUser.db'),
      version: 5,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE LoggedUser('
              'UserId INTEGER PRIMARY KEY AUTOINCREMENT, '
              'UserName TEXT, '
              'Password TEXT, '
              'Email TEXT)',
        );

        await db.execute(
          'CREATE TABLE UserDetails('
              'Id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'Name TEXT, '
              'Age INTEGER, '
              'DOB TEXT, '
              'Email TEXT, '
              'Gender TEXT, '
              'Religion TEXT, '
              'Caste TEXT, '
              'SubCaste TEXT, '
              'MarryOutside TEXT, '
              'Income TEXT, '
              'FamilyType TEXT, '
              'MaritalStatus TEXT, '
              'Height REAL, '
              'Complexion TEXT, '
              'Occupation TEXT, '
              'Education TEXT, '
              'City TEXT, '
              'Bio TEXT)',
        );
        await db.execute(
          'CREATE TABLE Favourite('
              'Favourite_id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'UserId INTEGER, '
              'Name TEXT, '
              'Age INTEGER, '
              'DOB TEXT, '
              'Email TEXT, '
              'Gender TEXT, '
              'Religion TEXT, '
              'Caste TEXT, '
              'SubCaste TEXT, '
              'MarryOutside TEXT, '
              'Income TEXT, '
              'FamilyType TEXT, '
              'MaritalStatus TEXT, '
              'Height REAL, '
              'Complexion TEXT, '
              'Occupation TEXT, '
              'Education TEXT, '
              'City TEXT, '
              'Bio TEXT, '
              'FOREIGN KEY (UserId) REFERENCES UserDetails(Id))',
        );

      },
      onUpgrade: (db,oldVersion,newVersion) async{
        if (oldVersion <5) {
          //await db.execute('ALTER TABLE LoggedUser ADD COLUMN Email TEXT');
          await db.execute('ALTER TABLE UserDetails RENAME COLUMN ImagePath TO Complexion');
          await db.execute('ALTER TABLE UserDetails RENAME COLUMN FullName TO Name;');
        }
      }
    );
  }

  Future<List<Map<String, dynamic>>> getAllProfiles() async {
    final db = await database;
    return db.query('UserDetails');
  }

  Future<int> insertUserInUserDetails(Map<String, dynamic> userProfile) async {
    final db = await database;
    return await db.insert('UserDetails', userProfile);
  }

  Future<Map<String, dynamic>?> getUserProfile({
    required String username,
    required String password,
  }) async {
    final db = await database;

    // 1. First, find the user in the LoggedUser table to get their email.
    final loggedUser = await db.query(
      'LoggedUser',
      columns: ['Email'], // Only get the Email column, as that is the common field.
      where: 'UserName = ? AND Password = ?',
      whereArgs: [username, password],
    );

    if (loggedUser.isNotEmpty) {
      final userEmail = loggedUser.first['Email'];

      // 2. Use the email to find the matching profile in the UserDetails table.
      final userProfile = await db.query(
        'UserDetails',
        where: 'Email = ?',
        whereArgs: [userEmail],
      );

      // 3. Return the profile data.
      if (userProfile.isNotEmpty) {
        return userProfile.first;
      }
    }

    // Return null if no profile is found.
    return null;
  }
  Future<Map<String, dynamic>?> getProfileById(int id) async {
    final db = await database;
    final result = await db.query('UserDetails', where: 'Id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateProfile(int id, Map<String, dynamic> updates) async {
    final db = await database;
    return db.update('UserDetails', updates, where: 'Id = ?', whereArgs: [id]);
  }
  Future<int> deleteProfile(int id) async {
    final db = await database;
    return db.delete('UserDetails', where: 'Id = ?', whereArgs: [id]);
  }


  Future<int> insertUserInsSignUp({required String username,required String password,required String email,})async {
      final db=await database;
      return db.insert('LoggedUser',  {
        'UserName': username,
        'Password': password,
        'Email':email,
        // Email is not in LoggedUser table currentlay!
        // Either add Email column in CREATE TABLE LoggedUser OR remove this line.
      },
        //conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }
  Future<int> updateUserPasswordByEmail(String email, String newPassword) async {
    final db = await database;
    return await db.update(
      'LoggedUser',
      {'Password': newPassword},
      where: 'Email= ?',
      whereArgs: [email],
    );
  }

  Future<Map<String, dynamic>> getUserDetailsByUsername(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'UserDetails',
      where: 'Name = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return {}; // Return an empty map if no profile is found
  }

  Future<Map<String, dynamic>?> getUserProfileByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'UserDetails',
      where: 'Email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }
  Future<Map<String, dynamic>?> getLoggedUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'LoggedUser',
      columns: ['UserName', 'Password'],
      where: 'Email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return {
        'UserName': result.first['UserName'],
        'Password': result.first['Password'],
      };
    }
    return null;
  }
  Future<bool> verifyUser({
    required String username,
    required String password,
  }) async {
    final db = await database; // ✅ reuse singleton db instance

    final result = await db.query(
      'LoggedUser',
      where: 'UserName = ? AND Password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty; // ✅ true if user exists
  }
  // Future<void> logout() async {
  //   final db = await database;
  //   await db.delete('LoggedUser');
  //
  //   // Optionally, you can also clear shared preferences to remove the login state
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  // }
  // Future<void> logoutUserByEmail(String email) async {
  //   final db = await database;
  //
  //   // Delete the record from the 'LoggedUser' table where the email matches.
  //   await db.delete(
  //     'LoggedUser',
  //     where: 'Email = ?',
  //     whereArgs: [email],
  //   );
  //
  // }
  Future<int> addToFavourite(Map<String, dynamic> userDetail) async {
    final db = await database;

    return await db.insert(
      'Favourite',
      {
        'UserId': userDetail['Id'],
        'Name': userDetail['Name'],
        'Age': userDetail['Age'],
        'DOB': userDetail['DOB'],
        'Email': userDetail['Email'],
        'Gender': userDetail['Gender'],
        'Religion': userDetail['Religion'],
        'Caste': userDetail['Caste'],
        'SubCaste': userDetail['SubCaste'],
        'MarryOutside': userDetail['MarryOutside'],
        'Income': userDetail['Income'],
        'FamilyType': userDetail['FamilyType'],
        'MaritalStatus': userDetail['MaritalStatus'],
        'Height': userDetail['Height'],
        'Complexion': userDetail['Complexion'],
        'Occupation': userDetail['Occupation'],
        'Education': userDetail['Education'],
        'City': userDetail['City'],
        'Bio': userDetail['Bio'],
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
  Future<List<Map<String, dynamic>>> getAllFavourites() async {
    final db = await database;

    // 🔹 Get count just for debugging/logging
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Favourite')
    );
    print("Total favourites: $count");

    // 🔹 Actually fetch all rows
    final results = await db.query('Favourite');
    print("Rows in Favourite table: ${results.length}");
    for (var row in results) {
      print(row);
    }

    print("Favourit all from database favourite table $results");
    return results;
  }

  // Inside your MyDataBase class

  Future<String?> getUserNameFromLoggedTableByEmail(String email) async {
    final db = await database;

    // Query the LoggedUser table to find the name associated with the email
    final List<Map<String, dynamic>> result = await db.query(
      'LoggedUser',
      columns: ['UserName'], // Retrieve only the UserName column
      where: 'Email = ?',
      whereArgs: [email],
      limit: 1, // We only need the first match
    );

    // Return the UserName if a record is found
    if (result.isNotEmpty) {
      return result.first['UserName'] as String?;
    } else {
      return null; // Return null if no record is found
    }
  }
  // Future<Map<String, dynamic>?> getLoggedUserByEmail(String email) async {
  //   final db = await database;
  //   final result = await db.query(
  //     'LoggedUser',
  //     columns: ['UserName', 'Password'],
  //     where: 'Email = ?',
  //     whereArgs: [email],
  //     limit: 1,
  //   );
  //
  //   if (result.isNotEmpty) {
  //     return {
  //       'UserName': result.first['UserName'],
  //       'Password': result.first['Password'],
  //     };
  //   }
  //   return null;
  // }

  // Inside your MyDataBase class in database.dart

  Future<int> removeFromFavouriteByEmail(String email) async {
    final db = await database;
    return await db.delete(
      'Favourite',
      where: 'Email = ?',
      whereArgs: [email],
    );
  }

// You should also update your addToFavourite to ensure Email is stored
  Future<int> addToFavouriteAfterRemoveFromFavourite(Map<String, dynamic> userDetail) async {
    final db = await database;

    return await db.insert(
      'Favourite',
      {
        // Your existing fields...
        'UserId': userDetail['UserId'],
        'Name': userDetail['Name'],
        'Email': userDetail['Email'], // Make sure this line exists
        // Other details...
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<bool> isFavourite(String email) async {
    final db = await database;
    final result = await db.query(
      'Favourite',
      where: 'Email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return result.isNotEmpty;
  }

}

