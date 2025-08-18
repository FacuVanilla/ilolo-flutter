import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CustomAuthService {
  static final CustomAuthService _instance = CustomAuthService._internal();
  factory CustomAuthService() => _instance;
  CustomAuthService._internal();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Database? _database;
  bool _isInitialized = false;

  // Initialize the database
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'ilolo_auth.db'),
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE users (
              id TEXT PRIMARY KEY,
              email TEXT UNIQUE NOT NULL,
              displayName TEXT,
              photoUrl TEXT,
              createdAt INTEGER,
              lastLoginAt INTEGER
            )
          ''');
        },
        version: 1,
      );
      _isInitialized = true;
      debugPrint('Custom auth service initialized successfully');
    } catch (e) {
      debugPrint('Error initializing custom auth service: $e');
    }
  }

  // Sign in with Google and register user in database
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      await initialize();
      debugPrint('Starting Google sign-in process...');

      // Try silent sign-in first
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();
      
      // If silent sign-in fails, try explicit sign-in
      if (account == null) {
        debugPrint('No existing Google sign-in, trying explicit sign-in...');
        account = await _googleSignIn.signIn();
      }

      if (account != null) {
        debugPrint('Google sign-in successful: ${account.email}');

        // Get authentication credentials
        final GoogleSignInAuthentication googleAuth = await account.authentication;

        // Create user data
        final userData = {
          'id': account.id,
          'email': account.email,
          'displayName': account.displayName,
          'photoUrl': account.photoUrl,
          'createdAt': DateTime.now().millisecondsSinceEpoch,
          'lastLoginAt': DateTime.now().millisecondsSinceEpoch,
        };

        // Save or update user in database
        await _saveUserToDatabase(userData);

        // Save authentication state
        await _saveAuthState(userData);

        return userData;
      } else {
        debugPrint('Google sign-in cancelled by user');
        return null;
      }
    } catch (error) {
      debugPrint('Custom auth sign-in error: $error');
      return null;
    }
  }

  // Save user to database
  Future<void> _saveUserToDatabase(Map<String, dynamic> userData) async {
    try {
      if (_database == null) return;

      // Check if user exists
      final existingUser = await _database!.query(
        'users',
        where: 'id = ?',
        whereArgs: [userData['id']],
      );

      if (existingUser.isNotEmpty) {
        // Update existing user
        await _database!.update(
          'users',
          {
            'displayName': userData['displayName'],
            'photoUrl': userData['photoUrl'],
            'lastLoginAt': userData['lastLoginAt'],
          },
          where: 'id = ?',
          whereArgs: [userData['id']],
        );
        debugPrint('User updated in database');
      } else {
        // Insert new user
        await _database!.insert('users', userData);
        debugPrint('New user registered in database');
      }
    } catch (e) {
      debugPrint('Error saving user to database: $e');
    }
  }

  // Save authentication state
  Future<void> _saveAuthState(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_user_id', userData['id']);
      await prefs.setString('auth_user_email', userData['email']);
      await prefs.setString('auth_user_name', userData['displayName'] ?? '');
      await prefs.setString('auth_user_photo', userData['photoUrl'] ?? '');
      await prefs.setBool('is_authenticated', true);
      debugPrint('Authentication state saved');
    } catch (e) {
      debugPrint('Error saving auth state: $e');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('is_authenticated') ?? false;
    } catch (e) {
      debugPrint('Error checking auth state: $e');
      return false;
    }
  }

  // Get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('auth_user_id');
      
      if (userId == null) return null;

      return {
        'id': userId,
        'email': prefs.getString('auth_user_email'),
        'displayName': prefs.getString('auth_user_name'),
        'photoUrl': prefs.getString('auth_user_photo'),
      };
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
      
      // Clear authentication state
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_user_id');
      await prefs.remove('auth_user_email');
      await prefs.remove('auth_user_name');
      await prefs.remove('auth_user_photo');
      await prefs.setBool('is_authenticated', false);
      
      debugPrint('Custom auth sign-out successful');
    } catch (error) {
      debugPrint('Custom auth logout error: $error');
    }
  }

  // Get user from database by ID
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      if (_database == null) return null;

      final results = await _database!.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (results.isNotEmpty) {
        return results.first;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user by ID: $e');
      return null;
    }
  }

  // Get user from database by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      if (_database == null) return null;

      final results = await _database!.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (results.isNotEmpty) {
        return results.first;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user by email: $e');
      return null;
    }
  }
}

