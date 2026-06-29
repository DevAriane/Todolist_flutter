-keep class io.objectbox.** { *; }
-dontwarn io.objectbox.**

# Empêche la modification de tes modèles de données
-keep class com.example.todolist_flutter.data.models.** { *; }
-keep class com.example.todolist_flutter.objectbox.** { *; }