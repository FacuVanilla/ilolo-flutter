import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:ilolo/services/custom_auth_service.dart';  // Using custom authentication service

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<Map<String, dynamic>?> signIn() async {
    try {
      debugPrint('Starting Google sign-in process...');

      // Use custom authentication service
      final userData = await CustomAuthService().signInWithGoogle();
      
      if (userData != null) {
        debugPrint('Custom auth sign-in successful: ${userData['email']}');
        return userData;
      } else {
        debugPrint('Custom auth sign-in failed');
        return null;
      }
    } catch (error) {
      debugPrint('Custom auth sign-in error: $error');
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      await CustomAuthService().signOut();
      debugPrint('Custom auth sign-out successful');
    } catch (error) {
      debugPrint('Custom auth logout error: $error');
    }
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    return await CustomAuthService().isAuthenticated();
  }

  // Get current user
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    return await CustomAuthService().getCurrentUser();
  }

  // static final GoogleSignIn _googleSignInIos = GoogleSignIn(
  //   clientId: Platform.isAndroid
  //     ? '103928665231-7g7dj268ohm2jrasdu88irt8vup25jfs.apps.googleusercontent.com'
  //     : '103928665231-duf21m11fsmh0j4gjv49c298jh9nv8ia.apps.googleusercontent.com',
  // );
  // static Future<GoogleSignInAccount?> signInIos() async => await _googleSignInIos.signIn();
}
