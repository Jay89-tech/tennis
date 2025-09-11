class AppConstants {
  static const String appName = "Tennis Training Pro";
  static const String racketAnimation = "assets/animations/tennis_racket.json";
  static const String ballAnimation = "assets/animations/tennis_ball.json";
  static const String defaultProfileImage = "https://firebasestorage.googleapis.com/v0/b/tennis-training-app.appspot.com/o/app_assets%2Fdefault_profile.png?alt=media";
  
  // Skill levels
  static const List<String> skillLevels = [
    "Beginner",
    "Intermediate",
    "Advanced",
    "Professional"
  ];
  
  // Playing styles
  static const List<String> playingStyles = [
    "Aggressive Baseliner",
    "Defensive Baseliner",
    "Serve and Volley",
    "All-Court Player",
    "Counter Puncher"
  ];
  
  // Court types
  static const List<String> courtTypes = [
    "Hard Court",
    "Clay Court",
    "Grass Court",
    "Artificial Grass",
    "Carpet"
  ];

  // Training types
  static const List<String> trainingTypes = [
    "Forehand",
    "Backhand",
    "Serve",
    "Volley",
    "Smash",
    "Footwork",
    "Match Practice",
    "Fitness"
  ];

  // Metrics to track
  static const List<String> trainingMetrics = [
    "Accuracy",
    "Power",
    "Consistency",
    "Footwork",
    "Stamina",
    "Technique"
  ];
}